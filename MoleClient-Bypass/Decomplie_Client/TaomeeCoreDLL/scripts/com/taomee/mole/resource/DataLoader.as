package com.taomee.mole.resource
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   
   public class DataLoader extends RESLoader
   {
      
      private var _urlloader:URLLoader = new URLLoader();
      
      public function DataLoader()
      {
         super();
         this._urlloader.dataFormat = URLLoaderDataFormat.BINARY;
      }
      
      override protected function startListener() : void
      {
         this._urlloader.addEventListener(Event.COMPLETE,this.complete);
         this._urlloader.addEventListener(ProgressEvent.PROGRESS,this.progress);
         this._urlloader.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         this._urlloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
      }
      
      override protected function stopListener() : void
      {
         this._urlloader.removeEventListener(Event.COMPLETE,this.complete);
         this._urlloader.removeEventListener(ProgressEvent.PROGRESS,this.progress);
         this._urlloader.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         this._urlloader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
      }
      
      override public function load(url:String, currentdomain:Boolean = false) : void
      {
         super.load(url);
         this._urlloader.load(new URLRequest(loadurl));
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
      
      override protected function delayToLoad() : void
      {
         this._urlloader.close();
         super.delayToLoad();
      }
      
      override public function get data() : *
      {
         return this._urlloader.data;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this._urlloader = null;
      }
   }
}

