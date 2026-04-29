package com.logic.socket
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.global.staticData.*;
   import flash.events.*;
   import flash.net.Socket;
   
   public class ClientRegistUDPSocket extends EventDispatcher
   {
      
      public static var SEND_DATA:String = "send_data";
      
      public static var SOCKET_SHUTDOWN:String = "socket_shutdown";
      
      public static var SOCKET_SUCCESS:String = "socket_success";
      
      public static var SOCKET_ERROR:String = "socket_error";
      
      public static var SOCKET_DATAS:String = "socket_datas";
      
      public static var CONNECT_FAIL:String = "connect_fail";
      
      public static var DATABASE_FAIL:String = "database_fail";
      
      public static var NIKE_LENGTH_ERROR:String = "nike_length_error";
      
      public static var DATA_NOT_ENOUGH:String = "data_not_enough";
      
      public static var DATA_TOO_BIG:String = "data_too_big";
      
      public static var GET_ROOM_HOST:String = "get_room_host";
      
      private var socket:Socket;
      
      public var obj:Object;
      
      private var is_head:Boolean;
      
      public function ClientRegistUDPSocket(ip:String, port:int)
      {
         super();
         this.socket = new Socket();
         this.obj = new Object();
         this.is_head = true;
         this.configureListeners();
         this.socket.connect(ip,port);
      }
      
      private function configureListeners() : void
      {
         this.socket.addEventListener(Event.CLOSE,this.closeHandler);
         this.socket.addEventListener(Event.CONNECT,this.connectHandler);
         this.socket.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         this.socket.addEventListener(ProgressEvent.SOCKET_DATA,this.socketDataHandler);
      }
      
      private function closeHandler(event:Event) : void
      {
         dispatchEvent(new Event(SOCKET_SHUTDOWN));
      }
      
      private function connectHandler(event:Event) : void
      {
         dispatchEvent(new Event(SOCKET_SUCCESS));
      }
      
      private function ioErrorHandler(event:IOErrorEvent) : void
      {
         dispatchEvent(new Event(SOCKET_ERROR));
      }
      
      private function socketDataHandler(event:ProgressEvent) : void
      {
         this.socketData();
      }
      
      public function getRoomHot(id:int, ismyhouse:int) : void
      {
         MsgHead.PkgLen = 18;
         if(MsgHead.Result != 0)
         {
            MsgHead.Result = 0;
         }
         this.socket.writeUnsignedInt(MsgHead.PkgLen);
         this.socket.writeByte(MsgHead.Version);
         this.socket.writeUnsignedInt(CommandID.getRoomHot);
         this.socket.writeUnsignedInt(id);
         this.socket.writeUnsignedInt(MsgHead.Result);
         this.socket.writeByte(ismyhouse);
         this.socket.flush();
      }
      
      private function socketData() : void
      {
         var getRoomHotObj:Object = null;
         if(this.socket.bytesAvailable > 0)
         {
            if(this.is_head && this.socket.bytesAvailable < 4)
            {
               this.obj.msg = "data not enough";
               dispatchEvent(new EventTaomee(DATA_NOT_ENOUGH,this.obj));
               return;
            }
            if(this.is_head)
            {
               MsgHead.PkgLen = this.socket.readUnsignedInt();
            }
            if(MsgHead.PkgLen < 0 || MsgHead.PkgLen > 8192)
            {
               this.obj.msg = "data too big";
               dispatchEvent(new EventTaomee(DATA_TOO_BIG,this.obj));
               this.socket.close();
               return;
            }
            if(this.socket.bytesAvailable < MsgHead.PkgLen - 4)
            {
               this.is_head = false;
               this.obj.msg = "data not enough";
               dispatchEvent(new EventTaomee(DATA_NOT_ENOUGH,this.obj));
               return;
            }
            this.is_head = true;
            MsgHead.Version = this.socket.readUnsignedByte();
            MsgHead.Command = this.socket.readUnsignedInt();
            this.socket.readUnsignedInt();
            MsgHead.Result = this.socket.readUnsignedInt();
            if(MsgHead.Result == 0)
            {
               switch(MsgHead.Command)
               {
                  case CommandID.getRoomHot:
                     getRoomHotObj = new Object();
                     getRoomHotObj.Hot = this.socket.readUnsignedInt();
                     dispatchEvent(new EventTaomee(GET_ROOM_HOST,getRoomHotObj));
               }
               this.socket.close();
            }
            else
            {
               if(MsgHead.Result == 2001)
               {
                  this.obj.msg = "注冊長度錯誤";
               }
               else if(MsgHead.Result == 1301)
               {
                  this.obj.msg = " 嗨，這個Email已經注冊過啦！";
               }
               else if(MsgHead.Result == 1104)
               {
                  this.obj.msg = " 數據庫錯誤";
               }
               dispatchEvent(new EventTaomee(CONNECT_FAIL,this.obj));
            }
         }
      }
   }
}

