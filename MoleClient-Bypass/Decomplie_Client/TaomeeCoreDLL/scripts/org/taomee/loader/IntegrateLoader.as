package org.taomee.loader
{
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.media.Sound;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   internal class IntegrateLoader extends EventDispatcher
   {
      
      private var _info:QueueInfo;
      
      private var _urlLoader:URLLoader;
      
      private var _loader:Loader;
      
      private var _sound:Sound;
      
      private var _module:AirLoader;
      
      public function IntegrateLoader()
      {
         super();
      }
      
      public function dispose() : void
      {
         this.close();
         if(Boolean(this._urlLoader))
         {
            this._urlLoader.removeEventListener(Event.OPEN,this.onOpen);
            this._urlLoader.removeEventListener(Event.COMPLETE,this.onComplete);
            this._urlLoader.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this._urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
            this._urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
         }
         if(Boolean(this._loader))
         {
            this._loader.contentLoaderInfo.removeEventListener(Event.OPEN,this.onOpen);
            this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
            this._loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
         }
         if(Boolean(this._module))
         {
            this._module.removeEventListener(Event.OPEN,this.onOpen);
            this._module.removeEventListener(Event.COMPLETE,this.onComplete);
            this._module.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this._module.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
            this._module.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
            this._module.dispose();
         }
         this._urlLoader = null;
         this._loader = null;
         this._sound = null;
         this._module = null;
      }
      
      public function get info() : QueueInfo
      {
         return this._info;
      }
      
      public function load(info:QueueInfo) : void
      {
         this._info = info;
         switch(this._info.type)
         {
            case LoadType.BINARY:
            case LoadType.TEXT:
               this.getURLLoader().dataFormat = this._info.type;
               this.getURLLoader().load(new URLRequest(this._info.url));
               break;
            case LoadType.DLL:
               this.getLoader().load(new URLRequest(this._info.url),new LoaderContext(false,ApplicationDomain.currentDomain));
               break;
            case LoadType.SWF:
            case LoadType.DOMAIN:
            case LoadType.IMAGE:
               this.getLoader().load(new URLRequest(this._info.url));
               break;
            case LoadType.SOUND:
               this.getSound().load(new URLRequest(this._info.url));
               break;
            case LoadType.MODULE:
               this.getModule().load(new URLRequest(this._info.url));
               break;
            default:
               return;
         }
      }
      
      public function close() : void
      {
         if(Boolean(this._info))
         {
            switch(this._info.type)
            {
               case LoadType.BINARY:
               case LoadType.TEXT:
                  this.closeURLLoader();
                  break;
               case LoadType.DLL:
               case LoadType.SWF:
               case LoadType.DOMAIN:
               case LoadType.IMAGE:
                  this.closeLoader();
                  break;
               case LoadType.SOUND:
                  this.closeSound();
               case LoadType.MODULE:
                  this.closeModule();
            }
         }
         this._info = null;
      }
      
      private function getURLLoader() : URLLoader
      {
         if(this._urlLoader == null)
         {
            this._urlLoader = new URLLoader();
            this._urlLoader.addEventListener(Event.OPEN,this.onOpen);
            this._urlLoader.addEventListener(Event.COMPLETE,this.onComplete);
            this._urlLoader.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this._urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
            this._urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
         }
         return this._urlLoader;
      }
      
      private function getLoader() : Loader
      {
         if(this._loader == null)
         {
            this._loader = new Loader();
            this._loader.contentLoaderInfo.addEventListener(Event.OPEN,this.onOpen);
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComplete);
            this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
         }
         return this._loader;
      }
      
      private function getSound() : Sound
      {
         this.closeSound();
         this._sound = new Sound();
         this._sound.addEventListener(Event.OPEN,this.onOpen);
         this._sound.addEventListener(Event.COMPLETE,this.onComplete);
         this._sound.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
         this._sound.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
         return this._sound;
      }
      
      private function getModule() : AirLoader
      {
         if(this._module == null)
         {
            this._module = new AirLoader();
            this._module.addEventListener(Event.OPEN,this.onOpen);
            this._module.addEventListener(Event.COMPLETE,this.onComplete);
            this._module.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this._module.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
            this._module.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
         }
         return this._module;
      }
      
      private function closeURLLoader() : void
      {
         if(Boolean(this._urlLoader))
         {
            try
            {
               this._urlLoader.close();
            }
            catch(e:Error)
            {
            }
         }
      }
      
      private function closeLoader() : void
      {
         if(Boolean(this._loader))
         {
            this._loader.unload();
            try
            {
               this._loader.close();
            }
            catch(e:Error)
            {
            }
         }
      }
      
      private function closeSound() : void
      {
         if(Boolean(this._sound))
         {
            this._sound.removeEventListener(Event.OPEN,this.onOpen);
            this._sound.removeEventListener(Event.COMPLETE,this.onComplete);
            this._sound.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this._sound.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
            try
            {
               this._sound.close();
            }
            catch(e:Error)
            {
            }
            this._sound = null;
         }
      }
      
      private function closeModule() : void
      {
         if(Boolean(this._module))
         {
            this._module.unload();
            try
            {
               this._module.close();
            }
            catch(e:Error)
            {
            }
         }
      }
      
      private function onOpen(event:Event) : void
      {
         dispatchEvent(event);
      }
      
      private function onComplete(event:Event) : void
      {
         if(this._info == null)
         {
            return;
         }
         switch(this._info.type)
         {
            case LoadType.BINARY:
            case LoadType.TEXT:
               dispatchEvent(new IntegrateLoaderEvent(IntegrateLoaderEvent.COMPLETE,this._info.url,this._urlLoader.data));
               break;
            case LoadType.DLL:
               dispatchEvent(new IntegrateLoaderEvent(IntegrateLoaderEvent.COMPLETE,this._info.url,null,this._loader.contentLoaderInfo.applicationDomain));
               break;
            case LoadType.SWF:
               dispatchEvent(new IntegrateLoaderEvent(IntegrateLoaderEvent.COMPLETE,this._info.url,this._loader.content,this._loader.contentLoaderInfo.applicationDomain));
               break;
            case LoadType.DOMAIN:
               dispatchEvent(new IntegrateLoaderEvent(IntegrateLoaderEvent.COMPLETE,this._info.url,this._loader.contentLoaderInfo.applicationDomain,this._loader.contentLoaderInfo.applicationDomain));
               break;
            case LoadType.IMAGE:
               dispatchEvent(new IntegrateLoaderEvent(IntegrateLoaderEvent.COMPLETE,this._info.url,Bitmap(this._loader.content).bitmapData,this._loader.contentLoaderInfo.applicationDomain));
               break;
            case LoadType.SOUND:
               dispatchEvent(new IntegrateLoaderEvent(IntegrateLoaderEvent.COMPLETE,this._info.url,this._sound));
               break;
            case LoadType.MODULE:
               dispatchEvent(new IntegrateLoaderEvent(IntegrateLoaderEvent.COMPLETE,this._info.url,this._module.content));
         }
      }
      
      private function onProgress(event:ProgressEvent) : void
      {
         dispatchEvent(event);
      }
      
      private function onError(event:ErrorEvent) : void
      {
         dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
      }
   }
}

