package com.logic.socket.JJLCard
{
   import com.event.EventTaomee;
   import flash.display.Sprite;
   
   public class SetJJLCardRes extends Sprite
   {
      
      public static var BACK_JJL_SET:String = "setjjl_back";
      
      public function SetJJLCardRes()
      {
         super();
      }
      
      public function backFun() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee(BACK_JJL_SET));
      }
   }
}

