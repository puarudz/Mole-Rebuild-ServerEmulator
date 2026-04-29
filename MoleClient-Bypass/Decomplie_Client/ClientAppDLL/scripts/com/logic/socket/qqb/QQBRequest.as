package com.logic.socket.qqb
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class QQBRequest extends BaseOnlineSocketRequest
   {
      
      public function QQBRequest()
      {
         super();
      }
      
      public static function qqbStatus() : void
      {
         MsgHead.Result = 0;
         MsgHead.PkgLen = 17;
         initAction(CommandID.QQB_STATUS);
         flush();
      }
      
      public static function qqbMove(x:Number, y:Number = 0, direction:int = 2) : void
      {
         MsgHead.Result = 0;
         MsgHead.PkgLen = 17 + 5;
         initAction(CommandID.QQB_MOVE_ACTION);
         GV.onlineSocket.writeShort(int(x));
         GV.onlineSocket.writeShort(int(y));
         GV.onlineSocket.writeByte(direction);
         flush();
      }
   }
}

