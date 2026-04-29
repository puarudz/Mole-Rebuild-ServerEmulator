package com.logic.socket.finishSomething
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import flash.events.EventDispatcher;
   
   public class finishSomethingReq extends EventDispatcher
   {
      
      public function finishSomethingReq()
      {
         super();
      }
      
      public static function sendReq(type:Number) : void
      {
         if(GV.isGameShowTip)
         {
            return;
         }
         MsgHead.PkgLen = 21;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.FINISH_SOMETHING);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(type);
         GV.onlineSocket.flush();
      }
   }
}

