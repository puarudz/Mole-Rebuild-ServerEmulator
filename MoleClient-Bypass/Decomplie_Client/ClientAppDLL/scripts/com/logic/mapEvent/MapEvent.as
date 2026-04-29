package com.logic.mapEvent
{
   import flash.events.Event;
   
   public class MapEvent extends Event
   {
      
      public static const CHANGE_MAP_COMPLETE:String = "itemSelectHandler";
      
      public static const READY_CHANGE_MAP:String = "removeMapEvent";
      
      public static const MOUSE_DOWN:String = "MapEvent_MouseDown";
      
      public function MapEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

