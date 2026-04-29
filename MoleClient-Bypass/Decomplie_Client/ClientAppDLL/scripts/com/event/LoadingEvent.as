package com.event
{
   import flash.events.Event;
   
   public class LoadingEvent extends Event
   {
      
      public static var CLOSE_LOADING:String = "closeLoading";
      
      public function LoadingEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

