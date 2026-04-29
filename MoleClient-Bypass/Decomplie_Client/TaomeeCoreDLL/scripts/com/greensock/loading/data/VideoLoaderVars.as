package com.greensock.loading.data
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   
   public class VideoLoaderVars
   {
      
      public static const version:Number = 1.23;
      
      protected var _vars:Object;
      
      public function VideoLoaderVars(vars:Object = null)
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
      }
      
      protected function _set(property:String, value:*) : VideoLoaderVars
      {
         if(value == null)
         {
            delete this._vars[property];
         }
         else
         {
            this._vars[property] = value;
         }
         return this;
      }
      
      public function prop(property:String, value:*) : VideoLoaderVars
      {
         return this._set(property,value);
      }
      
      public function autoDispose(value:Boolean) : VideoLoaderVars
      {
         return this._set("autoDispose",value);
      }
      
      public function name(value:String) : VideoLoaderVars
      {
         return this._set("name",value);
      }
      
      public function onCancel(value:Function) : VideoLoaderVars
      {
         return this._set("onCancel",value);
      }
      
      public function onComplete(value:Function) : VideoLoaderVars
      {
         return this._set("onComplete",value);
      }
      
      public function onError(value:Function) : VideoLoaderVars
      {
         return this._set("onError",value);
      }
      
      public function onFail(value:Function) : VideoLoaderVars
      {
         return this._set("onFail",value);
      }
      
      public function onHTTPStatus(value:Function) : VideoLoaderVars
      {
         return this._set("onHTTPStatus",value);
      }
      
      public function onInit(value:Function) : VideoLoaderVars
      {
         return this._set("onInit",value);
      }
      
      public function onIOError(value:Function) : VideoLoaderVars
      {
         return this._set("onIOError",value);
      }
      
      public function onOpen(value:Function) : VideoLoaderVars
      {
         return this._set("onOpen",value);
      }
      
      public function onProgress(value:Function) : VideoLoaderVars
      {
         return this._set("onProgress",value);
      }
      
      public function requireWithRoot(value:DisplayObject) : VideoLoaderVars
      {
         return this._set("requireWithRoot",value);
      }
      
      public function alternateURL(value:String) : VideoLoaderVars
      {
         return this._set("alternateURL",value);
      }
      
      public function estimatedBytes(value:uint) : VideoLoaderVars
      {
         return this._set("estimatedBytes",value);
      }
      
      public function noCache(value:Boolean) : VideoLoaderVars
      {
         return this._set("noCache",value);
      }
      
      public function allowMalformedURL(value:Boolean) : VideoLoaderVars
      {
         return this._set("allowMalformedURL",value);
      }
      
      public function alpha(value:Number) : VideoLoaderVars
      {
         return this._set("alpha",value);
      }
      
      public function bgAlpha(value:Number) : VideoLoaderVars
      {
         return this._set("bgAlpha",value);
      }
      
      public function bgColor(value:uint) : VideoLoaderVars
      {
         return this._set("bgColor",value);
      }
      
      public function blendMode(value:String) : VideoLoaderVars
      {
         return this._set("blendMode",value);
      }
      
      public function centerRegistration(value:Boolean) : VideoLoaderVars
      {
         return this._set("centerRegistration",value);
      }
      
      public function container(value:DisplayObjectContainer) : VideoLoaderVars
      {
         return this._set("container",value);
      }
      
      public function crop(value:Boolean) : VideoLoaderVars
      {
         return this._set("crop",value);
      }
      
      public function hAlign(value:String) : VideoLoaderVars
      {
         return this._set("hAlign",value);
      }
      
      public function height(value:Number) : VideoLoaderVars
      {
         return this._set("height",value);
      }
      
      public function onSecurityError(value:Function) : VideoLoaderVars
      {
         return this._set("onSecurityError",value);
      }
      
      public function rotation(value:Number) : VideoLoaderVars
      {
         return this._set("rotation",value);
      }
      
      public function rotationX(value:Number) : VideoLoaderVars
      {
         return this._set("rotationX",value);
      }
      
      public function rotationY(value:Number) : VideoLoaderVars
      {
         return this._set("rotationY",value);
      }
      
      public function rotationZ(value:Number) : VideoLoaderVars
      {
         return this._set("rotationZ",value);
      }
      
      public function scaleMode(value:String) : VideoLoaderVars
      {
         return this._set("scaleMode",value);
      }
      
      public function scaleX(value:Number) : VideoLoaderVars
      {
         return this._set("scaleX",value);
      }
      
      public function scaleY(value:Number) : VideoLoaderVars
      {
         return this._set("scaleY",value);
      }
      
      public function vAlign(value:String) : VideoLoaderVars
      {
         return this._set("vAlign",value);
      }
      
      public function visible(value:Boolean) : VideoLoaderVars
      {
         return this._set("visible",value);
      }
      
      public function width(value:Number) : VideoLoaderVars
      {
         return this._set("width",value);
      }
      
      public function x(value:Number) : VideoLoaderVars
      {
         return this._set("x",value);
      }
      
      public function y(value:Number) : VideoLoaderVars
      {
         return this._set("y",value);
      }
      
      public function z(value:Number) : VideoLoaderVars
      {
         return this._set("z",value);
      }
      
      public function autoAdjustBuffer(value:Boolean) : VideoLoaderVars
      {
         return this._set("autoAdjustBuffer",value);
      }
      
      public function autoDetachNetStream(value:Boolean) : VideoLoaderVars
      {
         return this._set("autoDetachNetStream",value);
      }
      
      public function autoPlay(value:Boolean) : VideoLoaderVars
      {
         return this._set("autoPlay",value);
      }
      
      public function bufferMode(value:Boolean) : VideoLoaderVars
      {
         return this._set("bufferMode",value);
      }
      
      public function bufferTime(value:Number) : VideoLoaderVars
      {
         return this._set("bufferTime",value);
      }
      
      public function checkPolicyFile(value:Boolean) : VideoLoaderVars
      {
         return this._set("checkPolicyFile",value);
      }
      
      public function deblocking(value:int) : VideoLoaderVars
      {
         return this._set("deblocking",value);
      }
      
      public function estimatedDuration(value:Number) : VideoLoaderVars
      {
         return this._set("estimatedDuration",value);
      }
      
      public function repeat(value:int) : VideoLoaderVars
      {
         return this._set("repeat",value);
      }
      
      public function smoothing(value:Boolean) : VideoLoaderVars
      {
         return this._set("smoothing",value);
      }
      
      public function volume(value:Number) : VideoLoaderVars
      {
         return this._set("volume",value);
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

