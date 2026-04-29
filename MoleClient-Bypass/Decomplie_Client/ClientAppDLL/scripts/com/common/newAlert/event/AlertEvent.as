package com.common.newAlert.event
{
   import flash.events.Event;
   
   public class AlertEvent extends Event
   {
      
      public static const ALERT_CLOSED:String = "alertClosed";
      
      public function AlertEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

