package com.module.loadExtentPanel
{
   import com.common.util.DisplayUtil;
   import com.core.loading.Loading;
   import com.core.loading.loadingstyle.ILoadingStyle;
   import com.core.newloader.MCLoader;
   import com.event.LoadingEvent;
   import com.event.MCLoadEvent;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class LoadPanel extends EventDispatcher
   {
      
      protected static var SEND_MSG:String = "send_msg";
      
      private var _url:String;
      
      private var _loadTips:String;
      
      protected var _parentCon:Sprite;
      
      protected var _curLoader:Loader;
      
      private var _mcLoader:MCLoader;
      
      public var panle:MovieClip;
      
      protected var _sandType:uint = 0;
      
      private var _loadingView:ILoadingStyle;
      
      public function LoadPanel(url:String, descTips:String, parent_mc:Sprite, type:uint = 1002)
      {
         super();
         this._url = url;
         this._parentCon = parent_mc;
         this._loadTips = descTips;
         this._sandType = type;
         this.loadUI();
      }
      
      private function loadUI() : void
      {
         if(this._sandType != 0)
         {
            BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.closeHandler);
         }
         this.panle = new MovieClip();
         this.panle.name = "panle";
         BC.addEvent(this,this.panle,Event.REMOVED_FROM_STAGE,this.closeHandler);
         this._parentCon.addChild(this.panle);
         this._mcLoader = new MCLoader(this._url,this.panle,Loading.TITLE_AND_PERCENT,this._loadTips);
         BC.addEvent(this,this._mcLoader,MCLoadEvent.ON_SUCCESS,this.loadPassHandler);
         this._mcLoader.doLoad();
         this._loadingView = this._mcLoader.loadingView;
         if(Boolean(this._loadingView))
         {
            this._loadingView.addEventListener(LoadingEvent.CLOSE_LOADING,this.closeHandler);
         }
      }
      
      private function loadPassHandler(evt:MCLoadEvent) : void
      {
         BC.removeEvent(this,this._mcLoader,MCLoadEvent.ON_SUCCESS,this.loadPassHandler);
         this._mcLoader.clear();
         var mainMC:DisplayObjectContainer = evt.getParent();
         this._curLoader = evt.getLoader();
         mainMC.addChild(this._curLoader);
         this._curLoader.content.addEventListener(Event.CLOSE,this.closeHandler);
         this.otherBtnEvent();
      }
      
      protected function otherBtnEvent() : void
      {
      }
      
      protected function closeHandler(evt:Event) : void
      {
         this.destroy();
      }
      
      public function destroy() : void
      {
         this._loadingView = this._mcLoader.loadingView;
         if(Boolean(this._loadingView))
         {
            this._loadingView.removeEventListener(LoadingEvent.CLOSE_LOADING,this.closeHandler);
         }
         this._curLoader.content.removeEventListener(Event.CLOSE,this.closeHandler);
         BC.removeEvent(this);
         DisplayUtil.removeForParent(this.panle);
      }
   }
}

