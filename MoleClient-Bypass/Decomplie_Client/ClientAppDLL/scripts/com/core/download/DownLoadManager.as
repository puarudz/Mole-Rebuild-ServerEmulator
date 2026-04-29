package com.core.download
{
   import com.common.data.HashMap;
   import com.mole.debug.DebugManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.system.ApplicationDomain;
   
   public class DownLoadManager
   {
      
      private static var _loaderHash:HashMap;
      
      private static var _eventHash:HashMap;
      
      private static var _eventDispatcher:EventDispatcher;
      
      private static var _resIdx:uint = 0;
      
      setup();
      
      public function DownLoadManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         _loaderHash = new HashMap();
         _eventHash = new HashMap();
         addEventListener(DownLoadEvent.OPEN,onLoaderOpen);
         addEventListener(DownLoadEvent.PROGRESS,onLoaderProgress);
         addEventListener(DownLoadEvent.COMPLETE,onLoaderComplete);
         addEventListener(DownLoadEvent.ERROR,onLoaderError);
      }
      
      private static function onLoaderOpen(e:DownLoadEvent) : void
      {
         var resID:uint = e.resInfo.resId;
         var eventInfo:DownloadEventInfo = _eventHash.getValue(resID);
         if(Boolean(eventInfo) && eventInfo.openFun != null)
         {
            eventInfo.openFun(e);
         }
      }
      
      private static function onLoaderProgress(e:DownLoadEvent) : void
      {
         var resID:uint = e.resInfo.resId;
         var eventInfo:DownloadEventInfo = _eventHash.getValue(resID);
         if(Boolean(eventInfo) && eventInfo.progressFun != null)
         {
            eventInfo.progressFun(e);
         }
      }
      
      private static function onLoaderComplete(e:DownLoadEvent) : void
      {
         var resID:uint = e.resInfo.resId;
         var eventInfo:DownloadEventInfo = _eventHash.remove(resID);
         if(Boolean(eventInfo) && eventInfo.completeFun != null)
         {
            eventInfo.completeFun(e);
         }
      }
      
      private static function onLoaderError(e:DownLoadEvent) : void
      {
         var resID:uint = e.resInfo.resId;
         var eventInfo:DownloadEventInfo = _eventHash.remove(resID);
         if(Boolean(eventInfo) && eventInfo.errorFun != null)
         {
            eventInfo.errorFun(e);
         }
      }
      
      public static function add(url:String, type:String, isKey:Boolean = false, desc:String = "Loading...", appDomain:ApplicationDomain = null, data:* = null, errMsg:String = "") : uint
      {
         var resLoadInfo:ResLoadInfo = new ResLoadInfo(++_resIdx,url,type,desc,isKey,appDomain,data,errMsg);
         loadNextRes(resLoadInfo);
         return _resIdx;
      }
      
      public static function remove(resId:uint) : void
      {
         var resLoader:ResLoader = _loaderHash.remove(resId);
         if(Boolean(resLoader))
         {
            dispatchEvent(new DownLoadEvent(DownLoadEvent.CANCEL,resLoader.resInfo));
            dispatchEvent(new DownLoadEvent(DownLoadEvent.ERROR,resLoader.resInfo));
            resLoader.destroy();
         }
         _eventHash.remove(resId);
      }
      
      public static function addEvent(resID:uint, completeFun:Function = null, openFun:Function = null, progressFun:Function = null, errorFun:Function = null) : void
      {
         var eventInfo:DownloadEventInfo = new DownloadEventInfo(resID,openFun,progressFun,completeFun,errorFun);
         _eventHash.add(resID,eventInfo);
      }
      
      public static function addNextEvent(completeFun:Function = null, openFun:Function = null, progressFun:Function = null, errorFun:Function = null) : void
      {
         var eventInfo:DownloadEventInfo = new DownloadEventInfo(_resIdx,openFun,progressFun,completeFun,errorFun);
         _eventHash.add(_resIdx,eventInfo);
      }
      
      private static function loadNextRes(resInfo:ResLoadInfo) : void
      {
         var resLoader:ResLoader = new ResLoader();
         resLoader.addEventListener(DownLoadEvent.OPEN,onResOpen);
         resLoader.addEventListener(DownLoadEvent.PROGRESS,onResProgress);
         resLoader.addEventListener(DownLoadEvent.COMPLETE,onResComplete);
         resLoader.addEventListener(DownLoadEvent.ERROR,onResError);
         _loaderHash.add(resInfo.resId,resLoader);
         resLoader.load(resInfo);
      }
      
      private static function onResError(e:DownLoadEvent) : void
      {
         var resInfo:ResLoadInfo = null;
         _loaderHash.remove(e.resInfo.resId);
         if(e.resInfo.isKey)
         {
            resInfo = e.resInfo;
            resInfo.isKey = false;
            loadNextRes(resInfo);
         }
         else
         {
            if(Boolean(e.resInfo.errMsg))
            {
               DebugManager.traceMsg(e.resInfo.errMsg,false);
            }
            else
            {
               DebugManager.traceMsg("加載資源失敗：\n\t" + e.resInfo);
            }
            dispatchEvent(e);
         }
      }
      
      private static function onResComplete(e:DownLoadEvent) : void
      {
         _loaderHash.remove(e.resInfo.resId);
         if(DebugManager.DEBUG)
         {
            trace("加載資源完成：\n\t" + e.resInfo);
         }
         dispatchEvent(e);
      }
      
      private static function onResProgress(e:DownLoadEvent) : void
      {
         dispatchEvent(e);
      }
      
      private static function onResOpen(e:DownLoadEvent) : void
      {
         dispatchEvent(e);
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
   }
}

