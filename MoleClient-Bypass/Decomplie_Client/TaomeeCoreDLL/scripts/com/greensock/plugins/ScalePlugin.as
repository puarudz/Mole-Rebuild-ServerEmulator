package com.greensock.plugins
{
   import com.greensock.*;
   
   public class ScalePlugin extends TweenPlugin
   {
      
      public static const API:Number = 1;
      
      protected var _target:Object;
      
      protected var _startX:Number;
      
      protected var _changeX:Number;
      
      protected var _startY:Number;
      
      protected var _changeY:Number;
      
      public function ScalePlugin()
      {
         super();
         this.propName = "scale";
         this.overwriteProps = ["scaleX","scaleY","width","height"];
      }
      
      override public function onInitTween(target:Object, value:*, tween:TweenLite) : Boolean
      {
         if(!target.hasOwnProperty("scaleX"))
         {
            return false;
         }
         this._target = target;
         this._startX = this._target.scaleX;
         this._startY = this._target.scaleY;
         if(typeof value == "number")
         {
            this._changeX = value - this._startX;
            this._changeY = value - this._startY;
         }
         else
         {
            this._changeX = this._changeY = Number(value);
         }
         return true;
      }
      
      override public function killProps(lookup:Object) : void
      {
         var i:int = int(this.overwriteProps.length);
         while(Boolean(i--))
         {
            if(this.overwriteProps[i] in lookup)
            {
               this.overwriteProps = [];
               return;
            }
         }
      }
      
      override public function set changeFactor(n:Number) : void
      {
         this._target.scaleX = this._startX + n * this._changeX;
         this._target.scaleY = this._startY + n * this._changeY;
      }
   }
}

