package com.logic.socket.gameLogic
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class GameLogicRes extends EventDispatcher
   {
      
      public static var GAME_LOGIC:String = "game_logic";
      
      public function GameLogicRes()
      {
         super();
      }
      
      public function gameLogic() : void
      {
         var gameObj:Object = null;
         var gameLogicObj:Object = new Object();
         var gameLogicArr:Array = new Array();
         gameLogicObj.BarrieType = GV.GameSocket.readUnsignedInt();
         gameLogicObj.NumOfBars = GV.GameSocket.readUnsignedInt();
         for(var i:int = 0; i < gameLogicObj.NumOfBars; i++)
         {
            gameObj = new Object();
            gameObj.PosX = GV.GameSocket.readUnsignedInt();
            gameObj.PosY = GV.GameSocket.readUnsignedInt();
            gameLogicArr.push(gameObj);
         }
         gameLogicObj.arr = gameLogicArr;
         GV.GameSocket.dispatchEvent(new EventTaomee(GAME_LOGIC,gameLogicObj));
      }
   }
}

