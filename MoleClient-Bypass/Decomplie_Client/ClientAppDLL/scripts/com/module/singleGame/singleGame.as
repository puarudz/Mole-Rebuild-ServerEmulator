package com.module.singleGame
{
   import com.common.util.MovieClipUtil;
   import com.core.info.LocalUserInfo;
   import com.core.loading.Loading;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.links.Links;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.socket.gameBegin.GameBeginRes;
   import com.logic.socket.leaveGame.LeaveGameRes;
   import com.logic.socket.singleGame.SingleGameActionReq;
   import com.module.activityModule.checkCloth;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.utils.ByteArray;
   
   public class singleGame
   {
      
      public static var IDARR:Array = new Array();
      
      private var RootMC:MovieClip;
      
      private var peopleMC:MovieClip;
      
      private var gameBG:MovieClip;
      
      private var peopleInfo:Array;
      
      private var gameID:int;
      
      private var UIclass:*;
      
      private var UIVipclass:*;
      
      private var chatView:singleGameChat;
      
      private var actionReq:SingleGameActionReq;
      
      private var infoClass:MCLoader;
      
      private var myaction:Number = 0;
      
      private var myshowtxt:Number = 0;
      
      private var myscore:Number = 0;
      
      private var mypercent:Number = 0;
      
      private var showMC:MovieClip;
      
      private var myInfo:Object;
      
      private var ToolArr:Array = new Array();
      
      public function singleGame(mc:MovieClip, peopleinfo:Array, gameid:int)
      {
         super();
         this.RootMC = mc;
         this.peopleMC = this.RootMC.peopleMC;
         this.gameBG = this.RootMC.gameBG;
         this.peopleInfo = peopleinfo;
         this.gameID = gameid;
         MovieClipUtil.gotoAndStop(this.gameBG,"bg" + this.gameID);
         MoveTo.CanMove = false;
         this.ToolArr = [{
            "gameid":1,
            "toolid":12201
         }];
         this.init();
      }
      
      public function init() : void
      {
         this.chatView = new singleGameChat(this.RootMC.chatMC);
         this.actionReq = new SingleGameActionReq();
         this.RootMC.close_btn.addEventListener(MouseEvent.CLICK,this.closeGame);
         this.loadPeople();
      }
      
      public function haveTool(userid:int) : Boolean
      {
         for(var i:uint = 0; i < this.ToolArr.length; i++)
         {
            if(this.ToolArr[i].gameid == this.gameID && userid == LocalUserInfo.getUserID())
            {
               return checkCloth.PeopleHaveItem(userid,this.ToolArr[i].toolid);
            }
         }
         return false;
      }
      
      public function loadPeople() : void
      {
         var tempLoader:Loader = new Loader();
         tempLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loadVipComplete);
         tempLoader.load(VL.getURLRequest(Links.getUrl("module/singleGame/icon/peoplevip" + this.gameID + ".swf",false,Links.moduleversion)));
      }
      
      private function loadVipComplete(e:Event) : void
      {
         e.target.removeEventListener(Event.COMPLETE,this.loadVipComplete);
         this.UIVipclass = e.target.applicationDomain.getDefinition("people");
         var tempLoader:Loader = new Loader();
         tempLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loadComplete);
         tempLoader.load(VL.getURLRequest(Links.getUrl("module/singleGame/icon/people" + this.gameID + ".swf",false,Links.moduleversion)));
      }
      
      private function loadComplete(e:Event) : void
      {
         e.target.removeEventListener(Event.COMPLETE,this.loadComplete);
         this.UIclass = e.target.applicationDomain.getDefinition("people");
         this.initPeople();
      }
      
      public function initPeople() : void
      {
         var obj:Object = null;
         for(var i:uint = 0; i < this.peopleInfo.length; i++)
         {
            IDARR.push(this.peopleInfo[i].Userid);
            obj = GF.getPeopleObj(this.peopleInfo[i].Userid);
            obj.Itemid = this.peopleInfo[i].Itemid;
            obj.Status = this.peopleInfo[i].Status;
            this.showPeople(obj);
         }
         this.showStar();
         GV.onlineSocket.addEventListener("peopleActionSingleGame",this.actionFromServer);
         GV.onlineSocket.addEventListener(LeaveGameRes.LEAVE_GAME,this.doLeave);
         GV.onlineSocket.addEventListener(GameBeginRes.BEGING_GAME,this.doEnter);
         this.loadSingleGame();
      }
      
      public function showStar() : void
      {
         var p:Object = null;
         var tempScore:Number = NaN;
         var people:Object = null;
         var highScore:int = -1;
         var highItemID:uint = 1;
         for(var i:uint = 1; i < 7; i++)
         {
            if(this.peopleMC["people" + i].numChildren > 0)
            {
               p = this.peopleMC["people" + i].getChildAt(0);
               tempScore = Number(p.scoreMC.score_txt.text);
               if(tempScore > highScore)
               {
                  highScore = tempScore;
                  highItemID = i;
               }
            }
         }
         var highPeople:Object = this.peopleMC["people" + highItemID].getChildAt(0);
         for(var j:uint = 1; j < 7; j++)
         {
            if(this.peopleMC["people" + j].numChildren > 0)
            {
               people = this.peopleMC["people" + j].getChildAt(0);
               people.star.visible = false;
            }
         }
         highPeople.star.visible = true;
      }
      
      public function showPeople(obj:Object) : void
      {
         var temp:Object = null;
         var colorObj:Array = null;
         if(obj.UserID == LocalUserInfo.getUserID())
         {
            this.myInfo = obj;
         }
         if(this.haveTool(obj.UserID))
         {
            temp = new this.UIVipclass();
         }
         else
         {
            temp = new this.UIclass();
         }
         temp.name = "mole" + obj.Itemid;
         this.peopleMC["people" + obj.Itemid].addChild(temp);
         var action:int = int(obj.Status.readByte());
         var percent:int = int(obj.Status.readByte());
         var score:uint = uint(obj.Status.readUnsignedInt());
         var showtxt:uint = uint(obj.Status.readUnsignedInt());
         temp.actionMC.gotoAndStop(action);
         this.gotoAction(temp,1);
         temp.scoreMC.score_txt.text = showtxt.toString();
         temp.Color = Number(obj.Color);
         if(this.gameID < 12)
         {
            colorObj = GF.getPrimitiveColors(temp.Color.toString(16));
            temp.moleMC.mole.transform.colorTransform = new ColorTransform(colorObj[0] / 256,colorObj[1] / 256,colorObj[2] / 256,1);
            temp.moleMC.mole_body.transform.colorTransform = new ColorTransform(colorObj[0] / 256,colorObj[1] / 256,colorObj[2] / 256,1);
         }
         else
         {
            temp.moleMC.colorObj = PeopleManageView(GV.MAN_PEOPLE).colorObj;
         }
         temp.name_txt.text = obj.Nick;
         temp.memberMC.visible = false;
         this.showPet(temp,obj);
      }
      
      public function showPet(temp:Object, obj:Object) : void
      {
         if(obj.PetID > 0)
         {
            temp.petMC.visible = true;
            temp.pet_ye.visible = true;
            temp.pet_ye.gotoAndStop(obj.Petlevel);
            temp.petMC.gotoAndStop(obj.Petlevel);
            this.setPetColor(temp.petMC,obj.PetColor);
         }
         else
         {
            temp.petMC.visible = false;
            temp.pet_ye.visible = false;
         }
      }
      
      public function setPetColor(mc:DisplayObject, colorNum:uint) : void
      {
         var _array:Array = GV["petColor_" + colorNum];
         mc.transform.colorTransform = new ColorTransform(_array[0],_array[1],_array[2],_array[3],_array[4],_array[5],_array[6],_array[7]);
      }
      
      public function moleLeaveGame(id:uint) : void
      {
         for(var i:uint = 0; i < this.peopleInfo.length; i++)
         {
            if(id == this.peopleInfo[i].Userid)
            {
               this.removeMole(this.peopleInfo[i]);
               this.peopleInfo.splice(i,1);
               break;
            }
         }
         this.showStar();
      }
      
      public function removeMole(obj:Object) : void
      {
         this.peopleMC["people" + obj.Itemid].removeChildAt(0);
      }
      
      public function moleEnterGame(tempobj:Object) : void
      {
         var obj:Object = GF.getPeopleObj(tempobj.UserID);
         if(obj != null)
         {
            obj.Userid = tempobj.UserID;
            obj.Itemid = tempobj.itemID;
            obj.Status = new ByteArray();
            obj.Status.length = 16;
            this.peopleInfo.push(obj);
            this.showPeople(obj);
            this.showStar();
         }
      }
      
      public function actionFromServer(e:* = null) : void
      {
         this.doMoleAction(e.EventObj);
      }
      
      public function doMoleAction(obj:Object) : void
      {
         var ItemID:Object = this.getItemID(obj.UserID);
         var action:int = int(obj.byte.readByte());
         var percent:int = int(obj.byte.readByte());
         var score:uint = uint(obj.byte.readUnsignedInt());
         var showtxt:uint = uint(obj.byte.readUnsignedInt());
         var p:Object = this.peopleMC["people" + ItemID].getChildAt(0);
         this.gotoAction(p,action);
         p.timeMachine.gotoAndPlay(2);
         p.scoreMC.score_txt.text = showtxt;
         if(obj.UserID == LocalUserInfo.getUserID())
         {
            this.myscore = score;
            this.mypercent = percent;
         }
         this.showStar();
      }
      
      public function gotoAction(p:Object, action:Object) : void
      {
         var tempmc:MovieClip = null;
         p.actionMC.gotoAndStop(action);
         for(var i:uint = 0; i < p.moleMC.numChildren; i++)
         {
            tempmc = p.moleMC.getChildAt(i) as MovieClip;
            tempmc.gotoAndStop(action);
         }
      }
      
      public function getItemID(id:Object) : Object
      {
         for(var i:uint = 0; i < this.peopleInfo.length; i++)
         {
            if(id == this.peopleInfo[i].Userid)
            {
               return this.peopleInfo[i].Itemid;
            }
         }
         return null;
      }
      
      public function doLeave(e:* = null) : void
      {
         this.moleLeaveGame(e.EventObj.UserID);
      }
      
      public function doEnter(e:* = null) : void
      {
         this.moleEnterGame(e.EventObj.gameArr[0]);
      }
      
      public function loadSingleGame() : void
      {
         this.infoClass = new MCLoader("module/singleGame/swf/game" + this.gameID + ".swf",this.RootMC.gameMC,Loading.TITLE_AND_PERCENT,"加載遊戲...");
         this.infoClass.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadOverHandler);
         this.infoClass.doLoad();
      }
      
      public function loadOverHandler(evt:MCLoadEvent) : void
      {
         this.infoClass.removeEventListener(MCLoadEvent.ON_SUCCESS,this.loadOverHandler);
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:Loader = evt.getLoader();
         mainMC.addChild(childMC);
         GV.onlineSocket.dispatchEvent(new EventTaomee("MoleInfo",this.myInfo));
         GV.onlineSocket.addEventListener("getActionFromGame",this.getAction);
         GV.onlineSocket.addEventListener("getOverFromGame",this.getGameOver);
         this.infoClass.clear();
      }
      
      private function getGameOver(e:EventTaomee) : void
      {
         this.myscore = e.EventObj.fraction;
         this.mypercent = e.EventObj.Ratio;
         this.closeGame();
      }
      
      private function leaveSingleGame(e:Event) : void
      {
      }
      
      private function getAction(e:*) : void
      {
         this.actionReq.sendAction(e.EventObj);
      }
      
      private function loadGameComplete(e:Event) : void
      {
         e.target.removeEventListener(Event.COMPLETE,this.loadComplete);
      }
      
      public function removeListen() : void
      {
         this.chatView.removeListenHandler();
         GV.onlineSocket.removeEventListener("getActionFromGame",this.getAction);
         GV.onlineSocket.removeEventListener("getOverFromGame",this.getGameOver);
         GV.onlineSocket.removeEventListener("peopleActionSingleGame",this.actionFromServer);
         GV.onlineSocket.removeEventListener(LeaveGameRes.LEAVE_GAME,this.doLeave);
         GV.onlineSocket.removeEventListener(GameBeginRes.BEGING_GAME,this.doEnter);
      }
      
      public function closeGame(e:* = null) : void
      {
         var tempMC:Class = null;
         GV.onlineSocket.dispatchEvent(new EventTaomee("closeFishGame"));
         if(this.mypercent > 100)
         {
            this.mypercent = 100;
         }
         if(this.mypercent < 0)
         {
            this.mypercent = 0;
         }
         if(this.gameID == 3 || this.gameID == 5 || this.gameID == 2 || this.gameID == 1)
         {
            tempMC = this.RootMC.loaderInfo.applicationDomain.getDefinition("RESULT") as Class;
            this.showMC = new tempMC();
            GV.onlineSocket.dispatchEvent(new EventTaomee("getGameFraction",{
               "fraction":this.myscore,
               "Ratio":this.mypercent,
               "mc":this.showMC
            }));
         }
         else
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("getGameFraction",{
               "fraction":this.myscore,
               "Ratio":this.mypercent
            }));
         }
         trace("RootMC",this.RootMC);
         this.chatView.removeScrollBarHandler();
         MoveTo.CanMove = true;
         GV.isSitDown = false;
         GC.stopAllMC(this.RootMC);
         this.removeListen();
         GC.clearAll(this.RootMC);
         this.RootMC.parent.parent.removeChild(this.RootMC.parent);
         this.RootMC = null;
      }
   }
}

