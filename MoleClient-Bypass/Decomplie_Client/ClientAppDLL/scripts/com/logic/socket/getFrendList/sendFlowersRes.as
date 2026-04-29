package com.logic.socket.getFrendList
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class sendFlowersRes extends EventDispatcher
   {
      
      public static var SEND_FLOWERS_MUD_SUCC:String = "SEND_FLOWERS_MUD_SUCC";
      
      public function sendFlowersRes()
      {
         super();
      }
      
      public function parseBA() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee(SEND_FLOWERS_MUD_SUCC));
      }
   }
}

