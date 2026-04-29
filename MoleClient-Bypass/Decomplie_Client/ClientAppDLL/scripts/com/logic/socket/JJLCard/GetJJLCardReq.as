package com.logic.socket.JJLCard
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class GetJJLCardReq extends BaseOnlineSocketRequest
   {
      
      public function GetJJLCardReq()
      {
         super();
      }
      
      public static function GetCard(userID:uint) : void
      {
         MsgHead.PkgLen = 4 + 17;
         initAction(CommandID.GET_JJL_CARD);
         GV.onlineSocket.writeUnsignedInt(userID);
         flush();
      }
   }
}

