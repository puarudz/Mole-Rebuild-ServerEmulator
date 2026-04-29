package com.logic.CarGameLogic
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.manager.IndexManager;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.RaceSportLogic.RaceSportLogic;
   import com.logic.socket.raceSport.RaceSportJoin;
   import com.module.activityModule.Presented;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class CarGameLogic
   {
      
      private static var instance:CarGameLogic;
      
      private var isJoinGame:Boolean = false;
      
      private var gameStartMC:MovieClip;
      
      private var timeMC:MovieClip;
      
      private var gameTimeNum:uint;
      
      private var gameType:uint;
      
      private var score:uint;
      
      public function CarGameLogic()
      {
         super();
      }
      
      public static function getInstance() : CarGameLogic
      {
         if(instance == null)
         {
            instance = new CarGameLogic();
         }
         return instance;
      }
      
      public function addGameEvent() : void
      {
         BC.addEvent(this,GV.onlineSocket,"POLICE_DUTY_EVENT",this.getCarGameEvent);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEvent);
      }
      
      private function removeEvent(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"POLICE_DUTY_EVENT",this.getCarGameEvent);
         BC.removeEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEvent);
      }
      
      private function getCarGameEvent(evt:EventTaomee) : void
      {
         var msg:String = null;
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(!p.hasCar)
         {
            msg = "    要開著你的炫風車一起來參加比賽哦。";
            GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
            return;
         }
         if(p.car_Info.ItemID == 1300005)
         {
            return;
         }
         if(evt.EventObj.mc.name != "joinGameBtn")
         {
            return;
         }
         if(!this.isJoinGame)
         {
            this.isJoinGame = true;
            if(Boolean(this.gameStartMC))
            {
               this.gameStartMC.gotoAndStop(2);
            }
            BC.addEvent(this,GV.onlineSocket,"itemSelectHandler",this.removeEventHandler);
            BC.addEvent(this,GV.onlineSocket,"iskaddish",this.gameCancelEvent);
            BC.addEvent(this,GV.onlineSocket,"CARGAME_START",this.gameStartEvent);
         }
      }
      
      private function gameStartEvent(evt:Event) : void
      {
         BC.addEvent(this,GV.onlineSocket,"POLICE_DUTY_EVENT",this.carGameEnd);
         BC.removeEvent(this,GV.onlineSocket,"iskaddish",this.gameCancelEvent);
         BC.removeEvent(this,GV.onlineSocket,"CARGAME_START",this.gameStartEvent);
         this.addTimeMC();
         BC.addEvent(this,GV.onlineSocket,CarGameTimeCotrol.CURRENTCOUNT,this.getTimeEvent);
         CarGameTimeCotrol.getInstance().startGameTime();
      }
      
      private function getTimeEvent(evt:EventTaomee) : void
      {
         if(this.timeMC != null)
         {
            this.timeMC.mc.timeTxt.text = String(evt.EventObj.timeNum) + "秒";
         }
      }
      
      private function gameCancelEvent(evt:Event = null) : void
      {
         CarGameTimeCotrol.getInstance().clearGameTime();
         this.isJoinGame = false;
         if(Boolean(this.gameStartMC))
         {
            this.gameStartMC.gotoAndStop(1);
         }
         BC.removeEvent(this,GV.onlineSocket,"iskaddish",this.gameCancelEvent);
         BC.removeEvent(this,GV.onlineSocket,"CARGAME_START",this.gameStartEvent);
         BC.removeEvent(this,GV.onlineSocket,"POLICE_DUTY_EVENT",this.carGameEnd);
      }
      
      public function carGamePause() : void
      {
         CarGameTimeCotrol.getInstance().pauseGameTime();
      }
      
      public function carGameKeep() : void
      {
         CarGameTimeCotrol.getInstance().keepGameTime();
      }
      
      public function carGameEnd(evt:EventTaomee) : void
      {
         if(evt.EventObj.mc.name != "endGameBtn")
         {
            return;
         }
         if(this.isJoinGame)
         {
            this.isJoinGame = false;
            this.gameCancelEvent();
            CarGameTimeCotrol.getInstance().clearGameTime();
            this.removeTimeMC();
            Presented.getInstance().superlamuParty(54);
         }
      }
      
      private function removeEventHandler(evt:EventTaomee) : void
      {
         var mapID:int = 0;
         if(this.isJoinGame)
         {
            mapID = LocalUserInfo.getMapID();
            if(mapID > 85 && mapID < 93)
            {
               return;
            }
            this.gameCancelEvent();
            CarGameTimeCotrol.getInstance().clearGameTime();
            this.removeTimeMC();
         }
      }
      
      private function addTimeMC() : void
      {
         var tempMC:Class = GV.Lib_Map.getClass("jishiqi");
         this.timeMC = new tempMC();
         this.timeMC.y = 120;
         MainManager.getGameLevel().addChild(this.timeMC);
      }
      
      private function removeTimeMC() : void
      {
         GC.clearAllChildren(this.timeMC);
         this.timeMC.parent.removeChild(this.timeMC);
         this.timeMC = null;
      }
      
      private function moveEvent() : void
      {
         var tempX:int = GV.MAN_PEOPLE.x - 130;
         MoveTo.AutoFind(tempX,GV.MAN_PEOPLE.y,GV.MAN_PEOPLE);
         this.noJoinGameTips();
      }
      
      public function noJoinGameTips() : void
      {
         var msg:String = "    只有擁有炫風駕照的小摩爾才能參加旋風拉力賽哦！快去交通署裡的滴滴嘟嘟學習班學習吧，我在這等你喲！";
         var url:String = "resource/allJob/AlertPic/beta/JoinSport_2.swf";
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
      }
      
      public function getScoceHandler(timeNum:int, type:int) : void
      {
         Presented.getInstance().superlamuParty(53);
      }
      
      public function getDataBack(evt:Event) : void
      {
         this.sendScoreHandler();
      }
      
      private function sendScoreHandler() : void
      {
         this.score = this.conversionScore(this.gameTimeNum,this.gameType);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1552,this.getTaskEvent);
         BC.addEvent(this,GV.onlineSocket,"race_sport_errorID",this.TaskErrorEvent);
         RaceSportJoin.addRaceScore(this.gameType,this.score,this.gameTimeNum);
      }
      
      private function TaskErrorEvent(evt:EventTaomee) : void
      {
         var msg:String = null;
         BC.removeEvent(this,GV.onlineSocket,"race_sport_errorID",this.TaskErrorEvent);
         if(evt.EventObj.ID == 100050)
         {
            msg = "　   恭喜你完成計時比賽，用時" + this.gameTimeNum + "秒。";
            GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
         }
      }
      
      private function getTaskEvent(evt:EventTaomee) : void
      {
         var i:int = 0;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1552,this.getTaskEvent);
         if(evt.EventObj.Flag == 1)
         {
            for(i = 1; i <= 4; i++)
            {
               if(i != this.gameType)
               {
                  RaceSportLogic["trackNum" + i] -= 1;
               }
            }
            this.showCards();
         }
         else
         {
            RaceSportLogic["trackNum" + this.gameType] += 1;
         }
         var msg:String = "　   恭喜你完成計時比賽，用時" + this.gameTimeNum + "秒。";
         GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
      }
      
      public function showCards() : void
      {
         var xuanfeng:MovieClip = IndexManager.getInstance().getMovieClip("xuanfeng");
         xuanfeng.x = 240;
         xuanfeng.y = 0;
         xuanfeng["team"].visible = true;
         xuanfeng["team"].gotoAndPlay(2);
         MainManager.getGameLevel().addChild(xuanfeng);
      }
      
      private function conversionScore(num:int, type:int) : int
      {
         var socre:int = 0;
         if(type == 1)
         {
            if(num <= 30)
            {
               return 10;
            }
            if(num <= 60)
            {
               return 5;
            }
            if(num > 60)
            {
               return 2;
            }
         }
         if(type == 2 || type == 3)
         {
            if(num <= 60)
            {
               return 10;
            }
            if(num <= 90)
            {
               return 5;
            }
            if(num > 90)
            {
               return 2;
            }
         }
         if(type == 4)
         {
            if(num <= 90)
            {
               return 10;
            }
            if(num <= 120)
            {
               return 5;
            }
            if(num > 120)
            {
               return 2;
            }
         }
         return 2;
      }
      
      public function set startMC(mc:MovieClip) : void
      {
         this.gameStartMC = mc;
      }
      
      public function set joinGame(bool:Boolean) : void
      {
         this.isJoinGame = bool;
      }
      
      public function get joinGame() : Boolean
      {
         return this.isJoinGame;
      }
   }
}

