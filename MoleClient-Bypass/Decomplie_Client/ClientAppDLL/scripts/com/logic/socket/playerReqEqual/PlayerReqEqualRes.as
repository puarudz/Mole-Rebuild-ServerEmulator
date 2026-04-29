package com.logic.socket.playerReqEqual
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class PlayerReqEqualRes extends EventDispatcher
   {
      
      public static var PLAYER_EQUAL:String = "player_equal";
      
      public function PlayerReqEqualRes()
      {
         super();
      }
      
      public function playerReqEqual() : void
      {
         var playerReqEqualObj:Object = new Object();
         playerReqEqualObj.UserID = GV.GameSocket.readUnsignedInt();
         playerReqEqualObj.UserIDmy = GV.GameSocket.readUnsignedInt();
         playerReqEqualObj.Result = GV.GameSocket.readUnsignedByte();
         GV.GameSocket.dispatchEvent(new EventTaomee(PLAYER_EQUAL,playerReqEqualObj));
      }
   }
}

