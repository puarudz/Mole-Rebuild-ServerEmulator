package com.logic.socket.getUserBasicInfo
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class GetUserBasicInfoReq
   {
      
      public function GetUserBasicInfoReq()
      {
         super();
      }
      
      public function getUserBasicInfo(userID:int) : void
      {
         if(userID == 0)
         {
            return;
         }
         MsgHead.PkgLen = 21;
         if(MsgHead.Result != 0)
         {
            MsgHead.Result = 0;
         }
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.getSingleUser);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(userID);
         GV.onlineSocket.flush();
      }
   }
}

