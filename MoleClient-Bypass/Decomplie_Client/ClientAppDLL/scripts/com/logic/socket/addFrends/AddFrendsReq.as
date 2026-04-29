package com.logic.socket.addFrends
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class AddFrendsReq
   {
      
      public function AddFrendsReq()
      {
         super();
      }
      
      public function addFrends(UserID:int) : void
      {
         MsgHead.PkgLen = 21;
         if(MsgHead.Result != 0)
         {
            MsgHead.Result = 0;
         }
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.requestJFrend);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(UserID);
         GV.onlineSocket.flush();
      }
   }
}

