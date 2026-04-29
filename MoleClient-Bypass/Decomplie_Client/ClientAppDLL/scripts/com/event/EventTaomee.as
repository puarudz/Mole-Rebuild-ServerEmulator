package com.event
{
   import flash.events.Event;
   
   public class EventTaomee extends Event
   {
      
      protected var _obj:Object;
      
      public function EventTaomee(type:String, obj:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this._obj = obj;
      }
      
      override public function clone() : Event
      {
         return new EventTaomee(type,this._obj,bubbles,cancelable);
      }
      
      public function get EventObj() : Object
      {
         return this._obj;
      }
   }
}

