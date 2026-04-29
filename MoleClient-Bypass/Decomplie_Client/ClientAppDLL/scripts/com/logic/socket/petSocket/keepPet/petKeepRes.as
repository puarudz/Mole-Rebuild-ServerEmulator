package com.logic.socket.petSocket.keepPet
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class petKeepRes extends EventDispatcher
   {
      
      public static var PET_KEEP_SUCC:String = "PET_KEEP_SUCC";
      
      public function petKeepRes()
      {
         super();
      }
      
      public function parseBA() : void
      {
         var obj:Object = new Object();
         obj.userID = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(PET_KEEP_SUCC,obj));
      }
   }
}

