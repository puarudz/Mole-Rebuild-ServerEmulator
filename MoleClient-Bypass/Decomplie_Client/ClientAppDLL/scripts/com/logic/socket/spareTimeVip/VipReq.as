package com.logic.socket.spareTimeVip
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class VipReq
   {
      
      public function VipReq()
      {
         super();
      }
      
      public static function vipFunc() : void
      {
         MsgHead.PkgLen = 17;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.VIP_SPARE_TIME);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.flush();
      }
   }
}

