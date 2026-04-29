package com.logic.socket.CSItems
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class CSReq extends BaseOnlineSocketRequest
   {
      
      public function CSReq()
      {
         super();
      }
      
      public static function Info(type:uint = 0) : void
      {
         if(type > 500 && type <= 600)
         {
            type += 2000;
         }
         MsgHead.Result = 0;
         MsgHead.PkgLen = 21;
         initAction(CommandID.CSITEM);
         GV.onlineSocket.writeUnsignedInt(type);
         flush();
      }
   }
}

