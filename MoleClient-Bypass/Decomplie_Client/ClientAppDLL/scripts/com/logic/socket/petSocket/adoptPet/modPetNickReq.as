package com.logic.socket.petSocket.adoptPet
{
   import com.common.data.socketDataHandler.decString.DealData;
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class modPetNickReq
   {
      
      public function modPetNickReq()
      {
         super();
      }
      
      public function sendPetNick(SpriteID:uint, nick:String) : void
      {
         if(MsgHead.Result != 0)
         {
            MsgHead.Result = 0;
         }
         MsgHead.PkgLen = 37;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.PETNICK);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(SpriteID);
         GV.onlineSocket.writeBytes(DealData.dealNikeName(nick));
         GV.onlineSocket.flush();
      }
   }
}

