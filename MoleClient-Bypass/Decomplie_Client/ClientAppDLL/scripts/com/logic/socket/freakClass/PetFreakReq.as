package com.logic.socket.freakClass
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class PetFreakReq extends BaseOnlineSocketRequest
   {
      
      public function PetFreakReq()
      {
         super();
      }
      
      public static function Info(type:uint = 0) : void
      {
         MsgHead.Result = 0;
         MsgHead.PkgLen = 21;
         initAction(CommandID.PETFREAKLEARN);
         GV.onlineSocket.writeUnsignedInt(type);
         flush();
      }
   }
}

