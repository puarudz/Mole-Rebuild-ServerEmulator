package com.greensock.loading.data
{
   import flash.display.DisplayObject;
   
   public class XMLLoaderVars
   {
      
      public static const version:Number = 1.22;
      
      protected var _vars:Object;
      
      public function XMLLoaderVars(vars:Object = null)
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
      
      protected function _set(property:String, value:*) : XMLLoaderVars
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
      
      public function prop(property:String, value:*) : XMLLoaderVars
      {
         return this._set(property,value);
      }
      
      public function autoDispose(value:Boolean) : XMLLoaderVars
      {
         return this._set("autoDispose",value);
      }
      
      public function name(value:String) : XMLLoaderVars
      {
         return this._set("name",value);
      }
      
      public function onCancel(value:Function) : XMLLoaderVars
      {
         return this._set("onCancel",value);
      }
      
      public function onComplete(value:Function) : XMLLoaderVars
      {
         return this._set("onComplete",value);
      }
      
      public function onError(value:Function) : XMLLoaderVars
      {
         return this._set("onError",value);
      }
      
      public function onFail(value:Function) : XMLLoaderVars
      {
         return this._set("onFail",value);
      }
      
      public function onHTTPStatus(value:Function) : XMLLoaderVars
      {
         return this._set("onHTTPStatus",value);
      }
      
      public function onIOError(value:Function) : XMLLoaderVars
      {
         return this._set("onIOError",value);
      }
      
      public function onOpen(value:Function) : XMLLoaderVars
      {
         return this._set("onOpen",value);
      }
      
      public function onProgress(value:Function) : XMLLoaderVars
      {
         return this._set("onProgress",value);
      }
      
      public function requireWithRoot(value:DisplayObject) : XMLLoaderVars
      {
         return this._set("requireWithRoot",value);
      }
      
      public function alternateURL(value:String) : XMLLoaderVars
      {
         return this._set("alternateURL",value);
      }
      
      public function estimatedBytes(value:uint) : XMLLoaderVars
      {
         return this._set("estimatedBytes",value);
      }
      
      public function noCache(value:Boolean) : XMLLoaderVars
      {
         return this._set("noCache",value);
      }
      
      public function allowMalformedURL(value:Boolean) : XMLLoaderVars
      {
         return this._set("allowMalformedURL",value);
      }
      
      public function integrateProgress(value:Boolean) : XMLLoaderVars
      {
         return this._set("integrateProgress",value);
      }
      
      public function maxConnections(value:uint) : XMLLoaderVars
      {
         return this._set("maxConnections",value);
      }
      
      public function onChildOpen(value:Function) : XMLLoaderVars
      {
         return this._set("onChildOpen",value);
      }
      
      public function onChildProgress(value:Function) : XMLLoaderVars
      {
         return this._set("onChildProgress",value);
      }
      
      public function onChildComplete(value:Function) : XMLLoaderVars
      {
         return this._set("onChildComplete",value);
      }
      
      public function onChildCancel(value:Function) : XMLLoaderVars
      {
         return this._set("onChildCancel",value);
      }
      
      public function onChildFail(value:Function) : XMLLoaderVars
      {
         return this._set("onChildFail",value);
      }
      
      public function onInit(value:Function) : XMLLoaderVars
      {
         return this._set("onInit",value);
      }
      
      public function onRawLoad(value:Function) : XMLLoaderVars
      {
         return this._set("onRawLoad",value);
      }
      
      public function prependURLs(value:String) : XMLLoaderVars
      {
         return this._set("prependURLs",value);
      }
      
      public function recursivePrependURLs(value:String) : XMLLoaderVars
      {
         return this._set("recursivePrependURLs",value);
      }
      
      public function skipFailed(value:Boolean) : XMLLoaderVars
      {
         return this._set("skipFailed",value);
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

