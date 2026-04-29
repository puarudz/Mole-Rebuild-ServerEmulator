package com.logic.socket.petSocket.adoptPet
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class adoptPetRes extends EventDispatcher
   {
      
      public static var ADOPTPET_OVER:String = "adoptPet_over";
      
      public function adoptPetRes()
      {
         super();
      }
      
      public function doAction() : void
      {
         var petObj:Object = new Object();
         petObj.itemID = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(ADOPTPET_OVER));
      }
   }
}

