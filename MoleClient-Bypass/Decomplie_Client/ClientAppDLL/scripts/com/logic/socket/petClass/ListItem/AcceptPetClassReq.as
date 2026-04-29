package com.logic.socket.petClass.ListItem
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class AcceptPetClassReq extends BaseOnlineSocketRequest
   {
      
      public function AcceptPetClassReq()
      {
         super();
      }
      
      public static function AcceptPetClass(petID:uint, classID:uint, classStep:int) : void
      {
         MsgHead.PkgLen = 17 + 10;
         initAction(CommandID.ACCEPT_PET_CLASS);
         GV.onlineSocket.writeUnsignedInt(petID);
         GV.onlineSocket.writeUnsignedInt(classID);
         GV.onlineSocket.writeShort(classStep);
         flush();
      }
   }
}

