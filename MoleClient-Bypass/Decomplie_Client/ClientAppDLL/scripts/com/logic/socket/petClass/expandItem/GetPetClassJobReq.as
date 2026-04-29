package com.logic.socket.petClass.expandItem
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class GetPetClassJobReq extends BaseOnlineSocketRequest
   {
      
      public function GetPetClassJobReq()
      {
         super();
      }
      
      public static function GetInfo(petID:uint = 0, classID:uint = 0) : void
      {
         MsgHead.PkgLen = 17 + 8;
         initAction(CommandID.PET_CLASSJOB_GET);
         GV.onlineSocket.writeUnsignedInt(petID);
         GV.onlineSocket.writeUnsignedInt(classID);
         flush();
      }
   }
}

