package com.mole.app.module
{
   import com.core.MainManager;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.mole.app.info.ModuleInfo;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.ui.InfoBox;
   import com.mole.app.ui.LoadingPanel;
   import com.mole.debug.DebugManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.system.LoaderContext;
   import flash.system.trace;
   import flash.utils.ByteArray;
   
   public class AppModuleControl extends EventDispatcher
   {
      
      private var _id:Object;
      
      private var _url:String;
      
      private var _data:Object;
      
      private var _parent:DisplayObjectContainer;
      
      private var _autoRemove:Boolean;
      
      private var _appLoader:Loader;
      
      private var _appModule:AppModuleBase;
      
      private var _resID:uint;
      
      public function AppModuleControl(id:Object, url:String, data:Object, parent:DisplayObjectContainer = null, desc:String = "正在加載面板。", autoRemove:Boolean = true, isEncryption:Boolean = false)
      {
         super();
         this._id = id;
         this._url = url;
         this._data = data;
         this._parent = parent == null ? MainManager.getAppLevel() : parent;
         this._autoRemove = autoRemove;
         if(!isEncryption)
         {
            this._resID = DownLoadManager.add(this._url,ResType.DISPLAY_OBJECT,true,desc);
            DownLoadManager.addEvent(this._resID,this.onLoaderModuleSucceed,null,null,this.onLoaderModuleFail);
         }
         else
         {
            this._resID = DownLoadManager.add(this._url,ResType.STRING,true,desc);
            DownLoadManager.addEvent(this._resID,this.onLoaderByteSucced,null,null,this.onLoaderModuleFail);
         }
         LoadingPanel.addRes(this._resID);
      }
      
      private function onLoaderByteSucced(e:DownLoadEvent) : void
      {
         var byteArr:ByteArray = e.data as ByteArray;
         this._appLoader = new Loader();
         this._appLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaderComplete);
         var context:LoaderContext = new LoaderContext(false);
         var afterByte:ByteArray = new ByteArray();
         trace(byteArr,afterByte);
         this._appLoader.loadBytes(afterByte,context);
      }
      
      private function onLoaderComplete(evt:Event) : void
      {
         this._appLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoaderComplete);
         var e:DownLoadEvent = new DownLoadEvent("",null,this._appLoader.content,this._appLoader);
         this.onLoaderModuleSucceed(e);
      }
      
      private function onLoaderModuleSucceed(e:DownLoadEvent) : void
      {
         this._appLoader = e.loader;
         this._appModule = e.data as AppModuleBase;
         if(Boolean(this._appModule))
         {
            dispatchEvent(new ModuleEvent(ModuleEvent.LOAD_PRECOMPLETE,this._id));
            this._parent.addChild(this._appModule);
            this._appModule.addEventListener(ModuleEvent.DESTROY,this.onCloseModule);
            this._appModule.init(this._data);
            dispatchEvent(new ModuleEvent(ModuleEvent.LOAD_COMPLETE,this._id));
         }
         else
         {
            if(DebugManager.DEBUG)
            {
               InfoBox.show("模塊初始化失敗:URL-->" + this._url);
            }
            this.close();
         }
      }
      
      private function onLoaderModuleFail(e:DownLoadEvent) : void
      {
         InfoBox.show("加載模塊失敗。");
         this.close();
      }
      
      private function onCloseModule(e:ModuleEvent) : void
      {
         this.close();
      }
      
      public function close() : void
      {
         ModuleManager.closeModuleID(this._id);
      }
      
      public function destroy() : void
      {
         var moduleInfo:ModuleInfo = null;
         var resultData:Object = null;
         DownLoadManager.remove(this._resID);
         if(Boolean(this._appModule))
         {
            moduleInfo = ModuleManager.getModuleInfo(this._appModule.gameID);
            resultData = this._appModule.resultData;
            if(Boolean(moduleInfo))
            {
               moduleInfo.score = Number(resultData);
            }
            this._appModule.removeEventListener(ModuleEvent.DESTROY,this.onCloseModule);
            this._appModule.destroy();
         }
         if(Boolean(this._appLoader))
         {
            this._appLoader.unload();
         }
         LoadingPanel.hide();
         dispatchEvent(new ModuleEvent(ModuleEvent.DESTROY,this._id,resultData));
         ModuleManager.submitScore(moduleInfo);
      }
      
      public function init(data:Object) : void
      {
         if(Boolean(this._appModule))
         {
            this._appModule.init(data);
         }
      }
      
      public function get id() : Object
      {
         return this._id;
      }
      
      public function get appModule() : AppModuleBase
      {
         return this._appModule;
      }
      
      public function removeCloseEvent() : void
      {
         if(Boolean(this._appModule))
         {
            this._appModule.removeEventListener(ModuleEvent.DESTROY,this.onCloseModule);
         }
      }
      
      public function get autoRemove() : Boolean
      {
         return this._autoRemove;
      }
   }
}

