package com.logic.socket.petSocket.learnPet
{
   import com.event.EventTaomee;
   import flash.display.Sprite;
   
   public class OverLearnRes extends Sprite
   {
      
      public static var OVERONEPETCLASS:String = "overOne_petClass";
      
      public function OverLearnRes()
      {
         super();
      }
      
      public function getBackFun() : void
      {
         GV.onlineClass.dispatchEvent(new EventTaomee(OVERONEPETCLASS));
      }
   }
}

