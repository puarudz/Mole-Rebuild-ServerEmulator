package com.logic.socket.SpecialGoodsSocket.lilypond
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import flash.events.EventDispatcher;
   
   public class LilyPondReq extends EventDispatcher
   {
      
      public function LilyPondReq()
      {
         super();
      }
      
      public function sendReq(houseid:uint, type:uint = 1) : void
      {
         MsgHead.PkgLen = 21;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.LILYPOND_INFO);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(type);
         GV.onlineSocket.writeUnsignedInt(houseid);
         GV.onlineSocket.flush();
      }
   }
}

