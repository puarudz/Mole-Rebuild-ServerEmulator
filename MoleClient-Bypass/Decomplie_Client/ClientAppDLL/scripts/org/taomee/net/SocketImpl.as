package org.taomee.net
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.ProgressEvent;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import org.taomee.net.tmf.HeadInfo;
   import org.taomee.net.tmf.TMF;
   
   [Event(name="error",type="flash.events.ErrorEvent")]
   public class SocketImpl extends Socket
   {
      
      public static var headClass:Class = HeadInfo;
      
      public static const PACKAGE_MAX:uint = 8388608;
      
      public static var headLength:uint = 18;
      
      public var userID:uint = 0;
      
      public var loggerFunc:Function = defTrace;
      
      public var resultFunc:Function = null;
      
      public var analyticsFunc:Function;
      
      private var _result:uint = 0;
      
      private var _packageLength:uint;
      
      private var _headInfo:HeadInfo;
      
      private var _dataLen:uint;
      
      private var _isGetHead:Boolean = true;
      
      private var _host:String;
      
      private var _port:int;
      
      private var _cmdDispatcher:EventDispatcher = new EventDispatcher();
      
      private var _errorDispatcher:EventDispatcher = new EventDispatcher();
      
      private var _blockSet:Dictionary = new Dictionary();
      
      private var _blockDataList:Array = [];
      
      private var _intermitSet:Dictionary = new Dictionary();
      
      public function SocketImpl(userID:uint = 0)
      {
         super();
         this.userID = userID;
      }
      
      private static function defTrace(type:String, commandID:uint, dataLength:int) : void
      {
         trace(type,commandID,dataLength);
      }
      
      public function dispose() : void
      {
         this._cmdDispatcher = null;
         this._errorDispatcher = null;
         this._headInfo = null;
         this.resultFunc = null;
         this.analyticsFunc = null;
         this.loggerFunc = null;
         this._blockSet = null;
         this._blockDataList = null;
         this._intermitSet = null;
      }
      
      private function get host() : String
      {
         return this._host;
      }
      
      private function get port() : int
      {
         return this._port;
      }
      
      public function send(commandID:uint, args:Array, endian:String = null) : void
      {
         var data:ByteArray = RequestPacker.createBody(args,endian);
         var length:uint = data.length + headLength;
         this.parseResult(commandID,length);
         writeBytes(RequestPacker.createHead(length,commandID,this.userID,this._result,endian));
         writeBytes(data);
         flush();
         this.parseAnalytics(commandID,1);
         this.parselogger(LoggerType.OUTPUT,commandID,data.length);
      }
      
      override public function connect(host:String, port:int) : void
      {
         this._result = 0;
         this._host = host;
         this._port = port;
         super.connect(host,port);
         addEventListener(ProgressEvent.SOCKET_DATA,this.onData);
         this.parselogger(LoggerType.CONNECT,0,0);
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
         this._result = 0;
      }
      
      public function blockCommand(commandID:uint) : void
      {
         this._blockSet[commandID] = true;
      }
      
      public function releaseCommand(commandID:uint) : void
      {
         var count:int = 0;
         var i:int = 0;
         var info:BlockInfo = null;
         if(commandID in this._blockSet)
         {
            delete this._blockSet[commandID];
            count = int(this._blockDataList.length);
            for(i = 0; i < count; i++)
            {
               info = this._blockDataList[i];
               if(Boolean(info))
               {
                  if(info.headInfo.commandID == commandID)
                  {
                     if(info.headInfo.error != 0)
                     {
                        this.outputError(info.headInfo);
                     }
                     else
                     {
                        this.outputCommand(info.headInfo,info.data);
                     }
                     this._blockDataList.splice(i,1);
                     i--;
                  }
               }
            }
         }
      }
      
      public function intermitCommand(commandID:uint) : void
      {
         this._intermitSet[commandID] = true;
      }
      
      public function restoreCommand(commandID:uint) : void
      {
         if(commandID in this._intermitSet)
         {
            delete this._intermitSet[commandID];
         }
      }
      
      public function addCommandListener(commandID:uint, listener:Function, useCapture:Boolean = false, priority:int = 0) : void
      {
         this._cmdDispatcher.addEventListener(commandID.toString(),listener,useCapture,priority);
      }
      
      public function removeCommandListener(commandID:uint, listener:Function, useCapture:Boolean = false) : void
      {
         this._cmdDispatcher.removeEventListener(commandID.toString(),listener,useCapture);
      }
      
      public function dispatchCommand(commandID:uint, headInfo:HeadInfo, data:Object = null) : Boolean
      {
         if(this._cmdDispatcher.hasEventListener(commandID.toString()))
         {
            return this._cmdDispatcher.dispatchEvent(new SocketEvent(commandID.toString(),headInfo,data));
         }
         return false;
      }
      
      public function hasCommandListener(commandID:uint) : Boolean
      {
         return this._cmdDispatcher.hasEventListener(commandID.toString());
      }
      
      public function addErrorListener(commandID:uint, listener:Function, useCapture:Boolean = false, priority:int = 0) : void
      {
         this._errorDispatcher.addEventListener(commandID.toString(),listener,useCapture,priority);
      }
      
      public function removeErrorListener(commandID:uint, listener:Function, useCapture:Boolean = false) : void
      {
         this._errorDispatcher.removeEventListener(commandID.toString(),listener,useCapture);
      }
      
      public function dispatchError(commandID:uint, headInfo:HeadInfo) : Boolean
      {
         if(this._errorDispatcher.hasEventListener(commandID.toString()))
         {
            return this._errorDispatcher.dispatchEvent(new SocketEvent(commandID.toString(),headInfo));
         }
         return false;
      }
      
      public function hasErrorListener(commandID:uint) : Boolean
      {
         return this._errorDispatcher.hasEventListener(commandID.toString());
      }
      
      private function parseAnalytics(commandID:uint, type:uint = 0) : void
      {
         if(this.analyticsFunc != null)
         {
            this.analyticsFunc(commandID,type);
         }
      }
      
      private function parseResult(commandID:uint, length:uint) : void
      {
         if(this.resultFunc != null)
         {
            this._result = this.resultFunc(commandID,length,this._result);
         }
         else
         {
            ++this._result;
         }
      }
      
      protected function parselogger(type:String, commandID:uint, dataLength:int) : void
      {
         if(this.loggerFunc != null)
         {
            this.loggerFunc(type,commandID,dataLength);
         }
      }
      
      private function outputError(headInfo:HeadInfo) : void
      {
         this.parseAnalytics(headInfo.commandID);
         this.dispatchError(headInfo.commandID,this._headInfo);
         dispatchEvent(new SocketEvent(SocketEvent.SOCKET_ERROR,headInfo));
      }
      
      protected function outputCommand(headInfo:HeadInfo, data:ByteArray = null) : void
      {
         var tmfClass:Class = null;
         if(data == null)
         {
            this.parseAnalytics(headInfo.commandID);
            this.dispatchCommand(headInfo.commandID,headInfo);
         }
         else
         {
            tmfClass = TMF.getClass(headInfo.commandID);
            this.parseAnalytics(headInfo.commandID);
            this.dispatchCommand(headInfo.commandID,headInfo,new tmfClass(data));
         }
      }
      
      private function parseIntermit(commandID:uint) : Boolean
      {
         if(commandID in this._intermitSet)
         {
            return true;
         }
         return false;
      }
      
      private function onData(event:Event) : void
      {
         var data:ByteArray = null;
         this.parselogger(LoggerType.DATA,0,0);
         while(bytesAvailable > 0)
         {
            if(this._isGetHead)
            {
               if(bytesAvailable < headLength)
               {
                  break;
               }
               this._packageLength = readUnsignedInt();
               if(this._packageLength < headLength || this._packageLength > PACKAGE_MAX)
               {
                  this.parseAnalytics(0);
                  dispatchEvent(new SocketEvent(SocketEvent.SOCKET_ERROR,null));
                  readBytes(new ByteArray());
                  return;
               }
               this._headInfo = new headClass(this);
               this._dataLen = this._packageLength - headLength;
               if(this.parseIntermit(this._headInfo.commandID))
               {
                  if(this._dataLen > 0)
                  {
                     this._isGetHead = false;
                  }
               }
               else if(this._headInfo.error != 0)
               {
                  if(this._headInfo.commandID in this._blockSet)
                  {
                     this._blockDataList.push(new BlockInfo(this._headInfo));
                  }
                  else
                  {
                     this.outputError(this._headInfo);
                  }
                  if(!connected)
                  {
                     break;
                  }
               }
               else
               {
                  this.parselogger(LoggerType.INPUT,this._headInfo.commandID,this._dataLen);
                  if(this._dataLen == 0)
                  {
                     if(this._headInfo.commandID in this._blockSet)
                     {
                        this._blockDataList.push(new BlockInfo(this._headInfo));
                     }
                     else
                     {
                        this.outputCommand(this._headInfo);
                     }
                     if(!connected)
                     {
                        break;
                     }
                  }
                  else
                  {
                     this._isGetHead = false;
                  }
               }
            }
            else
            {
               if(bytesAvailable < this._dataLen)
               {
                  break;
               }
               data = new ByteArray();
               data.endian = endian;
               readBytes(data,0,this._dataLen);
               this._isGetHead = true;
               if(!this.parseIntermit(this._headInfo.commandID))
               {
                  if(this._headInfo.commandID in this._blockSet)
                  {
                     this._blockDataList.push(new BlockInfo(this._headInfo,data));
                  }
                  else
                  {
                     this.outputCommand(this._headInfo,data);
                  }
                  if(!connected)
                  {
                     break;
                  }
               }
            }
         }
      }
   }
}

