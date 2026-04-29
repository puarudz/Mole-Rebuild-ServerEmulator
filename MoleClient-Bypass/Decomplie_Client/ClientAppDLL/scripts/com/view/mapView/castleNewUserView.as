package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.Tween.TweenLite;
   import com.common.util.MovieClipUtil;
   import com.common.util.StringUtil;
   import com.core.MainManager;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.info.LocalUserInfo;
   import com.core.manager.LevelManager;
   import com.core.music.TopicMusicManager;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.GameframeLogic.GameframeLogic;
   import com.logic.JobLogic.JobExpandLogic;
   import com.logic.socket.modUserColor.ModUserColorReq;
   import com.logic.socket.modUserColor.ModUserColorRes;
   import com.logic.socket.modUserInfo.ModUserInfoReq;
   import com.logic.socket.modUserInfo.ModUserInfoRes;
   import com.logic.socket.petSocket.adoptPet.petFollowReq;
   import com.logic.socket.petSocket.adoptPet.petInfoReq;
   import com.logic.socket.petSocket.adoptPet.petInfoRes;
   import com.logic.socket.petSocket.askingPet.PetAskReq;
   import com.module.activityModule.checkCloth;
   import com.module.loadExtentPanel.LoadPanel;
   import com.module.npc.dialog.TalkEvent;
   import com.module.npcFollowMole.FollowMole;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.PeopleManager;
   import com.mole.app.manager.StatisticsManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.map.MapManager;
   import com.mole.app.task.Task;
   import com.mole.app.task.TaskManager;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.activity.Task83.SoundManager;
   import com.view.toolView.toolView;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.system.Capabilities;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.utils.ByteArray;
   import flash.utils.clearInterval;
   
   public class castleNewUserView extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var btnLevel:MovieClip;
      
      public var TopLevel:MovieClip;
      
      private var taskObj:Object;
      
      private var nameMC:MovieClip;
      
      private var textNumX:Number;
      
      private var nameStr:String;
      
      private var intervalFun:uint;
      
      private var modUserInfoReq:ModUserInfoReq;
      
      private var playNum:int;
      
      private var sayBool:Boolean = false;
      
      private var movingLoad:Loader;
      
      private var movingMC:MovieClip;
      
      public function castleNewUserView()
      {
         super();
      }
      
      public static function get browserVersion() : String
      {
         var type:String = null;
         var ver:String = null;
         if(ExternalInterface.available)
         {
            type = ExternalInterface.call("getBrowserType");
            ver = ExternalInterface.call("getBrowserVersion");
            return type + ":" + ver;
         }
         return "null";
      }
      
      public static function get ad() : String
      {
         if(ExternalInterface.available)
         {
            return ExternalInterface.call("getAd");
         }
         return "null";
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.btnLevel = GV.MC_mapFrame["btnLevel"];
         this.TopLevel = GV.MC_mapFrame["top_mc"];
         this.nameMC = this.TopLevel.name_UI;
         StatisticsManager.send(413);
      }
      
      override public function init() : void
      {
         super.init();
         JobExpandLogic.getJobExpand().getOneJob(300);
         BC.addEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.getJobDataHandler);
         SystemEventManager.addEventListener("helpPet",this.helpPet);
         SystemEventManager.addEventListener("newPets_openAlt",this.openHandler);
         SystemEventManager.addEventListener("newPets_loadPan",this.onLoadPan);
         SystemEventManager.addEventListener("newPets_newTaskOven",this.newTaskOvenFun);
         BC.addEvent(this,GV.onlineSocket,"newPets_chooseColor",this.chooseColorHandler);
         TopicMusicManager.instance.stopSound();
         GameframeLogic.playMousicHandler();
         var taskMC:Sprite = MainManager.getToolLevel().getChildByName("notice_mc") as Sprite;
         if(Boolean(taskMC))
         {
            taskMC.visible = false;
         }
         toolView.getInstance().hide();
      }
      
      private function getJobDataHandler(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.getJobDataHandler);
         this.taskObj = evt.EventObj.obj.fla;
         var self:PeopleManageView = PeopleManager.getPeopleView(LocalUserInfo.getUserID());
         self.delTarget();
         switch(evt.EventObj.obj.flag)
         {
            case 0:
               PetAskReq.askOnePet();
               this.addChildPlayMC();
               break;
            case 2:
               FollowMole.NpcFollow(1139);
               self.isMoving = false;
               mapSay(2);
               break;
            case 3:
               FollowMole.NpcFollow(1139);
               self.isMoving = false;
               mapSay(4);
               break;
            case 4:
               FollowMole.NpcFollow(1139);
               self.isMoving = false;
               mapSay(5);
               break;
            default:
               this.addChildPlayMC();
         }
      }
      
      private function addChildPlayMC() : void
      {
         if(Boolean(this.movingLoad))
         {
            return;
         }
         this.movingLoad = new Loader();
         BC.addEvent(this,this.movingLoad.contentLoaderInfo,Event.COMPLETE,this.getMOvingMC);
         this.movingLoad.load(new URLRequest("resource/task/task382/taskmap137_0.swf"));
         this.TopLevel["addMC"].addChild(this.movingLoad);
      }
      
      private function getMOvingMC(e:Event) : void
      {
         BC.removeEvent(this,this.movingLoad.contentLoaderInfo,Event.COMPLETE,this.getMOvingMC);
         this.movingMC = this.movingLoad.content as MovieClip;
         this.movingMC.gotoAndPlay(1);
         BC.addEvent(this,this.movingMC,"playOver_137_0",this.beginSay);
         BC.addEvent(this,this.movingMC,"playOver_137_1",this.beginSay);
      }
      
      private function beginSay(e:Event) : void
      {
         var obj:Object = null;
         if(e.type == "playOver_137_0")
         {
            mapSay(1);
            return;
         }
         if(e.type == "playOver_137_1")
         {
            toolView.getInstance().hide();
            this.TopLevel["addMC"].visible = false;
            FollowMole.NpcFollow(1139);
            BC.addEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.getJobDataHandler);
            obj = {"flag":2};
            JobExpandLogic.getJobExpand().setOneJob(300,obj);
            return;
         }
      }
      
      private function helpPet(e:*) : void
      {
         StatisticsManager.send(414);
         toolView.getInstance().hide();
         this.movingMC.gotoAndPlay("a2");
         BC.addEvent(this,this.TopLevel["addMC"],MouseEvent.CLICK,this.helpPetNext);
      }
      
      private function helpPetNext(e:MouseEvent) : void
      {
         StatisticsManager.send(415);
         BC.removeEvent(this,this.TopLevel["addMC"],MouseEvent.CLICK,this.helpPetNext);
         this.movingMC.gotoAndPlay("a3");
      }
      
      private function openHandler(evt:*) : void
      {
         StatisticsManager.send(416);
         toolView.getInstance().hide();
         var self:PeopleManageView = PeopleManager.getPeopleView(LocalUserInfo.getUserID());
         self.isMoving = false;
         this.nameMC.visible = true;
         this.nameMC.alpha = 0.1;
         TweenLite.to(this.nameMC,0.1,{"alpha":1});
         var textField:TextField = this.nameMC.name_txt;
         textField.type = TextFieldType.INPUT;
         this.nameMC.name_txt.text = this.changName();
         GV.onlineSocket.addEventListener("dirty_word",this.errorName);
         BC.addEvent(this,this.nameMC.chang_btn,MouseEvent.CLICK,this.changTxtName);
         BC.addEvent(this,this.nameMC.save_btn,MouseEvent.CLICK,this.saveNameAlt);
      }
      
      private function errorName(e:Event) : void
      {
         Alert.closeAllAlert();
         this.nameMC.name_txt.text = this.changName();
      }
      
      private function saveNameAlt(e:MouseEvent) : void
      {
         var msg:String = null;
         var myAle:* = undefined;
         StatisticsManager.send(419);
         this.nameStr = this.nameMC.name_txt.text;
         if(this.trimStr(this.nameStr).length > 1)
         {
            msg = "    你確定要取“" + this.nameStr + "”這個名字嗎？";
            myAle = GF.showAlert(GV.MC_AppLever,msg,"",100,"sure,cancel",true,false,"E");
            BC.addOnceEvent(this,myAle,Alert.CLICK_ + "1",this.alClickHandler);
         }
         else
         {
            Alert.smileAlart("    告訴我你叫什麼名字吧！");
         }
      }
      
      private function alClickHandler(evt:*) : void
      {
         var lv:uint = 0;
         var ip:uint = 0;
         var navigate:ByteArray = null;
         var os:ByteArray = null;
         var ads:ByteArray = null;
         StatisticsManager.send(420);
         if(ExternalInterface.available)
         {
            ExternalInterface.call("eval","function getBrowserType() { var typeList = [\"chrome\", \"firefox\", \"msie\", \"opera\", \"safari\"]; var browser = window.T.browser; for (var i = 0; i < typeList.length; i++) { if (browser[typeList[i]]) { return typeList[i]; } } return \"unknown\"; }");
            ExternalInterface.call("eval","function getBrowserVersion(){return window.T.browser.version;}");
            ExternalInterface.call("eval","function getAd() { try { return ad.get.g(); } catch (e) { return \"none\" }");
            lv = uint(GF.leve(LocalUserInfo.getExp()));
            ip = 0;
            navigate = StringUtil.FillString(browserVersion,19);
            os = StringUtil.FillString(Capabilities.version,19);
            ads = StringUtil.FillString("0",19);
            GF.sendSocket(CommandID.STATICS_PLAYER_INTRO,navigate,os,ads);
         }
         this.modUserInfoReq = new ModUserInfoReq();
         BC.addEvent(this,GV.onlineSocket,ModUserInfoRes.MOD_USER_INFO,this.changeUserInfo);
         this.modUserInfoReq.modUserInfo(this.nameStr);
      }
      
      private function changeUserInfo(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,ModUserInfoRes.MOD_USER_INFO,this.changeUserInfo);
         GV.onlineSocket.removeEventListener("dirty_word",this.errorName);
         StatisticsManager.send(309);
         BC.removeEvent(this,this.nameMC);
         if(Boolean(this.nameMC.name_txt))
         {
            this.nameMC.name_txt.visible = false;
         }
         TweenLite.to(this.nameMC,1,{"alpha":0});
         var id:int = int(evt.EventObj.UserID);
         if(id == LocalUserInfo.getUserID())
         {
            GV.MyInfo_nickName = evt.EventObj.Nick;
            LocalUserInfo.setNickName(evt.EventObj.Nick);
            GV.MAN_PEOPLE.nickName = evt.EventObj.Nick;
            MainManager.getGlobalObject().data.nickName = LocalUserInfo.getNickName();
            MainManager.getGlobalObject().flush();
         }
         var tempMC:* = GF.getPeopleByID(id);
         if(checkCloth.checkOtherItem(12619,id))
         {
            tempMC.avatarMC.nickName_txt.htmlText = "<font color=\'#FF0000\'>" + String(evt.EventObj.Nick) + "</font>";
         }
         else
         {
            tempMC.avatarMC.nickName_txt.text = evt.EventObj.Nick;
         }
         if(GF.returnGM(id))
         {
            tempMC.avatarMC.nickName_txt.textColor = 255;
         }
         this.updateOnlineList(evt);
         BC.addEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.getJobDataEvent);
         var obj:Object = {"flag":3};
         JobExpandLogic.getJobExpand().setOneJob(300,obj);
      }
      
      private function getJobDataEvent(evt:EventTaomee) : void
      {
         BC.removeEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.getJobDataEvent);
         mapSay(4);
      }
      
      private function updateOnlineList(evt:*) : void
      {
         for(var i:uint = 0; i < GV.OnLineArray.length; i++)
         {
            if(evt.EventObj.UserID == GV.OnLineArray[i].UserID)
            {
               GV.OnLineArray[i].Nick = evt.EventObj.Nick;
               break;
            }
         }
      }
      
      private function changTxtName(e:MouseEvent) : void
      {
         StatisticsManager.send(418);
         this.nameMC.name_txt.text = this.changName();
      }
      
      private function changName() : String
      {
         var _name:String = "";
         var _arr:Array = ["小摩爾","小鼴鼠","萌小乖","超能俠","萬能小博士","開心小不點","愛心小鼴鼠","陽光小球手","琪琪公主","元素騎士"];
         var _ip:uint = uint(Math.random() * 10);
         return _arr[_ip];
      }
      
      private function onLoadPan(e:SystemEvent) : void
      {
         StatisticsManager.send(422);
         toolView.getInstance().hide();
         new LoadPanel("resource/task/newTaskMC.swf","createMoleColor",LevelManager.appLevel);
      }
      
      private function chooseColorHandler(evt:EventTaomee) : void
      {
         StatisticsManager.send(425);
         BC.removeEvent(this,GV.onlineSocket,"newPets_chooseColor",this.chooseColorHandler);
         BC.addEvent(this,GV.onlineSocket,ModUserColorRes.MOD_USER_COLOR,this.getUsersBasicObj);
         var clorReq:ModUserColorReq = new ModUserColorReq();
         var color:String = evt.EventObj.color;
         clorReq.modUserColor(0,uint(color));
         LocalUserInfo.setFamily(Number(Number(color).toString(10)));
         MainManager.getGlobalObject().data.Family = LocalUserInfo.getFamily();
         MainManager.getGlobalObject().flush();
      }
      
      private function getUsersBasicObj(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,ModUserColorRes.MOD_USER_COLOR,this.getUsersBasicObj);
         BC.addEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.getJobDataHandler);
         var obj:Object = {"flag":4};
         JobExpandLogic.getJobExpand().setOneJob(300,obj);
         StatisticsManager.send(310);
      }
      
      private function newTaskOvenFun(evt:*) : void
      {
         StatisticsManager.send(426);
         SoundManager.stopAll();
         BC.removeEvent(this,TalkEvent,"newPets_newTaskOven",this.newTaskOvenFun);
         var resID:uint = DownLoadManager.add("resource/task/task382/newTaskOvenMC.swf",ResType.DISPLAY_OBJECT,true,"請耐心等待~~~~");
         DownLoadManager.addEvent(resID,this.onLoadOverMovie);
      }
      
      private function onLoadOverMovie(e:DownLoadEvent) : void
      {
         var mc:MovieClip;
         StatisticsManager.send(428);
         mc = e.data as MovieClip;
         mc.gotoAndPlay(2);
         LevelManager.appLevel.addChild(mc);
         MovieClipUtil.playEndAndFunc(mc,function():void
         {
            var task:Task = null;
            FollowMole.NpcUnFollow(1139);
            seeHomePetCount();
            StatisticsManager.send(429);
            task = TaskManager.getTask(382);
            if(Boolean(task))
            {
               task.apply();
            }
            task = TaskManager.getTask(300);
            if(Boolean(task))
            {
               task.over();
            }
            MapManager.enterMap(15);
         });
      }
      
      private function seeHomePetCount() : void
      {
         BC.addEvent(this,GV.onlineSocket,petInfoRes.GET_PETINFO_SUCC,this.getPetInfo);
         var petInfo:petInfoReq = new petInfoReq();
         petInfo.sendInfoReq(LocalUserInfo.getUserID(),0,1);
      }
      
      private function getPetInfo(evt:EventTaomee) : void
      {
         var petfollowreq:petFollowReq = null;
         BC.removeEvent(this,GV.onlineSocket,petInfoRes.GET_PETINFO_SUCC,this.getPetInfo);
         if(Boolean(evt.EventObj.arr[0]) && evt.EventObj.arr[0].Level == 2)
         {
            petfollowreq = new petFollowReq();
            petfollowreq.sendFollowReq(evt.EventObj.arr[0].SpriteID,1);
         }
      }
      
      private function trimStr(str:String) : String
      {
         var _str:String = str;
         while(_str.substr(0,1) == " ")
         {
            _str = _str.substr(1);
         }
         return _str;
      }
      
      override public function destroy() : void
      {
         GV.onlineSocket.removeEventListener("dirty_word",this.errorName);
         clearInterval(this.intervalFun);
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
         this.btnLevel = null;
         this.TopLevel = null;
         super.destroy();
      }
   }
}

