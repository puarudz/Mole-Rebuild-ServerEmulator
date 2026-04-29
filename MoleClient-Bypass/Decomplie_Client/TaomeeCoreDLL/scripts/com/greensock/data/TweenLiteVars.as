package com.greensock.data
{
   import com.greensock.TweenLite;
   import com.greensock.motionPaths.MotionPath;
   import flash.display.Stage;
   import flash.geom.Point;
   
   public class TweenLiteVars
   {
      
      public static const version:Number = 5.2;
      
      protected var _vars:Object;
      
      public function TweenLiteVars(vars:Object = null)
      {
         var p:String = null;
         super();
         this._vars = {};
         if(vars != null)
         {
            for(p in vars)
            {
               this._vars[p] = vars[p];
            }
         }
         if(TweenLite.version < 11.4)
         {
            trace("WARNING: it is suggested that you update to at least version 11.4 of TweenLite in order for TweenLiteVars to work properly. http://www.greensock.com/tweenlite/");
         }
      }
      
      protected function _set(property:String, value:*, requirePlugin:Boolean = false) : TweenLiteVars
      {
         if(value == null)
         {
            delete this._vars[property];
         }
         else
         {
            this._vars[property] = value;
         }
         if(requirePlugin && !(property in TweenLite.plugins))
         {
            trace("WARNING: you must activate() the " + property + " plugin in order for the feature to work in TweenLite. See http://www.greensock.com/tweenlite/#plugins for details.");
         }
         return this;
      }
      
      public function prop(property:String, value:Number, relative:Boolean = false) : TweenLiteVars
      {
         return this._set(property,relative ? String(value) : value);
      }
      
      public function data(data:*) : TweenLiteVars
      {
         return this._set("data",data);
      }
      
      public function delay(delay:Number) : TweenLiteVars
      {
         return this._set("delay",delay);
      }
      
      public function ease(ease:Function, easeParams:Array = null) : TweenLiteVars
      {
         this._set("easeParams",easeParams);
         return this._set("ease",ease);
      }
      
      public function immediateRender(value:Boolean) : TweenLiteVars
      {
         return this._set("immediateRender",value,false);
      }
      
      public function onComplete(func:Function, params:Array = null) : TweenLiteVars
      {
         this._set("onCompleteParams",params);
         return this._set("onComplete",func);
      }
      
      public function onInit(func:Function, params:Array = null) : TweenLiteVars
      {
         this._set("onInitParams",params);
         return this._set("onInit",func);
      }
      
      public function onStart(func:Function, params:Array = null) : TweenLiteVars
      {
         this._set("onStartParams",params);
         return this._set("onStart",func);
      }
      
      public function onUpdate(func:Function, params:Array = null) : TweenLiteVars
      {
         this._set("onUpdateParams",params);
         return this._set("onUpdate",func);
      }
      
      public function onReverseComplete(func:Function, params:Array = null) : TweenLiteVars
      {
         this._set("onReverseCompleteParams",params);
         return this._set("onReverseComplete",func);
      }
      
      public function overwrite(value:int) : TweenLiteVars
      {
         return this._set("overwrite",value,false);
      }
      
      public function paused(value:Boolean) : TweenLiteVars
      {
         return this._set("paused",value,false);
      }
      
      public function runBackwards(value:Boolean) : TweenLiteVars
      {
         return this._set("runBackwards",value,false);
      }
      
      public function useFrames(value:Boolean) : TweenLiteVars
      {
         return this._set("useFrames",value,false);
      }
      
      public function move(x:Number, y:Number, relative:Boolean = false) : TweenLiteVars
      {
         this.prop("x",x,relative);
         return this.prop("y",y,relative);
      }
      
      public function scale(value:Number, relative:Boolean = false) : TweenLiteVars
      {
         this.prop("scaleX",value,relative);
         return this.prop("scaleY",value,relative);
      }
      
      public function rotation(value:Number, relative:Boolean = false) : TweenLiteVars
      {
         return this.prop("rotation",value,relative);
      }
      
      public function scaleX(value:Number, relative:Boolean = false) : TweenLiteVars
      {
         return this.prop("scaleX",value,relative);
      }
      
      public function scaleY(value:Number, relative:Boolean = false) : TweenLiteVars
      {
         return this.prop("scaleY",value,relative);
      }
      
      public function width(value:Number, relative:Boolean = false) : TweenLiteVars
      {
         return this.prop("width",value,relative);
      }
      
      public function height(value:Number, relative:Boolean = false) : TweenLiteVars
      {
         return this.prop("height",value,relative);
      }
      
      public function x(value:Number, relative:Boolean = false) : TweenLiteVars
      {
         return this.prop("x",value,relative);
      }
      
      public function y(value:Number, relative:Boolean = false) : TweenLiteVars
      {
         return this.prop("y",value,relative);
      }
      
      public function autoAlpha(alpha:Number) : TweenLiteVars
      {
         return this._set("autoAlpha",alpha,true);
      }
      
      public function bevelFilter(distance:Number = 4, angle:Number = 45, highlightColor:uint = 16777215, highlightAlpha:Number = 0.5, shadowColor:uint = 0, shadowAlpha:Number = 0.5, blurX:Number = 4, blurY:Number = 4, strength:Number = 1, quality:int = 2, remove:Boolean = false, addFilter:Boolean = false, index:int = -1) : TweenLiteVars
      {
         var filter:Object = {
            "distance":distance,
            "angle":angle,
            "highlightColor":highlightColor,
            "highlightAlpha":highlightAlpha,
            "shadowColor":shadowColor,
            "shadowAlpha":shadowAlpha,
            "blurX":blurX,
            "blurY":blurY,
            "strength":strength,
            "quality":quality,
            "addFilter":addFilter,
            "remove":remove
         };
         if(index > -1)
         {
            filter.index = index;
         }
         return this._set("bevelFilter",filter,true);
      }
      
      public function bezier(values:Array) : TweenLiteVars
      {
         return this._set("bezier",values,true);
      }
      
      public function bezierThrough(values:Array) : TweenLiteVars
      {
         return this._set("bezierThrough",values,true);
      }
      
      public function blurFilter(blurX:Number, blurY:Number, quality:int = 2, remove:Boolean = false, addFilter:Boolean = false, index:int = -1) : TweenLiteVars
      {
         var filter:Object = {
            "blurX":blurX,
            "blurY":blurY,
            "quality":quality,
            "addFilter":addFilter,
            "remove":remove
         };
         if(index > -1)
         {
            filter.index = index;
         }
         return this._set("blurFilter",filter,true);
      }
      
      public function circlePath2D(path:MotionPath, startAngle:Number, endAngle:Number, autoRotate:Boolean = false, direction:String = "clockwise", extraRevolutions:uint = 0, rotationOffset:Number = 0, useRadians:Boolean = false) : TweenLiteVars
      {
         return this._set("circlePath2D",{
            "path":path,
            "startAngle":startAngle,
            "endAngle":endAngle,
            "autoRotate":autoRotate,
            "direction":direction,
            "extraRevolutions":extraRevolutions,
            "rotationOffset":rotationOffset,
            "useRadians":useRadians
         },true);
      }
      
      public function colorMatrixFilter(colorize:uint = 16777215, amount:Number = 1, saturation:Number = 1, contrast:Number = 1, brightness:Number = 1, hue:Number = 0, threshold:Number = -1, remove:Boolean = false, addFilter:Boolean = false, index:int = -1) : TweenLiteVars
      {
         var filter:Object = {
            "saturation":saturation,
            "contrast":contrast,
            "brightness":brightness,
            "hue":hue,
            "addFilter":addFilter,
            "remove":remove
         };
         if(colorize != 16777215)
         {
            filter.colorize = colorize;
            filter.amount = amount;
         }
         if(threshold > -1)
         {
            filter.threshold = threshold;
         }
         if(index > -1)
         {
            filter.index = index;
         }
         return this._set("colorMatrixFilter",filter,true);
      }
      
      public function colorTransform(tint:Number = NaN, tintAmount:Number = NaN, exposure:Number = NaN, brightness:Number = NaN, redMultiplier:Number = NaN, greenMultiplier:Number = NaN, blueMultiplier:Number = NaN, alphaMultiplier:Number = NaN, redOffset:Number = NaN, greenOffset:Number = NaN, blueOffset:Number = NaN, alphaOffset:Number = NaN) : TweenLiteVars
      {
         var p:String = null;
         var values:Object = {
            "tint":tint,
            "tintAmount":(isNaN(tint) ? NaN : tintAmount),
            "exposure":exposure,
            "brightness":brightness,
            "redMultiplier":redMultiplier,
            "greenMultiplier":greenMultiplier,
            "blueMultiplier":blueMultiplier,
            "alphaMultiplier":alphaMultiplier,
            "redOffset":redOffset,
            "greenOffset":greenOffset,
            "blueOffset":blueOffset,
            "alphaOffset":alphaOffset
         };
         for(p in values)
         {
            if(isNaN(values[p]))
            {
               delete values[p];
            }
         }
         return this._set("colorTransform",values,true);
      }
      
      public function dropShadowFilter(distance:Number = 4, blurX:Number = 4, blurY:Number = 4, alpha:Number = 1, angle:Number = 45, color:uint = 0, strength:Number = 2, inner:Boolean = false, knockout:Boolean = false, hideObject:Boolean = false, quality:uint = 2, remove:Boolean = false, addFilter:Boolean = false, index:int = -1) : TweenLiteVars
      {
         var filter:Object = {
            "distance":distance,
            "blurX":blurX,
            "blurY":blurY,
            "alpha":alpha,
            "angle":angle,
            "color":color,
            "strength":strength,
            "inner":inner,
            "knockout":knockout,
            "hideObject":hideObject,
            "quality":quality,
            "addFilter":addFilter,
            "remove":remove
         };
         if(index > -1)
         {
            filter.index = index;
         }
         return this._set("dropShadowFilter",filter,true);
      }
      
      public function dynamicProps(props:Object, params:Object = null) : TweenLiteVars
      {
         if(params != null)
         {
            props.params = params;
         }
         return this._set("dynamicProps",props,true);
      }
      
      public function endArray(values:Array) : TweenLiteVars
      {
         return this._set("endArray",values,true);
      }
      
      public function frame(value:int, relative:Boolean = false) : TweenLiteVars
      {
         return this._set("frame",relative ? String(value) : value,true);
      }
      
      public function frameBackward(frame:int) : TweenLiteVars
      {
         return this._set("frameBackward",frame,true);
      }
      
      public function frameForward(frame:int) : TweenLiteVars
      {
         return this._set("frameForward",frame,true);
      }
      
      public function frameLabel(label:String) : TweenLiteVars
      {
         return this._set("frameLabel",label,true);
      }
      
      public function glowFilter(blurX:Number = 10, blurY:Number = 10, color:uint = 16777215, alpha:Number = 1, strength:Number = 2, inner:Boolean = false, knockout:Boolean = false, quality:uint = 2, remove:Boolean = false, addFilter:Boolean = false, index:int = -1) : TweenLiteVars
      {
         var filter:Object = {
            "blurX":blurX,
            "blurY":blurY,
            "color":color,
            "alpha":alpha,
            "strength":strength,
            "inner":inner,
            "knockout":knockout,
            "quality":quality,
            "addFilter":addFilter,
            "remove":remove
         };
         if(index > -1)
         {
            filter.index = index;
         }
         return this._set("glowFilter",filter,true);
      }
      
      public function hexColors(values:Object) : TweenLiteVars
      {
         return this._set("hexColors",values,true);
      }
      
      public function motionBlur(strength:Number = 1, fastMode:Boolean = false, quality:int = 2, padding:int = 10) : TweenLiteVars
      {
         return this._set("motionBlur",{
            "strength":strength,
            "fastMode":fastMode,
            "quality":quality,
            "padding":padding
         },true);
      }
      
      public function orientToBezier(values:Object = null) : TweenLiteVars
      {
         return this._set("orientToBezier",values == null ? true : values,false);
      }
      
      public function physics2D(velocity:Number, angle:Number, acceleration:Number = 0, accelerationAngle:Number = 90, friction:Number = 0) : TweenLiteVars
      {
         return this._set("physics2D",{
            "velocity":velocity,
            "angle":angle,
            "acceleration":acceleration,
            "accelerationAngle":accelerationAngle,
            "friction":friction
         },true);
      }
      
      public function physicsProps(values:Object) : TweenLiteVars
      {
         return this._set("physicsProps",values,true);
      }
      
      public function quaternions(values:Object) : TweenLiteVars
      {
         return this._set("quaternions",values,true);
      }
      
      public function removeTint(remove:Boolean = true) : TweenLiteVars
      {
         return this._set("removeTint",remove,true);
      }
      
      public function scrollRect(props:Object) : TweenLiteVars
      {
         return this._set("scrollRect",props,true);
      }
      
      public function setSize(width:Number = NaN, height:Number = NaN) : TweenLiteVars
      {
         var values:Object = {};
         if(!isNaN(width))
         {
            values.width = width;
         }
         if(!isNaN(height))
         {
            values.height = height;
         }
         return this._set("setSize",values,true);
      }
      
      public function shortRotation(values:Object) : TweenLiteVars
      {
         if(typeof values == "number")
         {
            values = {"rotation":values};
         }
         return this._set("shortRotation",values,true);
      }
      
      public function soundTransform(volume:Number = 1, pan:Number = 0, leftToLeft:Number = 1, leftToRight:Number = 0, rightToLeft:Number = 0, rightToRight:Number = 1) : TweenLiteVars
      {
         return this._set("soundTransform",{
            "volume":volume,
            "pan":pan,
            "leftToLeft":leftToLeft,
            "leftToRight":leftToRight,
            "rightToLeft":rightToLeft,
            "rightToRight":rightToRight
         },true);
      }
      
      public function stageQuality(stage:Stage, during:String = "medium", after:String = null) : TweenLiteVars
      {
         if(after == null)
         {
            after = stage.quality;
         }
         return this._set("stageQuality",{
            "stage":stage,
            "during":during,
            "after":after
         },true);
      }
      
      public function throwProps(props:Object) : TweenLiteVars
      {
         return this._set("throwProps",props,true);
      }
      
      public function tint(color:uint) : TweenLiteVars
      {
         return this._set("tint",color,true);
      }
      
      public function transformAroundCenter(props:Object) : TweenLiteVars
      {
         return this._set("transformAroundCenter",props,true);
      }
      
      public function transformAroundPoint(point:Point, props:Object) : TweenLiteVars
      {
         props.point = point;
         return this._set("transformAroundPoint",props,true);
      }
      
      public function transformMatrix(properties:Object) : TweenLiteVars
      {
         return this._set("transformMatrix",properties,true);
      }
      
      public function visible(value:Boolean) : TweenLiteVars
      {
         return this._set("visible",value,true);
      }
      
      public function volume(volume:Number) : TweenLiteVars
      {
         return this._set("volume",volume,true);
      }
      
      public function get vars() : Object
      {
         return this._vars;
      }
      
      public function get isGSVars() : Boolean
      {
         return true;
      }
   }
}

