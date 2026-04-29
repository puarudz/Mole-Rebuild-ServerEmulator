package com.greensock.loading.data
{
   import flash.display.DisplayObject;
   
   public class LoaderMaxVars
   {
      
      public static const version:Number = 1.1;
      
      protected var _vars:Object;
      
      public function LoaderMaxVars(vars:Object = null)
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
      
      protected function _set(property:String, value:*) : LoaderMaxVars
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
      
      public function prop(property:String, value:*) : LoaderMaxVars
      {
         return this._set(property,value);
      }
      
      public function autoDispose(value:Boolean) : LoaderMaxVars
      {
         return this._set("autoDispose",value);
      }
      
      public function autoLoad(value:Boolean) : LoaderMaxVars
      {
         return this._set("autoLoad",value);
      }
      
      public function name(value:String) : LoaderMaxVars
      {
         return this._set("name",value);
      }
      
      public function onCancel(value:Function) : LoaderMaxVars
      {
         return this._set("onCancel",value);
      }
      
      public function onComplete(value:Function) : LoaderMaxVars
      {
         return this._set("onComplete",value);
      }
      
      public function onError(value:Function) : LoaderMaxVars
      {
         return this._set("onError",value);
      }
      
      public function onFail(value:Function) : LoaderMaxVars
      {
         return this._set("onFail",value);
      }
      
      public function onHTTPStatus(value:Function) : LoaderMaxVars
      {
         return this._set("onHTTPStatus",value);
      }
      
      public function onIOError(value:Function) : LoaderMaxVars
      {
         return this._set("onIOError",value);
      }
      
      public function onOpen(value:Function) : LoaderMaxVars
      {
         return this._set("onOpen",value);
      }
      
      public function onProgress(value:Function) : LoaderMaxVars
      {
         return this._set("onProgress",value);
      }
      
      public function requireWithRoot(value:DisplayObject) : LoaderMaxVars
      {
         return this._set("requireWithRoot",value);
      }
      
      public function auditSize(value:Boolean) : LoaderMaxVars
      {
         return this._set("auditSize",value);
      }
      
      public function maxConnections(value:uint) : LoaderMaxVars
      {
         return this._set("maxConnections",value);
      }
      
      public function skipFailed(value:Boolean) : LoaderMaxVars
      {
         return this._set("skipFailed",value);
      }
      
      public function skipPaused(value:Boolean) : LoaderMaxVars
      {
         return this._set("skipPaused",value);
      }
      
      public function loaders(value:Array) : LoaderMaxVars
      {
         return this._set("loaders",value);
      }
      
      public function onChildOpen(value:Function) : LoaderMaxVars
      {
         return this._set("onChildOpen",value);
      }
      
      public function onChildProgress(value:Function) : LoaderMaxVars
      {
         return this._set("onChildProgress",value);
      }
      
      public function onChildComplete(value:Function) : LoaderMaxVars
      {
         return this._set("onChildComplete",value);
      }
      
      public function onChildCancel(value:Function) : LoaderMaxVars
      {
         return this._set("onChildCancel",value);
      }
      
      public function onChildFail(value:Function) : LoaderMaxVars
      {
         return this._set("onChildFail",value);
      }
      
      public function onScriptAccessDenied(value:Function) : LoaderMaxVars
      {
         return this._set("onScriptAccessDenied",value);
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

