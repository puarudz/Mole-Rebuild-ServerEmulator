package com.logic.socket.leaveGame
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class LeaveGameRes extends EventDispatcher
   {
      
      public static var LEAVE_GAME:String = "LEAVE_GAME";
      
      public function LeaveGameRes()
      {
         super();
      }
      
      public function leaveGameres() : void
      {
         var leaveGameObj:Object = new Object();
         leaveGameObj.UserID = GV.onlineSocket.readUnsignedInt();
         leaveGameObj.Reason = GV.onlineSocket.readUnsignedByte();
         GV.onlineSocket.dispatchEvent(new EventTaomee(LEAVE_GAME,leaveGameObj));
         GV.onlineSocket.dispatchEvent(new EventTaomee(LeaveGameReq.LEAVEGAME_CLEATNPC));
      }
   }
}

