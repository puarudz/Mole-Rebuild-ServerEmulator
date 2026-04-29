package com.logic.socket.CSItems
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class CSEXReq extends BaseOnlineSocketRequest
   {
      
      public function CSEXReq()
      {
         super();
      }
      
      public static function GetExItem(type:uint) : void
      {
         MsgHead.PkgLen = 17 + 4;
         initAction(CommandID.EXITEMCOUNT);
         GV.onlineSocket.writeUnsignedInt(type);
         flush();
      }
   }
}

