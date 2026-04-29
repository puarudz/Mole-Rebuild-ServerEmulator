package com.core.socketlogic.noticeExit
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class NoticeExitRes extends EventDispatcher
   {
      
      public static var NOTICE_EXIT:String = "notice_exit";
      
      public function NoticeExitRes()
      {
         super();
      }
      
      public function noticeExit() : void
      {
         var noticeExitObj:Object = new Object();
         noticeExitObj.UserID = GV.onlineSocket.readUnsignedInt();
         noticeExitObj.Error = GV.onlineSocket.readInt();
         noticeExitObj.Error = noticeExitObj.Error.toString(10);
         GV.onlineClass.dispatchEvent(new EventTaomee(NOTICE_EXIT,noticeExitObj));
      }
   }
}

