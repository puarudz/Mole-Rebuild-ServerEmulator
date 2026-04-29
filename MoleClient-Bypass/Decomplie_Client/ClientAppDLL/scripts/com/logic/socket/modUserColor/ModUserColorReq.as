package com.logic.socket.modUserColor
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class ModUserColorReq
   {
      
      public function ModUserColorReq()
      {
         super();
      }
      
      public function modUserColor(item:int, color:uint) : void
      {
         MsgHead.PkgLen = 25;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.modUserColor);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(item);
         GV.onlineSocket.writeUnsignedInt(color);
         GV.onlineSocket.flush();
      }
   }
}

