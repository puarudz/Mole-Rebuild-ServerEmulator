package com.greensock
{
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Transform;
   import mx.core.UIComponent;
   
   public class FlexBlitMask extends UIComponent
   {
      
      public static var version:Number = 0.6;
      
      protected static var _tempContainer:Sprite = new Sprite();
      
      protected static var _sliceRect:Rectangle = new Rectangle();
      
      protected static var _drawRect:Rectangle = new Rectangle();
      
      protected static var _destPoint:Point = new Point();
      
      protected static var _tempMatrix:Matrix = new Matrix();
      
      protected static var _emptyArray:Array = [];
      
      protected static var _colorTransform:ColorTransform = new ColorTransform();
      
      protected static var _mouseEvents:Array = [MouseEvent.CLICK,MouseEvent.DOUBLE_CLICK,MouseEvent.MOUSE_DOWN,MouseEvent.MOUSE_MOVE,MouseEvent.MOUSE_OUT,MouseEvent.MOUSE_OVER,MouseEvent.MOUSE_UP,MouseEvent.MOUSE_WHEEL,MouseEvent.ROLL_OUT,MouseEvent.ROLL_OVER];
      
      protected var _target:DisplayObject;
      
      protected var _fillColor:uint;
      
      protected var _smoothing:Boolean;
      
      protected var _width:Number;
      
      protected var _height:Number;
      
      protected var _bd:BitmapData;
      
      protected var _gridSize:int = 2879;
      
      protected var _grid:Array;
      
      protected var _bounds:Rectangle;
      
      protected var _clipRect:Rectangle;
      
      protected var _bitmapMode:Boolean;
      
      protected var _rows:int;
      
      protected var _columns:int;
      
      protected var _scaleX:Number;
      
      protected var _scaleY:Number;
      
      protected var _prevMatrix:Matrix;
      
      protected var _transform:Transform;
      
      protected var _prevRotation:Number;
      
      protected var _autoUpdate:Boolean;
      
      protected var _wrap:Boolean;
      
      protected var _wrapOffsetX:Number = 0;
      
      protected var _wrapOffsetY:Number = 0;
      
      public function FlexBlitMask(target:DisplayObject = null, x:Number = 0, y:Number = 0, width:Number = 100, height:Number = 100, smoothing:Boolean = false, autoUpdate:Boolean = true, fillColor:uint = 0, wrap:Boolean = false)
      {
         super();
         if(width < 0 || height < 0)
         {
            throw new Error("A FlexBlitMask cannot have a negative width or height.");
         }
         this._width = width;
         this._height = height;
         this._scaleX = this._scaleY = 1;
         this._smoothing = smoothing;
         this._fillColor = fillColor;
         this._autoUpdate = autoUpdate;
         this._wrap = wrap;
         this._grid = [];
         this._bounds = new Rectangle();
         if(this._smoothing)
         {
            super.x = x;
            super.y = y;
         }
         else
         {
            super.x = x < 0 ? x - 0.5 >> 0 : x + 0.5 >> 0;
            super.y = y < 0 ? y - 0.5 >> 0 : y + 0.5 >> 0;
         }
         this._clipRect = new Rectangle(0,0,this._gridSize + 1,this._gridSize + 1);
         this._bd = new BitmapData(width + 1,height + 1,true,this._fillColor);
         this._bitmapMode = true;
         this.target = target;
      }
      
      protected function _captureTargetBitmap() : void
      {
         var bd:BitmapData = null;
         var cumulativeWidth:Number = NaN;
         var column:int = 0;
         if(this._bd == null || this._target == null)
         {
            return;
         }
         this._disposeGrid();
         var prevMask:DisplayObject = this._target.mask;
         if(prevMask != null)
         {
            this._target.mask = null;
         }
         var prevScrollRect:Rectangle = this._target.scrollRect;
         if(prevScrollRect != null)
         {
            this._target.scrollRect = null;
         }
         var prevFilters:Array = this._target.filters;
         if(prevFilters.length != 0)
         {
            this._target.filters = _emptyArray;
         }
         this._grid = [];
         if(this._target.parent == null)
         {
            _tempContainer.addChild(this._target);
         }
         this._bounds = this._target.getBounds(this._target.parent);
         var w:Number = 0;
         var h:Number = 0;
         this._columns = Math.ceil(this._bounds.width / this._gridSize);
         this._rows = Math.ceil(this._bounds.height / this._gridSize);
         var cumulativeHeight:Number = 0;
         var matrix:Matrix = this._transform.matrix;
         var xOffset:Number = matrix.tx - this._bounds.x;
         var yOffset:Number = matrix.ty - this._bounds.y;
         if(!this._smoothing)
         {
            xOffset = xOffset + 0.5 >> 0;
            yOffset = yOffset + 0.5 >> 0;
         }
         for(var row:int = 0; row < this._rows; row++)
         {
            h = this._bounds.height - cumulativeHeight > this._gridSize ? this._gridSize : this._bounds.height - cumulativeHeight;
            matrix.ty = -cumulativeHeight + yOffset;
            cumulativeWidth = 0;
            this._grid[row] = [];
            for(column = 0; column < this._columns; column++)
            {
               w = this._bounds.width - cumulativeWidth > this._gridSize ? this._gridSize : this._bounds.width - cumulativeWidth;
               this._grid[row][column] = bd = new BitmapData(w + 1,h + 1,true,this._fillColor);
               matrix.tx = -cumulativeWidth + xOffset;
               bd.draw(this._target,matrix,null,null,this._clipRect,this._smoothing);
               cumulativeWidth += w;
            }
            cumulativeHeight += h;
         }
         if(this._target.parent == _tempContainer)
         {
            _tempContainer.removeChild(this._target);
         }
         if(prevMask != null)
         {
            this._target.mask = prevMask;
         }
         if(prevScrollRect != null)
         {
            this._target.scrollRect = prevScrollRect;
         }
         if(prevFilters.length != 0)
         {
            this._target.filters = prevFilters;
         }
      }
      
      protected function _disposeGrid() : void
      {
         var j:int = 0;
         var r:Array = null;
         var i:int = int(this._grid.length);
         while(--i > -1)
         {
            r = this._grid[i];
            j = int(r.length);
            while(--j > -1)
            {
               BitmapData(r[j]).dispose();
            }
         }
      }
      
      public function update(event:Event = null, forceRecaptureBitmap:Boolean = false) : void
      {
         var m:Matrix = null;
         if(this._bd == null)
         {
            return;
         }
         if(this._target == null)
         {
            this._render();
         }
         else if(Boolean(this._target.parent))
         {
            this._bounds = this._target.getBounds(this._target.parent);
            if(this.parent != this._target.parent)
            {
               if(this._target.parent.hasOwnProperty("addElementAt"))
               {
                  Object(this._target.parent).addElementAt(this,Object(this._target.parent).getChildIndex(this._target));
               }
               else
               {
                  this._target.parent.addChildAt(this,this._target.parent.getChildIndex(this._target));
               }
            }
         }
         if(this._bitmapMode || forceRecaptureBitmap)
         {
            m = this._transform.matrix;
            if(forceRecaptureBitmap || this._prevMatrix == null || m.a != this._prevMatrix.a || m.b != this._prevMatrix.b || m.c != this._prevMatrix.c || m.d != this._prevMatrix.d)
            {
               this._captureTargetBitmap();
               this._render();
            }
            else if(m.tx != this._prevMatrix.tx || m.ty != this._prevMatrix.ty)
            {
               this._render();
            }
            else if(this._bitmapMode && this._target != null)
            {
               this.filters = this._target.filters;
               this.transform.colorTransform = this._transform.colorTransform;
            }
            this._prevMatrix = m;
         }
      }
      
      protected function _render(xOffset:Number = 0, yOffset:Number = 0, clear:Boolean = true, limitRecursion:Boolean = false) : void
      {
         var xDestReset:Number = NaN;
         var xSliceReset:Number = NaN;
         var columnReset:int = 0;
         var bd:BitmapData = null;
         if(clear)
         {
            _sliceRect.x = _sliceRect.y = 0;
            _sliceRect.width = this._width + 1;
            _sliceRect.height = this._height + 1;
            this._bd.fillRect(_sliceRect,this._fillColor);
            if(this._bitmapMode && this._target != null)
            {
               this.filters = this._target.filters;
               this.transform.colorTransform = this._transform.colorTransform;
            }
            else
            {
               this.filters = _emptyArray;
               this.transform.colorTransform = _colorTransform;
            }
         }
         if(this._bd == null)
         {
            return;
         }
         if(this._rows == 0)
         {
            this._captureTargetBitmap();
         }
         var x:Number = super.x + xOffset;
         var y:Number = super.y + yOffset;
         var wrapWidth:int = this._bounds.width + this._wrapOffsetX + 0.5 >> 0;
         var wrapHeight:int = this._bounds.height + this._wrapOffsetY + 0.5 >> 0;
         var g:Graphics = this.graphics;
         if(this._bounds.width == 0 || this._bounds.height == 0 || this._wrap && (wrapWidth == 0 || wrapHeight == 0) || !this._wrap && (x + this._width < this._bounds.x || y + this._height < this._bounds.y || x > this._bounds.right || y > this._bounds.bottom))
         {
            g.clear();
            g.beginBitmapFill(this._bd);
            g.drawRect(0,0,this._width,this._height);
            g.endFill();
            return;
         }
         var column:int = int((x - this._bounds.x) / this._gridSize);
         if(column < 0)
         {
            column = 0;
         }
         var row:int = int((y - this._bounds.y) / this._gridSize);
         if(row < 0)
         {
            row = 0;
         }
         var maxColumn:int = int((x + this._width - this._bounds.x) / this._gridSize);
         if(maxColumn >= this._columns)
         {
            maxColumn = this._columns - 1;
         }
         var maxRow:uint = uint(int((y + this._height - this._bounds.y) / this._gridSize));
         if(maxRow >= this._rows)
         {
            maxRow = this._rows - 1;
         }
         var xNudge:Number = (this._bounds.x - x) % 1;
         var yNudge:Number = (this._bounds.y - y) % 1;
         if(y <= this._bounds.y)
         {
            _destPoint.y = this._bounds.y - y >> 0;
            _sliceRect.y = -1;
         }
         else
         {
            _destPoint.y = 0;
            _sliceRect.y = Math.ceil(y - this._bounds.y) - row * this._gridSize - 1;
            if(clear && yNudge != 0)
            {
               yNudge += 1;
            }
         }
         if(x <= this._bounds.x)
         {
            _destPoint.x = this._bounds.x - x >> 0;
            _sliceRect.x = -1;
         }
         else
         {
            _destPoint.x = 0;
            _sliceRect.x = Math.ceil(x - this._bounds.x) - column * this._gridSize - 1;
            if(clear && xNudge != 0)
            {
               xNudge += 1;
            }
         }
         if(this._wrap && clear)
         {
            this._render(Math.ceil((this._bounds.x - x) / wrapWidth) * wrapWidth,Math.ceil((this._bounds.y - y) / wrapHeight) * wrapHeight,false,false);
         }
         else if(this._rows != 0)
         {
            xDestReset = _destPoint.x;
            xSliceReset = _sliceRect.x;
            columnReset = column;
            while(row <= maxRow)
            {
               bd = this._grid[row][0];
               _sliceRect.height = bd.height - _sliceRect.y;
               _destPoint.x = xDestReset;
               _sliceRect.x = xSliceReset;
               column = columnReset;
               while(column <= maxColumn)
               {
                  bd = this._grid[row][column];
                  _sliceRect.width = bd.width - _sliceRect.x;
                  this._bd.copyPixels(bd,_sliceRect,_destPoint);
                  _destPoint.x += _sliceRect.width - 1;
                  _sliceRect.x = 0;
                  column++;
               }
               _destPoint.y += _sliceRect.height - 1;
               _sliceRect.y = 0;
               row++;
            }
         }
         if(clear)
         {
            _tempMatrix.tx = xNudge - 1;
            _tempMatrix.ty = yNudge - 1;
            g.clear();
            g.beginBitmapFill(this._bd,_tempMatrix,false,this._smoothing);
            g.drawRect(0,0,this._width,this._height);
            g.endFill();
         }
         else if(this._wrap)
         {
            if(x + this._width > this._bounds.right)
            {
               this._render(xOffset - wrapWidth,yOffset,false,true);
            }
            if(!limitRecursion && y + this._height > this._bounds.bottom)
            {
               this._render(xOffset,yOffset - wrapHeight,false,false);
            }
         }
      }
      
      public function setSize(width:Number, height:Number) : void
      {
         if(this._width == width && this._height == height)
         {
            return;
         }
         if(width < 0 || height < 0)
         {
            throw new Error("A FlexBlitMask cannot have a negative width or height.");
         }
         if(this._bd != null)
         {
            this._bd.dispose();
         }
         this._width = width;
         this._height = height;
         this._bd = new BitmapData(width + 1,height + 1,true,this._fillColor);
         this._render();
      }
      
      protected function _mouseEventPassthrough(event:MouseEvent) : void
      {
         if(this.mouseEnabled && (!this._bitmapMode || this.hitTestPoint(event.stageX,event.stageY,false)))
         {
            dispatchEvent(event);
         }
      }
      
      public function enableBitmapMode(event:Event = null) : void
      {
         this.bitmapMode = true;
      }
      
      public function disableBitmapMode(event:Event = null) : void
      {
         this.bitmapMode = false;
      }
      
      public function normalizePosition() : void
      {
         var wrapWidth:int = 0;
         var wrapHeight:int = 0;
         var offsetX:Number = NaN;
         var offsetY:Number = NaN;
         if(Boolean(this._target) && Boolean(this._bounds))
         {
            wrapWidth = this._bounds.width + this._wrapOffsetX + 0.5 >> 0;
            wrapHeight = this._bounds.height + this._wrapOffsetY + 0.5 >> 0;
            offsetX = (this._bounds.x - this.x) % wrapWidth;
            offsetY = (this._bounds.y - this.y) % wrapHeight;
            if(offsetX > (this._width + this._wrapOffsetX) / 2)
            {
               offsetX -= wrapWidth;
            }
            else if(offsetX < (this._width + this._wrapOffsetX) / -2)
            {
               offsetX += wrapWidth;
            }
            if(offsetY > (this._height + this._wrapOffsetY) / 2)
            {
               offsetY -= wrapHeight;
            }
            else if(offsetY < (this._height + this._wrapOffsetY) / -2)
            {
               offsetY += wrapHeight;
            }
            this._target.x += this.x + offsetX - this._bounds.x;
            this._target.y += this.y + offsetY - this._bounds.y;
         }
      }
      
      public function dispose() : void
      {
         if(this._bd == null)
         {
            return;
         }
         this._disposeGrid();
         this._bd.dispose();
         this._bd = null;
         this.bitmapMode = false;
         this.autoUpdate = false;
         if(this._target != null)
         {
            this._target.mask = null;
         }
         if(this.parent != null)
         {
            if(this.parent.hasOwnProperty("removeElement"))
            {
               Object(this.parent).removeElement(this);
            }
            else
            {
               this.parent.removeChild(this);
            }
         }
         this.target = null;
      }
      
      override protected function measure() : void
      {
         var bounds:Rectangle = null;
         if(Boolean(this.parent))
         {
            bounds = this.getBounds(this.parent);
            super.width = bounds.width;
            super.height = bounds.height;
         }
         this.explicitWidth = this._width;
         this.explicitHeight = this._height;
         super.measure();
      }
      
      override public function setActualSize(w:Number, h:Number) : void
      {
         this.setSize(w,h);
         super.setActualSize(w,h);
      }
      
      public function get bitmapMode() : Boolean
      {
         return this._bitmapMode;
      }
      
      public function set bitmapMode(value:Boolean) : void
      {
         if(this._bitmapMode != value)
         {
            this._bitmapMode = value;
            if(this._target != null)
            {
               this._target.visible = !this._bitmapMode;
               this.update(null);
               if(this._bitmapMode)
               {
                  this.filters = this._target.filters;
                  this.transform.colorTransform = this._transform.colorTransform;
                  if(this._target.blendMode == "auto")
                  {
                     this.blendMode = this._target.alpha == 0 || this._target.alpha == 1 ? BlendMode.NORMAL : BlendMode.LAYER;
                  }
                  else
                  {
                     this.blendMode = this._target.blendMode;
                  }
                  this._target.mask = null;
               }
               else
               {
                  this.filters = _emptyArray;
                  this.transform.colorTransform = _colorTransform;
                  this.blendMode = "normal";
                  this.cacheAsBitmap = false;
                  this._target.mask = this;
                  if(this._wrap)
                  {
                     this.normalizePosition();
                  }
               }
               if(this._bitmapMode && this._autoUpdate)
               {
                  this.addEventListener(Event.ENTER_FRAME,this.update,false,-10,true);
               }
               else
               {
                  this.removeEventListener(Event.ENTER_FRAME,this.update);
               }
            }
         }
      }
      
      public function get autoUpdate() : Boolean
      {
         return this._autoUpdate;
      }
      
      public function set autoUpdate(value:Boolean) : void
      {
         if(this._autoUpdate != value)
         {
            this._autoUpdate = value;
            if(this._bitmapMode && this._autoUpdate)
            {
               this.addEventListener(Event.ENTER_FRAME,this.update,false,-10,true);
            }
            else
            {
               this.removeEventListener(Event.ENTER_FRAME,this.update);
            }
         }
      }
      
      public function get target() : DisplayObject
      {
         return this._target;
      }
      
      public function set target(value:DisplayObject) : void
      {
         var i:int = 0;
         if(this._target != value)
         {
            i = int(_mouseEvents.length);
            if(this._target != null)
            {
               while(--i > -1)
               {
                  this._target.removeEventListener(_mouseEvents[i],this._mouseEventPassthrough);
               }
            }
            this._target = value;
            if(this._target != null)
            {
               i = int(_mouseEvents.length);
               while(--i > -1)
               {
                  this._target.addEventListener(_mouseEvents[i],this._mouseEventPassthrough,false,0,true);
               }
               this._prevMatrix = null;
               this._transform = this._target.transform;
               this._bitmapMode = !this._bitmapMode;
               this.bitmapMode = !this._bitmapMode;
            }
            else
            {
               this._bounds = new Rectangle();
            }
         }
      }
      
      override public function get x() : Number
      {
         return super.x;
      }
      
      override public function set x(value:Number) : void
      {
         if(this._smoothing)
         {
            super.x = value;
         }
         else if(value >= 0)
         {
            super.x = value + 0.5 >> 0;
         }
         else
         {
            super.x = value - 0.5 >> 0;
         }
         if(this._bitmapMode)
         {
            this._render();
         }
      }
      
      override public function get y() : Number
      {
         return super.y;
      }
      
      override public function set y(value:Number) : void
      {
         if(this._smoothing)
         {
            super.y = value;
         }
         else if(value >= 0)
         {
            super.y = value + 0.5 >> 0;
         }
         else
         {
            super.y = value - 0.5 >> 0;
         }
         if(this._bitmapMode)
         {
            this._render();
         }
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function set width(value:Number) : void
      {
         this.setSize(value,this._height);
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      override public function set height(value:Number) : void
      {
         this.setSize(this._width,value);
      }
      
      override public function get scaleX() : Number
      {
         return 1;
      }
      
      override public function set scaleX(value:Number) : void
      {
         var oldScaleX:Number = this._scaleX;
         this._scaleX = value;
         this.setSize(this._width * (this._scaleX / oldScaleX),this._height);
      }
      
      override public function get scaleY() : Number
      {
         return 1;
      }
      
      override public function set scaleY(value:Number) : void
      {
         var oldScaleY:Number = this._scaleY;
         this._scaleY = value;
         this.setSize(this._width,this._height * (this._scaleY / oldScaleY));
      }
      
      override public function set rotation(value:Number) : void
      {
         if(value != 0)
         {
            throw new Error("Cannot set the rotation of a FlexBlitMask to a non-zero number. FlexBlitMasks should remain unrotated.");
         }
      }
      
      public function get scrollX() : Number
      {
         return (super.x - this._bounds.x) / (this._bounds.width - this._width);
      }
      
      public function set scrollX(value:Number) : void
      {
         var dif:Number = NaN;
         if(this._target != null && Boolean(this._target.parent))
         {
            this._bounds = this._target.getBounds(this._target.parent);
            dif = super.x - (this._bounds.width - this._width) * value - this._bounds.x;
            this._target.x += dif;
            this._bounds.x += dif;
            if(this._bitmapMode)
            {
               this._render();
            }
         }
      }
      
      public function get scrollY() : Number
      {
         return (super.y - this._bounds.y) / (this._bounds.height - this._height);
      }
      
      public function set scrollY(value:Number) : void
      {
         var dif:Number = NaN;
         if(this._target != null && Boolean(this._target.parent))
         {
            this._bounds = this._target.getBounds(this._target.parent);
            dif = super.y - (this._bounds.height - this._height) * value - this._bounds.y;
            this._target.y += dif;
            this._bounds.y += dif;
            if(this._bitmapMode)
            {
               this._render();
            }
         }
      }
      
      public function get smoothing() : Boolean
      {
         return this._smoothing;
      }
      
      public function set smoothing(value:Boolean) : void
      {
         if(this._smoothing != value)
         {
            this._smoothing = value;
            this._captureTargetBitmap();
            if(this._bitmapMode)
            {
               this._render();
            }
         }
      }
      
      public function get fillColor() : uint
      {
         return this._fillColor;
      }
      
      public function set fillColor(value:uint) : void
      {
         if(this._fillColor != value)
         {
            this._fillColor = value;
            if(this._bitmapMode)
            {
               this._render();
            }
         }
      }
      
      public function get wrap() : Boolean
      {
         return this._wrap;
      }
      
      public function set wrap(value:Boolean) : void
      {
         if(this._wrap != value)
         {
            this._wrap = value;
            if(this._bitmapMode)
            {
               this._render();
            }
         }
      }
      
      public function get wrapOffsetX() : Number
      {
         return this._wrapOffsetX;
      }
      
      public function set wrapOffsetX(value:Number) : void
      {
         if(this._wrapOffsetX != value)
         {
            this._wrapOffsetX = value;
            if(this._bitmapMode)
            {
               this._render();
            }
         }
      }
      
      public function get wrapOffsetY() : Number
      {
         return this._wrapOffsetY;
      }
      
      public function set wrapOffsetY(value:Number) : void
      {
         if(this._wrapOffsetY != value)
         {
            this._wrapOffsetY = value;
            if(this._bitmapMode)
            {
               this._render();
            }
         }
      }
   }
}

