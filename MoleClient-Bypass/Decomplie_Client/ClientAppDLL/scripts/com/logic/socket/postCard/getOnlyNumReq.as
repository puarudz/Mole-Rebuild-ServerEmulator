package com.logic.socket.postCard
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class getOnlyNumReq extends BaseOnlineSocketRequest
   {
      
      public function getOnlyNumReq()
      {
         super();
      }
      
      public static function Info() : void
      {
         MsgHead.Result = 0;
         MsgHead.PkgLen = 17;
         initAction(CommandID.GET_ONLY_NUM);
         flush();
      }
   }
}

