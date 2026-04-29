package com.logic.socket.noticePlayerFail
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class NoticePlayerFailRes extends EventDispatcher
   {
      
      public static var PLAYER_FAIL:String = "player_fail";
      
      public function NoticePlayerFailRes()
      {
         super();
      }
      
      public function noticePlayerFail() : void
      {
         var noticePlayerFailObj:Object = new Object();
         noticePlayerFailObj.UserID = GV.GameSocket.readUnsignedInt();
         noticePlayerFailObj.Reason = GV.GameSocket.readUnsignedByte();
         GV.GameSocket.dispatchEvent(new EventTaomee(PLAYER_FAIL,noticePlayerFailObj));
      }
   }
}

