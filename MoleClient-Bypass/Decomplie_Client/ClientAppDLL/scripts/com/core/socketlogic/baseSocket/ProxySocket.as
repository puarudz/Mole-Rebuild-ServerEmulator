package com.core.socketlogic.baseSocket
{
   import com.event.EventTaomee;
   import flash.events.*;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   
   use namespace flash_proxy;
   
   public class ProxySocket extends Proxy implements IDataOutput, IDataInput
   {
      
      public static var SOCKET_SHUTDOWN:String = "socket_shutdown";
      
      public static var SOCKET_SUCCESS:String = "socket_success";
      
      public static var SOCKET_ERROR:String = "socket_error";
      
      public static var SOCKET_DATAS:String = "socket_datas";
      
      public static var SOCKET_SECURITY:String = "socket_security";
      
      public static var GET_HOLISTICPACKAGE:String = "get_holisticPackage";
      
      public static var GET_BODYPACKAGE:String = "get_bodyPackage";
      
      private var _moleSocket:MoleSocket;
      
      private var _dispatchObj:EventDispatcher = new EventDispatcher();
      
      public function ProxySocket()
      {
         super();
         this._moleSocket = new MoleSocket(0);
      }
      
      public function connect(host:String, port:int) : void
      {
         this._moleSocket.connectServer(host,port);
         BC.addEvent(this,this._moleSocket,SOCKET_SHUTDOWN,this.closeHandler);
         BC.addEvent(this,this._moleSocket,SOCKET_SUCCESS,this.connectHandler);
         BC.addEvent(this,this._moleSocket,SOCKET_ERROR,this.ioErrorHandler);
         BC.addEvent(this,this._moleSocket,SOCKET_DATAS,this.datasHandler);
         BC.addEvent(this,this._moleSocket,SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
         BC.addEvent(this,this._moleSocket,GET_HOLISTICPACKAGE,this.holisticPackageHandler);
         BC.addEvent(this,this._moleSocket,GET_BODYPACKAGE,this.bodyPackageHandler);
      }
      
      public function flush() : void
      {
         this._moleSocket.flushInput();
      }
      
      public function close() : void
      {
         this._moleSocket.close();
      }
      
      public function get bytesAvailable() : uint
      {
         return this._moleSocket.outputArray.length - this._moleSocket.outputArray.position;
      }
      
      public function set note(dic:Dictionary) : void
      {
         if(!dic["CMD_202"])
         {
            dic["CMD_202"] = {
               "path":"",
               "action":"",
               "isStatic":"",
               "note":"未知",
               "db":1
            };
         }
         if(!dic["CMD_203"])
         {
            dic["CMD_203"] = {
               "path":"",
               "action":"",
               "isStatic":"",
               "note":"獲取基本屬性",
               "db":1
            };
         }
         if(!dic["CMD_316"])
         {
            dic["CMD_316"] = {
               "path":"",
               "action":"",
               "isStatic":"",
               "note":"叨叨牆獻花",
               "db":1
            };
         }
         if(!dic["CMD_319"])
         {
            dic["CMD_319"] = {
               "path":"",
               "action":"",
               "isStatic":"",
               "note":"未知",
               "db":1
            };
         }
         if(!dic["CMD_508"])
         {
            dic["CMD_508"] = {
               "path":"",
               "action":"",
               "isStatic":"",
               "note":"丟棄道具",
               "db":1
            };
         }
         this._moleSocket.note = dic;
      }
      
      public function get connected() : Boolean
      {
         return this._moleSocket.connected;
      }
      
      public function set endian(type:String) : void
      {
         this._moleSocket.endian = type;
      }
      
      public function get endian() : String
      {
         return this._moleSocket.endian;
      }
      
      public function set objectEncoding(version:uint) : void
      {
         this._moleSocket.objectEncoding = version;
      }
      
      public function get objectEncoding() : uint
      {
         return this._moleSocket.objectEncoding;
      }
      
      public function writeBoolean(value:Boolean) : void
      {
         this._moleSocket.inputArray.writeBoolean(value);
      }
      
      public function writeByte(value:int) : void
      {
         this._moleSocket.inputArray.writeByte(value);
      }
      
      public function writeBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0) : void
      {
         this._moleSocket.inputArray.writeBytes(bytes,offset,length);
      }
      
      public function writeDouble(value:Number) : void
      {
         this._moleSocket.inputArray.writeDouble(value);
      }
      
      public function writeFloat(value:Number) : void
      {
         this._moleSocket.inputArray.writeFloat(value);
      }
      
      public function writeInt(value:int) : void
      {
         this._moleSocket.inputArray.writeInt(value);
      }
      
      public function writeMultiByte(value:String, charSet:String) : void
      {
         this._moleSocket.inputArray.writeMultiByte(value,charSet);
      }
      
      public function writeObject(object:*) : void
      {
         this._moleSocket.inputArray.writeObject(object);
      }
      
      public function writeShort(value:int) : void
      {
         this._moleSocket.inputArray.writeShort(value);
      }
      
      public function writeUnsignedInt(value:uint) : void
      {
         this._moleSocket.inputArray.writeUnsignedInt(value);
      }
      
      public function writeUTF(value:String) : void
      {
         this._moleSocket.inputArray.writeUTF(value);
      }
      
      public function writeUTFBytes(value:String) : void
      {
         this._moleSocket.inputArray.writeUTFBytes(value);
      }
      
      public function readBoolean() : Boolean
      {
         return this._moleSocket.outputArray.readBoolean();
      }
      
      public function readByte() : int
      {
         return this._moleSocket.outputArray.readByte();
      }
      
      public function readBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0) : void
      {
         this._moleSocket.outputArray.readBytes(bytes,offset,length);
      }
      
      public function readDouble() : Number
      {
         return this._moleSocket.outputArray.readDouble();
      }
      
      public function readFloat() : Number
      {
         return this._moleSocket.outputArray.readFloat();
      }
      
      public function readInt() : int
      {
         return this._moleSocket.outputArray.readInt();
      }
      
      public function readMultiByte(length:uint, charSet:String) : String
      {
         return this._moleSocket.outputArray.readMultiByte(length,charSet);
      }
      
      public function readObject() : *
      {
         return this._moleSocket.outputArray.readObject();
      }
      
      public function readShort() : int
      {
         return this._moleSocket.outputArray.readShort();
      }
      
      public function readUnsignedByte() : uint
      {
         return this._moleSocket.outputArray.readUnsignedByte();
      }
      
      public function readUnsignedInt() : uint
      {
         return this._moleSocket.outputArray.readUnsignedInt();
      }
      
      public function readUnsignedShort() : uint
      {
         return this._moleSocket.outputArray.readUnsignedShort();
      }
      
      public function readUTF() : String
      {
         return this._moleSocket.outputArray.readUTF();
      }
      
      public function readUTFBytes(length:uint) : String
      {
         return this._moleSocket.outputArray.readUTFBytes(length);
      }
      
      override flash_proxy function callProperty(methodName:*, ... args) : *
      {
         var res:* = undefined;
         var _loc4_:* = methodName.toString();
         switch(0)
         {
         }
         return this._moleSocket[methodName].apply(this._moleSocket,args);
      }
      
      override flash_proxy function getProperty(name:*) : *
      {
         return this._moleSocket[name];
      }
      
      override flash_proxy function setProperty(name:*, value:*) : void
      {
         this._moleSocket[name] = value;
      }
      
      private function closeHandler(event:EventTaomee) : void
      {
         this.dispatchEvent(new Event(Event.CLOSE));
      }
      
      private function connectHandler(event:EventTaomee) : void
      {
         this.dispatchEvent(new Event(Event.CONNECT));
      }
      
      private function ioErrorHandler(event:EventTaomee) : void
      {
         this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR,false,false,event.EventObj.msg));
      }
      
      private function securityErrorHandler(event:EventTaomee) : void
      {
         this.dispatchEvent(new SecurityErrorEvent(event.EventObj.type,event.EventObj.bubbles,event.EventObj.cancelable,event.EventObj.text));
      }
      
      private function datasHandler(event:EventTaomee) : void
      {
         this.dispatchEvent(new ProgressEvent(ProgressEvent.SOCKET_DATA,event.EventObj.bubbles,event.EventObj.cancelable,this._moleSocket.outputArray.length,this._moleSocket.outputArray.length));
      }
      
      private function holisticPackageHandler(event:EventTaomee) : void
      {
         this.dispatchEvent(new EventTaomee(GET_HOLISTICPACKAGE,event.EventObj));
      }
      
      private function bodyPackageHandler(event:EventTaomee) : void
      {
         this.dispatchEvent(new EventTaomee(GET_BODYPACKAGE,event.EventObj));
      }
      
      public function addCmdListener(cmdId:uint, listenerHandler:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         if(this.baseSocket is MoleSocket)
         {
            MoleSocket(this.baseSocket).addCommandListener(cmdId,listenerHandler,useCapture,priority);
         }
      }
      
      public function removeCmdListener(cmdId:uint, listenerHandler:Function, useCapture:Boolean = false) : void
      {
         if(this.baseSocket is MoleSocket)
         {
            MoleSocket(this.baseSocket).removeCommandListener(cmdId,listenerHandler);
         }
      }
      
      public function get baseSocket() : Socket
      {
         return this._moleSocket;
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         this._dispatchObj.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         this._dispatchObj.removeEventListener(type,listener,useCapture);
      }
      
      public function dispatchEvent(event:Event) : void
      {
         this._dispatchObj.dispatchEvent(event);
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return this._dispatchObj.hasEventListener(type);
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return this._dispatchObj.willTrigger(type);
      }
   }
}

