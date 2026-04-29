package com.logic.socket.petSocket.keepPet
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import flash.events.EventDispatcher;
   
   public class petBackKeepReq extends EventDispatcher
   {
      
      public function petBackKeepReq()
      {
         super();
      }
      
      public static function sendReq(arr:Array) : void
      {
         MsgHead.PkgLen = 18 + 4 * arr.length;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.KEEP_BACK_PET);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeByte(arr.length);
         for(var i:int = 0; i < arr.length; i++)
         {
            GV.onlineSocket.writeUnsignedInt(arr[i]);
         }
         GV.onlineSocket.flush();
      }
   }
}

