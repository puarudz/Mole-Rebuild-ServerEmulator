package com.core.newloader
{
   import com.event.MCLoadEvent;
   import com.mole.debug.DebugManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   [Event(name="error",type="com.event.MCLoadEvent")]
   [Event(name="onSuccess",type="com.event.MCLoadEvent")]
   public class BaseMCLoader extends EventDispatcher
   {
      
      protected var _parentMC:DisplayObjectContainer;
      
      private var _url:String;
      
      protected var _loader:Loader;
      
      protected var _contentLoaderInfo:LoaderInfo;
      
      private var _isCurrentApp:Boolean;
      
      public function BaseMCLoader(url:String, parentMC:DisplayObjectContainer = null, isCurrentApp:Boolean = false)
      {
         super();
         this._isCurrentApp = isCurrentApp;
         this._url = url;
         this._parentMC = parentMC;
         this._loader = new Loader();
         this._contentLoaderInfo = this._loader.contentLoaderInfo;
      }
      
      public function initEvent() : void
      {
      }
      
      public function doLoad(newURL:String = "") : void
      {
         this._url = newURL == "" ? this._url : newURL;
         if(Boolean(this._url))
         {
            this.load(VL.getURLRequest(this._url));
         }
         else if(DebugManager.DEBUG)
         {
            throw new Error("加載的URL為空，請檢查後重試");
         }
      }
      
      public function load(urlRequest:URLRequest = null) : void
      {
         var context:LoaderContext = null;
         if(urlRequest == null)
         {
            this.doLoad();
         }
         else
         {
            if(this._isCurrentApp)
            {
               context = new LoaderContext(false,ApplicationDomain.currentDomain);
            }
            this._contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
            this._contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadFail);
            this._loader.load(urlRequest,context);
            this.initEvent();
         }
      }
      
      protected function onLoadComplete(evt:Event) : void
      {
         dispatchEvent(new MCLoadEvent(MCLoadEvent.ON_SUCCESS,this));
         this.clear();
      }
      
      protected function onLoadFail(evt:IOErrorEvent) : void
      {
         dispatchEvent(new MCLoadEvent(MCLoadEvent.ERROR,this));
         this.destroy();
      }
      
      public function clear() : void
      {
         if(Boolean(this._contentLoaderInfo))
         {
            this._contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
            this._contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadFail);
         }
      }
      
      public function destroy() : void
      {
         this.clear();
         this._contentLoaderInfo = null;
         this._parentMC = null;
         this._loader = null;
      }
      
      public function close() : void
      {
         if(Boolean(this._loader))
         {
            this._loader.close();
         }
      }
      
      public function setParentMC(i:DisplayObjectContainer) : void
      {
         this._parentMC = i;
      }
      
      public function getParent() : DisplayObjectContainer
      {
         return this._parentMC;
      }
      
      public function get loader() : Loader
      {
         return this._loader;
      }
      
      public function get parentContainer() : DisplayObjectContainer
      {
         return this._parentMC;
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function get contentLoaderInfo() : LoaderInfo
      {
         return this._contentLoaderInfo;
      }
   }
}

