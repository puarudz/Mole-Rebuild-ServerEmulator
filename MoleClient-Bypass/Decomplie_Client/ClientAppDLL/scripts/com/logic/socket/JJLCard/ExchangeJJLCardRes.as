package com.logic.socket.JJLCard
{
   import com.event.EventTaomee;
   import flash.display.Sprite;
   
   public class ExchangeJJLCardRes extends Sprite
   {
      
      public static var BACK_JJL_CHANG:String = "changjjl_back";
      
      public function ExchangeJJLCardRes()
      {
         super();
      }
      
      public function backFun() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee(BACK_JJL_CHANG));
      }
   }
}

