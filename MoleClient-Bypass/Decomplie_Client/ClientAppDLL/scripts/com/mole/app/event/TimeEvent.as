package com.mole.app.event
{
   import flash.events.Event;
   
   public class TimeEvent extends Event
   {
      
      public static const TIMER_EVERY_MINUTE:String = "TIMER_EVERY_MINUTE";
      
      public static const TIMER_EVERY_FIFTEEN_MINUTE:String = "TIMER_EVERY_FIFTEEN_MINUTE";
      
      public static const TIMER_EVERY_THIRTY_MINUTE:String = "TIMER_EVERY_THIRTY_MINUTE";
      
      public static const TIMER_EVERY_FORTY_FIVE_MINUTE:String = "TIMER_EVERY_FORTY_FIVE_MINUTE";
      
      public static const TIMER_EVERY_FULL_HOUR:String = "TIMER_EVERY_FULL_HOUR";
      
      private var _date:Date;
      
      public function TimeEvent(type:String, _date:Date, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this._date = _date;
      }
      
      public function get date() : Date
      {
         return this._date;
      }
   }
}

