package com.logic.socket.gameGroup
{
   import com.event.EventTaomee;
   
   public class GameGroupRes
   {
      
      public static var GAMEGROPU:String = "gamegroup";
      
      public function GameGroupRes()
      {
         super();
      }
      
      public function gameGroup() : void
      {
         var gameObj:Object = null;
         var gameGroupObj:Object = new Object();
         var gameGroupArr:Array = new Array();
         gameGroupObj.userCount = GV.onlineSocket.readUnsignedInt();
         gameGroupObj.Count = GV.onlineSocket.readUnsignedInt();
         for(var i:int = 0; i < gameGroupObj.Count; i++)
         {
            gameObj = new Object();
            gameObj.UserID = GV.onlineSocket.readUnsignedInt();
            gameObj.itemID = GV.onlineSocket.readByte();
            gameGroupArr.push(gameObj);
         }
         gameGroupObj.gameArr = gameGroupArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee(GAMEGROPU,gameGroupObj));
      }
   }
}

