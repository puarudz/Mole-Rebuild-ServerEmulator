package com.greensock.plugins
{
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   
   public class FrameForwardPlugin extends TweenPlugin
   {
      
      public static const API:Number = 1;
      
      protected var _start:int;
      
      protected var _change:int;
      
      protected var _max:uint;
      
      protected var _target:MovieClip;
      
      protected var _backward:Boolean;
      
      public function FrameForwardPlugin()
      {
         super();
         this.propName = "frameForward";
         this.overwriteProps = ["frame","frameLabel","frameForward","frameBackward"];
         this.round = true;
      }
      
      override public function onInitTween(target:Object, value:*, tween:TweenLite) : Boolean
      {
         if(!(target is MovieClip) || isNaN(value))
         {
            return false;
         }
         this._target = target as MovieClip;
         this._start = this._target.currentFrame;
         this._max = this._target.totalFrames;
         this._change = typeof value == "number" ? int(Number(value) - this._start) : int(Number(value));
         if(!this._backward && this._change < 0)
         {
            this._change += this._max;
         }
         else if(this._backward && this._change > 0)
         {
            this._change -= this._max;
         }
         return true;
      }
      
      override public function set changeFactor(n:Number) : void
      {
         var frame:Number = (this._start + this._change * n) % this._max;
         if(frame < 0.5 && frame >= -0.5)
         {
            frame = this._max;
         }
         else if(frame < 0)
         {
            frame += this._max;
         }
         this._target.gotoAndStop(int(frame + 0.5));
      }
   }
}

