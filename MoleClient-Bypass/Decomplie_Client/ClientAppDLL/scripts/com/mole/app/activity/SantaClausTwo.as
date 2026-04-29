package com.mole.app.activity
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.util.Tick;
   import com.core.info.ServerUpTime;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.mapEvent.MapEvent;
   import com.logic.socket.superlamuParty.superlamuPartySocket;
   import com.module.popupMsg.PopupMsgCtl;
   import com.mole.app.map.MapManager;
   import com.mole.app.utils.PlayMovie;
   import com.mole.net.MoleSharedObject;
   import flash.events.Event;
   import flash.utils.setTimeout;
   
   public class SantaClausTwo
   {
      
      private static var instance:SantaClausTwo;
      
      private static var _fireMovie:PlayMovie;
      
      private static var isChange:Boolean;
      
      private static var _count:int = -1;
      
      private var day24Arr:Array = [1,68,6,204,77,9];
      
      private var day25Arr:Array = [2,37,41,83,7,109];
      
      private var curDate:Date;
      
      private var curMapId:uint;
      
      private var _isPlay:Boolean = false;
      
      private var playTime:Number = 0;
      
      public function SantaClausTwo()
      {
         super();
      }
      
      public static function getInstance() : SantaClausTwo
      {
         if(!instance)
         {
            instance = new SantaClausTwo();
         }
         return instance;
      }
      
      private static function get isStartDate() : Boolean
      {
         var curDate:Date = ServerUpTime.getInstance().chinaDate;
         return curDate.date == 1;
      }
      
      private static function get isStartMap() : Boolean
      {
         var curDate:Date = ServerUpTime.getInstance().chinaDate;
         if(curDate.date != 1)
         {
            return false;
         }
         if(curDate.hours == 18)
         {
            if(MapManager.curMapID == 2)
            {
               MoleSharedObject.moleObj.moleMap1 = curDate.minutes >= 0 && curDate.minutes <= 20;
               return curDate.minutes >= 0 && curDate.minutes < 20;
            }
            if(MapManager.curMapID == 37)
            {
               return curDate.minutes >= 20 && curDate.minutes < 40;
            }
            if(MapManager.curMapID == 41)
            {
               return curDate.minutes >= 40 && curDate.minutes < 60;
            }
         }
         else if(curDate.hours == 19)
         {
            if(MapManager.curMapID == 83)
            {
               return curDate.minutes >= 0 && curDate.minutes < 20;
            }
            if(MapManager.curMapID == 7)
            {
               return curDate.minutes >= 20 && curDate.minutes < 40;
            }
            if(MapManager.curMapID == 109)
            {
               return curDate.minutes >= 40 && curDate.minutes < 60;
            }
         }
         return false;
      }
      
      public static function getRandomGiftTwo(e:EventTaomee) : void
      {
         if(e.EventObj.type == 98)
         {
            Alert.smileAlart("    恭喜你獲得" + GoodsInfo.getItemNameByID(e.EventObj.itemId));
         }
      }
      
      public function setup() : void
      {
         this._isPlay = false;
         Tick.instance.addCallback(this.onCheckTime);
         if(isStartDate && (MapManager.curMapID == 2 || MapManager.curMapID == 37 || MapManager.curMapID == 41 || MapManager.curMapID == 83 || MapManager.curMapID == 7 || MapManager.curMapID == 109))
         {
            GV.onlineSocket.addEventListener(MapEvent.READY_CHANGE_MAP,this.onClear);
         }
      }
      
      private function onCheckTime(delay:Number) : void
      {
         var tmpMinutes:uint;
         var shardCountTwo:uint;
         var curDate:Date = null;
         var tmpCountTwo:uint = 0;
         var _fireMovieTwo:PlayMovie = null;
         curDate = ServerUpTime.getInstance().chinaDate;
         if((curDate.minutes == 0 || curDate.minutes == 20 || curDate.minutes == 40) && curDate.seconds == 0 && (curDate.hours == 18 || curDate.hours == 19) && curDate.date == 1)
         {
            if(curDate.time - this.playTime > 20 * 60 * 1000)
            {
               this.playTime = curDate.time;
               PopupMsgCtl.PopupMsg("　　聖誕老人降臨，找到他就可獲得禮物！");
            }
         }
         isChange = false;
         tmpCountTwo = Math.floor(curDate.minutes / 20);
         tmpMinutes = curDate.minutes % 20;
         shardCountTwo = uint(MoleSharedObject.moleObj.SantaClausCountTwo);
         if(isStartMap && MoleSharedObject.moleObj.SantaClausCountTwo != tmpCountTwo)
         {
            _count = tmpCountTwo;
            shardCountTwo++;
            Tick.instance.removeCallback(this.onCheckTime);
            _fireMovie = PlayMovie.play("resource/newTask/activity/act20121212.swf",null,null,function():void
            {
               BC.addEvent(this,GV.onlineSocket,"read_" + CommandID.TreasureBowl,getRandomGiftTwo);
               superlamuPartySocket.treasurebowl(98);
               var tmpCount:* = Math.floor(curDate.minutes / 20);
               MoleSharedObject.moleObj.SantaClausCountTwo = tmpCountTwo;
            },null,null,false);
         }
         else if(isStartMap && this._isPlay == false)
         {
            this._isPlay = true;
            _fireMovieTwo = PlayMovie.play("resource/newTask/activity/act20121213.swf",null,null,function():void
            {
            },null,null,false);
         }
         if((tmpMinutes == 0 || tmpMinutes == 20 || tmpMinutes == 40) && curDate.seconds == 0 && (curDate.hours == 18 || curDate.hours == 19) && curDate.date == 1)
         {
            this._isPlay == false;
            if(Boolean(_fireMovieTwo))
            {
               _fireMovieTwo.destroy();
               _fireMovieTwo = null;
            }
            if(Boolean(_fireMovie))
            {
               _fireMovie.destroy();
               _fireMovie = null;
            }
            setTimeout(function():void
            {
               MapManager.refreshMap();
            },2000);
         }
      }
      
      private function onClear(e:Event) : void
      {
         this.clear();
      }
      
      public function clear() : void
      {
         _count = -1;
         GV.onlineSocket.removeEventListener(MapEvent.READY_CHANGE_MAP,this.onClear);
         Tick.instance.removeCallback(this.onCheckTime);
      }
   }
}

