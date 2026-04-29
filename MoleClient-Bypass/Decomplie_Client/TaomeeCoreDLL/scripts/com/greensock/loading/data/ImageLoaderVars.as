package com.greensock.loading.data
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.system.LoaderContext;
   
   public class ImageLoaderVars
   {
      
      public static const version:Number = 1.22;
      
      protected var _vars:Object;
      
      public function ImageLoaderVars(vars:Object = null)
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
      
      protected function _set(property:String, value:*) : ImageLoaderVars
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
      
      public function prop(property:String, value:*) : ImageLoaderVars
      {
         return this._set(property,value);
      }
      
      public function autoDispose(value:Boolean) : ImageLoaderVars
      {
         return this._set("autoDispose",value);
      }
      
      public function name(value:String) : ImageLoaderVars
      {
         return this._set("name",value);
      }
      
      public function onCancel(value:Function) : ImageLoaderVars
      {
         return this._set("onCancel",value);
      }
      
      public function onComplete(value:Function) : ImageLoaderVars
      {
         return this._set("onComplete",value);
      }
      
      public function onError(value:Function) : ImageLoaderVars
      {
         return this._set("onError",value);
      }
      
      public function onFail(value:Function) : ImageLoaderVars
      {
         return this._set("onFail",value);
      }
      
      public function onHTTPStatus(value:Function) : ImageLoaderVars
      {
         return this._set("onHTTPStatus",value);
      }
      
      public function onIOError(value:Function) : ImageLoaderVars
      {
         return this._set("onIOError",value);
      }
      
      public function onOpen(value:Function) : ImageLoaderVars
      {
         return this._set("onOpen",value);
      }
      
      public function onProgress(value:Function) : ImageLoaderVars
      {
         return this._set("onProgress",value);
      }
      
      public function requireWithRoot(value:DisplayObject) : ImageLoaderVars
      {
         return this._set("requireWithRoot",value);
      }
      
      public function alternateURL(value:String) : ImageLoaderVars
      {
         return this._set("alternateURL",value);
      }
      
      public function estimatedBytes(value:uint) : ImageLoaderVars
      {
         return this._set("estimatedBytes",value);
      }
      
      public function noCache(value:Boolean) : ImageLoaderVars
      {
         return this._set("noCache",value);
      }
      
      public function allowMalformedURL(value:Boolean) : ImageLoaderVars
      {
         return this._set("allowMalformedURL",value);
      }
      
      public function alpha(value:Number) : ImageLoaderVars
      {
         return this._set("alpha",value);
      }
      
      public function bgAlpha(value:Number) : ImageLoaderVars
      {
         return this._set("bgAlpha",value);
      }
      
      public function bgColor(value:uint) : ImageLoaderVars
      {
         return this._set("bgColor",value);
      }
      
      public function blendMode(value:String) : ImageLoaderVars
      {
         return this._set("blendMode",value);
      }
      
      public function centerRegistration(value:Boolean) : ImageLoaderVars
      {
         return this._set("centerRegistration",value);
      }
      
      public function container(value:DisplayObjectContainer) : ImageLoaderVars
      {
         return this._set("container",value);
      }
      
      public function context(value:LoaderContext) : ImageLoaderVars
      {
         return this._set("context",value);
      }
      
      public function crop(value:Boolean) : ImageLoaderVars
      {
         return this._set("crop",value);
      }
      
      public function hAlign(value:String) : ImageLoaderVars
      {
         return this._set("hAlign",value);
      }
      
      public function height(value:Number) : ImageLoaderVars
      {
         return this._set("height",value);
      }
      
      public function onSecurityError(value:Function) : ImageLoaderVars
      {
         return this._set("onSecurityError",value);
      }
      
      public function rotation(value:Number) : ImageLoaderVars
      {
         return this._set("rotation",value);
      }
      
      public function rotationX(value:Number) : ImageLoaderVars
      {
         return this._set("rotationX",value);
      }
      
      public function rotationY(value:Number) : ImageLoaderVars
      {
         return this._set("rotationY",value);
      }
      
      public function rotationZ(value:Number) : ImageLoaderVars
      {
         return this._set("rotationZ",value);
      }
      
      public function scaleMode(value:String) : ImageLoaderVars
      {
         return this._set("scaleMode",value);
      }
      
      public function scaleX(value:Number) : ImageLoaderVars
      {
         return this._set("scaleX",value);
      }
      
      public function scaleY(value:Number) : ImageLoaderVars
      {
         return this._set("scaleY",value);
      }
      
      public function vAlign(value:String) : ImageLoaderVars
      {
         return this._set("vAlign",value);
      }
      
      public function visible(value:Boolean) : ImageLoaderVars
      {
         return this._set("visible",value);
      }
      
      public function width(value:Number) : ImageLoaderVars
      {
         return this._set("width",value);
      }
      
      public function x(value:Number) : ImageLoaderVars
      {
         return this._set("x",value);
      }
      
      public function y(value:Number) : ImageLoaderVars
      {
         return this._set("y",value);
      }
      
      public function z(value:Number) : ImageLoaderVars
      {
         return this._set("z",value);
      }
      
      public function smoothing(value:Boolean) : ImageLoaderVars
      {
         return this._set("smoothing",value);
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

