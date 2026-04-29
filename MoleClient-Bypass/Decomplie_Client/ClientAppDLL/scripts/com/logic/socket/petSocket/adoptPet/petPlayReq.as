package com.logic.socket.petSocket.adoptPet
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   
   public class petPlayReq extends EventDispatcher
   {
      
      public function petPlayReq()
      {
         super();
      }
      
      public static function sendpetPlayReq() : void
      {
         MsgHead.PkgLen = 17;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.PET_SHOP_PLAY);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.flush();
      }
      
      public static function sendpetbackreq(petobj:Object) : void
      {
         MsgHead.Command = 239;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(petobj.UserID);
         tempByteArray.writeUnsignedInt(petobj.SpriteID);
         GF.writeHead(tempByteArray);
      }
      
      public function sendPlayReq(UserID:int, SpriteID:uint) : void
      {
         MsgHead.PkgLen = 25;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.PETPLAY);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(UserID);
         GV.onlineSocket.writeUnsignedInt(SpriteID);
         GV.onlineSocket.flush();
      }
   }
}

