package com.mole.app.activity
{
   import com.common.util.Tick;
   import com.core.info.ServerUpTime;
   import com.logic.mapEvent.MapEvent;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.module.AppModuleControl;
   import com.mole.app.type.ModuleType;
   import com.mole.net.MoleSharedObject;
   import flash.events.Event;
   
   public class FireBalloonActivity
   {
      
      private static var _fireMovie:AppModuleControl;
      
      private static var _count:int = -1;
      
      public function FireBalloonActivity()
      {
         super();
      }
      
      public static function setup() : void
      {
         if(isStartDate && (MapManager.curMapID == 1 || MapManager.curMapID == 2 || MapManager.curMapID == 3))
         {
            GV.onlineSocket.addEventListener(MapEvent.READY_CHANGE_MAP,onClear);
            Tick.instance.addCallback(onCheckTime);
         }
      }
      
      private static function get isStartDate() : Boolean
      {
         var curDate:Date = ServerUpTime.getInstance().chinaDate;
         return curDate.date == 23 || curDate.date == 24 || curDate.date == 25 || curDate.date == 28;
      }
      
      private static function get isStartMap() : Boolean
      {
         var curDate:Date = ServerUpTime.getInstance().chinaDate;
         if(curDate.hours == 19)
         {
            if(MapManager.curMapID == 1)
            {
               return curDate.minutes >= 0 && curDate.minutes <= 20;
            }
            if(MapManager.curMapID == 2)
            {
               return curDate.minutes > 20 && curDate.minutes <= 40;
            }
            if(MapManager.curMapID == 3)
            {
               return curDate.minutes > 40 && curDate.minutes <= 60;
            }
         }
         return false;
      }
      
      private static function removeFire() : void
      {
         if(Boolean(_fireMovie))
         {
            _fireMovie.close();
            _fireMovie = null;
         }
      }
      
      private static function onCheckTime(delay:Number) : void
      {
         var curDate:Date = ServerUpTime.getInstance().chinaDate;
         var tmpCount:uint = Math.floor(curDate.minutes / 5);
         var tmpMinutes:uint = curDate.minutes % 5;
         var shardCount:uint = uint(MoleSharedObject.moleObj.fireCount);
         if(isStartMap && _count != tmpCount && MoleSharedObject.moleObj.fireCount != tmpCount)
         {
            _count = tmpCount;
            removeFire();
            _fireMovie = ModuleManager.openModule(ModuleType.INFANTA_PARTY_HAPPY_FIRE_MOVIE);
         }
      }
      
      private static function onClear(e:Event) : void
      {
         clear();
      }
      
      public static function clear() : void
      {
         _count = -1;
         GV.onlineSocket.removeEventListener(MapEvent.READY_CHANGE_MAP,onClear);
         Tick.instance.removeCallback(onCheckTime);
      }
   }
}

