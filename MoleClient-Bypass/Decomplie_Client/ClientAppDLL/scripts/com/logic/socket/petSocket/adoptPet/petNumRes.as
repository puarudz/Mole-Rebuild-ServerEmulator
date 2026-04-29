package com.logic.socket.petSocket.adoptPet
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class petNumRes extends EventDispatcher
   {
      
      public static var GET_PETNUM_SUCC:String = "GET_PETNUM_SUCC";
      
      public function petNumRes()
      {
         super();
      }
      
      public function parseBA() : void
      {
         var obj:Object = new Object();
         obj.Count = GV.onlineSocket.readUnsignedByte();
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_PETNUM_SUCC,obj));
      }
   }
}

