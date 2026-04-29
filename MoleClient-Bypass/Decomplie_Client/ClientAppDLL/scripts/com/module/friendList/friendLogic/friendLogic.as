package com.module.friendList.friendLogic
{
   import com.logic.socket.delBlackList.DelBlackListReq;
   import com.logic.socket.getBlackList.GetBlackListReq;
   import com.logic.socket.getUserBasicInfo.GetUserBasicInfoReq;
   
   public class friendLogic
   {
      
      private static var getUserBasicInfoReq:GetUserBasicInfoReq = new GetUserBasicInfoReq();
      
      private static var getBlackListReq:GetBlackListReq = new GetBlackListReq();
      
      private static var delBlackListReq:DelBlackListReq = new DelBlackListReq();
      
      public function friendLogic()
      {
         super();
      }
      
      public static function sendFriendID(id:int) : void
      {
         getUserBasicInfoReq.getUserBasicInfo(id);
      }
      
      public static function sendBlackID(id:int) : void
      {
         getUserBasicInfoReq.getUserBasicInfo(id);
      }
      
      public static function getBlackList() : void
      {
         getBlackListReq.getBlackList();
      }
      
      public static function delBlack(id:int) : void
      {
         delBlackListReq.delBlackList(id);
      }
   }
}

