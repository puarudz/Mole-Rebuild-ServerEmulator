package com.greensock.loading.data
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.system.LoaderContext;
   
   public class SWFLoaderVars
   {
      
      public static const version:Number = 1.23;
      
      protected var _vars:Object;
      
      public function SWFLoaderVars(vars:Object = null)
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
      
      protected function _set(property:String, value:*) : SWFLoaderVars
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
      
      public function prop(property:String, value:*) : SWFLoaderVars
      {
         return this._set(property,value);
      }
      
      public function autoDispose(value:Boolean) : SWFLoaderVars
      {
         return this._set("autoDispose",value);
      }
      
      public function name(value:String) : SWFLoaderVars
      {
         return this._set("name",value);
      }
      
      public function onCancel(value:Function) : SWFLoaderVars
      {
         return this._set("onCancel",value);
      }
      
      public function onComplete(value:Function) : SWFLoaderVars
      {
         return this._set("onComplete",value);
      }
      
      public function onError(value:Function) : SWFLoaderVars
      {
         return this._set("onError",value);
      }
      
      public function onFail(value:Function) : SWFLoaderVars
      {
         return this._set("onFail",value);
      }
      
      public function onHTTPStatus(value:Function) : SWFLoaderVars
      {
         return this._set("onHTTPStatus",value);
      }
      
      public function onIOError(value:Function) : SWFLoaderVars
      {
         return this._set("onIOError",value);
      }
      
      public function onOpen(value:Function) : SWFLoaderVars
      {
         return this._set("onOpen",value);
      }
      
      public function onProgress(value:Function) : SWFLoaderVars
      {
         return this._set("onProgress",value);
      }
      
      public function requireWithRoot(value:DisplayObject) : SWFLoaderVars
      {
         return this._set("requireWithRoot",value);
      }
      
      public function alternateURL(value:String) : SWFLoaderVars
      {
         return this._set("alternateURL",value);
      }
      
      public function estimatedBytes(value:uint) : SWFLoaderVars
      {
         return this._set("estimatedBytes",value);
      }
      
      public function noCache(value:Boolean) : SWFLoaderVars
      {
         return this._set("noCache",value);
      }
      
      public function allowMalformedURL(value:Boolean) : SWFLoaderVars
      {
         return this._set("allowMalformedURL",value);
      }
      
      public function alpha(value:Number) : SWFLoaderVars
      {
         return this._set("alpha",value);
      }
      
      public function bgAlpha(value:Number) : SWFLoaderVars
      {
         return this._set("bgAlpha",value);
      }
      
      public function bgColor(value:uint) : SWFLoaderVars
      {
         return this._set("bgColor",value);
      }
      
      public function blendMode(value:String) : SWFLoaderVars
      {
         return this._set("blendMode",value);
      }
      
      public function centerRegistration(value:Boolean) : SWFLoaderVars
      {
         return this._set("centerRegistration",value);
      }
      
      public function container(value:DisplayObjectContainer) : SWFLoaderVars
      {
         return this._set("container",value);
      }
      
      public function context(value:LoaderContext) : SWFLoaderVars
      {
         return this._set("context",value);
      }
      
      public function crop(value:Boolean) : SWFLoaderVars
      {
         return this._set("crop",value);
      }
      
      public function hAlign(value:String) : SWFLoaderVars
      {
         return this._set("hAlign",value);
      }
      
      public function height(value:Number) : SWFLoaderVars
      {
         return this._set("height",value);
      }
      
      public function onSecurityError(value:Function) : SWFLoaderVars
      {
         return this._set("onSecurityError",value);
      }
      
      public function rotation(value:Number) : SWFLoaderVars
      {
         return this._set("rotation",value);
      }
      
      public function rotationX(value:Number) : SWFLoaderVars
      {
         return this._set("rotationX",value);
      }
      
      public function rotationY(value:Number) : SWFLoaderVars
      {
         return this._set("rotationY",value);
      }
      
      public function rotationZ(value:Number) : SWFLoaderVars
      {
         return this._set("rotationZ",value);
      }
      
      public function scaleMode(value:String) : SWFLoaderVars
      {
         return this._set("scaleMode",value);
      }
      
      public function scaleX(value:Number) : SWFLoaderVars
      {
         return this._set("scaleX",value);
      }
      
      public function scaleY(value:Number) : SWFLoaderVars
      {
         return this._set("scaleY",value);
      }
      
      public function vAlign(value:String) : SWFLoaderVars
      {
         return this._set("vAlign",value);
      }
      
      public function visible(value:Boolean) : SWFLoaderVars
      {
         return this._set("visible",value);
      }
      
      public function width(value:Number) : SWFLoaderVars
      {
         return this._set("width",value);
      }
      
      public function x(value:Number) : SWFLoaderVars
      {
         return this._set("x",value);
      }
      
      public function y(value:Number) : SWFLoaderVars
      {
         return this._set("y",value);
      }
      
      public function z(value:Number) : SWFLoaderVars
      {
         return this._set("z",value);
      }
      
      public function autoPlay(value:Boolean) : SWFLoaderVars
      {
         return this._set("autoPlay",value);
      }
      
      public function integrateProgress(value:Boolean) : SWFLoaderVars
      {
         return this._set("integrateProgress",value);
      }
      
      public function onInit(value:Function) : SWFLoaderVars
      {
         return this._set("onInit",value);
      }
      
      public function onChildOpen(value:Function) : SWFLoaderVars
      {
         return this._set("onChildOpen",value);
      }
      
      public function onChildProgress(value:Function) : SWFLoaderVars
      {
         return this._set("onChildProgress",value);
      }
      
      public function onChildComplete(value:Function) : SWFLoaderVars
      {
         return this._set("onChildComplete",value);
      }
      
      public function onChildCancel(value:Function) : SWFLoaderVars
      {
         return this._set("onChildCancel",value);
      }
      
      public function onChildFail(value:Function) : SWFLoaderVars
      {
         return this._set("onChildFail",value);
      }
      
      public function onUncaughtError(value:Function) : SWFLoaderVars
      {
         return this._set("onUncaughtError",value);
      }
      
      public function suppressInitReparentEvents(value:Boolean) : SWFLoaderVars
      {
         return this._set("suppressInitReparentEvents",value);
      }
      
      public function suppressUncaughtErrors(value:Boolean) : SWFLoaderVars
      {
         return this._set("suppressUncaughtErrors",value);
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

