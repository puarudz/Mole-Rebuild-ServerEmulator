package com.core.socketlogic.baseSocket
{
   import com.common.Alert.Alert;
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.mole.net.events.SocketEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.IDataInput;
   import org.taomee.net.LoggerType;
   import org.taomee.net.SocketImpl;
   import org.taomee.net.tmf.HeadInfo;
   import org.taomee.net.tmf.TMF;
   
   public class MoleSocket extends SocketImpl
   {
      
      public static const HEAD_LEN:uint = 17;
      
      private static var SOCKET_SHUTDOWN:String = "socket_shutdown";
      
      public static var SOCKET_SUCCESS:String = "socket_success";
      
      private static var SOCKET_ERROR:String = "socket_error";
      
      private static var SOCKET_DATAS:String = "socket_datas";
      
      private static var SOCKET_SECURITY:String = "socket_security";
      
      private static var GET_HOLISTICPACKAGE:String = "get_holisticPackage";
      
      private static var GET_BODYPACKAGE:String = "get_bodyPackage";
      
      private static var SEND_PACKAGE:String = "SEND_PACKAGE";
      
      private var _inputArray:ByteArray;
      
      private var _ip:String;
      
      private var _port:int;
      
      private var _seq:int = 128;
      
      private var _outputArray:ByteArray;
      
      private var _note:Dictionary = new Dictionary();
      
      public function MoleSocket(userID:uint)
      {
         super(userID);
         this._seq = XMLInfo.VERSION;
         headClass = MoleHeadInfo;
         SocketImpl.headLength = HEAD_LEN;
         this._inputArray = new ByteArray();
         this.initListener();
      }
      
      private function initListener() : void
      {
         this.addEventListener(Event.CLOSE,this.closeHandler);
         this.addEventListener(Event.CONNECT,this.connectHandler);
         this.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         this.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
      }
      
      public function connectServer(host:String, port:int) : void
      {
         this._ip = host;
         this._port = port;
         connect(this._ip,port);
      }
      
      private function closeHandler(event:Event) : void
      {
         dispatchEvent(new EventTaomee(SOCKET_SHUTDOWN,event));
      }
      
      private function connectHandler(event:Event) : void
      {
         GV.ActionHistory = new Array();
         dispatchEvent(new EventTaomee(SOCKET_SUCCESS,event));
      }
      
      private function ioErrorHandler(event:IOErrorEvent) : void
      {
         dispatchEvent(new EventTaomee(SOCKET_ERROR,{"msg":"伺服器連接錯誤."}));
      }
      
      private function securityErrorHandler(event:SecurityErrorEvent) : void
      {
         dispatchEvent(new EventTaomee(SOCKET_SECURITY,event));
      }
      
      override public function send(cmdID:uint, args:Array, endian:String = null) : void
      {
         var data:ByteArray = null;
         var pkLen:uint = 0;
         if(connected)
         {
            data = this.createBody(args,endian);
            pkLen = HEAD_LEN + data.length;
            this._seq = this.versionEvent(cmdID,pkLen,this._seq,data);
            data = this.encryptBody(data,endian);
            pkLen = HEAD_LEN + data.length;
            writeUnsignedInt(pkLen);
            MsgHead.Version = this._seq;
            writeByte(MsgHead.Version);
            writeUnsignedInt(MsgHead.Command);
            writeUnsignedInt(MsgHead.UserID);
            writeUnsignedInt(MsgHead.Result);
            writeBytes(data,0,data.length);
            flush();
            this.parselogger(LoggerType.OUTPUT,cmdID,data.length);
         }
      }
      
      override protected function outputCommand(headInfo:HeadInfo, data:ByteArray = null) : void
      {
         var tmfClass:Class = null;
         if(headInfo.result != 0)
         {
            trace("協議號:" + headInfo.commandID + "    返回的錯誤碼是:" + headInfo.result);
         }
         var isDispatch:Boolean = false;
         if(headInfo.result != 0)
         {
            GV.onlineSocket.dispatchEvent(new SocketEvent(SocketEvent.ERROR,headInfo));
         }
         if((data == null || data.length == 1 || data.length == 0) && headInfo.result != 0)
         {
            data = new ByteArray();
            MoleHeadInfo(headInfo).packLen = 0;
            isDispatch = dispatchCommand(headInfo.commandID,headInfo);
         }
         else
         {
            data = MessageEncrypt.decrypt(data);
            MoleHeadInfo(headInfo).packLen = data.bytesAvailable;
            tmfClass = TMF.getClass(headInfo.commandID);
            isDispatch = dispatchCommand(headInfo.commandID,headInfo,new tmfClass(data));
            if(headInfo.commandID == 1242 && data.length == 4)
            {
               Alert.angryAlart("  小摩爾背包中已經有這個坐騎了哦!");
            }
         }
         MsgHead.PkgLen = MoleHeadInfo(headInfo).packLen;
         MsgHead.Version = MoleHeadInfo(headInfo).verson;
         MsgHead.Command = headInfo.commandID;
         MsgHead.UserID = headInfo.userID;
         MsgHead.Result = headInfo.result;
         this.holisticBody(data,headInfo.commandID);
         dispatchEvent(new EventTaomee(GET_BODYPACKAGE,{
            "Package":data,
            "Command":headInfo.commandID
         }));
         dispatchEvent(new EventTaomee(SOCKET_DATAS,new ProgressEvent(SOCKET_DATAS)));
      }
      
      override protected function parselogger(type:String, commandID:uint, dataLength:int) : void
      {
         var descObj:Object = this._note["CMD_" + commandID] || new Object();
         if(type == LoggerType.INPUT)
         {
            trace("接收[" + this._ip + ":" + this._port + "][CmdID:" + commandID + "][BodyLen:" + dataLength + "]",Boolean(descObj.note) ? descObj.note : "");
         }
         else if(type == LoggerType.OUTPUT)
         {
            trace("發送[" + this._ip + ":" + this._port + "][CmdID:" + commandID + "][BodyLen:" + dataLength + "]",Boolean(descObj.note) ? descObj.note : "");
         }
      }
      
      public function holisticBody(tempByteArr:ByteArray, Command:int) : void
      {
         this._outputArray = new ByteArray();
         this._outputArray.writeUnsignedInt(MsgHead.PkgLen);
         this._outputArray.writeByte(MsgHead.Version);
         this._outputArray.writeUnsignedInt(MsgHead.Command);
         this._outputArray.writeUnsignedInt(MsgHead.UserID);
         this._outputArray.writeUnsignedInt(MsgHead.Result);
         if(MsgHead.PkgLen > 0)
         {
            this._outputArray.writeBytes(tempByteArr);
         }
         this._outputArray.position = 0;
         dispatchEvent(new EventTaomee(GET_HOLISTICPACKAGE,{
            "Package":this._outputArray,
            "Command":Command
         }));
      }
      
      public function flushInput() : void
      {
         this._inputArray.position = 5;
         var cmdId:int = int(this._inputArray.readUnsignedInt());
         this._inputArray.position = 0;
         this.readHead(this._inputArray);
         var data:ByteArray = new ByteArray();
         data.writeBytes(this._inputArray,HEAD_LEN);
         this._inputArray = new ByteArray();
         this.send(cmdId,[data]);
      }
      
      private function readHead(tempByteArr:IDataInput) : void
      {
         MsgHead.PkgLen = tempByteArr.readUnsignedInt();
         MsgHead.Version = tempByteArr.readByte();
         MsgHead.Command = tempByteArr.readUnsignedInt();
         MsgHead.UserID = tempByteArr.readUnsignedInt();
         MsgHead.Result = tempByteArr.readUnsignedInt();
      }
      
      private function versionEvent(_cmdID:int, _len:int, _seqno:int, tempByteArr:ByteArray) : int
      {
         if(_cmdID == 201)
         {
            return _seqno;
         }
         if(_cmdID == 999)
         {
            return 0;
         }
         return int((_seqno - int(_seqno / 7) + 147 + _len % 21 + _cmdID % 13 + this.getCrc(tempByteArr)) % 256);
      }
      
      private function getCrc(buffer:ByteArray) : uint
      {
         var length:int = int(buffer.length);
         var crc:uint = 0;
         for(var i:int = 0; i < length; i++)
         {
            crc = uint((crc ^ buffer[i]) & 0xFF);
         }
         return crc & 0xFFFFFFFF;
      }
      
      public function get inputArray() : ByteArray
      {
         return this._inputArray;
      }
      
      public function get outputArray() : ByteArray
      {
         return this._outputArray;
      }
      
      public function get port() : int
      {
         return this._port;
      }
      
      public function get host() : String
      {
         return this._ip;
      }
      
      public function set note(val:Dictionary) : void
      {
         this._note = val;
      }
      
      protected function createBody(args:Array, endian:String) : ByteArray
      {
         var i:* = undefined;
         var data:ByteArray = new ByteArray();
         if(endian != null && endian != "")
         {
            data.endian = endian;
         }
         for each(i in args)
         {
            if(i is String)
            {
               data.writeUTFBytes(i);
            }
            else if(i is ByteArray)
            {
               data.writeBytes(i);
            }
            else
            {
               data.writeUnsignedInt(i);
            }
         }
         return data;
      }
      
      protected function encryptBody(data:ByteArray, endian:String) : ByteArray
      {
         if(endian != null && endian != "")
         {
            data.endian = endian;
         }
         return MessageEncrypt.encrypt(data,endian);
      }
   }
}

