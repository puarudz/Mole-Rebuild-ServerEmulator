package com.logic.socket.throwItem
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class ThrowItemReq
   {
      
      public function ThrowItemReq()
      {
         super();
      }
      
      public function throwItem(ItemID:int, EndX:int, EndY:int) : void
      {
         MsgHead.PkgLen = 29;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.THROW_ITEM);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(ItemID);
         GV.onlineSocket.writeUnsignedInt(EndX);
         GV.onlineSocket.writeUnsignedInt(EndY);
         GV.onlineSocket.flush();
      }
      
      public function throwEffectItem(ItemID:int, userID:int) : void
      {
         MsgHead.PkgLen = 25;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.useDProperty);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(userID);
         GV.onlineSocket.writeUnsignedInt(ItemID);
         GV.onlineSocket.flush();
      }
   }
}

