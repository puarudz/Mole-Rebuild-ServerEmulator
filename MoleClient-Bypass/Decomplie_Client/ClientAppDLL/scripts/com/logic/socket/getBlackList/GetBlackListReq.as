package com.logic.socket.getBlackList
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class GetBlackListReq
   {
      
      public function GetBlackListReq()
      {
         super();
      }
      
      public function getBlackList() : void
      {
         MsgHead.PkgLen = 17;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.GET_BALICKLIST);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.flush();
      }
   }
}

