package com.logic.socket.petSocket.learnPet
{
   import com.event.EventTaomee;
   import flash.display.Sprite;
   
   public class StopLearnRes extends Sprite
   {
      
      public static var SOTPPETCLASS:String = "stop_petClass";
      
      public function StopLearnRes()
      {
         super();
      }
      
      public function getBackFun() : void
      {
         GV.onlineClass.dispatchEvent(new EventTaomee(SOTPPETCLASS));
      }
   }
}

