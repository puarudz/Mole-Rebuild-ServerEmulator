package com.logic.socket.petSocket.adoptPet
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class IsSuperPetRes extends EventDispatcher
   {
      
      public static var IS_SL_SUCC:String = "IS_SL_SUCC";
      
      public function IsSuperPetRes()
      {
         super();
      }
      
      public function parseBA() : void
      {
         var obj:Object = new Object();
         obj.Flag = GV.onlineSocket.readUnsignedByte();
         GV.onlineSocket.dispatchEvent(new EventTaomee(IS_SL_SUCC,obj));
      }
   }
}

