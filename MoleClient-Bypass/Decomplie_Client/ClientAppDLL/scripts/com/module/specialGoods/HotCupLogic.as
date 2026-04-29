package com.module.specialGoods
{
   import com.core.MainManager;
   import com.core.loading.Loading;
   import com.core.newloader.MCLoader;
   import com.event.MCLoadEvent;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class HotCupLogic
   {
      
      private static const GOLD_CUP:int = 160795;
      
      private static const SILVER_CUP:int = 160796;
      
      private static const COPPER_CUP:int = 160797;
      
      private var _url:String;
      
      private var _UI:DisplayObject;
      
      public function HotCupLogic(itemID:int)
      {
         super();
         switch(itemID)
         {
            case GOLD_CUP:
               this._url = "resource/movie/hotCup_gold_cup.swf";
               break;
            case SILVER_CUP:
               this._url = "resource/movie/hotCup_silver_cup.swf";
               break;
            case COPPER_CUP:
               this._url = "resource/movie/hotCup_copper_cup.swf";
         }
         if(this._url != "")
         {
            this.init();
         }
      }
      
      public function ShowCup() : void
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
         var mcloader:MCLoader = new MCLoader(this._url,MainManager.getGameLevel(),Loading.TITLE_AND_PERCENT,"正在打開火神杯...");
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
         this.ShowCup();
         var mcloader:MCLoader = event.target as MCLoader;
         mcloader.clear();
      }
      
      public function removeHandler(e:Event) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeHandler);
      }
   }
}

