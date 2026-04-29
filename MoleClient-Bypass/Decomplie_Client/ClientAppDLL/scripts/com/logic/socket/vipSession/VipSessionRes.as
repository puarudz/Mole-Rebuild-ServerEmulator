package com.logic.socket.vipSession
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class VipSessionRes extends EventDispatcher
   {
      
      public static var GET_VIP_SESSION_SUCC:String = "GET_VIP_SESSION_SUCC";
      
      public function VipSessionRes()
      {
         super();
      }
      
      public function parseBA() : void
      {
         var obj:Object = new Object();
         obj.Time = GV.onlineSocket.readUnsignedInt();
         obj.Session = GV.onlineSocket.readUTFBytes(32);
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_VIP_SESSION_SUCC,obj));
      }
   }
}

