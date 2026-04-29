package com.mole.app.manager
{
   import com.core.info.ServerUpTime;
   import com.mole.app.event.TimeEvent;
   import flash.events.EventDispatcher;
   
   [Event(name="timer_every_full_hour",type="com.mole.app.event.TimeEvent")]
   [Event(name="timer_every_forty_five_minute",type="com.mole.app.event.TimeEvent")]
   [Event(name="timer_every_thirty_minute",type="com.mole.app.event.TimeEvent")]
   [Event(name="timer_every_fifteen_minute",type="com.mole.app.event.TimeEvent")]
   [Event(name="timer_every_minute",type="com.mole.app.event.TimeEvent")]
   public class TimerManager extends EventDispatcher
   {
      
      private static var _instance:TimerManager;
      
      private static var minuteIndex:int;
      
      private static var date:Date = new Date();
      
      public function TimerManager()
      {
         super();
      }
      
      public static function synTime(time:uint) : void
      {
         var date:Date = null;
         if(minuteIndex % 2 == 0)
         {
            date = ServerUpTime.getInstance().valueDate;
            ed.dispatchEvent(new TimeEvent(TimeEvent.TIMER_EVERY_MINUTE,date));
            switch(date.getMinutes())
            {
               case 0:
                  ed.dispatchEvent(new TimeEvent(TimeEvent.TIMER_EVERY_FULL_HOUR,date));
                  break;
               case 15:
                  ed.dispatchEvent(new TimeEvent(TimeEvent.TIMER_EVERY_FIFTEEN_MINUTE,date));
                  break;
               case 30:
                  ed.dispatchEvent(new TimeEvent(TimeEvent.TIMER_EVERY_THIRTY_MINUTE,date));
                  break;
               case 45:
                  ed.dispatchEvent(new TimeEvent(TimeEvent.TIMER_EVERY_FORTY_FIVE_MINUTE,date));
            }
         }
         ++minuteIndex;
      }
      
      public static function get ed() : TimerManager
      {
         return instance;
      }
      
      public static function get instance() : TimerManager
      {
         if(_instance == null)
         {
            _instance = new TimerManager();
         }
         return _instance;
      }
   }
}

