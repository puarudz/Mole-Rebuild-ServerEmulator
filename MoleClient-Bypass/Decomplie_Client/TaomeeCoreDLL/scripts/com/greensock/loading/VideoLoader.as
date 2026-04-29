package com.greensock.loading
{
   import com.greensock.events.LoaderEvent;
   import com.greensock.loading.core.LoaderItem;
   import com.greensock.loading.display.ContentDisplay;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.NetStatusEvent;
   import flash.events.ProgressEvent;
   import flash.events.TimerEvent;
   import flash.media.SoundTransform;
   import flash.media.Video;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import flash.net.URLRequest;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   [Event(name="netStatus",type="com.greensock.events.LoaderEvent")]
   [Event(name="httpStatus",type="com.greensock.events.LoaderEvent")]
   public class VideoLoader extends LoaderItem
   {
      
      private static var _classActivated:Boolean = _activateClass("VideoLoader",VideoLoader,"flv,f4v,mp4,mov");
      
      public static const VIDEO_COMPLETE:String = "videoComplete";
      
      public static const VIDEO_BUFFER_FULL:String = "videoBufferFull";
      
      public static const VIDEO_BUFFER_EMPTY:String = "videoBufferEmpty";
      
      public static const VIDEO_PAUSE:String = "videoPause";
      
      public static const VIDEO_PLAY:String = "videoPlay";
      
      public static const VIDEO_CUE_POINT:String = "videoCuePoint";
      
      public static const PLAY_PROGRESS:String = "playProgress";
      
      protected var _ns:NetStream;
      
      protected var _nc:NetConnection;
      
      protected var _auditNS:NetStream;
      
      protected var _video:Video;
      
      protected var _stageVideo:Object;
      
      protected var _sound:SoundTransform;
      
      protected var _videoPaused:Boolean;
      
      protected var _videoComplete:Boolean;
      
      protected var _forceTime:Number;
      
      protected var _duration:Number;
      
      protected var _pausePending:Boolean;
      
      protected var _volume:Number;
      
      protected var _sprite:Sprite;
      
      protected var _initted:Boolean;
      
      protected var _bufferMode:Boolean;
      
      protected var _repeatCount:uint;
      
      protected var _bufferFull:Boolean;
      
      protected var _dispatchPlayProgress:Boolean;
      
      protected var _prevTime:Number;
      
      protected var _prevCueTime:Number;
      
      protected var _firstCuePoint:CuePoint;
      
      protected var _renderedOnce:Boolean;
      
      protected var _renderTimer:Timer;
      
      protected var _autoDetachNetStream:Boolean;
      
      protected var _playStarted:Boolean;
      
      protected var _finalFrame:Boolean;
      
      public var metaData:Object;
      
      public var autoAdjustBuffer:Boolean;
      
      public function VideoLoader(urlOrRequest:*, vars:Object = null)
      {
         super(urlOrRequest,vars);
         _type = "VideoLoader";
         this._nc = new NetConnection();
         this._nc.connect(null);
         this._nc.addEventListener("asyncError",_failHandler,false,0,true);
         this._nc.addEventListener("securityError",_failHandler,false,0,true);
         this._renderTimer = new Timer(80,0);
         this._renderTimer.addEventListener(TimerEvent.TIMER,this._renderHandler,false,0,true);
         this._video = new Video(int(this.vars.width) || 320,int(this.vars.height) || 240);
         this._video.smoothing = Boolean(this.vars.smoothing != false);
         this._video.deblocking = uint(this.vars.deblocking);
         this._video.addEventListener(Event.ADDED_TO_STAGE,this._videoAddedToStage,false,0,true);
         this._video.addEventListener(Event.REMOVED_FROM_STAGE,this._videoRemovedFromStage,false,0,true);
         this._stageVideo = this.vars.stageVideo;
         this._autoDetachNetStream = Boolean(this.vars.autoDetachNetStream == true);
         this._refreshNetStream();
         this._duration = isNaN(this.vars.estimatedDuration) ? 200 : Number(this.vars.estimatedDuration);
         this._bufferMode = _preferEstimatedBytesInAudit = Boolean(this.vars.bufferMode == true);
         this._videoPaused = this._pausePending = Boolean(this.vars.autoPlay == false);
         this.autoAdjustBuffer = this.vars.autoAdjustBuffer != false;
         this.volume = "volume" in this.vars ? Number(this.vars.volume) : 1;
         if(LoaderMax.contentDisplayClass is Class)
         {
            this._sprite = new LoaderMax.contentDisplayClass(this);
            if(!this._sprite.hasOwnProperty("rawContent"))
            {
               throw new Error("LoaderMax.contentDisplayClass must be set to a class with a \'rawContent\' property, like com.greensock.loading.display.ContentDisplay");
            }
         }
         else
         {
            this._sprite = new ContentDisplay(this);
         }
         Object(this._sprite).rawContent = null;
      }
      
      protected function _refreshNetStream() : void
      {
         if(this._ns != null)
         {
            this._ns.pause();
            try
            {
               this._ns.close();
            }
            catch(error:Error)
            {
            }
            this._sprite.removeEventListener(Event.ENTER_FRAME,this._playProgressHandler);
            this._video.attachNetStream(null);
            this._video.clear();
            this._ns.client = {};
            this._ns.removeEventListener(NetStatusEvent.NET_STATUS,this._statusHandler);
            this._ns.removeEventListener("ioError",_failHandler);
            this._ns.removeEventListener("asyncError",_failHandler);
            this._ns.removeEventListener(Event.RENDER,this._renderHandler);
         }
         this._prevTime = this._prevCueTime = 0;
         this._ns = this.vars.netStream is NetStream ? this.vars.netStream : new NetStream(this._nc);
         this._ns.checkPolicyFile = Boolean(this.vars.checkPolicyFile == true);
         this._ns.client = {
            "onMetaData":this._metaDataHandler,
            "onCuePoint":this._cuePointHandler
         };
         this._ns.addEventListener(NetStatusEvent.NET_STATUS,this._statusHandler,false,0,true);
         this._ns.addEventListener("ioError",_failHandler,false,0,true);
         this._ns.addEventListener("asyncError",_failHandler,false,0,true);
         this._ns.bufferTime = isNaN(this.vars.bufferTime) ? 5 : Number(this.vars.bufferTime);
         if(this._stageVideo != null)
         {
            this._stageVideo.attachNetStream(this._ns);
         }
         else if(!this._autoDetachNetStream || this._video.stage != null)
         {
            this._video.attachNetStream(this._ns);
         }
         this._sound = this._ns.soundTransform;
      }
      
      override protected function _load() : void
      {
         var concatChar:String = null;
         _prepRequest();
         this._repeatCount = 0;
         this._prevTime = this._prevCueTime = 0;
         this._bufferFull = this._playStarted = this._renderedOnce = false;
         this.metaData = null;
         this._pausePending = this._videoPaused;
         if(this._videoPaused)
         {
            this._setForceTime(0);
            this._sound.volume = 0;
            this._ns.soundTransform = this._sound;
         }
         else
         {
            this.volume = this._volume;
         }
         this._sprite.addEventListener(Event.ENTER_FRAME,this._playProgressHandler);
         this._sprite.addEventListener(Event.ENTER_FRAME,this._loadingProgressCheck);
         this._waitForRender();
         this._videoComplete = this._initted = false;
         if(Boolean(this.vars.noCache) && (Boolean(!_isLocal || _url.substr(0,4) == "http")) && _request.data != null)
         {
            concatChar = _request.url.indexOf("?") != -1 ? "&" : "?";
            this._ns.play(_request.url + concatChar + _request.data.toString());
         }
         else
         {
            this._ns.play(_request.url);
         }
      }
      
      override protected function _dump(scrubLevel:int = 0, newStatus:int = 0, suppressEvents:Boolean = false) : void
      {
         if(this._sprite == null)
         {
            return;
         }
         this._sprite.removeEventListener(Event.ENTER_FRAME,this._loadingProgressCheck);
         this._sprite.removeEventListener(Event.ENTER_FRAME,this._playProgressHandler);
         this._sprite.removeEventListener(Event.ENTER_FRAME,this._detachNS);
         this._sprite.removeEventListener(Event.ENTER_FRAME,this._finalFrameFinished);
         this._ns.removeEventListener(Event.RENDER,this._renderHandler);
         this._renderTimer.stop();
         this._forceTime = NaN;
         this._prevTime = this._prevCueTime = 0;
         this._initted = false;
         this._renderedOnce = false;
         this._videoComplete = false;
         this.metaData = null;
         if(scrubLevel != 2)
         {
            this._refreshNetStream();
            (this._sprite as Object).rawContent = null;
            if(this._video.parent != null)
            {
               this._video.parent.removeChild(this._video);
            }
         }
         if(scrubLevel >= 2)
         {
            if(scrubLevel == 3)
            {
               (this._sprite as Object).dispose(false,false);
            }
            this._renderTimer.removeEventListener(TimerEvent.TIMER,this._renderHandler);
            this._nc.removeEventListener("asyncError",_failHandler);
            this._nc.removeEventListener("securityError",_failHandler);
            this._ns.removeEventListener(NetStatusEvent.NET_STATUS,this._statusHandler);
            this._ns.removeEventListener("ioError",_failHandler);
            this._ns.removeEventListener("asyncError",_failHandler);
            this._video.removeEventListener(Event.ADDED_TO_STAGE,this._videoAddedToStage);
            this._video.removeEventListener(Event.REMOVED_FROM_STAGE,this._videoRemovedFromStage);
            this._firstCuePoint = null;
            (this._sprite as Object).gcProtect = scrubLevel == 3 ? null : this._ns;
            this._ns.client = {};
            this._video = null;
            this._ns = null;
            this._nc = null;
            this._sound = null;
            (this._sprite as Object).loader = null;
            this._sprite = null;
            this._renderTimer = null;
         }
         else
         {
            this._duration = isNaN(this.vars.estimatedDuration) ? 200 : Number(this.vars.estimatedDuration);
            this._videoPaused = this._pausePending = Boolean(this.vars.autoPlay == false);
         }
         super._dump(scrubLevel,newStatus,suppressEvents);
      }
      
      public function setContentDisplay(contentDisplay:Sprite) : void
      {
         this._sprite = contentDisplay;
      }
      
      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         if(type == PLAY_PROGRESS)
         {
            this._dispatchPlayProgress = true;
         }
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      override protected function _calculateProgress() : void
      {
         _cachedBytesLoaded = this._ns.bytesLoaded;
         if(_cachedBytesLoaded > 1)
         {
            if(this._bufferMode)
            {
               _cachedBytesTotal = this._ns.bytesTotal * (this._ns.bufferTime / this._duration);
               if(this._ns.bufferLength > 0)
               {
                  _cachedBytesLoaded = this._ns.bufferLength / this._ns.bufferTime * _cachedBytesTotal;
               }
            }
            else
            {
               _cachedBytesTotal = this._ns.bytesTotal;
            }
            if(_cachedBytesTotal <= _cachedBytesLoaded)
            {
               _cachedBytesTotal = this.metaData != null && this._renderedOnce && this._initted || getTimer() - _time >= 10000 ? _cachedBytesLoaded : uint(int(1.01 * _cachedBytesLoaded) + 1);
            }
            if(!_auditedSize)
            {
               _auditedSize = true;
               dispatchEvent(new Event("auditedSize"));
            }
         }
         _cacheIsDirty = false;
      }
      
      public function addASCuePoint(time:Number, name:String = "", parameters:Object = null) : Object
      {
         var prev:CuePoint = this._firstCuePoint;
         if(prev != null && prev.time > time)
         {
            prev = null;
         }
         else
         {
            while(Boolean(prev && prev.time <= time) && Boolean(prev.next) && prev.next.time <= time)
            {
               prev = prev.next;
            }
         }
         var cp:CuePoint = new CuePoint(time,name,parameters,prev);
         if(prev == null)
         {
            if(this._firstCuePoint != null)
            {
               this._firstCuePoint.prev = cp;
               cp.next = this._firstCuePoint;
            }
            this._firstCuePoint = cp;
         }
         return cp;
      }
      
      public function removeASCuePoint(timeNameOrCuePoint:*) : Object
      {
         var cp:CuePoint = this._firstCuePoint;
         while(Boolean(cp))
         {
            if(cp == timeNameOrCuePoint || cp.time == timeNameOrCuePoint || cp.name == timeNameOrCuePoint)
            {
               if(Boolean(cp.next))
               {
                  cp.next.prev = cp.prev;
               }
               if(Boolean(cp.prev))
               {
                  cp.prev.next = cp.next;
               }
               else if(cp == this._firstCuePoint)
               {
                  this._firstCuePoint = cp.next;
               }
               cp.next = cp.prev = null;
               cp.gc = true;
               return cp;
            }
            cp = cp.next;
         }
         return null;
      }
      
      public function getCuePointTime(name:String) : Number
      {
         var i:int = 0;
         if(this.metaData != null && this.metaData.cuePoints is Array)
         {
            i = int(this.metaData.cuePoints.length);
            while(--i > -1)
            {
               if(name == this.metaData.cuePoints[i].name)
               {
                  return Number(this.metaData.cuePoints[i].time);
               }
            }
         }
         var cp:CuePoint = this._firstCuePoint;
         while(Boolean(cp))
         {
            if(cp.name == name)
            {
               return cp.time;
            }
            cp = cp.next;
         }
         return NaN;
      }
      
      public function gotoVideoCuePoint(name:String, forcePlay:Boolean = false, skipCuePoints:Boolean = true) : Number
      {
         return this.gotoVideoTime(this.getCuePointTime(name),forcePlay,skipCuePoints);
      }
      
      public function pauseVideo(event:Event = null) : void
      {
         this.videoPaused = true;
      }
      
      public function playVideo(event:Event = null) : void
      {
         this.videoPaused = false;
      }
      
      public function gotoVideoTime(time:Number, forcePlay:Boolean = false, skipCuePoints:Boolean = true) : Number
      {
         if(isNaN(time) || this._ns == null)
         {
            return NaN;
         }
         if(time > this._duration)
         {
            time = this._duration;
         }
         var changed:Boolean = time != this.videoTime;
         if(this._initted && this._renderedOnce && changed && !this._finalFrame)
         {
            this._seek(time);
         }
         else
         {
            this._setForceTime(time);
         }
         this._videoComplete = false;
         if(changed)
         {
            if(skipCuePoints)
            {
               this._prevCueTime = time;
            }
            else
            {
               this._playProgressHandler(null);
            }
         }
         if(forcePlay)
         {
            this.playVideo();
         }
         return time;
      }
      
      public function clearVideo() : void
      {
         this._video.smoothing = false;
         this._video.clear();
         this._video.smoothing = this.vars.smoothing != false;
         this._video.clear();
      }
      
      protected function _seek(time:Number) : void
      {
         this._ns.seek(time);
         this._setForceTime(time);
         if(this._bufferFull)
         {
            this._bufferFull = false;
            dispatchEvent(new LoaderEvent(VIDEO_BUFFER_EMPTY,this));
         }
      }
      
      protected function _setForceTime(time:Number) : void
      {
         if(!(this._forceTime || this._forceTime == 0))
         {
            this._waitForRender();
         }
         this._forceTime = time;
      }
      
      protected function _waitForRender() : void
      {
         this._ns.addEventListener(Event.RENDER,this._renderHandler,false,0,true);
         this._renderTimer.reset();
         this._renderTimer.start();
      }
      
      protected function _onBufferFull() : void
      {
         if(!this._renderedOnce && !this._renderTimer.running)
         {
            this._waitForRender();
            return;
         }
         if(this._pausePending)
         {
            if(!this._initted && getTimer() - _time < 10000)
            {
               this._video.attachNetStream(null);
            }
            else if(this._renderedOnce)
            {
               this._applyPendingPause();
            }
         }
         else if(!this._bufferFull)
         {
            this._bufferFull = true;
            dispatchEvent(new LoaderEvent(VIDEO_BUFFER_FULL,this));
         }
      }
      
      protected function _applyPendingPause() : void
      {
         this._pausePending = false;
         this.volume = this._volume;
         this._seek(this._forceTime || 0);
         if(this._stageVideo != null)
         {
            this._stageVideo.attachNetStream(this._ns);
            this._ns.pause();
         }
         else if(!this._autoDetachNetStream || this._video.stage != null)
         {
            this._video.cacheAsBitmap = false;
            this._video.attachNetStream(this._ns);
            this._ns.pause();
         }
      }
      
      protected function _forceInit() : void
      {
         if(this._ns.bufferTime >= this._duration)
         {
            this._ns.bufferTime = uint(this._duration - 1);
         }
         this._initted = true;
         if(!this._bufferFull && this._ns.bufferLength >= this._ns.bufferTime)
         {
            this._onBufferFull();
         }
         Object(this._sprite).rawContent = this._video;
         if(!this._bufferFull && this._pausePending && this._renderedOnce && this._video.stage != null)
         {
            this._video.attachNetStream(null);
         }
         else if(this._stageVideo != null)
         {
            this._stageVideo.attachNetStream(this._ns);
         }
         else if(!this._autoDetachNetStream || this._video.stage != null)
         {
            this._video.attachNetStream(this._ns);
         }
      }
      
      protected function _metaDataHandler(info:Object) : void
      {
         if(this.metaData == null || this.metaData.cuePoints == null)
         {
            this.metaData = info;
         }
         this._duration = info.duration;
         if("width" in info)
         {
            this._video.width = Number(info.width);
            this._video.height = Number(info.height);
         }
         if("framerate" in info)
         {
            this._renderTimer.delay = int(1000 / Number(info.framerate) + 1);
         }
         if(!this._initted)
         {
            this._forceInit();
         }
         else
         {
            (this._sprite as Object).rawContent = this._video;
         }
         dispatchEvent(new LoaderEvent(LoaderEvent.INIT,this,"",info));
      }
      
      protected function _cuePointHandler(info:Object) : void
      {
         if(!this._videoPaused)
         {
            dispatchEvent(new LoaderEvent(VIDEO_CUE_POINT,this,"",info));
         }
      }
      
      protected function _playProgressHandler(event:Event) : void
      {
         var prevTime:Number = NaN;
         var prevCueTime:Number = NaN;
         var next:CuePoint = null;
         var cp:CuePoint = null;
         if(!this._bufferFull && !this._videoComplete && (this._ns.bufferLength >= this._ns.bufferTime || this.duration - this.videoTime - this._ns.bufferLength < 0.1))
         {
            this._onBufferFull();
         }
         if(this._bufferFull && (Boolean(this._firstCuePoint) || Boolean(this._dispatchPlayProgress)))
         {
            prevTime = this._prevTime;
            prevCueTime = this._prevCueTime;
            this._prevTime = this._prevCueTime = (Boolean(this._forceTime) || Boolean(this._forceTime == 0)) && this._ns.time <= this._duration ? this._ns.time : this.videoTime;
            cp = this._firstCuePoint;
            while(Boolean(cp))
            {
               next = cp.next;
               if(cp.time > prevCueTime && cp.time <= this._prevCueTime && !cp.gc)
               {
                  dispatchEvent(new LoaderEvent(VIDEO_CUE_POINT,this,"",cp));
               }
               cp = next;
            }
            if(this._dispatchPlayProgress && prevTime != this._prevTime)
            {
               dispatchEvent(new LoaderEvent(PLAY_PROGRESS,this));
            }
         }
      }
      
      protected function _statusHandler(event:NetStatusEvent) : void
      {
         var videoRemaining:Number = NaN;
         var prevBufferMode:Boolean = false;
         var prog:Number = NaN;
         var loadRemaining:Number = NaN;
         var revisedBufferTime:Number = NaN;
         var code:String = event.info.code;
         if(code == "NetStream.Play.Start" && !this._playStarted)
         {
            this._playStarted = true;
            if(!this._pausePending)
            {
               dispatchEvent(new LoaderEvent(VIDEO_PLAY,this));
            }
         }
         dispatchEvent(new LoaderEvent(NetStatusEvent.NET_STATUS,this,code,event.info));
         if(code == "NetStream.Play.Stop")
         {
            if(this._videoPaused)
            {
               return;
            }
            this._finalFrame = true;
            this._sprite.addEventListener(Event.ENTER_FRAME,this._finalFrameFinished,false,100,true);
            if(this.vars.repeat == -1 || uint(this.vars.repeat) > this._repeatCount)
            {
               ++this._repeatCount;
               dispatchEvent(new LoaderEvent(VIDEO_COMPLETE,this));
               this.gotoVideoTime(0,!this._videoPaused,true);
            }
            else
            {
               this._videoComplete = true;
               this.videoPaused = true;
               this._playProgressHandler(null);
               dispatchEvent(new LoaderEvent(VIDEO_COMPLETE,this));
            }
         }
         else if(code == "NetStream.Buffer.Full")
         {
            this._onBufferFull();
         }
         else if(code == "NetStream.Seek.Notify")
         {
            if(!this._autoDetachNetStream && !isNaN(this._forceTime))
            {
               this._renderHandler(null);
            }
         }
         else if(code == "NetStream.Seek.InvalidTime" && "details" in event.info)
         {
            this._seek(event.info.details);
         }
         else if(code == "NetStream.Buffer.Empty" && !this._videoComplete)
         {
            videoRemaining = this.duration - this.videoTime;
            prevBufferMode = this._bufferMode;
            this._bufferMode = false;
            _cacheIsDirty = true;
            prog = this.progress;
            this._bufferMode = prevBufferMode;
            _cacheIsDirty = true;
            if(prog == 1)
            {
               return;
            }
            loadRemaining = 1 / prog * this.loadTime;
            revisedBufferTime = videoRemaining * (1 - videoRemaining / loadRemaining) * 0.9;
            if(this.autoAdjustBuffer && loadRemaining > videoRemaining)
            {
               this._ns.bufferTime = revisedBufferTime;
            }
            this._bufferFull = false;
            dispatchEvent(new LoaderEvent(VIDEO_BUFFER_EMPTY,this));
         }
         else if(code == "NetStream.Play.StreamNotFound" || code == "NetConnection.Connect.Failed" || code == "NetStream.Play.Failed" || code == "NetStream.Play.FileStructureInvalid" || code == "The MP4 doesn\'t contain any supported tracks")
         {
            _failHandler(new LoaderEvent(LoaderEvent.ERROR,this,code));
         }
      }
      
      protected function _finalFrameFinished(event:Event) : void
      {
         this._sprite.removeEventListener(Event.ENTER_FRAME,this._finalFrameFinished);
         this._finalFrame = false;
         if(!isNaN(this._forceTime))
         {
            this._seek(this._forceTime);
         }
      }
      
      protected function _loadingProgressCheck(event:Event) : void
      {
         var bl:uint = _cachedBytesLoaded;
         var bt:uint = _cachedBytesTotal;
         if(!this._bufferFull && this._ns.bufferLength >= this._ns.bufferTime)
         {
            this._onBufferFull();
         }
         this._calculateProgress();
         if(_cachedBytesLoaded == _cachedBytesTotal)
         {
            this._sprite.removeEventListener(Event.ENTER_FRAME,this._loadingProgressCheck);
            if(!this._bufferFull)
            {
               this._onBufferFull();
            }
            if(!this._initted)
            {
               this._forceInit();
               _errorHandler(new LoaderEvent(LoaderEvent.ERROR,this,"No metaData was received."));
            }
            _completeHandler(event);
         }
         else if(_dispatchProgress && _cachedBytesLoaded / _cachedBytesTotal != bl / bt)
         {
            dispatchEvent(new LoaderEvent(LoaderEvent.PROGRESS,this));
         }
      }
      
      override public function auditSize() : void
      {
         var request:URLRequest = null;
         if(_url.substr(0,4) == "http" && _url.indexOf("://") != -1)
         {
            super.auditSize();
         }
         else if(this._auditNS == null)
         {
            this._auditNS = new NetStream(this._nc);
            this._auditNS.bufferTime = isNaN(this.vars.bufferTime) ? 5 : Number(this.vars.bufferTime);
            this._auditNS.client = {
               "onMetaData":this._auditHandler,
               "onCuePoint":this._auditHandler
            };
            this._auditNS.addEventListener(NetStatusEvent.NET_STATUS,this._auditHandler,false,0,true);
            this._auditNS.addEventListener("ioError",this._auditHandler,false,0,true);
            this._auditNS.addEventListener("asyncError",this._auditHandler,false,0,true);
            this._auditNS.soundTransform = new SoundTransform(0);
            request = new URLRequest();
            request.data = _request.data;
            _setRequestURL(request,_url,!_isLocal || _url.substr(0,4) == "http" ? "gsCacheBusterID=" + _cacheID++ + "&purpose=audit" : "");
            this._auditNS.play(request.url);
         }
      }
      
      protected function _auditHandler(event:Event = null) : void
      {
         var request:URLRequest = null;
         var type:String = event == null ? "" : event.type;
         var code:String = event == null || !(event is NetStatusEvent) ? "" : NetStatusEvent(event).info.code;
         if(event != null && "duration" in event)
         {
            this._duration = Object(event).duration;
         }
         if(this._auditNS != null)
         {
            _cachedBytesTotal = this._auditNS.bytesTotal;
            if(this._bufferMode && this._duration != 0)
            {
               _cachedBytesTotal *= this._auditNS.bufferTime / this._duration;
            }
         }
         if(type == "ioError" || type == "asyncError" || code == "NetStream.Play.StreamNotFound" || code == "NetConnection.Connect.Failed" || code == "NetStream.Play.Failed" || code == "NetStream.Play.FileStructureInvalid" || code == "The MP4 doesn\'t contain any supported tracks")
         {
            if(this.vars.alternateURL != undefined && this.vars.alternateURL != "" && this.vars.alternateURL != _url)
            {
               _errorHandler(new LoaderEvent(LoaderEvent.ERROR,this,code));
               if(_status != LoaderStatus.DISPOSED)
               {
                  _url = this.vars.alternateURL;
                  _setRequestURL(_request,_url);
                  request = new URLRequest();
                  request.data = _request.data;
                  _setRequestURL(request,_url,!_isLocal || _url.substr(0,4) == "http" ? "gsCacheBusterID=" + _cacheID++ + "&purpose=audit" : "");
                  this._auditNS.play(request.url);
               }
               return;
            }
            super._failHandler(new LoaderEvent(LoaderEvent.ERROR,this,code));
         }
         _auditedSize = true;
         this._closeStream();
         dispatchEvent(new Event("auditedSize"));
      }
      
      override protected function _closeStream() : void
      {
         if(this._auditNS != null)
         {
            this._auditNS.client = {};
            this._auditNS.removeEventListener(NetStatusEvent.NET_STATUS,this._auditHandler);
            this._auditNS.removeEventListener("ioError",this._auditHandler);
            this._auditNS.removeEventListener("asyncError",this._auditHandler);
            this._auditNS.pause();
            try
            {
               this._auditNS.close();
            }
            catch(error:Error)
            {
            }
            this._auditNS = null;
         }
         else
         {
            super._closeStream();
         }
      }
      
      override protected function _auditStreamHandler(event:Event) : void
      {
         if(event is ProgressEvent && this._bufferMode)
         {
            (event as ProgressEvent).bytesTotal *= this._ns.bufferTime / this._duration;
         }
         super._auditStreamHandler(event);
      }
      
      protected function _renderHandler(event:Event) : void
      {
         this._renderedOnce = true;
         if(!this._videoPaused || this._initted)
         {
            if(!this._finalFrame)
            {
               this._forceTime = NaN;
               this._renderTimer.stop();
               this._ns.removeEventListener(Event.RENDER,this._renderHandler);
            }
         }
         if(this._pausePending)
         {
            if(this._bufferFull)
            {
               this._applyPendingPause();
            }
            else if(this._video.stage != null)
            {
               this._sprite.addEventListener(Event.ENTER_FRAME,this._detachNS,false,100,true);
            }
         }
         else if(this._videoPaused && this._initted)
         {
            this._ns.pause();
         }
      }
      
      private function _detachNS(event:Event) : void
      {
         this._sprite.removeEventListener(Event.ENTER_FRAME,this._detachNS);
         if(!this._bufferFull && this._pausePending)
         {
            this._video.attachNetStream(null);
         }
      }
      
      protected function _videoAddedToStage(event:Event) : void
      {
         if(this._autoDetachNetStream)
         {
            if(!this._pausePending)
            {
               this._seek(this.videoTime);
            }
            if(this._stageVideo != null)
            {
               this._stageVideo.attachNetStream(this._ns);
            }
            else
            {
               this._video.attachNetStream(this._ns);
            }
         }
      }
      
      protected function _videoRemovedFromStage(event:Event) : void
      {
         if(this._autoDetachNetStream)
         {
            this._video.attachNetStream(null);
            this._video.clear();
         }
      }
      
      override public function get content() : *
      {
         return this._sprite;
      }
      
      public function get rawContent() : Video
      {
         return this._video;
      }
      
      public function get netStream() : NetStream
      {
         return this._ns;
      }
      
      public function get videoPaused() : Boolean
      {
         return this._videoPaused;
      }
      
      public function set videoPaused(value:Boolean) : void
      {
         var changed:Boolean = Boolean(value != this._videoPaused);
         this._videoPaused = value;
         if(this._videoPaused)
         {
            if(!this._renderedOnce)
            {
               this._setForceTime(0);
               this._pausePending = true;
               this._sound.volume = 0;
               this._ns.soundTransform = this._sound;
            }
            else
            {
               this._pausePending = false;
               this.volume = this._volume;
               this._ns.pause();
            }
            if(changed)
            {
               dispatchEvent(new LoaderEvent(VIDEO_PAUSE,this));
            }
         }
         else
         {
            if(this._pausePending || !this._bufferFull)
            {
               if(this._stageVideo != null)
               {
                  this._stageVideo.attachNetStream(this._ns);
               }
               else if(this._video.stage != null)
               {
                  this._video.attachNetStream(this._ns);
               }
               if(this._initted && this._renderedOnce)
               {
                  this._seek(this.videoTime);
               }
               this._pausePending = false;
            }
            this.volume = this._volume;
            this._ns.resume();
            if(changed && this._playStarted)
            {
               dispatchEvent(new LoaderEvent(VIDEO_PLAY,this));
            }
         }
      }
      
      public function get bufferProgress() : Number
      {
         if(uint(this._ns.bytesTotal) < 5)
         {
            return 0;
         }
         return this._ns.bufferLength > this._ns.bufferTime ? 1 : this._ns.bufferLength / this._ns.bufferTime;
      }
      
      public function get playProgress() : Number
      {
         return this._videoComplete ? 1 : this.videoTime / this._duration;
      }
      
      public function set playProgress(value:Number) : void
      {
         if(this._duration != 0)
         {
            this.gotoVideoTime(value * this._duration,!this._videoPaused,true);
         }
      }
      
      public function get volume() : Number
      {
         return this._volume;
      }
      
      public function set volume(value:Number) : void
      {
         this._sound.volume = this._volume = value;
         this._ns.soundTransform = this._sound;
      }
      
      public function get videoTime() : Number
      {
         if(Boolean(this._forceTime) || this._forceTime == 0)
         {
            return this._forceTime;
         }
         if(this._videoComplete)
         {
            return this._duration;
         }
         if(this._ns.time > this._duration)
         {
            return this._duration * 0.995;
         }
         return this._ns.time;
      }
      
      public function set videoTime(value:Number) : void
      {
         this.gotoVideoTime(value,!this._videoPaused,true);
      }
      
      public function get duration() : Number
      {
         return this._duration;
      }
      
      public function get bufferMode() : Boolean
      {
         return this._bufferMode;
      }
      
      public function set bufferMode(value:Boolean) : void
      {
         this._bufferMode = value;
         _preferEstimatedBytesInAudit = this._bufferMode;
         this._calculateProgress();
         if(_cachedBytesLoaded < _cachedBytesTotal && _status == LoaderStatus.COMPLETED)
         {
            _status = LoaderStatus.LOADING;
            this._sprite.addEventListener(Event.ENTER_FRAME,this._loadingProgressCheck);
         }
      }
      
      public function get autoDetachNetStream() : Boolean
      {
         return this._autoDetachNetStream;
      }
      
      public function set autoDetachNetStream(value:Boolean) : void
      {
         this._autoDetachNetStream = value;
         if(this._autoDetachNetStream && this._video.stage == null)
         {
            this._video.attachNetStream(null);
            this._video.clear();
         }
         else if(this._stageVideo != null)
         {
            this._stageVideo.attachNetStream(this._ns);
         }
         else
         {
            this._video.attachNetStream(this._ns);
         }
      }
      
      public function get stageVideo() : Object
      {
         return this._stageVideo;
      }
      
      public function set stageVideo(value:Object) : void
      {
         if(this._stageVideo != value)
         {
            this._stageVideo = value;
            if(this._stageVideo != null)
            {
               this._stageVideo.attachNetStream(this._ns);
               this._video.clear();
            }
            else
            {
               this._video.attachNetStream(this._ns);
            }
         }
      }
   }
}

class CuePoint
{
   
   public var next:CuePoint;
   
   public var prev:CuePoint;
   
   public var time:Number;
   
   public var name:String;
   
   public var parameters:Object;
   
   public var gc:Boolean;
   
   public function CuePoint(time:Number, name:String, params:Object, prev:CuePoint)
   {
      super();
      this.time = time;
      this.name = name;
      this.parameters = params;
      if(Boolean(prev))
      {
         this.prev = prev;
         if(Boolean(prev.next))
         {
            prev.next.prev = this;
            this.next = prev.next;
         }
         prev.next = this;
      }
   }
}
