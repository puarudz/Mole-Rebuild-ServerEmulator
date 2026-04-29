package com.core.download
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.utils.Timer;
   
   public class ResLoader extends EventDispatcher
   {
      
      private var _resInfo:ResLoadInfo;
      
      private var _urlLoader:URLLoader;
      
      private var _loader:Loader;
      
      private var _delayTimer:Timer;
      
      public function ResLoader()
      {
         super();
         this._delayTimer = new Timer(10000,1);
         this._delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onDelayOver);
      }
      
      private function onDelayOver(e:TimerEvent) : void
      {
         dispatchEvent(new DownLoadEvent(DownLoadEvent.ERROR,this._resInfo));
      }
      
      public function get resInfo() : ResLoadInfo
      {
         return this._resInfo;
      }
      
      public function load(resInfo:ResLoadInfo) : void
      {
         var context:LoaderContext = null;
         this._resInfo = resInfo;
         var urlReq:URLRequest = VL.getURLRequest(this._resInfo.url);
         if(this._resInfo.type == ResType.DISPLAY_OBJECT || this._resInfo.type == ResType.BITMAP)
         {
            context = new LoaderContext(false,this._resInfo.appDomain);
            this._loader = new Loader();
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onDataLoaded);
            this._loader.contentLoaderInfo.addEventListener(Event.OPEN,this.onDataOpen);
            this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onDataProgress);
            this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onDataSecurityError);
            this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onDataFailed);
            this._loader.load(urlReq,context);
         }
         else if(this._resInfo.type == ResType.STRING)
         {
            this._urlLoader = new URLLoader();
            this._urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
            this._urlLoader.addEventListener(Event.OPEN,this.onDataOpen);
            this._urlLoader.addEventListener(Event.COMPLETE,this.onDataLoaded);
            this._urlLoader.addEventListener(ProgressEvent.PROGRESS,this.onDataProgress);
            this._urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onDataSecurityError);
            this._urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onDataFailed);
            this._urlLoader.load(urlReq);
         }
      }
      
      private function onDataOpen(e:Event) : void
      {
         dispatchEvent(new DownLoadEvent(DownLoadEvent.OPEN,this._resInfo,null,this._loader));
      }
      
      private function onDataLoaded(e:Event) : void
      {
         switch(this._resInfo.type)
         {
            case ResType.STRING:
               dispatchEvent(new DownLoadEvent(DownLoadEvent.COMPLETE,this._resInfo,this._urlLoader.data));
               break;
            case ResType.DISPLAY_OBJECT:
            case ResType.BITMAP:
               dispatchEvent(new DownLoadEvent(DownLoadEvent.COMPLETE,this._resInfo,this._loader.content,this._loader));
         }
      }
      
      public function destroy() : void
      {
         if(Boolean(this._urlLoader))
         {
            this._urlLoader.removeEventListener(Event.OPEN,this.onDataOpen);
            this._urlLoader.removeEventListener(Event.COMPLETE,this.onDataLoaded);
            this._urlLoader.removeEventListener(ProgressEvent.PROGRESS,this.onDataProgress);
            this._urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onDataSecurityError);
            this._urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onDataFailed);
            this._urlLoader.close();
            this._urlLoader = null;
         }
         if(Boolean(this._loader))
         {
            this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onDataLoaded);
            this._loader.contentLoaderInfo.removeEventListener(Event.OPEN,this.onDataOpen);
            this._loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onDataProgress);
            this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onDataSecurityError);
            this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onDataFailed);
         }
         if(Boolean(this._delayTimer))
         {
            this._delayTimer.stop();
            this._delayTimer = null;
         }
         this._resInfo = null;
      }
      
      private function onDataProgress(e:ProgressEvent) : void
      {
         dispatchEvent(new DownLoadEvent(DownLoadEvent.PROGRESS,this._resInfo,e));
      }
      
      private function onDataSecurityError(e:SecurityErrorEvent) : void
      {
         dispatchEvent(new DownLoadEvent(DownLoadEvent.ERROR,this._resInfo));
      }
      
      private function onDataFailed(e:IOErrorEvent) : void
      {
         dispatchEvent(new DownLoadEvent(DownLoadEvent.ERROR,this._resInfo));
      }
   }
}

