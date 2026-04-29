package com.core.newloader
{
   import com.common.util.DisplayUtil;
   import com.core.loading.Loading;
   import com.core.loading.loadingstyle.ILoadingStyle;
   import com.event.LoadingEvent;
   import com.event.MCLoadEvent;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.utils.getDefinitionByName;
   
   public class MCLoader extends BaseMCLoader
   {
      
      public static var ON_USER_CLOSE_LOADER:String = "ON_USER_CLOSE_LOADER";
      
      private var _loadingView:ILoadingStyle;
      
      private var _autoCloseLoading:Boolean;
      
      public function MCLoader(url:String, parentMC:DisplayObjectContainer, loadingStyle:int = 1, loadingTitle:String = "", autoCloseLoading:Boolean = true, isCurrentApp:Boolean = false)
      {
         super(url,parentMC,isCurrentApp);
         var Statistics:Class = getDefinitionByName("com.view.mapView.activity.Task83.StatisticsClass") as Class;
         Statistics["getInstance"]().init(0,"http://g.cn.miaozhen.com/x.gif?k=1001445&p=3xdTs0&rt=2&o=");
         this._autoCloseLoading = autoCloseLoading;
         this._loadingView = Loading.getLoadingStyle(loadingStyle,loadingTitle);
         this.initEvent();
      }
      
      public static function LoadModule(url:String, msg:String, parent:*, loadOkFun:Function = null) : void
      {
         var mapMC:MovieClip = null;
         var loader:MCLoader = null;
         if(!parent.getChildByName(url) && !GV.isChangeMap)
         {
            mapMC = new MovieClip();
            mapMC.name = url;
            parent.addChild(mapMC);
            var _temp_3:* = loader;
            var _temp_2:* = MCLoadEvent.ON_SUCCESS;
            with({})
            {
               
               _temp_3.addEventListener(_temp_2,function h(e:MCLoadEvent):void
               {
                  loader.removeEventListener(MCLoadEvent.ON_SUCCESS,arguments.callee);
                  loader.clear();
                  var mainMC:DisplayObjectContainer = e.getParent();
                  DisplayUtil.removeAllChild(mainMC);
                  var childMC:Loader = e.getLoader();
                  mainMC.addChild(childMC);
                  if(loadOkFun != null)
                  {
                     loadOkFun(childMC.content);
                  }
               });
               loader.load();
            }
         }
         
         override public function initEvent() : void
         {
            _contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onLoadProgress);
            this._loadingView.addEventListener(LoadingEvent.CLOSE_LOADING,this.loadingCloseHandler);
         }
         
         private function onLoadProgress(event:ProgressEvent) : void
         {
            var total:Number = event.bytesTotal;
            var loaded:Number = event.bytesLoaded;
            this._loadingView.changePercent(total,loaded);
         }
         
         private function loadingCloseHandler(event:LoadingEvent) : void
         {
            this._loadingView.removeEventListener(LoadingEvent.CLOSE_LOADING,this.loadingCloseHandler);
            this.clear();
            this.dispatchEvent(new Event(ON_USER_CLOSE_LOADER));
         }
         
         override public function clear() : void
         {
            if(Boolean(this._loadingView))
            {
               if(this._autoCloseLoading)
               {
                  this._loadingView.close();
               }
               this._loadingView.removeEventListener(LoadingEvent.CLOSE_LOADING,this.loadingCloseHandler);
            }
            _contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onLoadProgress);
            super.clear();
         }
         
         override public function setParentMC(i:DisplayObjectContainer) : void
         {
            if(!i)
            {
               throw new Error("MCLoader類的target參數不能為空！");
            }
            super.setParentMC(i);
         }
         
         public function getLoadingStyle() : ILoadingStyle
         {
            return this._loadingView;
         }
         
         public function get loadingView() : ILoadingStyle
         {
            return this._loadingView;
         }
         
         public function getLoader() : Loader
         {
            return _loader;
         }
      }
   }
   
   