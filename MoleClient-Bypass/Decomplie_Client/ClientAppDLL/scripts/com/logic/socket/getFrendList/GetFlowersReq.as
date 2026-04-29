package com.logic.socket.getFrendList
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class GetFlowersReq
   {
      
      public function GetFlowersReq()
      {
         super();
      }
      
      public function sendreq(id:uint) : void
      {
         MsgHead.PkgLen = 21;
         if(MsgHead.Result != 0)
         {
            MsgHead.Result = 0;
         }
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.FLOWERS_NUM);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(id);
         GV.onlineSocket.flush();
      }
   }
}

