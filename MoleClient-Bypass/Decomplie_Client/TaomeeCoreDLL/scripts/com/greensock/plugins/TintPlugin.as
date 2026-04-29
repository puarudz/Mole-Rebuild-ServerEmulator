package com.greensock.plugins
{
   import com.greensock.*;
   import com.greensock.core.*;
   import flash.display.*;
   import flash.geom.ColorTransform;
   import flash.geom.Transform;
   
   public class TintPlugin extends TweenPlugin
   {
      
      public static const API:Number = 1;
      
      protected static var _props:Array = ["redMultiplier","greenMultiplier","blueMultiplier","alphaMultiplier","redOffset","greenOffset","blueOffset","alphaOffset"];
      
      protected var _transform:Transform;
      
      public function TintPlugin()
      {
         super();
         this.propName = "tint";
         this.overwriteProps = ["tint"];
      }
      
      override public function onInitTween(target:Object, value:*, tween:TweenLite) : Boolean
      {
         if(!(target is DisplayObject))
         {
            return false;
         }
         var end:ColorTransform = new ColorTransform();
         if(value != null && tween.vars.removeTint != true)
         {
            end.color = uint(value);
         }
         this._transform = DisplayObject(target).transform;
         var start:ColorTransform = this._transform.colorTransform;
         end.alphaMultiplier = start.alphaMultiplier;
         end.alphaOffset = start.alphaOffset;
         this.init(start,end);
         return true;
      }
      
      public function init(start:ColorTransform, end:ColorTransform) : void
      {
         var p:String = null;
         var i:int = int(_props.length);
         var cnt:int = int(_tweens.length);
         while(Boolean(i--))
         {
            p = _props[i];
            if(start[p] != end[p])
            {
               _tweens[cnt++] = new PropTween(start,p,start[p],end[p] - start[p],"tint",false);
            }
         }
      }
      
      override public function set changeFactor(n:Number) : void
      {
         var ct:ColorTransform = null;
         var pt:PropTween = null;
         var i:int = 0;
         if(Boolean(this._transform))
         {
            ct = this._transform.colorTransform;
            i = int(_tweens.length);
            while(--i > -1)
            {
               pt = _tweens[i];
               ct[pt.property] = pt.start + pt.change * n;
            }
            this._transform.colorTransform = ct;
         }
      }
   }
}

