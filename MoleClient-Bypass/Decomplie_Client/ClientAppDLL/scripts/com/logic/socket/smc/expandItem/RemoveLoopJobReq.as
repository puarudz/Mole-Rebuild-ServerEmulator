package com.logic.socket.smc.expandItem
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class RemoveLoopJobReq extends BaseOnlineSocketRequest
   {
      
      public function RemoveLoopJobReq()
      {
         super();
      }
      
      public static function RemoveInfo(jobID:uint = 0) : void
      {
         MsgHead.PkgLen = 17 + 4;
         initAction(CommandID.LOOP_SMCJOB_REMOVE);
         GV.onlineSocket.writeUnsignedInt(jobID);
         flush();
      }
   }
}

