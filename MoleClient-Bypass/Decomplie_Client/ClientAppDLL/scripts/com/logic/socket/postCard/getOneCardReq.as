package com.logic.socket.postCard
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class getOneCardReq extends BaseOnlineSocketRequest
   {
      
      public function getOneCardReq()
      {
         super();
      }
      
      public static function Info(CardID:uint) : void
      {
         MsgHead.Result = 0;
         MsgHead.PkgLen = 21;
         initAction(CommandID.GET_ONEINFO_POSTCARD);
         GV.onlineSocket.writeUnsignedInt(CardID);
         flush();
      }
   }
}

