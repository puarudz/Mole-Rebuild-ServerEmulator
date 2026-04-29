package com.logic.socket.moleAction
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import flash.events.EventDispatcher;
   
   public class moleActionReq extends EventDispatcher
   {
      
      public function moleActionReq()
      {
         super();
      }
      
      public function sendAction(action:int, X:int = -1000, Y:int = -1000) : void
      {
         if(X == -1000)
         {
            X = int(GV.MAN_PEOPLE.x);
            Y = int(GV.MAN_PEOPLE.y);
         }
         MsgHead.PkgLen = 23;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.MOLESLIDE);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeShort(action);
         GV.onlineSocket.writeShort(X);
         GV.onlineSocket.writeShort(Y);
         GV.onlineSocket.flush();
      }
   }
}

