package com.common.byteLoader
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.net.URLStream;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.Timer;
   
   [Event(name="getByteData",type="ByteLoaderEvent")]
   [Event(name="getDataBegin",type="ByteLoaderEvent")]
   [Event(name="onTimeout",type="ByteLoaderEvent")]
   public class ByteLoader extends URLStream implements IDataInput, IByteLoader
   {
      
      protected var overtime:Timer;
      
      protected var cba:ByteArray;
      
      private var _timeoutDelay:uint;
      
      private var _checkTimeout:Boolean;
      
      private var _hasBreakTimeout:Boolean;
      
      private var c_Available:uint = 0;
      
      private var _timeoutCount:uint = 0;
      
      private var _reLoadCount:uint = 0;
      
      private var _bytesLoaded:uint = 0;
      
      private var _bytesTotal:uint = 0;
      
      private var _request:URLRequest;
      
      private var _urltag:String = "";
      
      private var startTimer:Number = 0;
      
      public function ByteLoader(checkTimeout:Boolean = false, timeoutDelay:uint = 15000)
      {
         this._checkTimeout = checkTimeout;
         this._timeoutDelay = timeoutDelay;
         super();
      }
      
      public function reTry(newtag:String = "") : void
      {
         this._urltag = newtag;
         this.close();
         this._hasBreakTimeout = false;
         ++this._reLoadCount;
         this.beginLoading();
      }
      
      override public function load(request:URLRequest) : void
      {
         if(!(Boolean(this._request) && Boolean(request) && this._request === request))
         {
            this._reLoadCount = 0;
         }
         this._urltag = "";
         this._request = request;
         this._timeoutCount = 0;
         this.beginLoading();
      }
      
      override public function get bytesAvailable() : uint
      {
         return this.cba.bytesAvailable;
      }
      
      protected function beginLoading() : void
      {
         this.cba = new ByteArray();
         this.c_Available = 0;
         this.addTimer();
         if(this._checkTimeout && Boolean(this.overtime))
         {
            this.overtime.start();
         }
         BC.addEvent(this,this,Event.COMPLETE,this.loadComplete);
         BC.addEvent(this,this,ProgressEvent.PROGRESS,this.getFileBytesTotal);
         BC.addEvent(this,this,ProgressEvent.PROGRESS,this.pushDataToByteArray);
         var temp_request:URLRequest = new URLRequest();
         temp_request.contentType = this._request.contentType;
         temp_request.data = this._request.data;
         temp_request.digest = this._request.digest;
         temp_request.method = this._request.method;
         temp_request.requestHeaders = this._request.requestHeaders;
         if(Boolean(this._urltag.length))
         {
            if(this._request.url.indexOf("?") == -1)
            {
               temp_request.url = this._request.url + "?" + this._urltag;
            }
            else
            {
               temp_request.url = this._request.url + "&" + this._urltag;
            }
         }
         else
         {
            temp_request.url = this._request.url;
         }
         super.load(temp_request);
         this.startTimer = new Date().time;
         dispatchEvent(new ByteLoaderEvent(ByteLoaderEvent.ON_START_LOAD));
      }
      
      public function loadComplete(e:Event) : void
      {
         BC.removeEvent(this);
         if(Boolean(this.overtime))
         {
            this.overtime.stop();
         }
         this.overtime = null;
      }
      
      override public function close() : void
      {
         super.close();
         BC.removeEvent(this);
         this.cba = new ByteArray();
         this.c_Available = 0;
         if(Boolean(this.overtime))
         {
            this.overtime.stop();
         }
         this.overtime = null;
      }
      
      public function getByteArray() : ByteArray
      {
         var tb:ByteArray = new ByteArray();
         tb.writeBytes(this.cba);
         tb.position = 0;
         return tb;
      }
      
      public function get hasBreakTimeout() : Boolean
      {
         return this._hasBreakTimeout;
      }
      
      public function get bytesLoaded() : uint
      {
         return this._bytesLoaded;
      }
      
      public function get bytesTotal() : uint
      {
         return this._bytesTotal;
      }
      
      public function get reTryCount() : uint
      {
         return this._reLoadCount;
      }
      
      public function get timeoutCount() : uint
      {
         return this._timeoutCount;
      }
      
      public function get delay() : uint
      {
         return this._timeoutDelay;
      }
      
      public function getURLRequest() : URLRequest
      {
         return this._request;
      }
      
      public function addCheckTimeout(timeoutDelay:uint = 15000) : void
      {
         this._checkTimeout = true;
         this._timeoutDelay = timeoutDelay;
      }
      
      private function checkIsTimeout(E:TimerEvent) : void
      {
         ++this._timeoutCount;
         dispatchEvent(new ByteLoaderEvent(ByteLoaderEvent.ON_TIME_OUT));
         if(this.c_Available != this._bytesLoaded)
         {
            this.c_Available = this._bytesLoaded;
         }
         else
         {
            this._hasBreakTimeout = true;
            dispatchEvent(new ByteLoaderEvent(ByteLoaderEvent.ON_BREAK_TIME_OUT));
         }
      }
      
      private function addTimer() : void
      {
         if(this._checkTimeout)
         {
            if(!this.overtime || Boolean(this.overtime) && Boolean(this.overtime.running))
            {
               this.overtime = new Timer(this._timeoutDelay,0);
               BC.addEvent(this,this.overtime,TimerEvent.TIMER,this.checkIsTimeout);
               BC.addEvent(this,this,Event.COMPLETE,this.onComplete);
               BC.addEvent(this,this,IOErrorEvent.IO_ERROR,this.onIoError);
            }
         }
      }
      
      private function onComplete(event:Event) : void
      {
         BC.removeEvent(this);
         if(Boolean(this.overtime))
         {
            this.overtime.stop();
         }
         this.overtime = null;
      }
      
      private function onIoError(E:IOErrorEvent) : void
      {
         BC.removeEvent(this);
         if(Boolean(this.overtime))
         {
            this.overtime.stop();
         }
         this.overtime = null;
         dispatchEvent(new ByteLoaderEvent(ByteLoaderEvent.ON_TIME_OUT));
      }
      
      private function getFileBytesTotal(E:ProgressEvent) : void
      {
         BC.removeEvent(this,this,ProgressEvent.PROGRESS,this.getFileBytesTotal);
         this._bytesLoaded = E.bytesLoaded;
         this._bytesTotal = E.bytesTotal;
         dispatchEvent(new ByteLoaderEvent(ByteLoaderEvent.GET_DATA_BEGIN));
      }
      
      private function pushDataToByteArray(E:ProgressEvent) : void
      {
         this._bytesLoaded = E.bytesLoaded;
         this._bytesTotal = E.bytesTotal;
         super.readBytes(this.cba,this.cba.length);
         dispatchEvent(new ByteLoaderEvent(ByteLoaderEvent.GET_BYTE_DATA));
      }
      
      override public function readBoolean() : Boolean
      {
         return this.cba.readBoolean();
      }
      
      override public function readByte() : int
      {
         return this.cba.readByte();
      }
      
      override public function readBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0) : void
      {
         this.cba.readBytes(bytes,offset,length);
      }
      
      override public function readDouble() : Number
      {
         return this.cba.readDouble();
      }
      
      override public function readFloat() : Number
      {
         return this.cba.readFloat();
      }
      
      override public function readInt() : int
      {
         return this.cba.readInt();
      }
      
      override public function readMultiByte(length:uint, charSet:String) : String
      {
         return this.cba.readMultiByte(length,charSet);
      }
      
      override public function readObject() : *
      {
         return this.cba.readObject();
      }
      
      override public function readShort() : int
      {
         return this.cba.readShort();
      }
      
      override public function readUnsignedByte() : uint
      {
         return this.cba.readUnsignedByte();
      }
      
      override public function readUnsignedInt() : uint
      {
         return this.cba.readUnsignedInt();
      }
      
      override public function readUnsignedShort() : uint
      {
         return this.cba.readUnsignedShort();
      }
      
      override public function readUTF() : String
      {
         return this.cba.readUTF();
      }
      
      override public function readUTFBytes(lenght:uint) : String
      {
         return this.cba.readUTFBytes(lenght);
      }
      
      public function get loadtimer() : Number
      {
         return new Date().time - this.startTimer;
      }
   }
}

