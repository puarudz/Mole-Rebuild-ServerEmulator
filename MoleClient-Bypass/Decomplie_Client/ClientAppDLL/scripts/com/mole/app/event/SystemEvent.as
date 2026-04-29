package com.mole.app.event
{
   import flash.events.Event;
   
   public class SystemEvent extends Event
   {
      
      private var _data:*;
      
      public function SystemEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this._data = data;
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      override public function clone() : Event
      {
         return new SystemEvent(this.type,this.data,this.bubbles,this.cancelable);
      }
   }
}

