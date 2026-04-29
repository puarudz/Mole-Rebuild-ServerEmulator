package com.logic.socket.randomItemLogic
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class randomItemReq
   {
      
      public function randomItemReq()
      {
         super();
      }
      
      public static function randomItemReqAction() : void
      {
         MsgHead.PkgLen = 17;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.randomItem);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.flush();
      }
   }
}

