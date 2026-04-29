package com.logic.socket.petSocket.askingPet
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class PetAskReq extends BaseOnlineSocketRequest
   {
      
      public function PetAskReq()
      {
         super();
      }
      
      public static function askOnePet() : void
      {
         MsgHead.Result = 0;
         MsgHead.PkgLen = 17;
         initAction(CommandID.askOnePet);
         flush();
      }
   }
}

