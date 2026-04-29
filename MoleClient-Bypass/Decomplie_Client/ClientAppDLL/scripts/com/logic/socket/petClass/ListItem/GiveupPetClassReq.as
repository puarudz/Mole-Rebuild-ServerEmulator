package com.logic.socket.petClass.ListItem
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class GiveupPetClassReq extends BaseOnlineSocketRequest
   {
      
      public function GiveupPetClassReq()
      {
         super();
      }
      
      public static function GiveupPetClass(petID:uint, classID:uint) : void
      {
         MsgHead.PkgLen = 17 + 8;
         initAction(CommandID.GIVEUP_PET_CLASS);
         GV.onlineSocket.writeUnsignedInt(petID);
         GV.onlineSocket.writeUnsignedInt(classID);
         flush();
      }
   }
}

