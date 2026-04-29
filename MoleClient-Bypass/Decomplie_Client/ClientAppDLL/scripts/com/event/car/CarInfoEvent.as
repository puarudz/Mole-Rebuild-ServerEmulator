package com.event.car
{
   import com.core.car.carInfo.CarInfo;
   import com.event.EventTaomee;
   
   public class CarInfoEvent extends EventTaomee
   {
      
      public function CarInfoEvent(type:String, obj:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,obj,bubbles,cancelable);
      }
      
      public function get getData() : CarInfo
      {
         var info:CarInfo = EventObj as CarInfo;
         if(!info)
         {
            throw "找不到交通工具資訊," + EventObj;
         }
         return info;
      }
   }
}

