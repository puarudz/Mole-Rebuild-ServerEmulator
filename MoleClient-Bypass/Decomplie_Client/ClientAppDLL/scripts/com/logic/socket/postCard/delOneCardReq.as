package com.logic.socket.postCard
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class delOneCardReq extends BaseOnlineSocketRequest
   {
      
      public function delOneCardReq()
      {
         super();
      }
      
      public static function Info(CardID:uint) : void
      {
         MsgHead.Result = 0;
         MsgHead.PkgLen = 21;
         initAction(CommandID.DEL_ONE_POSTCARD);
         GV.onlineSocket.writeUnsignedInt(CardID);
         flush();
      }
   }
}

