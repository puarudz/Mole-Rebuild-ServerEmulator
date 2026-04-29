package com.module.tommyWork
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.manager.UIManager;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.logic.CarGameLogic.CarGameTimeCotrol;
   import com.logic.socket.enterGame.EnterGameRes;
   import com.logic.socket.home.HomeCarSocket;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class jcxWork
   {
      
      private static var instance:jcxWork;
      
      private var timeMC:MovieClip;
      
      private var isJoinCushawGame:Boolean = false;
      
      private var isTakeCushaw:Boolean = false;
      
      private var MapBool:Boolean = false;
      
      private var time:uint;
      
      private var itemID:uint;
      
      public var taskid:uint;
      
      public function jcxWork()
      {
         super();
      }
      
      public static function getInstance() : jcxWork
      {
         if(instance == null)
         {
            instance = new jcxWork();
         }
         return instance;
      }
      
      public function addGameEvent(_taskid:uint, _itemID:uint, _time:uint) : void
      {
         this.itemID = _itemID;
         this.taskid = _taskid;
         this.time = _time;
         HomeCarSocket.RentACar();
         this.isJoinCushawGame = true;
         this.addTimeMC();
         BC.addEvent(this,GV.onlineSocket,CarGameTimeCotrol.CURRENTCOUNT,this.getTimeEvent);
         CarGameTimeCotrol.getInstance().startGameTime();
         BC.addEvent(this,GV.onlineSocket,"CAR_GAME_MAP",this.game_car_MapHandler);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1701,this.carDischarging);
         BC.addEvent(this,GV.onlineSocket,"itemSelectHandler",this.removeEventHandler);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventMapHandler);
         BC.addEvent(this,GV.onlineSocket,EnterGameRes.ENTER_GAME,this.enterGameHandler);
      }
      
      private function carDischarging(evt:EventTaomee) : void
      {
         if(evt.EventObj.UserID == LocalUserInfo.getUserID())
         {
            this.gameOven_NO();
         }
      }
      
      private function enterGameHandler(evt:EventTaomee) : void
      {
         if(evt.EventObj.UserID != LocalUserInfo.getUserID())
         {
            return;
         }
         BC.removeEvent(this,GV.onlineSocket,EnterGameRes.ENTER_GAME,this.enterGameHandler);
         this.gameOven_NO();
      }
      
      private function removeEventMapHandler(evt:EventTaomee) : void
      {
         if(this.isJoinCushawGame)
         {
            if(Boolean(this.timeMC))
            {
               CarGameTimeCotrol.getInstance().pauseGameTime();
               this.timeMC.visible = false;
            }
         }
      }
      
      private function removeEventHandler(evt:EventTaomee) : void
      {
         var msg:String = null;
         if(this.isJoinCushawGame)
         {
            if(this.MapBool)
            {
               msg = "    不能使用地圖功能哦，開的太快，違反交通規則啦。去重新領取任務吧。";
               GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
               GC.setGTimeout(this.gameOven_NO,2000);
            }
            else
            {
               CarGameTimeCotrol.getInstance().keepGameTime();
               this.timeMC.visible = true;
            }
            if(LocalUserInfo.getMapID() > 1000)
            {
               msg = "    在任務中不能進入小屋哦！";
               GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
               GC.setGTimeout(this.gameOven_NO,2000);
            }
         }
      }
      
      private function game_car_MapHandler(event:EventTaomee) : void
      {
         if(this.isJoinCushawGame)
         {
            this.MapBool = true;
         }
      }
      
      private function stopSoundGame(event:Event) : void
      {
         if(this.isJoinCushawGame)
         {
            this.gameOven_NO();
         }
      }
      
      private function Handler1701(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_1701",this.Handler1701);
         if(event.EventObj.UserID == GV.MyInfo_userID)
         {
            this.gameOven_NO();
         }
      }
      
      private function getTimeEvent(evt:EventTaomee) : void
      {
         var url:String = null;
         var msg:String = null;
         var myAlt:* = undefined;
         if(this.timeMC != null)
         {
            this.timeMC.mc.timeTxt.text = String(this.time - evt.EventObj.timeNum) + "秒";
         }
         if(evt.EventObj.timeNum == this.time)
         {
            url = "resource/allJob/AlertPic/beta/jiang.swf";
            msg = "    真是遺憾，時間到了呢。我等不及了，還有很多駕駛員等著用車，我就先把貨車收回啦。你可以再來重新領取任務。";
            myAlt = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"ok",true,false,"SMCUI");
            this.gameOven_NO();
         }
         if(this.isJoinCushawGame == false)
         {
            this.gameOven_NO();
         }
      }
      
      private function addTimeMC() : void
      {
         var cl:Class = UIManager.getClass("jishiqi");
         this.timeMC = new cl();
         this.timeMC.y = 120;
         this.timeMC.mc.timeTxt.text = String(this.time) + "秒";
         MainManager.getGameLevel().addChild(this.timeMC);
         BC.addEvent(this,this.timeMC,MouseEvent.MOUSE_OVER,this.showTip);
         BC.addEvent(this,this.timeMC,MouseEvent.MOUSE_OUT,this.clearTip);
      }
      
      private function showTip(E:MouseEvent) : void
      {
         GF.showTip(XMLInfo.transportJobLib[this.taskid].tips,{
            "x":E.stageX + 20,
            "y":E.stageY - 10
         });
      }
      
      private function clearTip(E:MouseEvent) : void
      {
         GF.clearTip();
      }
      
      private function gameOven_NO() : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_1701",this.Handler1701);
         if(PeopleManageView(GV.MAN_PEOPLE).hasCar)
         {
            HomeCarSocket.DOWNCar();
         }
         this.MapBool = false;
         this.isTakeCushaw = false;
         this.isJoinCushawGame = false;
         CarGameTimeCotrol.getInstance().clearGameTime();
         this.removeTimeMC();
      }
      
      public function gameOvenEvent() : void
      {
         if(this.isTakeCushaw == true)
         {
            this.gameOven_NO();
         }
      }
      
      public function setjoinGame(bool:Boolean) : void
      {
         this.isJoinCushawGame = bool;
      }
      
      public function getjoinGame() : Boolean
      {
         return this.isJoinCushawGame;
      }
      
      public function setTakeCushaw(bool:Boolean) : void
      {
         this.isTakeCushaw = bool;
      }
      
      public function getTakeCushaw() : Boolean
      {
         return this.isTakeCushaw;
      }
      
      private function removeTimeMC() : void
      {
         var temp:DisplayObject = null;
         if(Boolean(MainManager.getAppLevel().getChildByName("transportJobMC")))
         {
            temp = MainManager.getAppLevel().getChildByName("transportJobMC");
            MainManager.getAppLevel().removeChild(temp);
            temp = null;
         }
         if(Boolean(this.timeMC))
         {
            GC.clearAllChildren(this.timeMC);
            this.timeMC.parent.removeChild(this.timeMC);
            this.timeMC = null;
         }
         BC.removeEvent(this);
      }
   }
}

