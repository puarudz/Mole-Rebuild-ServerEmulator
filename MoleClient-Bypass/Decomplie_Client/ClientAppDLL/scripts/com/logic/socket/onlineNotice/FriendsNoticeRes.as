package com.logic.socket.onlineNotice
{
   import com.event.EventTaomee;
   
   public class FriendsNoticeRes
   {
      
      public static var FRIENDS_NOTICE:String = "friends_notice";
      
      public function FriendsNoticeRes()
      {
         super();
      }
      
      public function noticeHandler() : void
      {
         var userID:int = int(GV.onlineSocket.readUnsignedInt());
         GV.onlineSocket.dispatchEvent(new EventTaomee(FRIENDS_NOTICE,{"ID":userID}));
      }
   }
}

