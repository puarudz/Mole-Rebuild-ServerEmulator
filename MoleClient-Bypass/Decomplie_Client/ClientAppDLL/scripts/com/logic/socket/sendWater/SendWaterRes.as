package com.logic.socket.sendWater
{
   import com.event.EventTaomee;
   
   public class SendWaterRes
   {
      
      public static const SENDWATER:String = "send_Water";
      
      public function SendWaterRes()
      {
         super();
      }
      
      public static function sendWater() : void
      {
         var sendObj:Object = new Object();
         sendObj.Userid = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(SENDWATER,sendObj));
      }
   }
}

