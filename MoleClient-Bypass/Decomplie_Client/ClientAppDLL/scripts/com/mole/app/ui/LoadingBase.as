package com.mole.app.ui
{
   import com.common.util.DisplayUtil;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   
   [Event(name="closeLoading",type="com.event.LoadingEvent")]
   public class LoadingBase extends Sprite
   {
      
      protected var _loading_mc:DisplayObject;
      
      protected var _percent:Number;
      
      protected var _isShowClose:Boolean;
      
      private var _close_btn:InteractiveObject;
      
      protected var _title_txt:TextField;
      
      protected var _title:String = "";
      
      public function LoadingBase(loading_mc:DisplayObject, title:String)
      {
         super();
         this._loading_mc = loading_mc;
         this._close_btn = this._loading_mc["close_btn"];
         this._title_txt = this._loading_mc["content_txt"];
         this.init();
      }
      
      protected function init() : void
      {
         this.setTitle(this._title);
         addChild(this._loading_mc);
         this.isShowClose = true;
      }
      
      public function changePercent(total:Number, loaded:Number) : void
      {
         this._percent = loaded / total;
      }
      
      private function onClose(event:MouseEvent) : void
      {
         LoadingPanel.removeAll();
      }
      
      public function close() : void
      {
         var clsMoveTo:Class = ApplicationDomain.currentDomain.getDefinition("com.logic.FindPathLogic::MoveTo") as Class;
         if(Boolean(clsMoveTo))
         {
            clsMoveTo.CanMove = true;
         }
         if(this._close_btn != null)
         {
            this._close_btn.removeEventListener(MouseEvent.CLICK,this.onClose);
         }
         DisplayUtil.removeForParent(this);
         LoadingPanel.removeAll();
      }
      
      public function setTitle(str:String) : void
      {
         this._title = str;
         this._title_txt.text = this._title;
      }
      
      public function get isShowClose() : Boolean
      {
         return this._isShowClose;
      }
      
      public function set isShowClose(value:Boolean) : void
      {
         this._isShowClose = value;
         if(this._isShowClose)
         {
            this._close_btn.addEventListener(MouseEvent.CLICK,this.onClose);
         }
         else
         {
            this._close_btn.visible = false;
         }
      }
   }
}

