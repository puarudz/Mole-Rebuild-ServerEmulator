package com.logic.socket.postCard
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class getAllCardReq extends BaseOnlineSocketRequest
   {
      
      public function getAllCardReq()
      {
         super();
      }
      
      public static function Info() : void
      {
         MsgHead.Result = 0;
         MsgHead.PkgLen = 17;
         initAction(CommandID.GET_ALL_POSTCARD);
         flush();
      }
   }
}

