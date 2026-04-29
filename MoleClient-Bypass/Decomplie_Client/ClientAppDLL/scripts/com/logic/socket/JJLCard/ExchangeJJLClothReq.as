package com.logic.socket.JJLCard
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class ExchangeJJLClothReq extends BaseOnlineSocketRequest
   {
      
      public function ExchangeJJLClothReq()
      {
         super();
      }
      
      public static function ChangCloth() : void
      {
         MsgHead.PkgLen = 17;
         initAction(CommandID.EXCHANG_JJL_CLOTH);
         flush();
      }
   }
}

