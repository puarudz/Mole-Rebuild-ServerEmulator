package com.logic.socket.noticeGameOver
{
   import com.event.EventTaomee;
   
   public class NoticeGameOverRes
   {
      
      public static var GAME_OVER:String = "game_over";
      
      public function NoticeGameOverRes()
      {
         super();
      }
      
      public function noticeGameOver() : void
      {
         var noticeGameOverObj:Object = new Object();
         noticeGameOverObj.Reason = GV.GameSocket.readUnsignedByte();
         noticeGameOverObj.UserID = GV.GameSocket.readUnsignedInt();
         GV.GameSocket.dispatchEvent(new EventTaomee(GAME_OVER,noticeGameOverObj));
      }
   }
}

