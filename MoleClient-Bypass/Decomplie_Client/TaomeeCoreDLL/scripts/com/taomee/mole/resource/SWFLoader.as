package com.taomee.mole.resource
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class SWFLoader extends RESLoader
   {
      
      private var _loader:Loader;
      
      public function SWFLoader()
      {
         super();
      }
      
      override protected function startListener() : void
      {
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.complete);
         this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.progress);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
      }
      
      override protected function stopListener() : void
      {
         this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.complete);
         this._loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.progress);
         this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
      }
      
      override public function load(url:String, currentdomain:Boolean = false) : void
      {
         if(!this._loader)
         {
            this._loader = new Loader();
         }
         super.load(url,currentdomain);
         var context:LoaderContext = new LoaderContext(false,_currentdomain ? ApplicationDomain.currentDomain : null);
         this._loader.load(new URLRequest(loadurl),context);
      }
      
      private function complete(event:Event) : void
      {
         this.stopListener();
         if(completeHandler != null)
         {
            completeHandler(this);
         }
      }
      
      private function progress(event:ProgressEvent) : void
      {
         var percent:int = 0;
         if(progressHandler != null)
         {
            percent = Math.floor(event.bytesLoaded * 100 / event.bytesTotal);
            percent = Math.min(100,percent);
            progressHandler(percent);
         }
      }
      
      private function securityErrorHandler(event:SecurityErrorEvent) : void
      {
         this.delayToLoad();
      }
      
      private function ioErrorHandler(event:IOErrorEvent) : void
      {
         this.delayToLoad();
      }
      
      override public function clear() : void
      {
         super.clear();
         this._loader.unload();
         this._loader = null;
      }
      
      override protected function delayToLoad() : void
      {
         this._loader.unload();
         super.delayToLoad();
      }
      
      override public function get data() : *
      {
         return this._loader.content;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this._loader = null;
      }
   }
}

