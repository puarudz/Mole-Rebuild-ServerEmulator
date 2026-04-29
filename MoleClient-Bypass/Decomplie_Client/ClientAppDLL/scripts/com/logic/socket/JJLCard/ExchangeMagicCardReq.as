package com.logic.socket.JJLCard
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class ExchangeMagicCardReq extends BaseOnlineSocketRequest
   {
      
      public function ExchangeMagicCardReq()
      {
         super();
      }
      
      public static function ExchangeMagicCard() : void
      {
         MsgHead.PkgLen = 17;
         initAction(CommandID.EXCHANGE_MAGIC_CARD);
         flush();
      }
   }
}

