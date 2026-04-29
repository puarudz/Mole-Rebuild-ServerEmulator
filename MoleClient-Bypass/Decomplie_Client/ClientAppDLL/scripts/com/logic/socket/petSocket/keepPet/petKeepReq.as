package com.logic.socket.petSocket.keepPet
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import flash.events.EventDispatcher;
   
   public class petKeepReq extends EventDispatcher
   {
      
      public function petKeepReq()
      {
         super();
      }
      
      public static function sendReq(arr:Array, type:uint) : void
      {
         MsgHead.PkgLen = 22 + 4 * arr.length;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.KEEP_PET);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeByte(arr.length);
         for(var i:uint = 0; i < arr.length; i++)
         {
            GV.onlineSocket.writeUnsignedInt(arr[i]);
         }
         GV.onlineSocket.writeUnsignedInt(type);
         GV.onlineSocket.flush();
      }
   }
}

