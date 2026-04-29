package com.logic.socket.leaveGame
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   
   public class LeaveGameReq
   {
      
      public static var LEAVEGAME_CLEATNPC:String = "LEAVEGAME_CLEATNPC";
      
      public function LeaveGameReq()
      {
         super();
      }
      
      public static function leaveGame(reason:int) : void
      {
         MsgHead.PkgLen = 18;
         if(MsgHead.Result != 0)
         {
            MsgHead.Result = 0;
         }
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.exitGame);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeByte(reason);
         GV.onlineSocket.flush();
         GV.onlineSocket.dispatchEvent(new EventTaomee(LEAVEGAME_CLEATNPC));
      }
   }
}

