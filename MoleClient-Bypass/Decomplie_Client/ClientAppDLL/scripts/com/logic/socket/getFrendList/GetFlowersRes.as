package com.logic.socket.getFrendList
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class GetFlowersRes extends EventDispatcher
   {
      
      public static var GET_FLOWERS_LIST:String = "GET_FLOWERS_LIST";
      
      public function GetFlowersRes()
      {
         super();
      }
      
      public function parseBA() : void
      {
         var visitor:Object = new Object();
         visitor.mapid = GV.onlineSocket.readUnsignedInt();
         visitor.hot = GV.onlineSocket.readUnsignedInt();
         visitor.flowers = GV.onlineSocket.readUnsignedInt();
         visitor.mud = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_FLOWERS_LIST,visitor));
      }
   }
}

