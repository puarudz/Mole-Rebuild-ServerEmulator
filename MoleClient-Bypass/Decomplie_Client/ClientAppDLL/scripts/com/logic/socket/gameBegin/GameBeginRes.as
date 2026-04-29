package com.logic.socket.gameBegin
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class GameBeginRes extends EventDispatcher
   {
      
      public static var BEGING_GAME:String = "begin_game";
      
      public function GameBeginRes()
      {
         super();
      }
      
      public function gamebegin() : void
      {
         var userObj:Object = null;
         var gameBeginObj:Object = new Object();
         var gameBeginArr:Array = new Array();
         gameBeginObj.GroupID = GV.onlineSocket.readUnsignedInt();
         gameBeginObj.GameID = GV.onlineSocket.readUnsignedInt();
         gameBeginObj.Count = GV.onlineSocket.readUnsignedShort();
         for(var i:int = 0; i < gameBeginObj.Count; i++)
         {
            userObj = new Object();
            userObj.UserID = GV.onlineSocket.readUnsignedInt();
            userObj.itemID = GV.onlineSocket.readUnsignedShort();
            gameBeginArr.push(userObj);
         }
         gameBeginObj.gameArr = gameBeginArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee(BEGING_GAME,gameBeginObj));
      }
   }
}

