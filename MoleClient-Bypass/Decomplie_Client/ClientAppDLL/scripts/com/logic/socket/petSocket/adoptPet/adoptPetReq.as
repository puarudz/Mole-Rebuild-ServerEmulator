package com.logic.socket.petSocket.adoptPet
{
   import com.common.data.socketDataHandler.decString.DealData;
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import flash.events.EventDispatcher;
   
   public class adoptPetReq extends EventDispatcher
   {
      
      public function adoptPetReq()
      {
         super();
      }
      
      public function adoptPetAction(itemID:int, itemColor:int, nickName:String) : void
      {
         MsgHead.PkgLen = 41;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.adoptPer);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(itemID);
         GV.onlineSocket.writeUnsignedInt(itemColor);
         GV.onlineSocket.writeBytes(DealData.dealNikeName(nickName));
         GV.onlineSocket.flush();
      }
   }
}

