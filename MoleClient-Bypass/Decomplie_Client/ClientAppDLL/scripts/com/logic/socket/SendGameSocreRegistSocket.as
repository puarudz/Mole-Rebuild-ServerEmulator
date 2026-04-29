package com.logic.socket
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.global.staticData.*;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.net.Socket;
   import flash.system.Security;
   import flash.utils.ByteArray;
   
   public class SendGameSocreRegistSocket extends Sprite
   {
      
      public static var SEND_GAME_SOCRE:String = "send_game_socre";
      
      public static var LIST_SEQUENCE:String = "list_sequence";
      
      private var socket:Socket;
      
      private var ip:String;
      
      private var port:int;
      
      public var obj:Object;
      
      private var is_head:Boolean;
      
      private var gameId:int;
      
      private var soce:int;
      
      private var session:ByteArray;
      
      private var eventType:Number;
      
      public function SendGameSocreRegistSocket(getObj:Object)
      {
         super();
         this.eventType = getObj.type;
         if(this.eventType == 0)
         {
            this.soce = getObj.score;
            this.session = getObj.session;
         }
         this.ip = getObj.ip;
         this.port = getObj.port;
         this.gameId = getObj.gameID;
         this.socket = new Socket();
         this.obj = new Object();
         this.is_head = true;
         Security.loadPolicyFile("http://" + this.ip + "/crossdomain.xml");
         this.configureListeners();
         this.socket.connect(this.ip,this.port);
      }
      
      private function configureListeners() : void
      {
         this.socket.addEventListener(Event.CLOSE,this.closeHandler);
         this.socket.addEventListener(Event.CONNECT,this.connectHandler);
         this.socket.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         this.socket.addEventListener(ProgressEvent.SOCKET_DATA,this.socketDataHandler);
      }
      
      public function closeSendGame() : void
      {
         this.socket.removeEventListener(Event.CLOSE,this.closeHandler);
         this.socket.removeEventListener(Event.CONNECT,this.connectHandler);
         this.socket.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         this.socket.removeEventListener(ProgressEvent.SOCKET_DATA,this.socketDataHandler);
         if(this.socket.connected)
         {
            this.socket.close();
         }
      }
      
      private function closeHandler(event:Event) : void
      {
         trace("closeHandler: registSer socket關閉.........." + event);
      }
      
      private function connectHandler(event:Event) : void
      {
         if(this.eventType == 0)
         {
            this.sendGameSocre(this.gameId,this.soce,this.session);
         }
         else
         {
            this.listSocrePeople(this.gameId);
         }
      }
      
      private function ioErrorHandler(event:IOErrorEvent) : void
      {
         trace("ioErrorHandler: registSer socket連接錯誤................" + event);
      }
      
      private function socketDataHandler(event:ProgressEvent) : void
      {
         this.socketData();
      }
      
      public function listSocrePeople(GameID:int) : void
      {
         MsgHead.PkgLen = 21;
         if(MsgHead.Result != 0)
         {
            MsgHead.Result = 0;
         }
         this.socket.writeUnsignedInt(MsgHead.PkgLen);
         this.socket.writeByte(MsgHead.Version);
         this.socket.writeUnsignedInt(CommandID.listGameScore);
         this.socket.writeUnsignedInt(MsgHead.UserID);
         this.socket.writeUnsignedInt(MsgHead.Result);
         this.socket.writeUnsignedInt(GameID);
         this.socket.flush();
      }
      
      public function sendGameSocre(gameID:int, Score:int, session:ByteArray) : void
      {
         MsgHead.PkgLen = 49;
         MsgHead.Result = 0;
         this.socket.writeUnsignedInt(MsgHead.PkgLen);
         this.socket.writeByte(MsgHead.Version);
         this.socket.writeUnsignedInt(CommandID.submissGameScore);
         this.socket.writeUnsignedInt(MsgHead.UserID);
         this.socket.writeUnsignedInt(MsgHead.Result);
         this.socket.writeUnsignedInt(gameID);
         this.socket.writeUnsignedInt(Score);
         this.socket.writeBytes(session);
         this.socket.flush();
      }
      
      private function socketData() : void
      {
         var sendgamesocreObj:Object = null;
         var listsocreObj:Object = null;
         var listSocreArr:Array = null;
         var i:int = 0;
         var listNameObj:Object = null;
         var MsgObj:Object = null;
         while(this.socket.bytesAvailable > 0)
         {
            if(this.is_head && this.socket.bytesAvailable < 4)
            {
               this.obj.msg = "data not enough";
               return;
            }
            if(this.is_head)
            {
               MsgHead.PkgLen = this.socket.readUnsignedInt();
            }
            if(MsgHead.PkgLen < 0 || MsgHead.PkgLen > 8192)
            {
               this.obj.msg = "data too big";
               this.socket.close();
               return;
            }
            if(this.socket.bytesAvailable < MsgHead.PkgLen - 4)
            {
               this.is_head = false;
               return;
            }
            this.is_head = true;
            MsgHead.Version = this.socket.readUnsignedByte();
            MsgHead.Command = this.socket.readUnsignedInt();
            MsgHead.UserID = this.socket.readUnsignedInt();
            MsgHead.Result = this.socket.readUnsignedInt();
            if(MsgHead.Result != 0)
            {
               MsgObj = new Object();
               MsgObj.msg = "提交遊戲積分失敗";
               dispatchEvent(new EventTaomee(SEND_GAME_SOCRE,MsgObj));
               break;
            }
            switch(MsgHead.Command)
            {
               case CommandID.submissGameScore:
                  sendgamesocreObj = new Object();
                  sendgamesocreObj.msg = "提交遊戲積分成功";
                  dispatchEvent(new EventTaomee(SEND_GAME_SOCRE,sendgamesocreObj));
                  break;
               case CommandID.listGameScore:
                  listsocreObj = new Object();
                  listSocreArr = new Array();
                  listsocreObj.GameID = this.socket.readUnsignedInt();
                  listsocreObj.Count = this.socket.readUnsignedInt();
                  for(i = 0; i < listsocreObj.Count; i++)
                  {
                     listNameObj = new Object();
                     listNameObj.UserID = this.socket.readUnsignedInt();
                     listNameObj.Nick = this.socket.readUTFBytes(16);
                     listNameObj.Score = this.socket.readUnsignedInt();
                     listSocreArr.push(listNameObj);
                  }
                  listsocreObj.listArr = listSocreArr;
                  dispatchEvent(new EventTaomee(LIST_SEQUENCE,listsocreObj));
            }
         }
      }
   }
}

