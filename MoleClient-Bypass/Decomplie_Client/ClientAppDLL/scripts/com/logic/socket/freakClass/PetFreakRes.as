package com.logic.socket.freakClass
{
   import com.event.EventTaomee;
   
   public class PetFreakRes
   {
      
      public static var LEARN_OK:String = "learn_ok";
      
      public function PetFreakRes()
      {
         super();
      }
      
      public function getBackFun() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee(LEARN_OK));
      }
   }
}

