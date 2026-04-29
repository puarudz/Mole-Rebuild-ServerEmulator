package org.taomee.events
{
   import flash.events.Event;
   
   public class DynamicEvent extends Event
   {
      
      private var _paramObject:*;
      
      public function DynamicEvent(type:String, paramObject:* = null)
      {
         super(type,false,false);
         this._paramObject = paramObject;
      }
      
      public function get paramObject() : *
      {
         return this._paramObject;
      }
      
      override public function clone() : Event
      {
         return new DynamicEvent(type,this._paramObject);
      }
   }
}

