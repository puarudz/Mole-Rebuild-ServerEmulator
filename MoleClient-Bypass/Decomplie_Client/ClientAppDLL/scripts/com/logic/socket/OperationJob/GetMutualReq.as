package com.logic.socket.OperationJob
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class GetMutualReq extends BaseOnlineSocketRequest
   {
      
      public function GetMutualReq()
      {
         super();
      }
      
      public static function GetInfo() : void
      {
         MsgHead.PkgLen = 17;
         initAction(CommandID.MUTUAL_OPERATION_GET);
         flush();
      }
   }
}

