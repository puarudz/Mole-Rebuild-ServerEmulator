package com.greensock.loading.data
{
   import flash.display.DisplayObject;
   
   public class CSSLoaderVars
   {
      
      public static const version:Number = 1.2;
      
      protected var _vars:Object;
      
      public function CSSLoaderVars(vars:Object = null)
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
      
      protected function _set(property:String, value:*) : CSSLoaderVars
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
      
      public function prop(property:String, value:*) : CSSLoaderVars
      {
         return this._set(property,value);
      }
      
      public function autoDispose(value:Boolean) : CSSLoaderVars
      {
         return this._set("autoDispose",value);
      }
      
      public function name(value:String) : CSSLoaderVars
      {
         return this._set("name",value);
      }
      
      public function onCancel(value:Function) : CSSLoaderVars
      {
         return this._set("onCancel",value);
      }
      
      public function onComplete(value:Function) : CSSLoaderVars
      {
         return this._set("onComplete",value);
      }
      
      public function onError(value:Function) : CSSLoaderVars
      {
         return this._set("onError",value);
      }
      
      public function onFail(value:Function) : CSSLoaderVars
      {
         return this._set("onFail",value);
      }
      
      public function onHTTPStatus(value:Function) : CSSLoaderVars
      {
         return this._set("onHTTPStatus",value);
      }
      
      public function onIOError(value:Function) : CSSLoaderVars
      {
         return this._set("onIOError",value);
      }
      
      public function onOpen(value:Function) : CSSLoaderVars
      {
         return this._set("onOpen",value);
      }
      
      public function onProgress(value:Function) : CSSLoaderVars
      {
         return this._set("onProgress",value);
      }
      
      public function requireWithRoot(value:DisplayObject) : CSSLoaderVars
      {
         return this._set("requireWithRoot",value);
      }
      
      public function alternateURL(value:String) : CSSLoaderVars
      {
         return this._set("alternateURL",value);
      }
      
      public function estimatedBytes(value:uint) : CSSLoaderVars
      {
         return this._set("estimatedBytes",value);
      }
      
      public function noCache(value:Boolean) : CSSLoaderVars
      {
         return this._set("noCache",value);
      }
      
      public function allowMalformedURL(value:Boolean) : CSSLoaderVars
      {
         return this._set("allowMalformedURL",value);
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

