package com.logic.socket.petSocket.adoptPet
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class petDead extends EventDispatcher
   {
      
      public static var PET_DEAD:String = "PET_DEAD";
      
      public function petDead()
      {
         super();
      }
      
      public function parseBA() : void
      {
         var obj:Object = new Object();
         obj.SpriteID = GV.onlineSocket.readUnsignedInt();
         obj.Nick = GV.onlineSocket.readUTFBytes(16);
         GV.onlineSocket.dispatchEvent(new EventTaomee(PET_DEAD,obj));
      }
   }
}

