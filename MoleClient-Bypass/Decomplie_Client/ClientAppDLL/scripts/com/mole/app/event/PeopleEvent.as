package com.mole.app.event
{
   import com.event.EventTaomee;
   import flash.events.Event;
   
   public class PeopleEvent extends EventTaomee
   {
      
      public static const READY_MOVE:String = "iskaddish";
      
      public static const PEOPLE_CHANGE_CLOTH:String = "peopleChangeCloth";
      
      public function PeopleEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,data,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         return new PeopleEvent(type,_obj,bubbles,cancelable);
      }
   }
}

