package com.logic.socket.petSocket.adoptPet
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import flash.events.EventDispatcher;
   
   public class petFoodReq extends EventDispatcher
   {
      
      public function petFoodReq()
      {
         super();
      }
      
      public function sendFoodReq(uid:uint, petID:uint, itemID:uint) : void
      {
         MsgHead.PkgLen = 25;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.PETFOOD);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(uid);
         GV.onlineSocket.writeUnsignedInt(petID);
         GV.onlineSocket.writeUnsignedInt(itemID);
         GV.onlineSocket.flush();
      }
   }
}

