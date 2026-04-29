package com.event
{
   import flash.display.MovieClip;
   
   public class ThrowEvent extends EventTaomee
   {
      
      public function ThrowEvent(type:String, obj:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,obj,bubbles,cancelable);
      }
      
      public function get item_mc() : MovieClip
      {
         return _obj.mc;
      }
   }
}

