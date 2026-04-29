package com.logic.socket.searchMole
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class searchMoleRes extends EventDispatcher
   {
      
      public static var SEARCHMOLE_SUCC:String = "SEARCHMOLE_SUCC";
      
      public function searchMoleRes()
      {
         super();
      }
      
      public function parseBA() : void
      {
         var obj:Object = new Object();
         obj.OnlineID = GV.onlineSocket.readUnsignedShort();
         obj.MapID = GV.onlineSocket.readUnsignedInt();
         obj.MapName = GV.onlineSocket.readUTFBytes(64);
         GV.onlineSocket.dispatchEvent(new EventTaomee(SEARCHMOLE_SUCC,obj));
      }
   }
}

