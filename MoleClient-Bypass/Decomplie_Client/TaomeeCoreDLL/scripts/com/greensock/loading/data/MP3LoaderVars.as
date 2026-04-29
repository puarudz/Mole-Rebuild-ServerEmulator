package com.greensock.loading.data
{
   import flash.display.DisplayObject;
   import flash.media.SoundLoaderContext;
   
   public class MP3LoaderVars
   {
      
      public static const version:Number = 1.2;
      
      protected var _vars:Object;
      
      public function MP3LoaderVars(vars:Object = null)
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
      
      protected function _set(property:String, value:*) : MP3LoaderVars
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
      
      public function prop(property:String, value:*) : MP3LoaderVars
      {
         return this._set(property,value);
      }
      
      public function autoDispose(value:Boolean) : MP3LoaderVars
      {
         return this._set("autoDispose",value);
      }
      
      public function name(value:String) : MP3LoaderVars
      {
         return this._set("name",value);
      }
      
      public function onCancel(value:Function) : MP3LoaderVars
      {
         return this._set("onCancel",value);
      }
      
      public function onComplete(value:Function) : MP3LoaderVars
      {
         return this._set("onComplete",value);
      }
      
      public function onError(value:Function) : MP3LoaderVars
      {
         return this._set("onError",value);
      }
      
      public function onFail(value:Function) : MP3LoaderVars
      {
         return this._set("onFail",value);
      }
      
      public function onHTTPStatus(value:Function) : MP3LoaderVars
      {
         return this._set("onHTTPStatus",value);
      }
      
      public function onIOError(value:Function) : MP3LoaderVars
      {
         return this._set("onIOError",value);
      }
      
      public function onOpen(value:Function) : MP3LoaderVars
      {
         return this._set("onOpen",value);
      }
      
      public function onProgress(value:Function) : MP3LoaderVars
      {
         return this._set("onProgress",value);
      }
      
      public function requireWithRoot(value:DisplayObject) : MP3LoaderVars
      {
         return this._set("requireWithRoot",value);
      }
      
      public function alternateURL(value:String) : MP3LoaderVars
      {
         return this._set("alternateURL",value);
      }
      
      public function estimatedBytes(value:uint) : MP3LoaderVars
      {
         return this._set("estimatedBytes",value);
      }
      
      public function noCache(value:Boolean) : MP3LoaderVars
      {
         return this._set("noCache",value);
      }
      
      public function allowMalformedURL(value:Boolean) : MP3LoaderVars
      {
         return this._set("allowMalformedURL",value);
      }
      
      public function autoPlay(value:Boolean) : MP3LoaderVars
      {
         return this._set("autoPlay",value);
      }
      
      public function repeat(value:int) : MP3LoaderVars
      {
         return this._set("repeat",value);
      }
      
      public function volume(value:Number) : MP3LoaderVars
      {
         return this._set("volume",value);
      }
      
      public function context(value:SoundLoaderContext) : MP3LoaderVars
      {
         return this._set("context",value);
      }
      
      public function initThreshold(value:uint) : MP3LoaderVars
      {
         return this._set("initThreshold",value);
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

