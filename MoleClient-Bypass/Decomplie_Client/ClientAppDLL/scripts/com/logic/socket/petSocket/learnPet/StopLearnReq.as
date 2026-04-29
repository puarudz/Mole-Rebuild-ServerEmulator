package com.logic.socket.petSocket.learnPet
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class StopLearnReq extends BaseOnlineSocketRequest
   {
      
      public function StopLearnReq()
      {
         super();
      }
      
      public static function StopOneClass(Arr:Array) : void
      {
         var Count:uint = Arr.length;
         MsgHead.Result = 0;
         MsgHead.PkgLen = 18 + uint(Count * 4);
         initAction(CommandID.PETLEARNSTOP);
         GV.onlineSocket.writeByte(Count);
         for(var i:uint = 0; i < Count; i++)
         {
            GV.onlineSocket.writeUnsignedInt(Arr[i].petID);
         }
         flush();
      }
   }
}

