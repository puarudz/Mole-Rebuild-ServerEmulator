package com.logic.socket.coinBuy
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class GetOneCoinInfoReq extends BaseOnlineSocketRequest
   {
      
      public function GetOneCoinInfoReq()
      {
         super();
      }
      
      public static function Info(ID:uint = 0) : void
      {
         MsgHead.Result = 0;
         MsgHead.PkgLen = 21;
         initAction(CommandID.COIN_GETONEINFO);
         GV.onlineSocket.writeUnsignedInt(ID);
         flush();
      }
   }
}

