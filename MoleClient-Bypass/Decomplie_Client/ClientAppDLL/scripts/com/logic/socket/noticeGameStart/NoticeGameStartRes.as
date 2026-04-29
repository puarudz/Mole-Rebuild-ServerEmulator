package com.logic.socket.noticeGameStart
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class NoticeGameStartRes extends EventDispatcher
   {
      
      public static var GAME_START:String = "game_start";
      
      public function NoticeGameStartRes()
      {
         super();
      }
      
      public function noticeGameStart() : void
      {
         var palyerObj:Object = null;
         var noticeGameStartObj:Object = new Object();
         var palyerArr:Array = new Array();
         noticeGameStartObj.GroupID = GV.GameSocket.readUnsignedInt();
         noticeGameStartObj.GameID = GV.GameSocket.readUnsignedInt();
         noticeGameStartObj.Count = GV.GameSocket.readUnsignedInt();
         for(var i:int = 0; i < noticeGameStartObj.Count; i++)
         {
            palyerObj = new Object();
            palyerObj.UserID = GV.GameSocket.readUnsignedInt();
            palyerArr.push(palyerObj);
         }
         noticeGameStartObj.useid = palyerArr;
         GV.GameSocket.dispatchEvent(new EventTaomee(GAME_START,noticeGameStartObj));
      }
   }
}

