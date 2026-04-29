package com.logic.socket.reponseFriendInvate
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class ResponseFriendInvateReq
   {
      
      public function ResponseFriendInvateReq()
      {
         super();
      }
      
      public function responseFriendInvate(UserID:int, MapID:int, Accept:int, MapType:int = 0) : void
      {
         MsgHead.PkgLen = 30;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.responseFriendR);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(UserID);
         GV.onlineSocket.writeUnsignedInt(MapID);
         GV.onlineSocket.writeUnsignedInt(MapType);
         GV.onlineSocket.writeByte(Accept);
         GV.onlineSocket.flush();
      }
   }
}

