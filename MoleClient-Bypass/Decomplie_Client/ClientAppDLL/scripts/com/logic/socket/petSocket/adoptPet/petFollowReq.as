package com.logic.socket.petSocket.adoptPet
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import flash.events.EventDispatcher;
   
   public class petFollowReq extends EventDispatcher
   {
      
      public function petFollowReq()
      {
         super();
      }
      
      public function sendFollowReq(SpriteID:int, Status:uint) : void
      {
         MsgHead.PkgLen = 25;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.PETFOLLOW);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(SpriteID);
         GV.onlineSocket.writeUnsignedInt(Status);
         GV.onlineSocket.flush();
      }
   }
}

