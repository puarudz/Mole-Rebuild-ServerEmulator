package com.logic.socket.finishSomething
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import flash.events.EventDispatcher;
   
   public class finishedSomethingReq extends EventDispatcher
   {
      
      public function finishedSomethingReq()
      {
         super();
      }
      
      public static function sendReq(type:Number) : void
      {
         MsgHead.PkgLen = 21;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.FINISHED_SOMETHING);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(type);
         GV.onlineSocket.flush();
      }
   }
}

