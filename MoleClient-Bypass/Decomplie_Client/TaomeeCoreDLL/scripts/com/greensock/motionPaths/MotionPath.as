package com.greensock.motionPaths
{
   import flash.display.Shape;
   import flash.events.Event;
   
   public class MotionPath extends Shape
   {
      
      protected static const _RAD2DEG:Number = 180 / Math.PI;
      
      protected static const _DEG2RAD:Number = Math.PI / 180;
      
      protected var _redrawLine:Boolean;
      
      protected var _thickness:Number;
      
      protected var _color:uint;
      
      protected var _lineAlpha:Number;
      
      protected var _pixelHinting:Boolean;
      
      protected var _scaleMode:String;
      
      protected var _caps:String;
      
      protected var _joints:String;
      
      protected var _miterLimit:Number;
      
      protected var _rootFollower:PathFollower;
      
      protected var _progress:Number;
      
      protected var _rawProgress:Number;
      
      public function MotionPath()
      {
         super();
         this._progress = this._rawProgress = 0;
         this.lineStyle(1,6710886,1,false,"none",null,null,3,true);
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage,false,0,true);
      }
      
      protected function onAddedToStage(event:Event) : void
      {
         this.update();
      }
      
      public function addFollower(target:*, progress:Number = 0, autoRotate:Boolean = false, rotationOffset:Number = 0) : PathFollower
      {
         var f:PathFollower = this.getFollower(target);
         if(f == null)
         {
            f = new PathFollower(target);
         }
         f.autoRotate = autoRotate;
         f.rotationOffset = rotationOffset;
         if(f.path != this)
         {
            if(Boolean(this._rootFollower))
            {
               this._rootFollower.cachedPrev = f;
            }
            f.cachedNext = this._rootFollower;
            this._rootFollower = f;
            f.path = this;
            f.progress = progress;
         }
         return f;
      }
      
      public function removeFollower(target:*) : void
      {
         var f:PathFollower = this.getFollower(target);
         if(f == null)
         {
            return;
         }
         if(Boolean(f.cachedNext))
         {
            f.cachedNext.cachedPrev = f.cachedPrev;
         }
         if(Boolean(f.cachedPrev))
         {
            f.cachedPrev.cachedNext = f.cachedNext;
         }
         else if(this._rootFollower == f)
         {
            this._rootFollower = f.cachedNext;
         }
         f.cachedNext = f.cachedPrev = null;
         f.path = null;
      }
      
      public function removeAllFollowers() : void
      {
         var next:PathFollower = null;
         var f:PathFollower = this._rootFollower;
         while(Boolean(f))
         {
            next = f.cachedNext;
            f.cachedNext = f.cachedPrev = null;
            f.path = null;
            f = next;
         }
         this._rootFollower = null;
      }
      
      public function distribute(targets:Array = null, min:Number = 0, max:Number = 1, autoRotate:Boolean = false, rotationOffset:Number = 0) : void
      {
         var f:PathFollower = null;
         if(targets == null)
         {
            targets = this.followers;
         }
         min = this._normalize(min);
         max = this._normalize(max);
         var i:int = int(targets.length);
         var space:Number = i > 1 ? (max - min) / (i - 1) : 1;
         while(--i > -1)
         {
            f = this.getFollower(targets[i]);
            if(f == null)
            {
               f = this.addFollower(targets[i],0,autoRotate,rotationOffset);
            }
            f.cachedProgress = f.cachedRawProgress = min + space * i;
            this.renderObjectAt(f.target,f.cachedProgress,autoRotate,rotationOffset);
         }
      }
      
      protected function _normalize(num:Number) : Number
      {
         if(num > 1)
         {
            num -= int(num);
         }
         else if(num < 0)
         {
            num -= int(num) - 1;
         }
         return num;
      }
      
      public function getFollower(target:Object) : PathFollower
      {
         if(target is PathFollower)
         {
            return target as PathFollower;
         }
         var f:PathFollower = this._rootFollower;
         while(Boolean(f))
         {
            if(f.target == target)
            {
               return f;
            }
            f = f.cachedNext;
         }
         return null;
      }
      
      public function update(event:Event = null) : void
      {
      }
      
      public function renderObjectAt(target:Object, progress:Number, autoRotate:Boolean = false, rotationOffset:Number = 0) : void
      {
      }
      
      public function lineStyle(thickness:Number = 1, color:uint = 6710886, alpha:Number = 1, pixelHinting:Boolean = false, scaleMode:String = "none", caps:String = null, joints:String = null, miterLimit:Number = 3, skipRedraw:Boolean = false) : void
      {
         this._thickness = thickness;
         this._color = color;
         this._lineAlpha = alpha;
         this._pixelHinting = pixelHinting;
         this._scaleMode = scaleMode;
         this._caps = caps;
         this._joints = joints;
         this._miterLimit = miterLimit;
         this._redrawLine = true;
         if(!skipRedraw)
         {
            this.update();
         }
      }
      
      override public function get rotation() : Number
      {
         return super.rotation;
      }
      
      override public function set rotation(value:Number) : void
      {
         super.rotation = value;
         this.update();
      }
      
      override public function get scaleX() : Number
      {
         return super.scaleX;
      }
      
      override public function set scaleX(value:Number) : void
      {
         super.scaleX = value;
         this.update();
      }
      
      override public function get scaleY() : Number
      {
         return super.scaleY;
      }
      
      override public function set scaleY(value:Number) : void
      {
         super.scaleY = value;
         this.update();
      }
      
      override public function get x() : Number
      {
         return super.x;
      }
      
      override public function set x(value:Number) : void
      {
         super.x = value;
         this.update();
      }
      
      override public function get y() : Number
      {
         return super.y;
      }
      
      override public function set y(value:Number) : void
      {
         super.y = value;
         this.update();
      }
      
      override public function get width() : Number
      {
         return super.width;
      }
      
      override public function set width(value:Number) : void
      {
         super.width = value;
         this.update();
      }
      
      override public function get height() : Number
      {
         return super.height;
      }
      
      override public function set height(value:Number) : void
      {
         super.height = value;
         this.update();
      }
      
      override public function get visible() : Boolean
      {
         return super.visible;
      }
      
      override public function set visible(value:Boolean) : void
      {
         super.visible = value;
         this._redrawLine = true;
         this.update();
      }
      
      public function get rawProgress() : Number
      {
         return this._rawProgress;
      }
      
      public function set rawProgress(value:Number) : void
      {
         this.progress = value;
      }
      
      public function get progress() : Number
      {
         return this._progress;
      }
      
      public function set progress(value:Number) : void
      {
         if(value > 1)
         {
            this._rawProgress = value;
            value -= int(value);
            if(value == 0)
            {
               value = 1;
            }
         }
         else if(value < 0)
         {
            this._rawProgress = value;
            value -= int(value) - 1;
         }
         else
         {
            this._rawProgress = int(this._rawProgress) + value;
         }
         var dif:Number = value - this._progress;
         var f:PathFollower = this._rootFollower;
         while(Boolean(f))
         {
            f.cachedProgress += dif;
            f.cachedRawProgress += dif;
            if(f.cachedProgress > 1)
            {
               f.cachedProgress -= int(f.cachedProgress);
               if(f.cachedProgress == 0)
               {
                  f.cachedProgress = 1;
               }
            }
            else if(f.cachedProgress < 0)
            {
               f.cachedProgress -= int(f.cachedProgress) - 1;
            }
            f = f.cachedNext;
         }
         this._progress = value;
         this.update();
      }
      
      public function get followers() : Array
      {
         var a:Array = [];
         var cnt:uint = 0;
         var f:PathFollower = this._rootFollower;
         while(Boolean(f))
         {
            a[cnt++] = f;
            f = f.cachedNext;
         }
         return a;
      }
      
      public function get targets() : Array
      {
         var a:Array = [];
         var cnt:uint = 0;
         var f:PathFollower = this._rootFollower;
         while(Boolean(f))
         {
            a[cnt++] = f.target;
            f = f.cachedNext;
         }
         return a;
      }
   }
}

