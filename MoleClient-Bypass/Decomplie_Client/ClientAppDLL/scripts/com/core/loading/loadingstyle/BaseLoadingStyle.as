package com.core.loading.loadingstyle
{
   import com.common.util.DisplayUtil;
   import com.core.MainManager;
   import com.core.manager.LoadingManager;
   import com.event.LoadingEvent;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   
   [Event(name="closeLoading",type="com.event.LoadingEvent")]
   public class BaseLoadingStyle extends EventDispatcher implements ILoadingStyle
   {
      
      private static const KEY:String = "baseLoading";
      
      protected var _loadingMC:MovieClip;
      
      protected var _parentMC:DisplayObjectContainer;
      
      protected var _percent:Number;
      
      protected var _isShowCloseBtn:Boolean;
      
      private var _close_btn:InteractiveObject;
      
      public function BaseLoadingStyle(parentMC:DisplayObjectContainer = null, showCloseBtn:Boolean = false)
      {
         super();
         this._isShowCloseBtn = showCloseBtn;
         this._parentMC = parentMC;
         this._loadingMC = LoadingManager.getMovieClip(this.getKey());
         this._close_btn = this._loadingMC["close_btn"];
         this.initPosition();
         this.checkIsShowCloseBtn();
      }
      
      protected function initPosition() : void
      {
         var W:Number = NaN;
         var H:Number = NaN;
         if(this._parentMC == null)
         {
            this._parentMC = MainManager.getStage();
            W = MainManager.getStageWidth();
            H = MainManager.getStageHeight();
         }
         else
         {
            W = MainManager.getStageWidth();
            H = MainManager.getStageHeight();
         }
         this._loadingMC.x = (W - this._loadingMC.width) / 2;
         this._loadingMC.y = (H - this._loadingMC.height) / 2;
         this._parentMC.addChild(this._loadingMC);
      }
      
      protected function checkIsShowCloseBtn() : void
      {
         if(this._close_btn != null)
         {
            if(this._close_btn is Sprite)
            {
               Sprite(this._close_btn).buttonMode = true;
            }
            this._close_btn.visible = this._isShowCloseBtn;
            if(this._isShowCloseBtn)
            {
               this._close_btn.addEventListener(MouseEvent.CLICK,this.closeHandler);
            }
            else
            {
               this._close_btn.removeEventListener(MouseEvent.CLICK,this.closeHandler);
            }
         }
      }
      
      public function changePercent(total:Number, loaded:Number) : void
      {
         this._percent = Math.floor(loaded / total * 100);
      }
      
      private function closeHandler(event:MouseEvent) : void
      {
         this.close();
         dispatchEvent(new LoadingEvent(LoadingEvent.CLOSE_LOADING));
      }
      
      public function close() : void
      {
         if(this._close_btn != null)
         {
            this._close_btn.removeEventListener(MouseEvent.CLICK,this.closeHandler);
            this._close_btn = null;
         }
         var clsMoveTo:Class = ApplicationDomain.currentDomain.getDefinition("com.logic.FindPathLogic::MoveTo") as Class;
         if(Boolean(clsMoveTo))
         {
            clsMoveTo.CanMove = true;
         }
         DisplayUtil.removeForParent(this._loadingMC);
      }
      
      public function setIsShowCloseBtn(i:Boolean) : void
      {
         this._isShowCloseBtn = i;
         this.checkIsShowCloseBtn();
      }
      
      public function setTitle(str:String) : void
      {
      }
      
      protected function getKey() : String
      {
         return KEY;
      }
   }
}

