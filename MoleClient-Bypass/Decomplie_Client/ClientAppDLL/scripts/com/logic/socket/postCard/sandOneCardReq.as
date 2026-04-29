package com.logic.socket.postCard
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   import flash.utils.ByteArray;
   
   public class sandOneCardReq extends BaseOnlineSocketRequest
   {
      
      public function sandOneCardReq()
      {
         super();
      }
      
      public static function Info(CardID:uint, Msg:String, FriendArr:Array) : void
      {
         var lgh:int = 0;
         var idd:uint = 0;
         var msgbyte:ByteArray = new ByteArray();
         msgbyte.writeUTFBytes(Msg);
         msgbyte.writeByte(0);
         var msglg:int = int(msgbyte.length);
         lgh = int(FriendArr.length);
         MsgHead.Result = 0;
         MsgHead.PkgLen = 23 + msglg + lgh * 4;
         initAction(CommandID.SAND_ONEINFO_POSTCARD);
         GV.onlineSocket.writeUnsignedInt(CardID);
         GV.onlineSocket.writeByte(msglg);
         GV.onlineSocket.writeBytes(msgbyte,0,msglg);
         GV.onlineSocket.writeByte(lgh);
         for(var i:uint = 0; i < lgh; i++)
         {
            idd = uint(FriendArr[i]);
            GV.onlineSocket.writeUnsignedInt(idd);
         }
         flush();
      }
   }
}

