package com.view.mapView.activity.mapActivity.elaineParty
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.soundControl.soundControl;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.elaineParty.ElainePartySocket;
   import com.view.mapView.activity.mapActivity.ElaineCharityPartyActivity;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class PartyCommonControler
   {
      
      private static var _instance:PartyCommonControler;
      
      public static const GUESS_GAME_STSTE_NOT_OPEN:int = 0;
      
      public static const GUESS_GAME_STSTE_RUNING:int = 1;
      
      public static const GUESS_GAME_STSTE_END:int = 2;
      
      private var _partyInfoTimer:Timer;
      
      private var _partyInfoObservers:Array;
      
      private var _guessGameState:int = 0;
      
      private var _guessGameItem:int = 0;
      
      private var _guessGameItemCount:int = 0;
      
      private var _endTimeCount:int;
      
      private var _guessGameStateObservers:Array;
      
      private var _winerArr:Array;
      
      private var _guessGameTimerObservers:Array;
      
      private var _guessGameTimer:Timer;
      
      public function PartyCommonControler()
      {
         super();
         this._guessGameTimerObservers = new Array();
         this._guessGameStateObservers = new Array();
         this._partyInfoObservers = new Array();
         this.RegisterGuessStateObserver(this.GuessGameStateObserver);
      }
      
      public static function get instance() : PartyCommonControler
      {
         if(_instance == null)
         {
            _instance = new PartyCommonControler();
         }
         return _instance;
      }
      
      public function Init() : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + ElainePartySocket.CharityDonateInfoCommand,this.UpdatePartyInfo);
         this.InitPartyInfoTimer();
         this.StartPartyInfoTimer();
      }
      
      public function Clear() : void
      {
         this.ClearGuessGameTimer();
         this.ClearPartyInfoTimer();
         BC.removeEvent(this,GV.onlineSocket,"read_" + ElainePartySocket.CharityDonateInfoCommand,this.UpdatePartyInfo);
      }
      
      private function InitPartyInfoTimer() : void
      {
         this.ClearPartyInfoTimer();
         this._partyInfoTimer = new Timer(30000,100000);
      }
      
      private function StartPartyInfoTimer() : void
      {
         if(Boolean(this._partyInfoTimer))
         {
            BC.addEvent(this._partyInfoTimer,this._partyInfoTimer,TimerEvent.TIMER,this.OnPartyTimerHandler);
            this._partyInfoTimer.start();
         }
      }
      
      private function OnPartyTimerHandler(e:TimerEvent) : void
      {
         ElainePartySocket.CharityDonateInfo();
      }
      
      private function ClearPartyInfoTimer() : void
      {
         if(Boolean(this._partyInfoTimer))
         {
            this._partyInfoTimer.stop();
            BC.removeEvent(this._partyInfoTimer);
            this._partyInfoTimer = null;
         }
      }
      
      private function UpdatePartyInfo(e:EventTaomee) : void
      {
         var fun:Function = null;
         var obj:Object = e.EventObj;
         for each(fun in this._partyInfoObservers)
         {
            fun(obj.userCount,obj.moneyCount,obj.itemCount);
         }
      }
      
      public function RegisterPartyInfoObserver(fun:Function) : void
      {
         var index:int = this._partyInfoObservers.indexOf(fun);
         if(index < 0)
         {
            this._partyInfoObservers.push(fun);
         }
      }
      
      public function UnRegisterPartyInfoObserver(fun:Function) : void
      {
         var index:int = this._partyInfoObservers.indexOf(fun);
         if(index >= 0)
         {
            this._partyInfoObservers.splice(index,1);
         }
      }
      
      public function CheckGuessGameState() : void
      {
         ElainePartySocket.GuessGameCheck();
      }
      
      public function get guessGameState() : int
      {
         return this._guessGameState;
      }
      
      public function get guessGameItem() : int
      {
         return this._guessGameItem;
      }
      
      public function get guessGameItemCount() : int
      {
         return this._guessGameItemCount;
      }
      
      public function get winerArr() : Array
      {
         return this._winerArr;
      }
      
      private function UpdateGuessGameStateHandler(e:EventTaomee) : void
      {
         var obj:Object = e.EventObj;
         if(e.type == "read_" + ElainePartySocket.GuessGameCheckCommand)
         {
            if(obj.itemId == 0)
            {
               this._guessGameState = GUESS_GAME_STSTE_END;
            }
            else if(obj.itemId == 1)
            {
               this._guessGameState = GUESS_GAME_STSTE_NOT_OPEN;
            }
            else
            {
               this._guessGameItem = obj.itemId;
               this._guessGameItemCount = obj.count;
               this._guessGameState = GUESS_GAME_STSTE_RUNING;
               this._endTimeCount = obj.time;
            }
            this._winerArr = null;
         }
         else if(e.type == "read_" + ElainePartySocket.GuessGameEndCommand)
         {
            this._guessGameState = GUESS_GAME_STSTE_END;
            this._winerArr = obj.winerArr;
            this._guessGameItem = obj.itemId;
         }
         this.UpdateGuessGameState();
      }
      
      private function UpdateGuessGameState() : void
      {
         var fun:Function = null;
         for each(fun in this._guessGameStateObservers)
         {
            fun(this._guessGameState,this._guessGameItem,this._guessGameItemCount);
         }
      }
      
      public function RegisterGuessStateObserver(fun:Function) : void
      {
         var index:int = this._guessGameStateObservers.indexOf(fun);
         if(index < 0)
         {
            this._guessGameStateObservers.push(fun);
         }
      }
      
      public function UnRegisterGuessStateObserver(fun:Function) : void
      {
         var index:int = this._guessGameTimerObservers.indexOf(fun);
         if(index >= 0)
         {
            this._guessGameTimerObservers.splice(index,1);
         }
      }
      
      private function GuessGameStateObserver(state:int, item:int, count:int) : void
      {
         var obj:Object = null;
         var elaineMCUrl:String = null;
         var name:String = null;
         var itemPosition:String = null;
         var sc:soundControl = null;
         var msg:String = null;
         if(state == GUESS_GAME_STSTE_RUNING)
         {
            this.InitGuessGameTImer(this._endTimeCount);
            this.StartGuessGameTimer();
         }
         else if(state == GUESS_GAME_STSTE_END)
         {
            for each(obj in this._winerArr)
            {
               if(obj.id == LocalUserInfo.getUserID())
               {
                  LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() - obj.money);
                  if(GV.MapInfo_mapID == 142)
                  {
                     elaineMCUrl = "resource/allJob/AlertPic/elaine.swf";
                     name = GoodsInfo.getItemNameByID(item);
                     itemPosition = GoodsInfo.getItemCollectionBoxNameByID(item);
                     sc = new soundControl();
                     sc.getSound(ElaineCharityPartyActivity.instance._app.getDefinition("WinSound"),0,1);
                     msg = "    恭喜你成功贏得了這次競猜，" + count + "個" + name + "已經放入你的" + itemPosition + "啦！感謝你奉獻愛心！";
                     Alert.showAlert(MainManager.getAppLevel(),elaineMCUrl,msg,Alert.CHANG_ALERT,"iknow",true,false,"SMCUI");
                  }
                  break;
               }
            }
         }
      }
      
      private function InitGuessGameTImer(count:int) : void
      {
         this.ClearGuessGameTimer();
         this._guessGameTimer = new Timer(1000,count);
      }
      
      private function ClearGuessGameTimer() : void
      {
         if(Boolean(this._guessGameTimer))
         {
            this._guessGameTimer.stop();
            BC.removeEvent(this._guessGameTimer);
            this._guessGameTimer = null;
         }
      }
      
      private function StartGuessGameTimer() : void
      {
         if(Boolean(this._guessGameTimer))
         {
            BC.addEvent(this._guessGameTimer,this._guessGameTimer,TimerEvent.TIMER,this.OnTimerHandler);
            this._guessGameTimer.start();
         }
      }
      
      private function OnTimerHandler(e:TimerEvent) : void
      {
         var fun:Function = null;
         var lastCount:int = this._guessGameTimer.repeatCount - this._guessGameTimer.currentCount;
         var SynchronizCount:int = 20;
         if(lastCount > 0 && lastCount % SynchronizCount == 0)
         {
            ElainePartySocket.GuessGameCheck();
         }
         for each(fun in this._guessGameTimerObservers)
         {
            fun(lastCount);
         }
      }
      
      public function RegisterGuessTimerObserver(fun:Function) : void
      {
         var index:int = this._guessGameTimerObservers.indexOf(fun);
         if(index < 0)
         {
            this._guessGameTimerObservers.push(fun);
         }
      }
      
      public function UnRegisterGuessTimerObserver(fun:Function) : void
      {
         var index:int = this._guessGameTimerObservers.indexOf(fun);
         if(index >= 0)
         {
            this._guessGameTimerObservers.splice(index,1);
         }
      }
   }
}

