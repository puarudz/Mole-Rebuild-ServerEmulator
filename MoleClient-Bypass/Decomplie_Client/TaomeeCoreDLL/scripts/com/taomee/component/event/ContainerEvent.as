package com.taomee.component.event
{
   import com.taomee.component.Component;
   import flash.events.Event;
   
   public class ContainerEvent extends Event
   {
      
      public static const COMP_ADDED:String = "compAdded";
      
      public static const COMP_REMOVED:String = "compRemoved";
      
      private var comp:Component;
      
      public function ContainerEvent(type:String, comp:Component, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.comp = comp;
      }
      
      public function getComp() : Component
      {
         return this.comp;
      }
   }
}

