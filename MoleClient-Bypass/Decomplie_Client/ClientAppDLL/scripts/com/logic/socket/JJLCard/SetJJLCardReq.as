package com.logic.socket.JJLCard
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class SetJJLCardReq extends BaseOnlineSocketRequest
   {
      
      public function SetJJLCardReq()
      {
         super();
      }
      
      public static function SetCard(Flag:uint, myCardID:uint, getCardID:uint) : void
      {
         MsgHead.PkgLen = 12 + 17;
         initAction(CommandID.SET_JJL_CARD);
         GV.onlineSocket.writeUnsignedInt(Flag);
         GV.onlineSocket.writeUnsignedInt(myCardID);
         GV.onlineSocket.writeUnsignedInt(getCardID);
         flush();
      }
   }
}

