package com.logic.socket.coinBuy
{
   import com.adobe.crypto.MD5;
   import com.common.msgHead.MsgHead;
   import com.core.info.LocalUserInfo;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class CoinApplyReq extends BaseOnlineSocketRequest
   {
      
      public function CoinApplyReq()
      {
         super();
      }
      
      public static function Info(ID:uint, Count:uint, Passwd:*) : void
      {
         MsgHead.Result = 0;
         MsgHead.PkgLen = 17 + 42;
         initAction(CommandID.COIN_BUY);
         GV.onlineSocket.writeUnsignedInt(LocalUserInfo.getUserID());
         GV.onlineSocket.writeUnsignedInt(ID);
         GV.onlineSocket.writeShort(Count);
         GV.onlineSocket.writeUTFBytes(MD5.hash(Passwd));
         flush();
      }
   }
}

