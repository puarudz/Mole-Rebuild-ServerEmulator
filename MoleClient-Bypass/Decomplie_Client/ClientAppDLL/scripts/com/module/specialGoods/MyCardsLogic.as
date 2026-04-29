package com.module.specialGoods
{
   import com.core.MainManager;
   import com.core.newloader.MCLoader;
   import com.event.MCLoadEvent;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.events.Event;
   
   public class MyCardsLogic
   {
      
      private var mcloader:MCLoader;
      
      public function MyCardsLogic()
      {
         super();
         this.init();
      }
      
      public function init() : void
      {
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeHandler);
         this.loadUI();
      }
      
      private function loadUI() : void
      {
         this.mcloader = new MCLoader("module/external/MyCards.swf",MainManager.getGameLevel(),1,"正在打開騎士卡牌冊...");
         this.mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadSucc);
         this.mcloader.addEventListener(MCLoadEvent.ERROR,this.loadErr);
         this.mcloader.doLoad();
      }
      
      private function loadErr(event:MCLoadEvent) : void
      {
         trace("加載出錯");
      }
      
      private function loadSucc(event:MCLoadEvent) : void
      {
         var a:DisplayObjectContainer = event.getParent();
         var b:Loader = event.getLoader();
         var c:DisplayObject = event.getContent();
         MainManager.getAppLevel().addChild(c);
         trace("loadSucc",c.name);
         var mcloader:MCLoader = event.target as MCLoader;
         mcloader.clear();
      }
      
      public function removeHandler(e:Event) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeHandler);
      }
   }
}

