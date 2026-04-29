package com.logic.socket.fiveChess
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class FiveChessSuccessRes extends EventDispatcher
   {
      
      public static var FIVECHESS_SUCC:String = "fivechess_succ";
      
      public function FiveChessSuccessRes()
      {
         super();
      }
      
      public function fiveChessSuccess(packaLen:int) : void
      {
         var i:int = 0;
         var chessObj:Object = null;
         var fiveChessSuccObj:Object = new Object();
         var fiveChessArr:Array = new Array();
         fiveChessSuccObj.UserID = GV.GameSocket.readUnsignedInt();
         if(packaLen == 31)
         {
            for(i = 0; i < 5; i++)
            {
               chessObj = new Object();
               chessObj.x = GV.GameSocket.readUnsignedByte();
               chessObj.y = GV.GameSocket.readUnsignedByte();
               fiveChessArr.push(chessObj);
            }
         }
         fiveChessSuccObj.fiveChess = fiveChessArr;
         GV.GameSocket.dispatchEvent(new EventTaomee(FIVECHESS_SUCC,fiveChessSuccObj));
      }
   }
}

