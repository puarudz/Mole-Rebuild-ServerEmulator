package com.logic.socket.lockHome
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class lockHomeReq
   {
      
      public function lockHomeReq()
      {
         super();
      }
      
      public function lock(lockNum:int, type:uint = 2) : void
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
         GV.onlineSocket.writeShort(type);
         GV.onlineSocket.writeShort(lockNum);
         GV.onlineSocket.flush();
      }
   }
}

