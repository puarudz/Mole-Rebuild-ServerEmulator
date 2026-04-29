package com.module.specialGoods
{
   import com.core.MainManager;
   import com.core.loading.Loading;
   import com.core.newloader.MCLoader;
   import com.event.MCLoadEvent;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class HanqinBook
   {
      
      public static const ITEM_ID:int = 160814;
      
      private var _url:String = "resource/movie/hanqinBook.swf";
      
      private var _UI:DisplayObject;
      
      public function HanqinBook()
      {
         super();
         this.init();
      }
      
      public function ShowBook() : void
      {
         MainManager.getAppLevel().addChild(this._UI);
      }
      
      private function init() : void
      {
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeHandler);
         this.loadUI();
      }
      
      private function loadUI() : void
      {
         var mcloader:MCLoader = new MCLoader(this._url,MainManager.getGameLevel(),Loading.TITLE_AND_PERCENT,"正在打開漢青莊園遊記...");
         mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadSucc);
         mcloader.addEventListener(MCLoadEvent.ERROR,this.loadErr);
         mcloader.doLoad();
      }
      
      private function loadErr(event:MCLoadEvent) : void
      {
         trace(this + " 加載出錯");
      }
      
      private function loadSucc(event:MCLoadEvent) : void
      {
         this._UI = event.getContent();
         this.ShowBook();
         var mcloader:MCLoader = event.target as MCLoader;
         mcloader.clear();
      }
      
      public function removeHandler(e:Event) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeHandler);
         if(Boolean(this._UI.parent))
         {
            this._UI.parent.removeChild(this._UI);
         }
      }
   }
}

