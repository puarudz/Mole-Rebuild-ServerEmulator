package com.mole.app.ui
{
   import flash.display.SimpleButton;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.taomee.events.DynamicEvent;
   
   [Event(name="click",type="flash.events.MouseEvent")]
   public class UIPageBar extends EventDispatcher
   {
      
      public static const PAGE_NO:int = 0;
      
      public static const PAGE_PRE:int = 1;
      
      public static const PAGE_NEXT:int = 2;
      
      public static const PAGE_ALL:int = 3;
      
      protected var _preBtn:SimpleButton;
      
      protected var _nextBtn:SimpleButton;
      
      protected var _txt:TextField;
      
      protected var _index:uint;
      
      protected var _pageLength:uint;
      
      protected var _totalLength:uint;
      
      protected var _totalPage:uint;
      
      public function UIPageBar(preBtn:SimpleButton, nextBtn:SimpleButton, txt:TextField, max:uint)
      {
         super();
         this._preBtn = preBtn;
         this._nextBtn = nextBtn;
         this._txt = txt;
         this._pageLength = max;
         this._txt.mouseEnabled = false;
         this._preBtn.addEventListener(MouseEvent.CLICK,this.onPre);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.onNext);
         this._totalPage = 1;
         this.setPageState();
      }
      
      public function set pageLength(v:uint) : void
      {
         this._pageLength = v;
         this.init();
      }
      
      public function get pageLength() : uint
      {
         return this._pageLength;
      }
      
      public function set totalLength(v:uint) : void
      {
         this._totalLength = v;
         this.init();
      }
      
      public function get totalLength() : uint
      {
         return this._totalLength;
      }
      
      public function get index() : uint
      {
         return this._index;
      }
      
      public function set index(v:uint) : void
      {
         this._index = v;
         this.init();
      }
      
      public function get totalPage() : uint
      {
         return this._totalPage;
      }
      
      public function destroy() : void
      {
         this._preBtn.removeEventListener(MouseEvent.CLICK,this.onPre);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.onNext);
         this._preBtn = null;
         this._nextBtn = null;
         this._txt = null;
      }
      
      protected function init() : void
      {
         if(this._pageLength < this._totalLength)
         {
            this._totalPage = Math.ceil(this._totalLength / this._pageLength);
         }
         else
         {
            this._totalPage = 1;
         }
         this._index = Math.min(this._index,this._totalPage);
         this.setPageState();
      }
      
      private function onPre(e:MouseEvent) : void
      {
         --this._index;
         this.setPageState();
      }
      
      private function onNext(e:MouseEvent) : void
      {
         ++this._index;
         this.setPageState();
      }
      
      protected function setPageState() : void
      {
         if(this.index <= 0)
         {
            this.setBtnView(this._preBtn,false);
         }
         else
         {
            this.setBtnView(this._preBtn,true);
         }
         if(this.index >= this._totalPage - 1)
         {
            this.setBtnView(this._nextBtn,false);
         }
         else
         {
            this.setBtnView(this._nextBtn,true);
         }
         this._txt.text = this._index + 1 + "/" + this._totalPage;
         dispatchEvent(new DynamicEvent(MouseEvent.CLICK,this._index));
      }
      
      protected function setBtnView(btn:SimpleButton, enable:Boolean) : void
      {
         if(enable)
         {
            btn.mouseEnabled = true;
            btn.alpha = 1;
         }
         else
         {
            btn.mouseEnabled = false;
            btn.alpha = 0.4;
         }
      }
   }
}

