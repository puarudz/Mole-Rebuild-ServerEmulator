package com.logic.socket.vipSession
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import flash.events.EventDispatcher;
   
   public class VipSessionReq extends EventDispatcher
   {
      
      public function VipSessionReq()
      {
         super();
      }
      
      public function sendReq() : void
      {
         MsgHead.PkgLen = 17;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.VIP_SESSION);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.flush();
      }
   }
}

