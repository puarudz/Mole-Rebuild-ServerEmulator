package com.logic.socket.delBlackList
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class DelBlackListReq
   {
      
      public function DelBlackListReq()
      {
         super();
      }
      
      public function delBlackList(userId:int) : void
      {
         MsgHead.Result = 0;
         MsgHead.PkgLen = 21;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.DEL_BALICKLIST);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(userId);
         GV.onlineSocket.flush();
      }
   }
}

