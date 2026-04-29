package com.taomee.mole.cache
{
   import flash.system.ApplicationDomain;
   import flash.utils.Dictionary;
   import org.taomee.ds.HashMap;
   import org.taomee.loader.ContentInfo;
   import org.taomee.player.data.FrameInfo;
   import org.taomee.player.utils.*;
   
   public class SheetCache extends CacheImpl
   {
      
      protected var _counterMap:HashMap = new HashMap();
      
      public function SheetCache()
      {
         super();
      }
      
      override public function clearCache() : void
      {
         var info:CacheInfo = null;
         for each(info in _cacheList)
         {
            this.disposeCacheInfo(info);
         }
      }
      
      public function disconnect(uid:String) : void
      {
         var cacheItem:CacheInfo = null;
         if(uid == null || uid == "")
         {
            return;
         }
         for each(cacheItem in _cacheList)
         {
            if(cacheItem.uid == uid)
            {
               if(cacheItem.useCount > 0)
               {
                  --cacheItem.useCount;
               }
               break;
            }
         }
      }
      
      public function getContentFromDomain(uid:String, appDomain:ApplicationDomain, complete:Function, error:Function = null, data:* = null) : void
      {
         var cacheInfo:CacheInfo = null;
         if(uid == null || uid == "")
         {
            return;
         }
         for each(cacheInfo in _cacheList)
         {
            if(cacheInfo.uid == uid)
            {
               this.parseOutput(uid,null,null,complete,cacheInfo,data);
               return;
            }
         }
         cacheInfo = new CacheInfo();
         cacheInfo.uid = uid;
         cacheInfo.content = SheetUtil.makeSheetMap(appDomain);
         this.parseCache(cacheInfo);
         this.parseOutput(uid,null,null,complete,cacheInfo,data);
      }
      
      override protected function parseCache(info:CacheInfo) : void
      {
         var dInfo:CacheInfo = null;
         var i:int = 0;
         var cInfo:CacheInfo = null;
         var len:int = int(_cacheList.length);
         if(len > maxCount)
         {
            _cacheList.sort(this.sortCounter);
            dInfo = null;
            for(i = 0; i < len; i++)
            {
               cInfo = _cacheList[i];
               if(cInfo.useCount == 0)
               {
                  _cacheList.splice(i,1);
                  dInfo = cInfo;
                  break;
               }
            }
            if(Boolean(dInfo))
            {
               this.disposeCacheInfo(dInfo);
            }
         }
         _cacheList.push(info);
         var v:uint = this._counterMap.getValue(info.uid);
         v++;
         this._counterMap.add(info.uid,v);
      }
      
      private function disposeCacheInfo(info:CacheInfo) : void
      {
         var sheets:Vector.<FrameInfo> = null;
         var frameInfo:FrameInfo = null;
         var content:Dictionary = info.content;
         info.dispose();
         for each(sheets in content)
         {
            for each(frameInfo in sheets)
            {
               if(Boolean(frameInfo))
               {
                  frameInfo.data.dispose();
                  frameInfo.data = null;
               }
            }
         }
      }
      
      override protected function parseContent(cacheInfo:CacheInfo, contentInfo:ContentInfo) : void
      {
         cacheInfo.content = SheetUtil.makeSheetMap(contentInfo.content);
      }
      
      private function sortCounter(a:CacheInfo, b:CacheInfo) : int
      {
         var av:uint = this._counterMap.getValue(a.uid);
         var bv:uint = this._counterMap.getValue(b.uid);
         if(av < bv)
         {
            return 1;
         }
         if(av > bv)
         {
            return -1;
         }
         return 0;
      }
      
      override protected function parseOutput(uid:String, type:String, name:String, complete:Function, cacheInfo:CacheInfo, data:* = null) : void
      {
         ++cacheInfo.useCount;
         complete(new ContentInfo(uid,type,cacheInfo.content,cacheInfo.domain,data));
      }
   }
}

