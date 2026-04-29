package com.logic.socket.petClass.ListItem
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class GetPetClassReq extends BaseOnlineSocketRequest
   {
      
      public function GetPetClassReq()
      {
         super();
      }
      
      public static function GetPetClass(petID:uint, start_id:uint, end_id:uint) : void
      {
         MsgHead.PkgLen = 17 + 12;
         initAction(CommandID.GET_PET_CLASSLIST);
         GV.onlineSocket.writeUnsignedInt(petID);
         GV.onlineSocket.writeUnsignedInt(start_id);
         GV.onlineSocket.writeUnsignedInt(end_id);
         flush();
      }
   }
}

