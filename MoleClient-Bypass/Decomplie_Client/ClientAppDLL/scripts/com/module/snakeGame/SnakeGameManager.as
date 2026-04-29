package com.module.snakeGame
{
   import com.common.msgHead.MsgHead;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.socket.ClientGameSerSocket;
   import com.logic.socket.enterPlayerGame.EnterPlayerGameRes;
   import com.logic.socket.newUserEnterGame.NewUserEnterGameRes;
   import com.logic.socket.noticeGameStart.NoticeGameStartRes;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.ByteArray;
   
   public class SnakeGameManager extends Sprite
   {
      
      public var MyLoader:*;
      
      public function SnakeGameManager(mc:*, obj:Object = null)
      {
         super();
         this.MyLoader = mc;
         new ClientGameSerSocket(obj.ip,obj.port,obj.SessionID);
         GV.onlineSocket.dispatchEvent(new Event("GameSeverReady"));
         BC.addEvent(this,GV.GameSocket,ClientGameSerSocket.SOCKET_CONNECT,this.ServerConnect);
      }
      
      public static function sendSocket(cmdID:uint, ... args) : void
      {
         var arg:* = undefined;
         var byteLen:uint = 0;
         var bodyData:ByteArray = null;
         if(Boolean(GV.GameSocket) && GV.GameSocket.connected)
         {
            byteLen = 0;
            bodyData = new ByteArray();
            for each(arg in args)
            {
               if(arg is String)
               {
                  bodyData.writeUTFBytes(arg);
               }
               else if(arg is ByteArray)
               {
                  bodyData.writeBytes(arg);
               }
               else if(arg is uint)
               {
                  bodyData.writeUnsignedInt(arg);
               }
               else
               {
                  bodyData.writeInt(arg);
               }
            }
            MsgHead.Command = cmdID;
            MsgHead.Result = 0;
            MsgHead.PkgLen = 17 + bodyData.length;
            GV.GameSocket.writeUnsignedInt(MsgHead.PkgLen);
            GV.GameSocket.writeByte(MsgHead.Version);
            GV.GameSocket.writeUnsignedInt(MsgHead.Command);
            GV.GameSocket.writeUnsignedInt(MsgHead.UserID);
            GV.GameSocket.writeUnsignedInt(MsgHead.Result);
            GV.GameSocket.writeBytes(bodyData,0,bodyData.length);
            GV.GameSocket.flush();
         }
      }
      
      private function ServerConnect(E:*) : void
      {
         BC.addEvent(this,GV.GameSocket,EnterPlayerGameRes.ENTER_GAME_SUCCESS,this.getPeopleArray);
         BC.addEvent(this,GV.GameSocket,NewUserEnterGameRes.NEWUSER_ENTERGAME,this.getPeople);
         BC.addEvent(this,GV.GameSocket,ClientGameSerSocket.SOCKET_ERROR,this.GameError);
         BC.addEvent(this,GV.GameSocket,ClientGameSerSocket.SOCKET_SHUTDOWN,this.GameError);
         BC.addEvent(this,GV.GameSocket,NoticeGameStartRes.GAME_START,this.readyGame);
         BC.addEvent(this,GV.onlineSocket,"CLOSE_SNAKE_GAME",this.closeFunc);
      }
      
      private function readyGame(e:* = null) : void
      {
      }
      
      public function getPeople(E:* = null) : void
      {
      }
      
      public function getPeopleArray(E:* = null) : void
      {
      }
      
      public function GameError(E:* = null) : void
      {
      }
      
      public function closeFunc(E:* = null) : void
      {
         BC.removeEvent(this,GV.GameSocket,ClientGameSerSocket.SOCKET_SHUTDOWN,this.GameError);
         BC.removeEvent(this,GV.GameSocket,EnterPlayerGameRes.ENTER_GAME_SUCCESS,this.getPeopleArray);
         BC.removeEvent(this,GV.GameSocket,NewUserEnterGameRes.NEWUSER_ENTERGAME,this.getPeople);
         BC.removeEvent(this,GV.GameSocket,ClientGameSerSocket.SOCKET_ERROR,this.GameError);
         BC.removeEvent(this,GV.GameSocket,NoticeGameStartRes.GAME_START,this.readyGame);
         BC.removeEvent(this,GV.GameSocket,ClientGameSerSocket.SOCKET_CONNECT,this.ServerConnect);
         BC.removeEvent(this,GV.onlineSocket,"CLOSE_SNAKE_GAME",this.closeFunc);
         GC.clearAll(this.MyLoader);
         this.outGame();
      }
      
      private function outGame() : void
      {
         GV.isSitDown = false;
         MoveTo.CanMove = true;
      }
      
      public function destroy() : void
      {
      }
   }
}

