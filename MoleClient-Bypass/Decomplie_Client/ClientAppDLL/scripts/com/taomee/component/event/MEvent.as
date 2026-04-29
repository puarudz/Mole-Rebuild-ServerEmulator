package com.taomee.component.event
{
   import flash.events.Event;
   
   public class MEvent extends Event
   {
      
      public static const LAYOUT_SET_CHANGED:String = "layoutSetChanged";
      
      public static const FRAME_CLOSED:String = "frameClosed";
      
      public static const ON_ROLL_OVER:String = "onRollOver";
      
      public static const ON_ROLL_OUT:String = "onRollOut";
      
      public static const PRESS:String = "press";
      
      public static const RELEASE:String = "release";
      
      public static const RELEASE_OUTSIDE:String = "releaseOutside";
      
      public function MEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

