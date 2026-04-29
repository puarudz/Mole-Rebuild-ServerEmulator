package com.logic.socket.enterGame
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class EnterGameReq
   {
      
      public function EnterGameReq()
      {
         super();
      }
      
      public static function send(siteID:int, mapID:int = 0) : void
      {
         new EnterGameReq().enterGame(siteID,mapID);
      }
      
      public function enterGame(ItemID:int, mapID:int = 0) : void
      {
         var sitID:int = ItemID;
         if(sitID <= 0)
         {
            sitID = 1;
         }
         MsgHead.PkgLen = 21;
         if(MsgHead.Result != 0)
         {
            MsgHead.Result = 0;
         }
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.enterGame);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(sitID);
         GV.onlineSocket.writeUnsignedInt(mapID);
         GV.onlineSocket.flush();
      }
   }
}

