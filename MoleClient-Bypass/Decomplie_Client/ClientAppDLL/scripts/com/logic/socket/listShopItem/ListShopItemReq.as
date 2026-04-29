package com.logic.socket.listShopItem
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class ListShopItemReq
   {
      
      public function ListShopItemReq()
      {
         super();
      }
      
      public function listShopItem(Type:int) : void
      {
         if(MsgHead.Result != 0)
         {
            MsgHead.Result = 0;
         }
         try
         {
            MsgHead.PkgLen = 18;
            GV.onlineSocket.writeInt(MsgHead.PkgLen);
            GV.onlineSocket.writeByte(MsgHead.Version);
            GV.onlineSocket.writeInt(CommandID.listShoppingItem);
            GV.onlineSocket.writeInt(MsgHead.UserID);
            GV.onlineSocket.writeInt(MsgHead.Result);
            GV.onlineSocket.writeByte(Type);
            GV.onlineSocket.flush();
         }
         catch(e:*)
         {
         }
      }
   }
}

