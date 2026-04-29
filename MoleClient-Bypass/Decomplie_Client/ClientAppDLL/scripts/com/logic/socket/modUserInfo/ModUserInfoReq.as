package com.logic.socket.modUserInfo
{
   import com.common.data.socketDataHandler.decString.DealData;
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class ModUserInfoReq
   {
      
      public function ModUserInfoReq()
      {
         super();
      }
      
      public function modUserInfo(nick:String) : void
      {
         if(MsgHead.Result != 0)
         {
            MsgHead.Result = 0;
         }
         MsgHead.PkgLen = 33;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.modUserNikeName);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeBytes(DealData.dealNikeName(nick));
         GV.onlineSocket.flush();
      }
   }
}

