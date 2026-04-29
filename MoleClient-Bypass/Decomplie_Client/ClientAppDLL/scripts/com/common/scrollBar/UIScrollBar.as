package com.common.scrollBar
{
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class UIScrollBar extends EventDispatcher
   {
      
      private var _thumb:Sprite;
      
      private var _track:InteractiveObject;
      
      private var _upBtn:InteractiveObject;
      
      private var _downBtn:InteractiveObject;
      
      private var _wheelObject:InteractiveObject;
      
      private var _scrollRect:Rectangle;
      
      private var _pageSize:int;
      
      private var _per:Number = 0;
      
      private var _scrollPosition:int = 0;
      
      private var _maxScrollPosition:int = 0;
      
      private var _pageScrollSize:uint = 1;
      
      private var _upNum:Number = 0;
      
      private var _downNum:Number = 0;
      
      public function UIScrollBar(ui:DisplayObjectContainer)
      {
         super();
         this._thumb = ui["ScrollThumb"];
         this._track = ui["ScrollTrack"];
         this._upBtn = ui["ScrollArrowUp_Button"];
         this._downBtn = ui["ScrollArrowDown_Button"];
         if(Boolean(this._upBtn))
         {
            this._upNum = this._upBtn.height;
            this._upBtn.x = this._track.x + (this._track.width - this._upBtn.width) / 2;
            this._upBtn.y = this._track.y;
            this._upBtn.mouseEnabled = false;
         }
         if(Boolean(this._downBtn))
         {
            this._downNum = this._downBtn.height;
            this._downBtn.x = this._track.x + (this._track.width - this._downBtn.width) / 2;
            this._downBtn.y = this._track.y + this._track.height - this._downBtn.height;
            this._downBtn.mouseEnabled = false;
         }
         this.upDateScroll();
         this._thumb.buttonMode = true;
         this._thumb.mouseEnabled = false;
         this._thumb.x = this._scrollRect.x;
         this._thumb.y = this._scrollRect.y;
         this._thumb.visible = false;
      }
      
      public function get pageSize() : int
      {
         return this._pageSize;
      }
      
      public function set pageSize(value:int) : void
      {
         this._pageSize = value;
      }
      
      public function get pageScrollSize() : int
      {
         return this._pageScrollSize;
      }
      
      public function set pageScrollSize(value:int) : void
      {
         this._pageScrollSize = value;
      }
      
      public function get scrollPosition() : int
      {
         return this._scrollPosition;
      }
      
      public function set scrollPosition(value:int) : void
      {
         if(value < 0 || value > this._maxScrollPosition)
         {
            return;
         }
         this._scrollPosition = value;
         this._thumb.y = this._scrollPosition * this._per + this._scrollRect.y;
         dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE));
      }
      
      public function get maxScrollPosition() : int
      {
         return this._maxScrollPosition;
      }
      
      public function set maxScrollPosition(value:int) : void
      {
         this._maxScrollPosition = value;
         this._thumb.y = this._scrollRect.y;
         this._scrollPosition = 0;
         if(value > this._pageSize)
         {
            this._thumb.mouseEnabled = true;
            this._thumb.visible = true;
            this._per = this._scrollRect.height / (value - this._pageSize);
            this._thumb.addEventListener(MouseEvent.MOUSE_DOWN,this.onBarBlockDown);
            this._track.addEventListener(MouseEvent.MOUSE_DOWN,this.onBackDown);
            if(Boolean(this._wheelObject))
            {
               this._wheelObject.addEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel);
            }
            if(Boolean(this._upBtn))
            {
               this._upBtn.mouseEnabled = true;
               this._upBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onUpDown);
            }
            if(Boolean(this._downBtn))
            {
               this._downBtn.mouseEnabled = true;
               this._downBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onDownDown);
            }
         }
         else
         {
            this._thumb.mouseEnabled = false;
            this._thumb.visible = false;
            this._thumb.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBarBlockDown);
            this._track.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBackDown);
            if(Boolean(this._wheelObject))
            {
               this._wheelObject.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel);
            }
            if(Boolean(this._upBtn))
            {
               this._upBtn.mouseEnabled = false;
               this._upBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onUpDown);
               if(Boolean(this._upBtn.stage))
               {
                  this._upBtn.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onUpUp);
               }
            }
            if(Boolean(this._downBtn))
            {
               this._downBtn.mouseEnabled = false;
               this._downBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDownDown);
               if(Boolean(this._downBtn.stage))
               {
                  this._downBtn.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onDownUp);
               }
            }
         }
      }
      
      public function set wheelObject(o:InteractiveObject) : void
      {
         this._wheelObject = o;
         if(this._thumb.mouseEnabled)
         {
            this._wheelObject.addEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel);
         }
      }
      
      public function get wheelObject() : InteractiveObject
      {
         return this._wheelObject;
      }
      
      public function setScrollProperties(pageSize:int, maxScrollPosition:int, pageScrollSize:int = 1) : void
      {
         this._pageSize = pageSize;
         this.maxScrollPosition = maxScrollPosition;
         this._pageScrollSize = pageScrollSize;
      }
      
      public function destroy() : void
      {
         this._thumb.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBarBlockDown);
         this._track.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBackDown);
         if(Boolean(this._wheelObject))
         {
            this._wheelObject.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel);
            this._wheelObject = null;
         }
         if(Boolean(this._upBtn))
         {
            this._upBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onUpDown);
            if(Boolean(this._upBtn.stage))
            {
               this._upBtn.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onUpUp);
            }
            this._upBtn = null;
         }
         if(Boolean(this._downBtn))
         {
            this._downBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDownDown);
            if(Boolean(this._downBtn.stage))
            {
               this._downBtn.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onDownUp);
            }
            this._downBtn = null;
         }
         this._thumb = null;
         this._track = null;
         this._scrollRect = null;
      }
      
      private function upDateScroll() : void
      {
         this._scrollRect = new Rectangle(this._track.x - (this._thumb.width - this._track.width) / 2,this._track.y + this._upNum,0,this._track.height - this._thumb.height - this._upNum - this._downNum);
      }
      
      private function onBarBlockDown(e:MouseEvent) : void
      {
         this._thumb.startDrag(false,this._scrollRect);
         this._thumb.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onBarBlockMove);
         this._thumb.stage.addEventListener(MouseEvent.MOUSE_UP,this.onBarBlockUp);
         this._thumb.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBarBlockDown);
      }
      
      private function onBarBlockMove(e:MouseEvent) : void
      {
         if(this._thumb.y < this._scrollRect.y)
         {
            this._thumb.y = this._scrollRect.y;
         }
         if(this._thumb.y > this._scrollRect.bottom)
         {
            this._thumb.y = this._scrollRect.bottom;
         }
         var index:int = Math.round((this._thumb.y - this._scrollRect.y) / this._per);
         if(index < 0)
         {
            index = 0;
         }
         if(Math.ceil(index / this._pageScrollSize) != this._scrollPosition)
         {
            this._scrollPosition = Math.ceil(index / this._pageScrollSize);
            dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE));
         }
      }
      
      private function onBarBlockUp(e:MouseEvent) : void
      {
         this._thumb.stopDrag();
         this._thumb.addEventListener(MouseEvent.MOUSE_DOWN,this.onBarBlockDown);
         this._thumb.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onBarBlockMove);
         this._thumb.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onBarBlockUp);
      }
      
      private function onBackDown(e:MouseEvent) : void
      {
         this._thumb.y = (this._track.parent.mouseY - this._scrollRect.y) / (this._scrollRect.height + this._thumb.height) * this._scrollRect.height + this._scrollRect.y;
         this.onBarBlockMove(null);
      }
      
      private function onWheel(e:MouseEvent) : void
      {
         if(this._thumb.y >= this._scrollRect.y && this._thumb.y <= this._scrollRect.bottom)
         {
            this._thumb.y -= e.delta;
            this.onBarBlockMove(null);
         }
      }
      
      private function onUpDown(e:MouseEvent) : void
      {
         this._upBtn.addEventListener(Event.ENTER_FRAME,this.onUpEnter);
         if(Boolean(this._upBtn.stage))
         {
            this._upBtn.stage.addEventListener(MouseEvent.MOUSE_UP,this.onUpUp);
         }
      }
      
      private function onUpUp(e:MouseEvent) : void
      {
         if(Boolean(this._upBtn.stage))
         {
            this._upBtn.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onUpUp);
         }
         this._upBtn.removeEventListener(Event.ENTER_FRAME,this.onUpEnter);
      }
      
      private function onUpEnter(e:Event) : void
      {
         if(this._thumb.y >= this._scrollRect.y)
         {
            this._thumb.y -= 3;
            this.onBarBlockMove(null);
         }
         else
         {
            this._thumb.y = this._scrollRect.y;
            this._upBtn.removeEventListener(Event.ENTER_FRAME,this.onUpEnter);
         }
      }
      
      private function onDownDown(e:MouseEvent) : void
      {
         this._downBtn.addEventListener(Event.ENTER_FRAME,this.onDownEnter);
         if(Boolean(this._downBtn.stage))
         {
            this._downBtn.stage.addEventListener(MouseEvent.MOUSE_UP,this.onDownUp);
         }
      }
      
      private function onDownUp(e:MouseEvent) : void
      {
         if(Boolean(this._downBtn.stage))
         {
            this._downBtn.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onDownUp);
         }
         this._downBtn.removeEventListener(Event.ENTER_FRAME,this.onDownEnter);
      }
      
      private function onDownEnter(e:Event) : void
      {
         if(this._thumb.y <= this._scrollRect.bottom)
         {
            this._thumb.y += 3;
            this.onBarBlockMove(null);
         }
         else
         {
            this._thumb.y = this._scrollRect.bottom;
            this._downBtn.removeEventListener(Event.ENTER_FRAME,this.onDownEnter);
         }
      }
   }
}

