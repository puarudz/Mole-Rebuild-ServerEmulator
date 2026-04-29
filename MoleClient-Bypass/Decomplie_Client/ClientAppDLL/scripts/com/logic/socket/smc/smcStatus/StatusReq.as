package com.logic.socket.smc.smcStatus
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class StatusReq
   {
      
      public function StatusReq()
      {
         super();
      }
      
      public function status(Pos:int, Tobe:int) : void
      {
         MsgHead.PkgLen = 21;
         if(MsgHead.Result != 0)
         {
            MsgHead.Result = 0;
         }
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.LOCK_HOME);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeShort(Pos);
         GV.onlineSocket.writeShort(Tobe);
         GV.onlineSocket.flush();
      }
   }
}

