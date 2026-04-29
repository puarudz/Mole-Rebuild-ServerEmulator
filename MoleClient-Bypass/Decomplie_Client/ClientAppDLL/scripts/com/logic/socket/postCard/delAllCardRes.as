package com.logic.socket.postCard
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class delAllCardRes extends EventDispatcher
   {
      
      public static var DELONECARD_INFO:String = "del_allcard";
      
      public function delAllCardRes()
      {
         super();
      }
      
      public function getBackFun() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee(DELONECARD_INFO));
      }
   }
}

