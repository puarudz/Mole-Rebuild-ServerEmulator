package com.logic.socket.traffic
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class trafficRes extends EventDispatcher
   {
      
      public static var TRAFFIC_OVER:String = "traffic_over";
      
      public function trafficRes()
      {
         super();
      }
      
      public static function doAction() : void
      {
         var tempObj:Object = new Object();
         tempObj.type = GV.onlineSocket.readUnsignedInt();
         tempObj.Status = GV.onlineSocket.readUnsignedInt();
         tempObj.Sec = GV.onlineSocket.readUnsignedInt();
         if(tempObj.type == 3)
         {
            return;
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(TRAFFIC_OVER,tempObj));
      }
   }
}

