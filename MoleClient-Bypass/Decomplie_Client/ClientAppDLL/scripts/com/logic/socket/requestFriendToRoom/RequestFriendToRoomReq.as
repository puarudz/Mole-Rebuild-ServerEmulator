package com.logic.socket.requestFriendToRoom
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class RequestFriendToRoomReq
   {
      
      public function RequestFriendToRoomReq()
      {
         super();
      }
      
      public function requestFriendToRoom(UserID:int, MapID:int, MapType:uint = 0) : void
      {
         MsgHead.PkgLen = 25;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.requestFriendS);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(UserID);
         GV.onlineSocket.writeUnsignedInt(MapID);
         GV.onlineSocket.writeUnsignedInt(MapType);
         GV.onlineSocket.flush();
      }
   }
}

