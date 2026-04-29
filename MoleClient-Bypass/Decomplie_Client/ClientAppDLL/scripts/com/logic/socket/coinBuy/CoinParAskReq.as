package com.logic.socket.coinBuy
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class CoinParAskReq extends BaseOnlineSocketRequest
   {
      
      public function CoinParAskReq()
      {
         super();
      }
      
      public static function Info() : void
      {
         MsgHead.Result = 0;
         MsgHead.PkgLen = 17;
         initAction(CommandID.COIN_PAR_ASK);
         flush();
      }
   }
}

