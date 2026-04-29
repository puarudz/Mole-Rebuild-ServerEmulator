package com.logic.socket.getRoomInfo
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class GetRoomInfoReq
   {
      
      public function GetRoomInfoReq()
      {
         super();
      }
      
      public function getRoomInfo(UserID:int) : void
      {
         MsgHead.PkgLen = 21;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.GET_ROOM_INFO);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.flush();
      }
   }
}

