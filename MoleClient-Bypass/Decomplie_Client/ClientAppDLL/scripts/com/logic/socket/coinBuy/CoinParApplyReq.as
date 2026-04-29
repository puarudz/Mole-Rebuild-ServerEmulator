package com.logic.socket.coinBuy
{
   import com.adobe.crypto.MD5;
   import com.common.msgHead.MsgHead;
   import com.core.info.LocalUserInfo;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   import flash.utils.ByteArray;
   
   public class CoinParApplyReq extends BaseOnlineSocketRequest
   {
      
      public function CoinParApplyReq()
      {
         super();
      }
      
      public static function Info(ID:uint, Count:uint, Passwd:*) : void
      {
         MsgHead.Command = CommandID.COIN_PAR_BUY;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(LocalUserInfo.getUserID());
         tempByteArray.writeUnsignedInt(ID);
         tempByteArray.writeShort(Count);
         var md5:String = MD5.hash(Passwd);
         tempByteArray.writeUTFBytes(md5);
         GF.writeHead(tempByteArray);
      }
   }
}

