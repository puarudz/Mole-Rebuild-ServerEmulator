package com.logic.socket.initPlayerCard
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class InitPlayerReq
   {
      
      public function InitPlayerReq()
      {
         super();
      }
      
      public static function initPlay() : void
      {
         MsgHead.Result = 0;
         MsgHead.PkgLen = 17;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.INIT_CARD);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.flush();
      }
   }
}

