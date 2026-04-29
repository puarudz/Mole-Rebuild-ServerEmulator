package com.logic.socket.gameLogic
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class AllMapEndRes extends EventDispatcher
   {
      
      public static var ALL_MAP_END:String = "all_map_end";
      
      public function AllMapEndRes()
      {
         super();
      }
      
      public function allMapEnd() : void
      {
         var allMapMsgObj:Object = new Object();
         allMapMsgObj.msg = "所有地圖發送完畢.";
         GV.GameSocket.dispatchEvent(new EventTaomee(ALL_MAP_END,allMapMsgObj));
      }
   }
}

