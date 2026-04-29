package com.logic.socket.smc.PickItem
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class PickItemReq
   {
      
      public function PickItemReq()
      {
         super();
      }
      
      public static function pickItem(ItemID:int) : void
      {
         if(ItemID == 0)
         {
            return;
         }
         MsgHead.PkgLen = 21;
         if(MsgHead.Result != 0)
         {
            MsgHead.Result = 0;
         }
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.PICKITEM);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(ItemID);
         GV.onlineSocket.flush();
      }
   }
}

