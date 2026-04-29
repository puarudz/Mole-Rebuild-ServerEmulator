package com.view.LamuWorld
{
   import com.global.links.Links;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   
   public class UILamuWorld
   {
      
      private var app:ApplicationDomain;
      
      public var isComplete:Boolean = false;
      
      public function UILamuWorld()
      {
         super();
      }
      
      public function loadUI() : void
      {
         var req:URLRequest = new URLRequest(Links.getUrl("resource/ui/LamuWorldUI.swf"));
         var loader:Loader = new Loader();
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComplete);
         loader.load(req);
      }
      
      private function onComplete(event:Event) : void
      {
         this.isComplete = true;
         var info:LoaderInfo = event.currentTarget as LoaderInfo;
         info.removeEventListener(Event.COMPLETE,this.onComplete);
         info.removeEventListener(Event.COMPLETE,this.onComplete);
         this.app = info.applicationDomain;
         GV.onlineSocket.dispatchEvent(new Event("lamuComplete"));
      }
      
      public function getClass(str:String) : Class
      {
         return this.app.getDefinition(str) as Class;
      }
      
      public function getSprite(str:String) : Sprite
      {
         var cls:Class = this.app.getDefinition(str) as Class;
         return new cls() as Sprite;
      }
      
      public function getButton(str:String) : SimpleButton
      {
         var cls:Class = this.app.getDefinition(str) as Class;
         return new cls() as SimpleButton;
      }
      
      public function getBitmap(str:String) : Bitmap
      {
         var cls:Class = this.app.getDefinition(str) as Class;
         return new cls() as Bitmap;
      }
      
      public function getSound(str:String) : Sound
      {
         var cls:Class = this.app.getDefinition(str) as Class;
         return new cls() as Sound;
      }
   }
}

