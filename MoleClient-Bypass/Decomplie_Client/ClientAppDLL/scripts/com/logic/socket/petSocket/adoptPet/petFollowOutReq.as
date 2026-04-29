package com.logic.socket.petSocket.adoptPet
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import flash.events.EventDispatcher;
   
   public class petFollowOutReq extends EventDispatcher
   {
      
      public function petFollowOutReq()
      {
         super();
      }
      
      public function sendFollowReq(UserID:int, SpriteID:int) : void
      {
         MsgHead.PkgLen = 25;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.PETFOLLOW_OUT);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(UserID);
         GV.onlineSocket.writeUnsignedInt(SpriteID);
         GV.onlineSocket.flush();
      }
   }
}

