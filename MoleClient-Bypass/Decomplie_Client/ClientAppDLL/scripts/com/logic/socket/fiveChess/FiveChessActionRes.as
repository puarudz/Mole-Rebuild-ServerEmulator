package com.logic.socket.fiveChess
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class FiveChessActionRes extends EventDispatcher
   {
      
      public static var FIVECHESS_ACTION:String = "fivechess_action";
      
      public function FiveChessActionRes()
      {
         super();
      }
      
      public function fiveChessAction() : void
      {
         var fiveChessActionObj:Object = new Object();
         fiveChessActionObj.UserID = GV.GameSocket.readUnsignedInt();
         fiveChessActionObj.Xpos = GV.GameSocket.readUnsignedShort();
         fiveChessActionObj.Ypos = GV.GameSocket.readUnsignedShort();
         GV.GameSocket.dispatchEvent(new EventTaomee(FIVECHESS_ACTION,fiveChessActionObj));
      }
   }
}

