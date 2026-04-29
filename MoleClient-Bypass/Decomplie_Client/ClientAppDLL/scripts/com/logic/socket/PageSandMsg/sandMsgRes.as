package com.logic.socket.PageSandMsg
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class sandMsgRes extends EventDispatcher
   {
      
      public static var PAGESANDBACK_SUCCESS:String = "pagesandback_success";
      
      public function sandMsgRes()
      {
         super();
      }
      
      public function getBackFun() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee(PAGESANDBACK_SUCCESS));
      }
   }
}

