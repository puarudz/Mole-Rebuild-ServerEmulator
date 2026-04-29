package com.logic.socket.card
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class CardNumReq
   {
      
      public function CardNumReq()
      {
         super();
      }
      
      public static function getCardNum(userid:uint) : void
      {
         MsgHead.Result = 0;
         MsgHead.PkgLen = 17;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.CARD_NUM);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(userid);
         GV.onlineSocket.flush();
      }
      
      public static function repairRedCloth() : void
      {
         MsgHead.Command = 1221;
         GF.writeHead();
      }
   }
}

