package com.logic.socket.footBall
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class goReq
   {
      
      public function goReq()
      {
         super();
      }
      
      public function sendgo(startx:int, starty:int, endx:int, endy:int) : void
      {
         MsgHead.PkgLen = 33;
         if(MsgHead.Result != 0)
         {
            MsgHead.Result = 0;
         }
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.GOFOOTBALL);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(startx);
         GV.onlineSocket.writeUnsignedInt(starty);
         GV.onlineSocket.writeUnsignedInt(endx);
         GV.onlineSocket.writeUnsignedInt(endy);
         GV.onlineSocket.flush();
      }
   }
}

