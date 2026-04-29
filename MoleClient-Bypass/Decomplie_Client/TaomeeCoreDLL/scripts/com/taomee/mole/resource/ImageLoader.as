package com.taomee.mole.resource
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   
   public class ImageLoader extends RESLoader
   {
      
      private var _loader:Loader = new Loader();
      
      public function ImageLoader()
      {
         super();
      }
      
      override protected function startListener() : void
      {
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.complete);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
      }
      
      override protected function stopListener() : void
      {
         this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.complete);
         this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
      }
      
      override public function load(url:String, currentdomain:Boolean = false) : void
      {
         super.load(url);
         this._loader.load(new URLRequest(loadurl));
      }
      
      private function complete(event:Event) : void
      {
         this.stopListener();
         if(completeHandler != null)
         {
            completeHandler(this);
         }
      }
      
      private function ioErrorHandler(event:IOErrorEvent) : void
      {
         this.delayToLoad();
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

