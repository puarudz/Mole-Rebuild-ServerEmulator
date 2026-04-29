package com.mole.app.manager
{
   import com.common.data.HashMap;
   import com.core.MainManager;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.newloader.MCLoader;
   import com.event.MCLoadEvent;
   import com.logic.mapEvent.MapEvent;
   import com.mole.app.info.ModuleInfo;
   import com.mole.app.module.AppModuleControl;
   import com.mole.app.module.ModuleEvent;
   import com.mole.app.module.ModuleSubmitScoreEvent;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class ModuleManager
   {
      
      private static var _appModuleHash:HashMap;
      
      private static var _parent:DisplayObjectContainer;
      
      private static var _moduleInfoMap:HashMap;
      
      private static var _eventDispatcher:EventDispatcher;
      
      private static const _obj:Object = new Object();
      
      public static const MOVIE_PATH:String = "resource/movie/";
      
      public static const PANEL_PATH:String = "module/external/";
      
      public static const GAME_PATH:String = "module/game/";
      
      setup();
      
      public function ModuleManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         _appModuleHash = new HashMap();
         _moduleInfoMap = new HashMap();
         BC.addEvent(_obj,GV.onlineSocket,MapEvent.READY_CHANGE_MAP,onReadyChangeMap);
         var resID:uint = DownLoadManager.add("resource/xml/ModuleInfoList.xml",ResType.STRING,true);
         DownLoadManager.addEvent(resID,onLoadGameInfoComplete);
      }
      
      private static function onModuleDestroy(e:ModuleEvent) : void
      {
         iCloseModule(e.id);
      }
      
      private static function onReadyChangeMap(e:Event) : void
      {
         closeAll();
      }
      
      public static function closeAll() : void
      {
         var moduleKey:Object = null;
         var appModuleControl:AppModuleControl = null;
         var moduleArr:Array = _appModuleHash.values;
         for each(appModuleControl in moduleArr)
         {
            if(appModuleControl.autoRemove)
            {
               appModuleControl.destroy();
               moduleKey = _appModuleHash.getKey(appModuleControl);
               _appModuleHash.remove(moduleKey);
            }
         }
      }
      
      public static function openPanel(moduleName:String, data:Object = null, desc:String = "正在加載面板，請耐心等待......", parent:DisplayObjectContainer = null, autoRemove:Boolean = true, isEncryption:Boolean = false) : AppModuleControl
      {
         desc = desc == "" ? "正在加載面板，請耐心等待......" : desc;
         var moduleID:String = PANEL_PATH + moduleName + ".swf";
         if(moduleName == "KFCGoldClaw")
         {
            StatisticsManager.send(318);
         }
         GV.onlineSocket.dispatchEvent(new ModuleEvent(ModuleEvent.LOAD_COMPLETE,moduleName));
         return openModule1(moduleID,moduleID,data,parent,desc,autoRemove,isEncryption);
      }
      
      public static function openGame(moduleName:String, data:Object = null, desc:String = "正在加載遊戲，請耐心等待......", autoRemove:Boolean = true) : AppModuleControl
      {
         desc = desc == "" ? "正在加載遊戲，請耐心等待......" : desc;
         var moduleID:String = GAME_PATH + moduleName + ".swf";
         return openModule1(moduleID,moduleID,data,MainManager.getGameLevel(),desc,autoRemove);
      }
      
      public static function openModule(moduleName:String, data:Object = null, path:String = "", parent:DisplayObjectContainer = null, desc:String = "正在加載模塊，請耐心等待......") : AppModuleControl
      {
         path = path == "" ? MOVIE_PATH : path;
         var moduleID:String = path + moduleName + ".swf";
         return openModule1(moduleID,moduleID,data,parent,desc);
      }
      
      public static function openModule1(moduleID:String, moduleUrl:String, data:Object = null, parent:DisplayObjectContainer = null, desc:String = "正在加載模塊，請耐心等待......", autoRemove:Boolean = true, isEncryption:Boolean = false) : AppModuleControl
      {
         var appModuleControl:AppModuleControl = _appModuleHash.getValue(moduleID);
         if(appModuleControl == null)
         {
            appModuleControl = new AppModuleControl(moduleID,moduleUrl,data,parent,desc,autoRemove,isEncryption);
            _appModuleHash.add(moduleID,appModuleControl);
         }
         else
         {
            appModuleControl.init(data);
         }
         return appModuleControl;
      }
      
      public static function openPanelByMCLoader(moduleName:String, parent:DisplayObjectContainer = null) : void
      {
         _parent = parent;
         var tempMC:MCLoader = new MCLoader(PANEL_PATH + moduleName + ".swf",MainManager.getAppLevel(),1,"請耐心等待......");
         tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,onLoadGameComplete);
         tempMC.doLoad();
      }
      
      private static function onLoadPanelComplete(e:MCLoadEvent) : void
      {
         MCLoader(e.currentTarget).removeEventListener(MCLoadEvent.ON_SUCCESS,onLoadGameComplete);
         if(_parent == null)
         {
            MainManager.getAppLevel().addChild(e.getLoader());
         }
         else
         {
            _parent.addChild(e.getLoader());
            _parent = null;
         }
      }
      
      public static function openGameByMCLoader(moduleName:String, parent:DisplayObjectContainer = null) : void
      {
         _parent = parent;
         var tempMC:MCLoader = new MCLoader(GAME_PATH + moduleName + ".swf",MainManager.getAppLevel(),1,"請耐心等待......");
         tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,onLoadGameComplete);
         tempMC.doLoad();
      }
      
      private static function onLoadGameComplete(e:MCLoadEvent) : void
      {
         var spr:Sprite = null;
         MCLoader(e.currentTarget).removeEventListener(MCLoadEvent.ON_SUCCESS,onLoadGameComplete);
         if(_parent == null)
         {
            spr = new Sprite();
            spr.addChild(e.getLoader());
            MainManager.getAppLevel().addChild(spr);
         }
         else
         {
            _parent.addChild(e.getLoader());
            _parent = null;
         }
      }
      
      public static function closeModuleID(moduleID:Object) : void
      {
         iCloseModule(moduleID);
      }
      
      public static function closePanel(name:String) : void
      {
         ModuleManager.closeModuleID(ModuleManager.PANEL_PATH + name + ".swf");
      }
      
      private static function iCloseModule(moduleID:Object) : void
      {
         var appModuleControl:AppModuleControl = _appModuleHash.remove(moduleID);
         if(Boolean(appModuleControl))
         {
            appModuleControl.destroy();
         }
      }
      
      private static function onLoadGameInfoComplete(e:DownLoadEvent) : void
      {
         var moduleInfo:ModuleInfo = null;
         var xml:XML = null;
         var moduleInfoList:XML = XML(e.data);
         for each(xml in moduleInfoList.children())
         {
            moduleInfo = new ModuleInfo();
            moduleInfo.initXml(xml);
            _moduleInfoMap.add(moduleInfo.id,moduleInfo);
         }
      }
      
      public static function getModuleInfo(moduleID:uint) : ModuleInfo
      {
         return _moduleInfoMap.getValue(moduleID);
      }
      
      private static function getEventDispathcer() : EventDispatcher
      {
         if(_eventDispatcher == null)
         {
            _eventDispatcher = new EventDispatcher();
         }
         return _eventDispatcher;
      }
      
      public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         getEventDispathcer().addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         getEventDispathcer().removeEventListener(type,listener,useCapture);
      }
      
      public static function dispatchEvent(event:Event) : void
      {
         getEventDispathcer().dispatchEvent(event);
      }
      
      public static function hasEventListener(type:String) : Boolean
      {
         return getEventDispathcer().hasEventListener(type);
      }
      
      public static function willTrigger(type:String) : Boolean
      {
         return getEventDispathcer().willTrigger(type);
      }
      
      public static function submitScore(moduleInfo:ModuleInfo) : void
      {
         if(Boolean(moduleInfo) && moduleInfo.id != 0)
         {
            dispatchEvent(new ModuleSubmitScoreEvent(ModuleSubmitScoreEvent.SUBMIT_SCORE,moduleInfo));
         }
      }
   }
}

