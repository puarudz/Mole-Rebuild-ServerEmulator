package com.taomee.mole.cache
{
   import org.taomee.loader.ContentInfo;
   import org.taomee.loader.QueueLoader;
   
   internal class CacheImpl
   {
      
      public var maxCount:uint;
      
      protected var _cacheList:Array = [];
      
      protected var _waitList:Array = [];
      
      public function CacheImpl()
      {
         super();
      }
      
      public function dispose() : void
      {
         this.clear();
         this.clearCache();
         this._waitList = null;
         this._cacheList = null;
      }
      
      public function clear() : void
      {
         this.clearWait();
         this.clearCache();
      }
      
      public function clearWait() : void
      {
         var info:WaitInfo = null;
         for each(info in this._waitList)
         {
            info.dispose();
         }
      }
      
      public function clearCache() : void
      {
         var info:CacheInfo = null;
         for each(info in this._cacheList)
         {
            info.dispose();
         }
      }
      
      public function getContent(uid:String, type:String, name:String, complete:Function, error:Function = null, data:* = null, priority:int = 2, open:Function = null, progress:Function = null) : void
      {
         var cacheInfo:CacheInfo = null;
         if(uid == null || uid == "")
         {
            return;
         }
         for each(cacheInfo in this._cacheList)
         {
            if(cacheInfo.uid == uid)
            {
               this.parseOutput(uid,type,name,complete,cacheInfo,data);
               return;
            }
         }
         if(this.hasWaitList(uid,complete))
         {
            return;
         }
         var info:WaitInfo = new WaitInfo();
         info.uid = uid;
         info.name = name;
         info.completeHandler = complete;
         info.errorHandler = error;
         this._waitList.push(info);
         QueueLoader.load(uid,type,this.onComplete,this.onError,data,priority,open,progress);
      }
      
      public function cancel(uid:String, complete:Function) : void
      {
         var info:WaitInfo = null;
         if(uid == null || uid == "")
         {
            return;
         }
         var b:Boolean = false;
         var len:int = int(this._waitList.length);
         for(var i:int = 0; i < len; i++)
         {
            info = this._waitList[i];
            if(info.uid == uid)
            {
               if(info.completeHandler == complete)
               {
                  this._waitList.splice(i,1);
                  info.dispose();
                  b = true;
                  break;
               }
            }
         }
         if(b == false)
         {
            return;
         }
         for each(info in this._waitList)
         {
            if(info.uid == uid)
            {
               return;
            }
         }
         QueueLoader.cancel(uid,this.onComplete);
      }
      
      protected function hasWaitList(uid:String, complete:Function) : Boolean
      {
         var info:WaitInfo = null;
         for each(info in this._waitList)
         {
            if(info.uid == uid)
            {
               if(info.completeHandler == complete)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      protected function onError(contentInfo:ContentInfo) : void
      {
         var info:WaitInfo = null;
         var len:int = int(this._waitList.length);
         for(var i:int = 0; i < len; i++)
         {
            info = this._waitList[i];
            if(Boolean(info))
            {
               if(info.uid == contentInfo.url)
               {
                  this._waitList.splice(i,1);
                  i--;
                  if(info.errorHandler != null)
                  {
                     info.errorHandler(new ContentInfo(info.uid,contentInfo.type,null,null,contentInfo.data));
                  }
                  info.dispose();
               }
            }
         }
      }
      
      protected function onComplete(contentInfo:ContentInfo) : void
      {
         var waitInfo:WaitInfo = null;
         var cacheInfo:CacheInfo = null;
         var cacheItem:CacheInfo = null;
         var len:int = int(this._waitList.length);
         for(var i:int = 0; i < len; i++)
         {
            waitInfo = this._waitList[i];
            if(Boolean(waitInfo))
            {
               if(waitInfo.uid == contentInfo.url)
               {
                  this._waitList.splice(i,1);
                  i--;
                  for each(cacheItem in this._cacheList)
                  {
                     if(cacheItem.uid == waitInfo.uid)
                     {
                        cacheInfo = cacheItem;
                        break;
                     }
                  }
                  if(cacheInfo == null)
                  {
                     cacheInfo = new CacheInfo();
                     cacheInfo.uid = waitInfo.uid;
                     this.parseContent(cacheInfo,contentInfo);
                     this.parseCache(cacheInfo);
                  }
                  if(waitInfo.completeHandler != null)
                  {
                     this.parseOutput(waitInfo.uid,contentInfo.type,waitInfo.name,waitInfo.completeHandler,cacheInfo,contentInfo.data);
                  }
                  waitInfo.dispose();
               }
            }
         }
      }
      
      protected function parseOutput(uid:String, type:String, name:String, complete:Function, cacheInfo:CacheInfo, data:* = null) : void
      {
         complete(new ContentInfo(uid,type,cacheInfo.content,cacheInfo.domain,data));
      }
      
      protected function parseCache(info:CacheInfo) : void
      {
         var len:int = int(this._cacheList.length);
         if(len > this.maxCount)
         {
            info = this._cacheList.shift();
            info.dispose();
         }
         this._cacheList.push(info);
      }
      
      protected function parseContent(cacheInfo:CacheInfo, contentInfo:ContentInfo) : void
      {
         cacheInfo.content = contentInfo.content;
         cacheInfo.domain = contentInfo.domain;
      }
   }
}

