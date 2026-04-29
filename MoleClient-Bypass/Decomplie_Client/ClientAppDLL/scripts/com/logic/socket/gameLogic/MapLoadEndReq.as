package com.logic.socket.gameLogic
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class MapLoadEndReq
   {
      
      public function MapLoadEndReq()
      {
         super();
      }
      
      public function mapEndReq() : void
      {
         MsgHead.PkgLen = 17;
         MsgHead.Result = 0;
         GV.GameSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.GameSocket.writeByte(MsgHead.Version);
         GV.GameSocket.writeUnsignedInt(CommandID.FINISHMAP);
         GV.GameSocket.writeUnsignedInt(MsgHead.UserID);
         GV.GameSocket.writeUnsignedInt(MsgHead.Result);
         GV.GameSocket.flush();
      }
   }
}

