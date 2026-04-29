package com.logic.socket.coinBuy
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class GetOneCoinReq extends BaseOnlineSocketRequest
   {
      
      public function GetOneCoinReq()
      {
         super();
      }
      
      public static function Info(ID:uint = 0) : void
      {
         MsgHead.Result = 0;
         MsgHead.PkgLen = 21;
         initAction(CommandID.COIN_GETONE);
         GV.onlineSocket.writeUnsignedInt(ID);
         flush();
      }
   }
}

