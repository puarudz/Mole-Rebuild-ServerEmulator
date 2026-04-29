package com.logic.socket.responsetAddFrend
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class ResAddFrendReq
   {
      
      public function ResAddFrendReq()
      {
         super();
      }
      
      public function resAddFrend(UserID:int, Accept:int) : void
      {
         MsgHead.PkgLen = 22;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.responseJFriendR);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(UserID);
         GV.onlineSocket.writeByte(Accept);
         GV.onlineSocket.flush();
      }
   }
}

