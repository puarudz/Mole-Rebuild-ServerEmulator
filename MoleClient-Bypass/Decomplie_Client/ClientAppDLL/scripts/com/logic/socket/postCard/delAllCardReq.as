package com.logic.socket.postCard
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class delAllCardReq extends BaseOnlineSocketRequest
   {
      
      public function delAllCardReq()
      {
         super();
      }
      
      public static function Info() : void
      {
         MsgHead.Result = 0;
         MsgHead.PkgLen = 17;
         initAction(CommandID.DEL_ALL_POSTCARD);
         flush();
      }
   }
}

