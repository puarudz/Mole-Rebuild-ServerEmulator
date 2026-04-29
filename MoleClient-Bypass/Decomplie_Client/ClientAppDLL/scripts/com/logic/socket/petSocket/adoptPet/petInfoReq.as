package com.logic.socket.petSocket.adoptPet
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import flash.events.EventDispatcher;
   
   public class petInfoReq extends EventDispatcher
   {
      
      public function petInfoReq()
      {
         super();
      }
      
      public function sendInfoReq(UserID:int, SpriteID:uint = 0, Type:int = 0) : void
      {
         MsgHead.PkgLen = 26;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.PETINFO);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(UserID);
         GV.onlineSocket.writeUnsignedInt(SpriteID);
         GV.onlineSocket.writeByte(Type);
         GV.onlineSocket.flush();
      }
   }
}

