package com.logic.socket.smc.ListItem
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class getSMCLevelReq
   {
      
      public function getSMCLevelReq()
      {
         super();
      }
      
      public static function dosend(ID:int) : void
      {
         MsgHead.PkgLen = 21;
         if(MsgHead.Result != 0)
         {
            MsgHead.Result = 0;
         }
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.GET_SMC_LEVEL);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(ID);
         GV.onlineSocket.flush();
      }
   }
}

