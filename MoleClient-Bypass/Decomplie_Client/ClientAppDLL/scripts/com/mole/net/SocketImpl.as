package com.mole.net
{
   import com.common.util.Tick;
   import com.core.manager.SocketDataManager;
   import com.core.socketlogic.baseSocket.MoleHeadInfo;
   import com.mole.net.events.SocketEvent;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   import org.taomee.net.tmf.HeadInfo;
   import org.taomee.net.tmf.TMF;
   import org.taomee.net.tmf.TmfByteArray;
   
   public class SocketImpl extends Socket
   {
      
      public static const PACKAGE_MAX:uint = 8388608;
      
      protected var _version:int;
      
      protected var _userID:uint;
      
      protected var _host:String;
      
      protected var _port:int;
      
      public const HEAD_LEN:uint = 17;
      
      protected var _cmdList:Array;
      
      private var _bufferData:ByteArray = new ByteArray();
      
      private var _isGetHead:Boolean = false;
      
      private var _dataLen:uint;
      
      private var _headInfo:MoleHeadInfo;
      
      public function SocketImpl(userID:uint)
      {
         super();
         this._version = 65;
         this._userID = userID;
         this._cmdList = new Array();
      }
      
      public static function getCmdLabel(cmdID:uint) : String
      {
         var cmdInfo:Object = SocketDataManager.inst.getInfo(cmdID);
         if(Boolean(cmdInfo))
         {
            return cmdInfo.note;
         }
         return "---";
      }
      
      override public function connect(host:String, port:int) : void
      {
         super.connect(host,port);
         this._host = host;
         this._port = port;
         BC.addEvent(this,this,Event.CONNECT,this.onConnect);
         BC.addEvent(this,this,ProgressEvent.SOCKET_DATA,this.onData);
         trace("Socket連接---->IP:",host,"Port:",port);
      }
      
      private function onConnect(event:Event) : void
      {
         GV.ActionHistory = new Array();
         Tick.instance.addCallback(this.sendCmd);
      }
      
      private function sendCmd(delay:Number) : void
      {
         var bytes:ByteArray = null;
         var headInfo:MoleHeadInfo = null;
         var bodyBytes:ByteArray = null;
         if(this._cmdList.length > 0)
         {
            bytes = this._cmdList.shift();
            headInfo = this.analysisInputData(bytes);
            this.traceData(headInfo);
            bodyBytes = new ByteArray();
            bodyBytes.writeBytes(bytes,17);
            bytes.position = 0;
            bytes.writeUnsignedInt(bytes.length);
            bytes.writeByte(this.nextVersion(headInfo.commandID,bytes.length,bodyBytes));
            writeBytes(bytes);
            if(connected)
            {
               flush();
            }
         }
      }
      
      private function traceData(headInfo:MoleHeadInfo) : void
      {
         trace(">>>>>Socket[" + this._host + ":" + this._port + "][CmdID:" + headInfo.commandID + "][PkgLen:" + headInfo.packLen + "]>>>>>",getCmdLabel(headInfo.commandID));
      }
      
      protected function analysisInputData(inputData:ByteArray) : MoleHeadInfo
      {
         inputData.position = 0;
         var len:uint = inputData.readUnsignedInt();
         var headInfo:MoleHeadInfo = new MoleHeadInfo(inputData);
         headInfo.packLen = len;
         return headInfo;
      }
      
      public function send(cmdID:uint, ... args) : void
      {
         var arg:* = undefined;
         var bodyData:ByteArray = null;
         var byteLen:uint = 0;
         var bytes:ByteArray = new ByteArray();
         for each(arg in args)
         {
            if(arg is String)
            {
               bytes.writeUTFBytes(arg);
            }
            else if(arg is ByteArray)
            {
               bytes.writeBytes(arg);
            }
            else if(arg is uint)
            {
               bytes.writeUnsignedInt(arg);
            }
            else
            {
               bytes.writeInt(arg);
            }
         }
         byteLen = bytes.length + this.HEAD_LEN;
         bodyData = new ByteArray();
         bodyData.writeUnsignedInt(byteLen);
         bodyData.writeByte(0);
         bodyData.writeUnsignedInt(cmdID);
         bodyData.writeUnsignedInt(this._userID);
         bodyData.writeUnsignedInt(0);
         bodyData.writeBytes(bytes);
         this._cmdList.push(bodyData);
      }
      
      override public function close() : void
      {
         removeEventListener(ProgressEvent.SOCKET_DATA,this.onData);
         if(connected)
         {
            super.close();
         }
         this._host = "";
         this._port = -1;
      }
      
      protected function onData(event:ProgressEvent) : void
      {
         var packageLen:uint = 0;
         var bodyBytes:ByteArray = null;
         var tmpBodyByte:ByteArray = new ByteArray();
         this._bufferData.position = 0;
         this._bufferData.readBytes(tmpBodyByte);
         readBytes(tmpBodyByte,tmpBodyByte.length);
         while(tmpBodyByte.bytesAvailable > 0)
         {
            if(!this._isGetHead)
            {
               if(tmpBodyByte.bytesAvailable < this.HEAD_LEN)
               {
                  break;
               }
               packageLen = tmpBodyByte.readUnsignedInt();
               this._dataLen = packageLen - this.HEAD_LEN;
               this._headInfo = new MoleHeadInfo(tmpBodyByte);
               this._headInfo.packLen = packageLen;
               this._isGetHead = true;
               if(packageLen > PACKAGE_MAX)
               {
                  dispatchEvent(new SocketEvent(SocketEvent.ERROR,this._headInfo));
                  tmpBodyByte.position = tmpBodyByte.length;
                  break;
               }
               if(this._headInfo.error != 0)
               {
                  dispatchEvent(new SocketEvent(SocketEvent.ERROR,this._headInfo));
                  this.dispatchErrorCmd(this._headInfo.commandID,this._headInfo);
                  tmpBodyByte.position = packageLen;
                  this._isGetHead = false;
                  break;
               }
            }
            if(tmpBodyByte.bytesAvailable < this._dataLen)
            {
               break;
            }
            bodyBytes = new ByteArray();
            tmpBodyByte.readBytes(bodyBytes,0,this._dataLen);
            this.dispatchData(this._headInfo,bodyBytes);
            this._isGetHead = false;
         }
         this._bufferData = new ByteArray();
         if(Boolean(tmpBodyByte.bytesAvailable))
         {
            tmpBodyByte.readBytes(this._bufferData);
         }
      }
      
      private function dispatchData(headInfo:MoleHeadInfo, bodyBytes:ByteArray) : void
      {
         var ProtocolCommand:Class;
         var iSocketCommand:Object = null;
         trace("<<<<<Socket[" + this._host + ":" + this._port.toString() + "][CmdID:" + headInfo.commandID + "][PkgLen:" + headInfo.packLen + "]<<<<<",getCmdLabel(headInfo.commandID));
         ProtocolCommand = TMF.getClass(headInfo.commandID);
         try
         {
            iSocketCommand = new ProtocolCommand();
            iSocketCommand.decode(bodyBytes);
         }
         catch(e:Error)
         {
            iSocketCommand = new TmfByteArray(bodyBytes);
         }
         this.dispatchCmd(headInfo.commandID,headInfo,iSocketCommand);
      }
      
      public function addCmdListener(cmdID:uint, succeedListener:Function, errorListener:Function = null) : void
      {
         addEventListener(cmdID.toString(),succeedListener);
         if(errorListener != null)
         {
            addEventListener(SocketEvent.ERROR + cmdID.toString(),errorListener);
         }
      }
      
      public function removeCmdListener(cmdID:uint, succeedListener:Function, errorListener:Function = null) : void
      {
         removeEventListener(cmdID.toString(),succeedListener);
         if(errorListener != null)
         {
            removeEventListener(SocketEvent.ERROR + cmdID.toString(),errorListener);
         }
      }
      
      public function dispatchCmd(cmdID:uint, headInfo:HeadInfo, bodyInfo:Object) : Boolean
      {
         return dispatchEvent(new SocketEvent(cmdID.toString(),headInfo,bodyInfo));
      }
      
      public function dispatchErrorCmd(cmdID:uint, headInfo:HeadInfo) : Boolean
      {
         return dispatchEvent(new SocketEvent(SocketEvent.ERROR + cmdID.toString(),headInfo));
      }
      
      public function hasCmdListener(cmdID:uint) : Boolean
      {
         return hasEventListener(cmdID.toString());
      }
      
      public function hasErrorCmdListener(cmdID:uint) : Boolean
      {
         return hasEventListener(SocketEvent.ERROR + cmdID.toString());
      }
      
      public function get host() : String
      {
         return this._host;
      }
      
      public function get port() : int
      {
         return this._port;
      }
      
      public function nextVersion(cmdID:uint, len:uint, bodyBytes:ByteArray) : int
      {
         if(cmdID == 201)
         {
            return this._version;
         }
         if(len == 999)
         {
            return 0;
         }
         this._version = (this._version - int(this._version / 7) + 147 + len % 21 + cmdID % 13 + this.getCrc(bodyBytes)) % 256;
         return this._version;
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
      
      public function destroy() : void
      {
         Tick.instance.removeCallback(this.sendCmd);
         BC.removeEvent(this);
      }
   }
}

