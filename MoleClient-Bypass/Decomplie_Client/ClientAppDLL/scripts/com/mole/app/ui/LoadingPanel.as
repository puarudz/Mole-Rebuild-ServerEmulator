package com.mole.app.ui
{
   import com.common.data.HashMap;
   import com.common.util.DisplayUtil;
   import com.core.MainManager;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.manager.LoadingManager;
   import flash.display.Sprite;
   import flash.events.ProgressEvent;
   
   public class LoadingPanel extends Sprite
   {
      
      private static var _isShow:Boolean;
      
      private static var _loadingPanel:LoadingPanel;
      
      setup();
      
      private var _resProHash:HashMap;
      
      private var _curCount:uint;
      
      private var _loading:LoadingBase;
      
      public function LoadingPanel()
      {
         super();
         this._resProHash = new HashMap();
         this._curCount = 0;
         this._loading = new PercentLoading(LoadingManager.getSprite("RES_TitleLoading"),"Loading...");
         addChild(this._loading);
         DownLoadManager.addEventListener(DownLoadEvent.OPEN,this.onLoaderOpen);
         DownLoadManager.addEventListener(DownLoadEvent.COMPLETE,this.onLoaderSucceed);
         DownLoadManager.addEventListener(DownLoadEvent.ERROR,this.onLoaderFail);
         DownLoadManager.addEventListener(DownLoadEvent.CANCEL,this.onLoaderFail);
         DownLoadManager.addEventListener(DownLoadEvent.PROGRESS,this.onLoaderProgress);
      }
      
      public static function setup() : void
      {
         _loadingPanel = new LoadingPanel();
         _isShow = false;
      }
      
      public static function show() : void
      {
         if(_isShow == false)
         {
            MainManager.getStage().addChild(_loadingPanel);
            _isShow = true;
         }
      }
      
      public static function hide() : void
      {
         if(_isShow)
         {
            DisplayUtil.removeForParent(_loadingPanel,false);
            _loadingPanel.initView();
            _isShow = false;
         }
      }
      
      public static function addRes(resID:uint) : void
      {
         _loadingPanel.addRes(resID);
         show();
      }
      
      public static function removeRes(resID:uint) : void
      {
         _loadingPanel.removeRes(resID);
      }
      
      public static function removeAll() : void
      {
         _loadingPanel.removeAll();
      }
      
      public static function set isShowClose(value:Boolean) : void
      {
         _loadingPanel.isShowClose = value;
      }
      
      public static function get isShowClose() : Boolean
      {
         return _loadingPanel.isShowClose;
      }
      
      private function onLoaderOpen(e:DownLoadEvent) : void
      {
         var resID:uint = e.resInfo.resId;
         if(this._resProHash.containsKey(resID))
         {
            this._loading.setTitle(e.resInfo.desc);
         }
      }
      
      private function onLoaderSucceed(e:DownLoadEvent) : void
      {
         this.checkOver(e.resInfo.resId);
      }
      
      private function onLoaderFail(e:DownLoadEvent) : void
      {
         this.checkOver(e.resInfo.resId);
      }
      
      private function onLoaderProgress(e:DownLoadEvent) : void
      {
         var progressEvent:ProgressEvent = null;
         var totalProNum:Number = NaN;
         var resProList:Array = null;
         var proNum:Number = NaN;
         var progressNum:Number = NaN;
         var bytes:Number = NaN;
         if(this._resProHash.containsKey(e.resInfo.resId))
         {
            progressEvent = e.data;
            this._resProHash.add(e.resInfo.resId,progressEvent.bytesLoaded / progressEvent.bytesTotal);
            totalProNum = 0;
            resProList = this._resProHash.values;
            for each(proNum in resProList)
            {
               totalProNum += proNum;
            }
            totalProNum += this._curCount - resProList.length;
            progressNum = totalProNum / this._curCount;
            bytes = progressNum * 1000;
            this._loading.changePercent(1000,bytes);
         }
      }
      
      private function initView() : void
      {
         this._loading.changePercent(1000,0);
         this.isShowClose = true;
      }
      
      private function checkOver(resID:uint) : void
      {
         this._resProHash.remove(resID);
         if(this._resProHash.length == 0)
         {
            this._curCount = 0;
            hide();
         }
      }
      
      public function addRes(resID:uint) : void
      {
         ++this._curCount;
         this._resProHash.add(resID,0);
      }
      
      public function removeRes(resID:uint) : void
      {
         this.checkOver(resID);
         DownLoadManager.remove(resID);
      }
      
      public function removeAll() : void
      {
         var resID:uint = 0;
         var keys:Array = this._resProHash.keys;
         while(Boolean(resID = keys.pop()))
         {
            DownLoadManager.remove(resID);
         }
         this._resProHash.clear();
         this._curCount = 0;
         hide();
      }
      
      public function get isShowClose() : Boolean
      {
         return this._loading.isShowClose;
      }
      
      public function set isShowClose(value:Boolean) : void
      {
         this._loading.isShowClose = value;
      }
   }
}

