package com.logic.socket.waterTub
{
   import com.event.EventTaomee;
   
   public class WaterTubOverTimeRes
   {
      
      public static const OVER_TIME:String = "over_time";
      
      public function WaterTubOverTimeRes()
      {
         super();
      }
      
      public static function overTime() : void
      {
         var overTimeObj:Object = new Object();
         overTimeObj.UserID = GV.onlineSocket.readUnsignedInt();
         overTimeObj.ItemID = 0;
         GV.onlineSocket.dispatchEvent(new EventTaomee(OVER_TIME,overTimeObj));
      }
      
      public static function overTime2() : void
      {
         var overTimeObj:Object = new Object();
         overTimeObj.Count = GV.onlineSocket.readUnsignedInt();
         for(var i:int = 0; i < overTimeObj.Count; i++)
         {
            overTimeObj.UserID = GV.onlineSocket.readUnsignedInt();
            overTimeObj.ItemID = 0;
            GV.onlineSocket.dispatchEvent(new EventTaomee(OVER_TIME,overTimeObj));
         }
      }
   }
}

