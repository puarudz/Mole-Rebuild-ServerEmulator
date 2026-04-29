package com.core.car.carInfo
{
   public class CarInfo
   {
      
      public var UserID:int;
      
      public var CarID:int;
      
      public var ItemID:int;
      
      public var Oil:int;
      
      public var Engine:int;
      
      public var Color:int;
      
      public var SlotCount:int;
      
      public var Slot1:int;
      
      public var Slot2:int;
      
      public var Slot3:int;
      
      public var Slot4:int;
      
      public var Item1:int;
      
      public var Item2:int;
      
      public var LastOil:int;
      
      public var TotalOil:int;
      
      public function CarInfo(infoObj:Object)
      {
         var name:String = null;
         super();
         for(name in infoObj)
         {
            try
            {
               this[name] = infoObj[name];
            }
            catch(err:Error)
            {
               trace("CarInfo缺少關鍵字:",name);
            }
         }
      }
   }
}

