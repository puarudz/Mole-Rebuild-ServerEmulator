package com.logic.socket.petSocket.learnPet
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class OverLearnReq extends BaseOnlineSocketRequest
   {
      
      public function OverLearnReq()
      {
         super();
      }
      
      public static function overOneClass(Arr:Array) : void
      {
         var Count:uint = Arr.length;
         MsgHead.Result = 0;
         MsgHead.PkgLen = 18 + uint(Count * 8);
         initAction(CommandID.PETLEARNOVER);
         GV.onlineSocket.writeByte(Count);
         for(var i:uint = 0; i < Count; i++)
         {
            GV.onlineSocket.writeUnsignedInt(Arr[i].petID);
            GV.onlineSocket.writeUnsignedInt(Arr[i].classID);
         }
         flush();
      }
   }
}

