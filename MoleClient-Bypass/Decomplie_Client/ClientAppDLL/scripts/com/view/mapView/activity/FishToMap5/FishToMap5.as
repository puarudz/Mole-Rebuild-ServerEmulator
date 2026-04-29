package com.view.mapView.activity.FishToMap5
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.socketlogic.ClientOnLineSerSocket;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.socket.action.ActionReq;
   import com.logic.socket.enterGame.EnterGameReq;
   import com.logic.socket.enterGame.EnterGameRes;
   import com.logic.socket.farm.farmSocket;
   import com.logic.socket.leaveGame.LeaveGameReq;
   import com.logic.socket.leaveGame.LeaveGameRes;
   import com.logic.socket.tryMachine.tryMachineSocket;
   import com.mapOldFunc.PolicDuty;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class FishToMap5
   {
      
      private static var instance:FishToMap5;
      
      private static var canotNew:Boolean = true;
      
      private var mainMc:MovieClip;
      
      private var seatNum:int;
      
      private var isJoin:Boolean;
      
      private var joinRequest:EnterGameReq = new EnterGameReq();
      
      private var fishTimer:Timer = new Timer(30000,1);
      
      private var process:uint;
      
      private var fishIcon:String;
      
      private var fishName:String;
      
      private var fishID:int;
      
      private var hasAngelSeed:int;
      
      public function FishToMap5()
      {
         super();
         if(canotNew)
         {
            throw new Error("FishToMap5不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : FishToMap5
      {
         if(!instance)
         {
            canotNew = false;
            instance = new FishToMap5();
            canotNew = true;
         }
         return instance;
      }
      
      public function init(tempMc:MovieClip, a:uint = 2, b:uint = 5) : void
      {
         var p:PolicDuty = null;
         this.mainMc = tempMc;
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeEventHandler);
         BC.addEvent(this,GV.onlineSocket,"read_" + 60014,this.onRead_60014);
         tryMachineSocket.mofaAbcEffects();
         BC.addEvent(this,GV.onlineSocket,EnterGameRes.ENTER_GAME,this.enterGameHandler);
         BC.addEvent(this,GV.onlineSocket,LeaveGameRes.LEAVE_GAME,this.leaveGameHandler);
         BC.addEvent(this,GV.onlineSocket,ClientOnLineSerSocket.ERROR_GAME,this.haveSitHandler);
         BC.addEvent(this,this.fishTimer,TimerEvent.TIMER_COMPLETE,this.onTimerFishComplete);
         for(var ix:int = int(a); ix <= b; ix++)
         {
            p = new PolicDuty();
            p.mapid = 5;
            p.click_btn = this.mainMc["woolBtn_" + ix];
            p.init();
         }
      }
      
      private function onRead_60014(evt:EventTaomee) : void
      {
         var posArr:Array = evt.EventObj.arr as Array;
         for(var posArrRound:int = 0; posArrRound < posArr.length; posArrRound++)
         {
            if(posArr[posArrRound].uType == 1)
            {
               if(posArr[posArrRound].uId != LocalUserInfo.getUserID())
               {
                  this.mainMc["rod" + posArrRound].gotoAndStop(2);
               }
            }
            else if(posArr[posArrRound].uId != LocalUserInfo.getUserID())
            {
               this.mainMc["rod" + posArrRound].gotoAndStop(1);
            }
         }
         BC.addEvent(this,GV.onlineSocket,"POLICE_DUTY_EVENT",this.joinAbcEvent);
      }
      
      private function joinAbcEvent(evt:EventTaomee) : void
      {
         trace("********************************走到對應的座位******************************");
         if(this.isJoin == true)
         {
            LeaveGameReq.leaveGame(this.seatNum);
         }
         else
         {
            this.seatNum = int(String(evt.EventObj.mc.name).slice(8));
            this.joinRequest.enterGame(this.seatNum);
         }
      }
      
      private function enterGameHandler(event:EventTaomee) : void
      {
         var actionReq:ActionReq = null;
         var rodNum:int = 0;
         trace("********************************進入遊戲********************************");
         try
         {
            if(event.EventObj.UserID == LocalUserInfo.getUserID())
            {
               if(LocalUserInfo.getMapID() == 5)
               {
                  this.seatNum = int(event.EventObj.ItemID) - 2;
               }
               else if(LocalUserInfo.getMapID() == 112)
               {
                  this.seatNum = int(event.EventObj.ItemID) - 1;
               }
               this.mainMc["rod" + this.seatNum].gotoAndStop(2);
               BC.removeEvent(this,GV.onlineSocket,"POLICE_DUTY_EVENT",this.joinAbcEvent);
               GV.isSitDown = true;
               this.isJoin = true;
               PeopleManageView(GV.MAN_PEOPLE).sitDown(7);
               actionReq = new ActionReq();
               actionReq.actions(3,7);
               this.mainMc.fishHide.gotoAndPlay(2);
               if(GV.MAN_PEOPLE.Petlevel > 0)
               {
                  PeopleManageView(GV.MAN_PEOPLE).lamu_say("    沉住氣，等魚漂抖動的時候再收桿。");
               }
               rodNum = int(Math.random() * 4) + 10;
               this.fishTimerHandle(rodNum);
            }
         }
         catch(E:Error)
         {
         }
      }
      
      private function leaveGameHandler(event:EventTaomee) : void
      {
         trace("********************************離開座位********************************");
         try
         {
            if(event.EventObj.UserID == LocalUserInfo.getUserID())
            {
               if(LocalUserInfo.getMapID() == 5)
               {
                  MoveTo.AutoFind(460,300,GV.MAN_PEOPLE);
               }
               else if(LocalUserInfo.getMapID() == 112)
               {
                  MoveTo.AutoFind(380,330,GV.MAN_PEOPLE);
               }
               BC.addEvent(this,GV.onlineSocket,"POLICE_DUTY_EVENT",this.joinAbcEvent);
               this.mainMc["rod" + this.seatNum].buttonMode = false;
               this.isJoin = false;
               GV.isSitDown = false;
               this.fishTimer.reset();
               this.mainMc["rod" + this.seatNum].gotoAndStop(1);
               this.mainMc.fishHide.gotoAndStop(1);
            }
         }
         catch(E:Error)
         {
         }
      }
      
      private function haveSitHandler(evt:EventTaomee) : void
      {
         trace("********************************位置已經有人********************************");
         Alert.showAlert(MainManager.getGameLevel(),"    動作慢了一步，位子已經被佔了。","",6,"D");
         if(LocalUserInfo.getMapID() == 5)
         {
            MoveTo.AutoFind(460,300,GV.MAN_PEOPLE);
         }
         else if(LocalUserInfo.getMapID() == 112)
         {
            MoveTo.AutoFind(380,330,GV.MAN_PEOPLE);
         }
         if(this.isJoin)
         {
            this.isJoin = false;
         }
      }
      
      private function fishTimerHandle(t:int) : void
      {
         this.fishTimer.delay = t * 1000;
         this.fishTimer.start();
      }
      
      private function onTimerFishComplete(evt:TimerEvent) : void
      {
         var rodNum:int = 0;
         if(this.mainMc["rod" + this.seatNum].currentFrame == 2)
         {
            this.mainMc["rod" + this.seatNum].gotoAndStop(3);
            this.mainMc["rod" + this.seatNum].buttonMode = true;
            BC.addEvent(this,this.mainMc["rod" + this.seatNum],MouseEvent.CLICK,this.onRod);
            if(GV.MAN_PEOPLE.Petlevel > 0)
            {
               PeopleManageView(GV.MAN_PEOPLE).lamu_say("    就是現在！收桿！");
            }
            rodNum = int(Math.random() * 4) + 2;
            this.fishTimerHandle(rodNum);
         }
         else if(this.mainMc["rod" + this.seatNum].currentFrame == 3)
         {
            LeaveGameReq.leaveGame(this.seatNum);
            Alert.showAlert(MainManager.getGameLevel(),"    你錯過了一次機會，魚跑了，下次收桿要及時啊。","",6,"D");
         }
      }
      
      private function onRod(evt:MouseEvent) : void
      {
         BC.removeEvent(this,this.mainMc["rod" + this.seatNum],MouseEvent.CLICK,this.onRod);
         this.mainMc["rod" + this.seatNum].buttonMode = false;
         if(this.mainMc["rod" + this.seatNum].currentFrame == 3)
         {
            this.fishTimer.reset();
            BC.addEvent(this,GV.onlineSocket,"read_" + 1957,this.onRead1957);
            farmSocket.getfishBy8();
         }
      }
      
      private function onRead1957(evt:EventTaomee) : void
      {
         var frameNum:int = 0;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1957,this.onRead1957);
         this.hasAngelSeed = int(evt.EventObj.angelSeedId);
         this.fishID = evt.EventObj.fishId;
         this.fishName = GoodsInfo.getItemNameByID(evt.EventObj.fishId);
         GF.sendSocket(CommandID.GOLDEN_BEAN_REWARD,0,6);
         if(int(evt.EventObj.fishId) == 0)
         {
            BC.addEvent(this,GV.onlineSocket,"NoFish",this.onNoFish);
            frameNum = int(this.mainMc["rod" + this.seatNum].totalFrames);
            this.mainMc["rod" + this.seatNum].gotoAndStop(frameNum);
            GV.onlineClass.chating(0,"/fd");
            if(GV.MAN_PEOPLE.Petlevel > 0)
            {
               PeopleManageView(GV.MAN_PEOPLE).lamu_say("    哎呀真可惜，魚兒逃掉了。再試一次吧。");
            }
            else
            {
               Alert.showAlert(MainManager.getGameLevel(),"    真可惜，魚吃了你的魚餌跑啦！","",6,"D");
            }
         }
         else
         {
            BC.addEvent(this,GV.onlineSocket,"ShowFish",this.onShowFish);
            if(int(evt.EventObj.fishId) >= 1270001)
            {
               this.fishIcon = "resource\\farm\\fish\\fish3\\" + evt.EventObj.fishId + ".swf";
            }
            else
            {
               this.fishIcon = GoodsInfo.getItemPathByID(evt.EventObj.fishId) + evt.EventObj.fishId + ".swf";
            }
            this.mainMc["rod" + this.seatNum].gotoAndStop(4);
         }
      }
      
      private function onNoFish(evt:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"NoFish",this.onNoFish);
         var rodNum:int = int(Math.random() * 4) + 10;
         this.fishTimerHandle(rodNum);
      }
      
      private function onShowFish(evt:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"ShowFish",this.onShowFish);
         var tempLoader:Loader = new Loader();
         tempLoader.load(VL.getURLRequest(this.fishIcon));
         this.mainMc["rod" + this.seatNum].icon.addChild(tempLoader);
         GV.onlineClass.chating(0,"/wx");
         if(GV.MAN_PEOPLE.Petlevel > 0)
         {
            if(this.hasAngelSeed != 0)
            {
               PeopleManageView(GV.MAN_PEOPLE).lamu_say("    快看，有一個圓滾滾" + GoodsInfo.getItemNameByID(this.hasAngelSeed) + "出現了，去天使園倉庫中看看吧。");
            }
            else
            {
               PeopleManageView(GV.MAN_PEOPLE).lamu_say("    哇，是" + this.fishName + "，它很稀有嗎？它很兇嗎？小主人快去百寶集查查。");
            }
         }
         else if(this.hasAngelSeed != 0)
         {
            if(this.fishID >= 1270001)
            {
               Alert.getIconByID_Alart(this.fishID,"    你釣到一條" + this.fishName + "魚苗,還發現了一個天使種子" + GoodsInfo.getItemNameByID(this.hasAngelSeed) + "，去天使倉庫中看看吧！");
            }
            else
            {
               Alert.getIconByID_Alart(this.fishID,"    你釣到一條" + this.fishName + ",還發現了一個天使種子" + GoodsInfo.getItemNameByID(this.hasAngelSeed) + "，去天使倉庫中看看吧！");
            }
         }
         else if(this.fishID >= 1270001)
         {
            Alert.getIconByID_Alart(this.fishID,"    釣到一條" + this.fishName + "魚苗,已經放入你的牧場倉庫中了！");
         }
         else
         {
            Alert.getIconByID_Alart(this.fishID,"    釣到一條" + this.fishName + ",已經放入你的百寶箱中了！");
         }
         LeaveGameReq.leaveGame(this.seatNum);
      }
      
      private function removeEventHandler(evt:*) : void
      {
         this.isJoin = false;
         GV.isSitDown = false;
         BC.removeEvent(this);
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEventHandler);
      }
   }
}

