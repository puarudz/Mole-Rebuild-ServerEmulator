package com.event.dragon
{
   import com.core.dragon.dragonInfo.DragonInfo;
   import com.event.EventTaomee;
   
   public class DragonInfoEvent extends EventTaomee
   {
      
      public function DragonInfoEvent(type:String, obj:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,obj,bubbles,cancelable);
      }
      
      public function get getData() : DragonInfo
      {
         var info:DragonInfo = EventObj as DragonInfo;
         if(!info)
         {
            throw "找不到龍的資訊," + EventObj;
         }
         return info;
      }
   }
}

