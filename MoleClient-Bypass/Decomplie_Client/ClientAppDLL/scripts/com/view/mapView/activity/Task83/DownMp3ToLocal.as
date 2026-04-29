package com.view.mapView.activity.Task83
{
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.FileReference;
   import flash.net.URLRequest;
   
   public class DownMp3ToLocal
   {
      
      public static var instance:DownMp3ToLocal;
      
      private var downloadURL:URLRequest;
      
      private var fileName:String = "摩爾歡樂頌.mp3";
      
      private var file:FileReference;
      
      private var target_mc:*;
      
      public function DownMp3ToLocal()
      {
         super();
      }
      
      public static function getInstance() : DownMp3ToLocal
      {
         if(instance == null)
         {
            instance = new DownMp3ToLocal();
         }
         return instance;
      }
      
      public function addEventFun(_mc:*) : void
      {
         this.target_mc = _mc;
         BC.addEvent(this,this.target_mc,MouseEvent.CLICK,this.onMouseClick);
      }
      
      public function removeEventFun() : void
      {
         BC.removeEvent(this,this.target_mc,MouseEvent.CLICK,this.onMouseClick);
      }
      
      private function onMouseClick(e:MouseEvent) : void
      {
         this.onDownMusic();
      }
      
      public function onDownMusic() : void
      {
         this.downloadURL = new URLRequest();
         this.downloadURL.url = "http://mole.61.com/resource/soundLib/MolePark.mp3";
         this.file = new FileReference();
         this.configureListeners(this.file);
         this.file.download(this.downloadURL,this.fileName);
      }
      
      private function configureListeners(dispatcher:IEventDispatcher) : void
      {
         dispatcher.addEventListener(Event.CANCEL,this.cancelHandler);
         dispatcher.addEventListener(Event.COMPLETE,this.completeHandler);
         dispatcher.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         dispatcher.addEventListener(Event.OPEN,this.openHandler);
         dispatcher.addEventListener(ProgressEvent.PROGRESS,this.progressHandler);
         dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
         dispatcher.addEventListener(Event.SELECT,this.selectHandler);
      }
      
      private function cancelHandler(event:Event) : void
      {
         trace("cancelHandler: " + event);
      }
      
      private function completeHandler(event:Event) : void
      {
         trace("completeHandler: " + event);
      }
      
      private function ioErrorHandler(event:IOErrorEvent) : void
      {
         trace("ioErrorHandler: " + event);
      }
      
      private function openHandler(event:Event) : void
      {
         trace("openHandler: " + event);
      }
      
      private function progressHandler(event:ProgressEvent) : void
      {
         var file:FileReference = FileReference(event.target);
         trace("progressHandler name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
      }
      
      private function securityErrorHandler(event:SecurityErrorEvent) : void
      {
         trace("securityErrorHandler: " + event);
      }
      
      private function selectHandler(event:Event) : void
      {
         var file:FileReference = FileReference(event.target);
         trace("selectHandler: name=" + file.name + " URL=" + this.downloadURL.url);
      }
   }
}

