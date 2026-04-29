package com.logic.socket.fiveChess
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class FiveChessRes extends EventDispatcher
   {
      
      public static var FIVECHESS:String = "fivechess";
      
      public function FiveChessRes()
      {
         super();
      }
      
      public function fiveChess() : void
      {
         var fiveChessObj:Object = new Object();
         fiveChessObj.UserID = GV.GameSocket.readUnsignedInt();
         GV.GameSocket.dispatchEvent(new EventTaomee(FIVECHESS,fiveChessObj));
      }
   }
}

