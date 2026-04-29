package com.logic.socket.impeach
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class ImpeachReq
   {
      
      public function ImpeachReq()
      {
         super();
      }
      
      public function impeach(Userid:int, Reason:int) : void
      {
         MsgHead.PkgLen = 25;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.IMPEACH);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(Userid);
         GV.onlineSocket.writeUnsignedInt(Reason);
         GV.onlineSocket.flush();
      }
   }
}

