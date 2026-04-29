package com.logic.socket.noticeLooker
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class NoticeLookerRes extends EventDispatcher
   {
      
      public static var NOTICE_LOOKER:String = "notice_looker";
      
      public function NoticeLookerRes()
      {
         super();
      }
      
      public function noticeLooker() : void
      {
         var j:int = 0;
         var noticeLookerObj:Object = new Object();
         var chessboardArr:Array = new Array();
         noticeLookerObj.UserID1 = GV.GameSocket.readUnsignedInt();
         noticeLookerObj.Chess1 = GV.GameSocket.readUnsignedByte();
         noticeLookerObj.UserID2 = GV.GameSocket.readUnsignedInt();
         noticeLookerObj.Chess2 = GV.GameSocket.readUnsignedByte();
         for(var i:int = 0; i < 15; i++)
         {
            chessboardArr[i] = new Array(15);
            for(j = 0; j < 15; j++)
            {
               chessboardArr[i][j] = GV.GameSocket.readUnsignedByte();
            }
         }
         noticeLookerObj.ChessBoard = chessboardArr;
         GV.GameSocket.dispatchEvent(new EventTaomee(NOTICE_LOOKER,noticeLookerObj));
      }
   }
}

