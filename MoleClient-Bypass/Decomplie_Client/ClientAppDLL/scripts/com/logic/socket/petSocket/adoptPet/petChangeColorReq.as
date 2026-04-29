package com.logic.socket.petSocket.adoptPet
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import flash.events.EventDispatcher;
   
   public class petChangeColorReq extends EventDispatcher
   {
      
      public function petChangeColorReq()
      {
         super();
      }
      
      public function sendReq(petid:int, item:uint, Colortype:uint = 1) : void
      {
         MsgHead.PkgLen = 29;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.PET_CHANGE_COLOR);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(petid);
         GV.onlineSocket.writeUnsignedInt(item);
         GV.onlineSocket.writeUnsignedInt(Colortype);
         GV.onlineSocket.flush();
      }
   }
}

