package com.logic.socket.enterPlayerGame
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import flash.utils.ByteArray;
   
   public class EnterPlayerGameReq
   {
      
      public function EnterPlayerGameReq()
      {
         super();
      }
      
      public function enterPlayerGame(SessionID:ByteArray) : void
      {
         MsgHead.PkgLen = 112 + 17;
         MsgHead.Version = 1;
         MsgHead.Result = 0;
         GV.GameSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.GameSocket.writeByte(MsgHead.Version);
         GV.GameSocket.writeUnsignedInt(CommandID.USERREQ_ENTER_GAME);
         GV.GameSocket.writeUnsignedInt(MsgHead.UserID);
         GV.GameSocket.writeUnsignedInt(MsgHead.Result);
         GV.GameSocket.writeBytes(SessionID);
         GV.GameSocket.flush();
      }
   }
}

