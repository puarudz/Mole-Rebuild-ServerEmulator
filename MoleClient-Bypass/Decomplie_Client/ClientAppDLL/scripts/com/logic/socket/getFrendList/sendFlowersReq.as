package com.logic.socket.getFrendList
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class sendFlowersReq
   {
      
      public function sendFlowersReq()
      {
         super();
      }
      
      public function sendreq(mapid:int, flowerORmub:int) : void
      {
         MsgHead.PkgLen = 25;
         if(MsgHead.Result != 0)
         {
            MsgHead.Result = 0;
         }
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.SEND_FLOWERS_MUD);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(mapid);
         GV.onlineSocket.writeUnsignedInt(flowerORmub);
         GV.onlineSocket.flush();
      }
   }
}

