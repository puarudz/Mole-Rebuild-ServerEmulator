package com.logic.socket.gameScore
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   
   public class GameSocreRes extends EventDispatcher
   {
      
      public static var GAMESORE:String = "gamesocre";
      
      public function GameSocreRes()
      {
         super();
      }
      
      public function gameSocre() : void
      {
         var gameSocreObj:Object = new Object();
         var byte:ByteArray = new ByteArray();
         gameSocreObj.GameID = GV.GameSocket.readUnsignedShort();
         gameSocreObj.Rank = GV.GameSocket.readUnsignedShort();
         gameSocreObj.Strong = GV.GameSocket.readUnsignedInt();
         gameSocreObj.IQ = GV.GameSocket.readUnsignedInt();
         gameSocreObj.Lovely = GV.GameSocket.readUnsignedInt();
         gameSocreObj.Exp = GV.GameSocket.readUnsignedInt();
         gameSocreObj.score = GV.GameSocket.readUnsignedInt();
         gameSocreObj.Time = GV.GameSocket.readUnsignedInt();
         gameSocreObj.Yxb = GV.GameSocket.readUnsignedInt();
         gameSocreObj.ItemID = GV.GameSocket.readUnsignedInt();
         GV.GameSocket.readBytes(byte,0,24);
         gameSocreObj.Session = byte;
         GV.GameSocket.dispatchEvent(new EventTaomee(GAMESORE,gameSocreObj));
      }
   }
}

