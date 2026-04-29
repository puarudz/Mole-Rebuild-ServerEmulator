package com.logic.socket.singleGame
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import flash.utils.ByteArray;
   
   public class SingleGameActionReq
   {
      
      public function SingleGameActionReq()
      {
         super();
      }
      
      public function sendAction(obj:Object) : void
      {
         MsgHead.PkgLen = 33;
         if(MsgHead.Result != 0)
         {
            MsgHead.Result = 0;
         }
         var ba:ByteArray = new ByteArray();
         ba.writeByte(obj.action);
         ba.writeByte(obj.percent);
         ba.writeUnsignedInt(obj.score);
         ba.writeUnsignedInt(obj.showtxt);
         ba.length = 16;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.SINGLEGAMEACTION);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeBytes(ba);
         GV.onlineSocket.flush();
      }
   }
}

