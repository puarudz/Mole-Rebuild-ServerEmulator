package com.logic.socket.shopItem
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class BuyItemReq
   {
      
      public function BuyItemReq()
      {
         super();
      }
      
      public function buyItems(ItemID:int, Count:int) : void
      {
         MsgHead.PkgLen = 25;
         if(MsgHead.Result != 0)
         {
            MsgHead.Result = 0;
         }
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.buyItem);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(ItemID);
         GV.onlineSocket.writeUnsignedInt(Count);
         GV.onlineSocket.flush();
      }
   }
}

