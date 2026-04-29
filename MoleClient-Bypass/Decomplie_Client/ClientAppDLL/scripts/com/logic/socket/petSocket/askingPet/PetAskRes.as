package com.logic.socket.petSocket.askingPet
{
   import com.event.EventTaomee;
   import flash.display.Sprite;
   
   public class PetAskRes extends Sprite
   {
      
      public static var ASKONEPETBACK:String = "askonepet_back";
      
      public function PetAskRes()
      {
         super();
      }
      
      public function getBackFun() : void
      {
         var objs:Object = new Object();
         objs.PetID = GV.onlineSocket.readUnsignedInt();
         GV.onlineClass.dispatchEvent(new EventTaomee(ASKONEPETBACK,objs));
      }
   }
}

