package com.logic.socket.singleGame
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class SingleGameReq
   {
      
      public function SingleGameReq()
      {
         super();
      }
      
      public function singlegame(Ratio:int, Score:uint, Square:uint) : void
      {
         MsgHead.PkgLen = 25;
         if(MsgHead.Result != 0)
         {
            MsgHead.Result = 0;
         }
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.singleGame);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(Ratio);
         GV.onlineSocket.writeUnsignedInt(Score);
         GV.onlineSocket.writeUnsignedInt(Square);
         GV.onlineSocket.flush();
      }
   }
}

