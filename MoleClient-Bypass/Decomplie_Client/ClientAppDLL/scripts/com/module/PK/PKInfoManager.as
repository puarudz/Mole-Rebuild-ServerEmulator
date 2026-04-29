package com.module.PK
{
   import com.common.Alert.Alert;
   import com.common.view.MCScrollBar.ScrollBarTop;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.PKsocket.GameKingSocket;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.logic.socket.getSceneUserInfo.GetSceneUserInfoReq;
   import com.logic.socket.getSceneUserInfo.GetSceneUserRes;
   import com.module.changeClothsModule.prevView;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class PKInfoManager
   {
      
      private static var instance:PKInfoManager = null;
      
      private var PK_UI:*;
      
      private var ListUI:*;
      
      private var ListUIClass:Class;
      
      private var PK_UIClass:Class;
      
      private var visitorPanel:MovieClip;
      
      private var Man0:Class;
      
      private var Man2:Class;
      
      private var len:uint;
      
      private var arrMC:Array = new Array();
      
      private var ScrollBar:*;
      
      private var ScrollBar2:*;
      
      private var myTimeout:*;
      
      private var MC:MovieClip;
      
      private var Obj:Object;
      
      private var VisitorArr:Array;
      
      private var Type:uint = 0;
      
      private var mcloader:MCLoader;
      
      private var willPKMan:*;
      
      private var TodayPKObj:Object;
      
      public function PKInfoManager()
      {
         super();
      }
      
      public static function getInstance() : PKInfoManager
      {
         return instance = instance || new PKInfoManager();
      }
      
      public function init() : void
      {
         this.Type = 0;
         this.loadUI();
      }
      
      private function loadUI() : void
      {
         if(!this.ListUI)
         {
            this.mcloader = new MCLoader("module/PK/MyPKUI.swf",MainManager.getGameLevel(),1,"正在打開我的遊戲王面板...");
            this.mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadSucc);
            this.mcloader.addEventListener(MCLoadEvent.ERROR,this.loadErr);
            this.mcloader.doLoad();
         }
         else
         {
            this.ListUI.x = MainManager.getAppLevel().getChildByName("mySelfinfoMC").x + 260;
            this.ListUI.y = MainManager.getAppLevel().getChildByName("mySelfinfoMC").y;
            this.initPanel(0);
            BC.addEvent(this,GV.onlineSocket,"read_" + 1464,this.HistoryPK);
            GameKingSocket.HistoryPK();
         }
      }
      
      private function loadErr(event:MCLoadEvent) : void
      {
         trace("加載出錯");
      }
      
      private function removeEvent(e:Event) : void
      {
         this.ListUI.y = 1000;
      }
      
      private function loadSucc(event:MCLoadEvent) : void
      {
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeEvent);
         var a:DisplayObjectContainer = event.getParent();
         var b:Loader = event.getLoader();
         this.PK_UIClass = b.contentLoaderInfo.applicationDomain.getDefinition("VSPanel") as Class;
         this.ListUIClass = b.contentLoaderInfo.applicationDomain.getDefinition("list_UI") as Class;
         this.Man0 = b.contentLoaderInfo.applicationDomain.getDefinition("man0") as Class;
         this.Man2 = b.contentLoaderInfo.applicationDomain.getDefinition("man2") as Class;
         this.ListUI = new this.ListUIClass();
         this.ListUI.x = MainManager.getAppLevel().getChildByName("mySelfinfoMC").x + 260;
         this.ListUI.y = MainManager.getAppLevel().getChildByName("mySelfinfoMC").y;
         MainManager.getTopLevel().addChild(this.ListUI);
         var mcloader:MCLoader = event.target as MCLoader;
         mcloader.clear();
         this.visitorPanel = this.ListUI;
         BC.addEvent(this,this.visitorPanel.drag_mc,MouseEvent.MOUSE_DOWN,this.drag_start);
         BC.addEvent(this,this.visitorPanel.drag_mc,MouseEvent.MOUSE_UP,this.drag_stop);
         BC.addEvent(this,this.visitorPanel.drag_mc,MouseEvent.MOUSE_MOVE,this.drag_move);
         BC.addEvent(this,this.visitorPanel.close_btn,MouseEvent.CLICK,this.closeMC);
         BC.addEvent(this,this.visitorPanel.btn0,MouseEvent.CLICK,this.changeType);
         BC.addEvent(this,this.visitorPanel.btn1,MouseEvent.CLICK,this.changeType);
         BC.addEvent(this,this.visitorPanel.btn2,MouseEvent.CLICK,this.changeType);
         this.initPanel(0);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1464,this.HistoryPK);
         GameKingSocket.HistoryPK();
      }
      
      private function changeType(e:MouseEvent) : void
      {
         var i:int = int(e.currentTarget.name.slice(3,4));
         this.Type = i;
         this.initPanel(i);
         if(i != 0)
         {
            if(i == 1)
            {
               BC.addEvent(this,GV.onlineSocket,"read_" + 1465,this.WineRsult);
               GameKingSocket.UserWineRsult(LocalUserInfo.getUserID());
            }
            else
            {
               BC.addEvent(this,GV.onlineSocket,"read_" + 1462,this.mygamelist);
               GameKingSocket.usergamelist(LocalUserInfo.getUserID());
            }
         }
      }
      
      private function mygamelist(e:EventTaomee) : void
      {
         var obj:Object = null;
         var j:uint = 0;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1462,this.mygamelist);
         var serverarr:Array = e.EventObj.arr;
         var arr:Array = new Array();
         for(var i:uint = 0; i < PKManager.PKGameArr.length; i++)
         {
            obj = new Object();
            obj.GameID = PKManager.PKGameArr[i].id;
            obj.GameScore = 0;
            obj.GameFlag = 0;
            for(j = 0; j < serverarr.length; j++)
            {
               if(serverarr[j].GameID == obj.GameID)
               {
                  obj.GameScore = serverarr[j].GameScore;
                  obj.GameFlag = serverarr[j].GameFlag;
                  break;
               }
            }
            arr.push(obj);
         }
         this.VisitorArr = arr;
         this.showVisitor2(this.visitorPanel.visitorUI2);
      }
      
      private function WineRsult(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1465,this.WineRsult);
         this.initInfo(e);
      }
      
      private function initInfo(e:EventTaomee) : void
      {
         var i:uint = 0;
         var obj:Object = e.EventObj;
         this.ListUI.mc1.win.text = obj.win;
         this.ListUI.mc1.lose.text = obj.lose;
         this.ListUI.mc1.score.text = obj.score;
         LocalUserInfo.setGameKing(obj.score);
         var score:uint = uint(obj.score);
         var kinglevelnum:int = -1;
         if(score < 400)
         {
            for(i = 0; i < 6; i++)
            {
               this.ListUI.mc1["kinglevel" + i].gotoAndStop(1);
            }
            this.ListUI.mc1.percent.text = score + "/" + 400;
            this.ListUI.mc1.exp_mc.width = score / 400 * 100;
         }
         else
         {
            kinglevelnum = int((score - 400) / 2000);
            for(i = 0; i < 6; i++)
            {
               if(i <= kinglevelnum)
               {
                  this.ListUI.mc1["kinglevel" + i].gotoAndStop(2);
               }
               else
               {
                  this.ListUI.mc1["kinglevel" + i].gotoAndStop(1);
               }
            }
            if(score < 10400)
            {
               this.ListUI.mc1.percent.text = score + "/" + ((kinglevelnum + 1) * 2000 + 400);
               this.ListUI.mc1.exp_mc.width = score / ((kinglevelnum + 1) * 2000 + 400) * 100;
            }
            else
            {
               this.ListUI.mc1.percent.text = 10400 + "/" + 10400;
               this.ListUI.mc1.exp_mc.width = 100;
            }
         }
      }
      
      private function HistoryPK(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1464,this.HistoryPK);
         this.VisitorArr = e.EventObj.arr;
         this.showVisitor(this.visitorPanel.visitorUI0);
      }
      
      private function showVisitor(mc:MovieClip) : void
      {
         var i:uint = 0;
         this.arrMC = new Array();
         this.visitorPanel.bg_mc.height = 260;
         this.MC = mc;
         GC.clearAllChildren(this.MC.manMC);
         this.len = this.VisitorArr.length;
         if(this.len > 7)
         {
            for(i = 0; i < this.len; i++)
            {
               this.initMan(this.VisitorArr[i],false);
            }
            this.initScrollBar();
         }
         else
         {
            for(i = 0; i < this.len; i++)
            {
               this.initMan(this.VisitorArr[i],false);
            }
            this.initScrollBar();
         }
      }
      
      private function showVisitor2(mc:MovieClip) : void
      {
         var i:uint = 0;
         this.arrMC = new Array();
         this.visitorPanel.bg_mc.height = 260;
         this.MC = mc;
         GC.clearAllChildren(this.MC.manMC);
         this.len = this.VisitorArr.length;
         if(this.len > 7)
         {
            for(i = 0; i < this.len; i++)
            {
               this.initMan(this.VisitorArr[i],false);
            }
            this.initScrollBar2();
         }
         else
         {
            for(i = 0; i < this.len; i++)
            {
               this.initMan(this.VisitorArr[i],false);
            }
            this.initScrollBar2();
         }
      }
      
      private function initMan(manInfo:*, bool:Boolean) : void
      {
         var temp:* = undefined;
         var date:Date = null;
         var str:String = null;
         if(this.Type == 0)
         {
            temp = new this.Man0();
            temp.visible = false;
            temp.GameID = manInfo.GameID;
            temp.UserID = manInfo.UserID;
            temp.username.text = manInfo.UserName;
            temp.gamename.text = PKManager.getGameName(manInfo.GameID).name;
            temp.GameTime = manInfo.GameTime;
            temp.Hescore = manInfo.Hescore;
            temp.Myscore = manInfo.Myscore;
            temp.GameFlag = manInfo.GameFlag;
            date = new Date(manInfo.GameTime * 1000);
            str = String(date.getFullYear()).substr(2,2) + "/" + int(date.getMonth() + 1) + "/" + date.getDate();
            temp.tip = manInfo.Hescore + "/" + manInfo.Myscore + "  " + str;
            temp.pkbtn.addEventListener(MouseEvent.MOUSE_OUT,this.hidetip);
            temp.pkbtn.addEventListener(MouseEvent.MOUSE_OVER,this.showtip);
            if(manInfo.Myscore >= manInfo.Hescore)
            {
               temp.pkbtn.gotoAndStop(2);
            }
            else
            {
               temp.pkbtn.gotoAndStop(1);
               temp.pkbtn.buttonMode = true;
               temp.pkbtn.addEventListener(MouseEvent.CLICK,this.pk30);
            }
         }
         else
         {
            temp = new this.Man2();
            temp.visible = false;
            temp.GameID = manInfo.GameID;
            temp.GameFlag = manInfo.GameFlag;
            temp.winlose.gotoAndStop(3);
            temp.gamename.text = PKManager.getGameName(manInfo.GameID).name;
            temp.gamescore.text = manInfo.GameScore;
         }
         this.arrMC.push(temp);
         this.MC.manMC.addChild(temp);
      }
      
      private function pk30(e:MouseEvent) : void
      {
         this.willPKMan = e.currentTarget.parent;
         if(!this.TodayPKObj)
         {
            GV.onlineSocket.addEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,this.getTodayPkNum);
            finishSomethingReq.sendReq(139);
         }
         else
         {
            this.canPK();
         }
      }
      
      private function canPK() : void
      {
         if(this.TodayPKObj.Done >= 30)
         {
            Alert.showAlert(MainManager.getGameLevel(),"    今天你已經競技了30次囉！休息一下，明天繼續吧！","",6,"D");
         }
         else
         {
            this.getUserHighScore();
         }
      }
      
      private function getTodayPkNum(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,this.getTodayPkNum);
         this.TodayPKObj = e.EventObj;
         this.canPK();
      }
      
      private function getUserHighScoreSucc(e:EventTaomee) : void
      {
         this.pk(e.EventObj.arr[0].GameScore);
      }
      
      private function getUserHighScore() : void
      {
         GV.onlineSocket.addEventListener("read_" + 1461,this.getUserHighScoreSucc);
         GameKingSocket.friendgamelist(this.willPKMan.GameID,this.willPKMan.UserID);
      }
      
      private function pk(highscore:int) : void
      {
         if(!Boolean(this.PK_UI))
         {
            this.PK_UI = new this.PK_UIClass();
            this.PK_UI.gotoAndStop(1);
            this.PK_UI.close_btn.addEventListener(MouseEvent.CLICK,this.closeHotPanel);
            this.PK_UI.yes_btn.addEventListener(MouseEvent.CLICK,this.PKGameInfo);
            this.PK_UI.no_btn.addEventListener(MouseEvent.CLICK,this.closeHotPanel);
            MainManager.getTopLevel().addChild(this.PK_UI);
         }
         this.PK_UI.UserID = this.willPKMan.UserID;
         this.PK_UI.GameID = this.willPKMan.GameID;
         this.PK_UI.Username = this.willPKMan.username.text;
         this.PK_UI.visible = true;
         this.PK_UI.x = 205;
         this.PK_UI.y = 80;
         this.PK_UI.pkscore.text = highscore;
         this.PK_UI.myid.text = LocalUserInfo.getUserID();
         this.PK_UI.heid.text = this.willPKMan.UserID;
         this.PK_UI.myname.text = LocalUserInfo.getNickName();
         this.PK_UI.hename.text = this.willPKMan.username.text;
         this.PK_UI.game.gotoAndStop("game" + this.willPKMan.GameID);
         new prevView(this.PK_UI.mymole_mc,LocalUserInfo.getFamily().toString(16),LocalUserInfo.getClothItem());
         var getSceneUserInfoReq:GetSceneUserInfoReq = new GetSceneUserInfoReq();
         GV.onlineSocket.addEventListener(GetSceneUserRes.GET_SCENE_INFO,this.getSenceUserInfor);
         getSceneUserInfoReq.getSeceeUserInfo(this.willPKMan.UserID);
      }
      
      private function getSenceUserInfor(evt:*) : void
      {
         GV.onlineSocket.removeEventListener(GetSceneUserRes.GET_SCENE_INFO,this.getSenceUserInfor);
         var userInfo:Object = new Object();
         userInfo = evt.EventObj;
         var tempObj:Object = GF.getPeopleObj(this.willPKMan.UserID);
         new prevView(this.PK_UI.hemole_mc,userInfo.Color.toString(16),userInfo.itemArr,tempObj);
      }
      
      private function PKGameInfo(e:MouseEvent) : void
      {
         this.closeHotPanel();
         PKHePanel.PKUID = this.PK_UI.UserID;
         PKHePanel.PKName = this.PK_UI.Username;
         PKHePanel.PKGID = this.PK_UI.GameID;
         GF.switchMap(PKManager.getGameName(this.PK_UI.GameID).mapid,true);
      }
      
      private function closeHotPanel(e:MouseEvent = null) : void
      {
         this.PK_UI.y = 1000;
         this.PK_UI.visible = false;
      }
      
      private function hidetip(e:MouseEvent) : void
      {
         GF.clearTip();
      }
      
      private function showtip(e:MouseEvent) : void
      {
         var tip:String = e.currentTarget.parent.tip;
         GF.showTip(tip);
      }
      
      private function initScrollBar() : void
      {
         var i:uint = 0;
         if(this.len > 7)
         {
            this.arrange(this.arrMC);
            this.MC.scroll_mc.visible = true;
            if(!this.ScrollBar)
            {
               this.ScrollBar = new ScrollBarTop(this.MC.scroll_mc,this.MC.manMC,178,253);
            }
            else
            {
               this.ScrollBar.reSet();
            }
            this.MC.scroll_mc.drag_mc.visible = true;
            this.MC.scroll_mc.line_mc.visible = true;
         }
         else
         {
            for(i = this.len; i < 7; i++)
            {
               this.addBG();
            }
            this.MC.scroll_mc.drag_mc.visible = false;
            this.MC.scroll_mc.line_mc.visible = false;
            this.arrange(this.arrMC);
         }
      }
      
      private function initScrollBar2() : void
      {
         var i:uint = 0;
         if(this.len > 7)
         {
            this.arrange(this.arrMC);
            this.MC.scroll_mc.visible = true;
            if(!this.ScrollBar2)
            {
               this.ScrollBar2 = new ScrollBarTop(this.MC.scroll_mc,this.MC.manMC,178,253);
            }
            else
            {
               this.ScrollBar2.reSet();
            }
            this.MC.scroll_mc.drag_mc.visible = true;
            this.MC.scroll_mc.line_mc.visible = true;
         }
         else
         {
            for(i = this.len; i < 7; i++)
            {
               this.addBG();
            }
            this.MC.scroll_mc.drag_mc.visible = false;
            this.MC.scroll_mc.line_mc.visible = false;
            this.arrange(this.arrMC);
         }
      }
      
      private function addBG() : void
      {
         var temp:* = new this.Man0();
         temp.pkbtn.visible = false;
         this.arrMC.push(temp);
         this.MC.manMC.addChild(temp);
      }
      
      private function initPanel(i:uint) : void
      {
         this.Type = i;
         this.ListUI.bgmc0.gotoAndStop(1);
         this.ListUI.bgmc1.gotoAndStop(1);
         this.ListUI.bgmc2.gotoAndStop(1);
         this.ListUI["bgmc" + i].gotoAndStop(2);
         this.ListUI.mc0.visible = false;
         this.ListUI.mc1.visible = false;
         this.ListUI.mc2.visible = false;
         this.ListUI["mc" + i].visible = true;
         this.ListUI["mc" + i].visible = true;
         if(i == 0)
         {
            this.ListUI.bg_mc.visible = true;
            this.ListUI.visitorUI0.visible = true;
            this.ListUI.visitorUI2.visible = false;
         }
         else if(i == 1)
         {
            this.ListUI.bg_mc.visible = false;
            this.ListUI.visitorUI0.visible = false;
            this.ListUI.visitorUI2.visible = false;
         }
         else
         {
            this.ListUI.bg_mc.visible = true;
            this.ListUI.visitorUI0.visible = false;
            this.ListUI.visitorUI2.visible = true;
         }
      }
      
      private function closeMC(e:MouseEvent) : void
      {
         this.ListUI.y = 1000;
      }
      
      private function arrange(arr:Array) : void
      {
         for(var k:uint = 0; k < arr.length; k++)
         {
            arr[k].y = 36 * k;
            arr[k].visible = true;
         }
      }
      
      private function drag_start(evt:MouseEvent) : void
      {
         this.visitorPanel.startDrag();
      }
      
      private function drag_stop(evt:MouseEvent) : void
      {
         this.visitorPanel.stopDrag();
      }
      
      private function drag_move(evt:MouseEvent) : void
      {
         evt.updateAfterEvent();
      }
      
      private function goto2(e:Event) : void
      {
         e.target.parent.gotoAndStop(2);
      }
      
      private function goto1(e:Event) : void
      {
         e.target.parent.gotoAndStop(1);
      }
   }
}

