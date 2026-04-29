package com.logic.socket.petSocket.learnPet
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class AllLearnListReq extends BaseOnlineSocketRequest
   {
      
      public function AllLearnListReq()
      {
         super();
      }
      
      public static function getAllPet() : void
      {
         MsgHead.Result = 0;
         MsgHead.PkgLen = 17;
         initAction(CommandID.PETLEARNALLLIST);
         flush();
      }
   }
}

