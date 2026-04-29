package com.logic.socket.JJLCard
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class ExchangeJJLCardReq extends BaseOnlineSocketRequest
   {
      
      public function ExchangeJJLCardReq()
      {
         super();
      }
      
      public static function ChangCard(friendID:uint, myCardID:uint, getCardID:uint) : void
      {
         MsgHead.PkgLen = 12 + 17;
         initAction(CommandID.EXCHANG_JJL_CARD);
         GV.onlineSocket.writeUnsignedInt(friendID);
         GV.onlineSocket.writeUnsignedInt(myCardID);
         GV.onlineSocket.writeUnsignedInt(getCardID);
         flush();
      }
   }
}

