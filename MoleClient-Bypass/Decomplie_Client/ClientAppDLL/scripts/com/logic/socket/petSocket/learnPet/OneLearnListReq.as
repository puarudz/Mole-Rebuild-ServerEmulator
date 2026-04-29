package com.logic.socket.petSocket.learnPet
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class OneLearnListReq extends BaseOnlineSocketRequest
   {
      
      public function OneLearnListReq()
      {
         super();
      }
      
      public static function getOneList(PetID:uint, startID:uint, stopID:uint, type:uint) : void
      {
         trace(PetID,startID,stopID,type,"@@228sand");
         MsgHead.Result = 0;
         MsgHead.PkgLen = 17 + 16;
         initAction(CommandID.PETLEARNONELIST);
         GV.onlineSocket.writeUnsignedInt(PetID);
         GV.onlineSocket.writeUnsignedInt(startID);
         GV.onlineSocket.writeUnsignedInt(stopID);
         GV.onlineSocket.writeUnsignedInt(type);
         flush();
      }
   }
}

