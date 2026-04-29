package com.logic.socket.GetItemCount
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class GetItemCountReq
   {
      
      public function GetItemCountReq()
      {
         super();
      }
      
      public static function getItemCount(UserID:int, ItemID:int, Flag:int, endItemID:int = 0) : void
      {
         endItemID = endItemID == 0 ? int(ItemID + 1) : endItemID;
         MsgHead.PkgLen = 30;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.ITEMCOUNT);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(UserID);
         GV.onlineSocket.writeUnsignedInt(ItemID);
         GV.onlineSocket.writeUnsignedInt(endItemID);
         GV.onlineSocket.writeByte(Flag);
         GV.onlineSocket.flush();
      }
   }
}

