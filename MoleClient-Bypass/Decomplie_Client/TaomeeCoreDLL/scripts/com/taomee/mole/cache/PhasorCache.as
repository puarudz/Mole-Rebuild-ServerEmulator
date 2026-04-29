package com.taomee.mole.cache
{
   import flash.display.DisplayObject;
   import org.taomee.loader.ContentInfo;
   import org.taomee.loader.QueueLoader;
   import org.taomee.utils.DomainUtil;
   
   internal class PhasorCache extends CacheImpl
   {
      
      public function PhasorCache()
      {
         super();
      }
      
      override protected function parseOutput(uid:String, type:String, name:String, complete:Function, cacheInfo:CacheInfo, data:* = null) : void
      {
         var content:DisplayObject = DomainUtil.getDisplayObject(name,cacheInfo.content);
         complete(new ContentInfo(uid,type,content,cacheInfo.domain,data));
      }
      
      override public function getContent(uid:String, type:String, name:String, complete:Function, error:Function = null, data:* = null, priority:int = 2, open:Function = null, progress:Function = null) : void
      {
         var cacheInfo:CacheInfo = null;
         var info:WaitInfo = null;
         if(uid == null || uid == "")
         {
            return;
         }
         for each(cacheInfo in _cacheList)
         {
            if(cacheInfo.uid == uid)
            {
               this.parseOutput(uid,type,name,complete,cacheInfo,data);
               return;
            }
         }
         if(this.phasorHasWaitList(uid,name,complete))
         {
            return;
         }
         info = new WaitInfo();
         info.uid = uid;
         info.name = name;
         info.completeHandler = complete;
         info.errorHandler = error;
         info.data = data;
         _waitList.push(info);
         QueueLoader.load(uid,type,this.onComplete,onError,data,priority,open,progress);
      }
      
      private function phasorHasWaitList(uid:String, name:String, complete:Function) : Boolean
      {
         var info:WaitInfo = null;
         for each(info in _waitList)
         {
            if(info.uid == uid && info.completeHandler == complete && info.name == name)
            {
               return true;
            }
         }
         return false;
      }
      
      override protected function onComplete(contentInfo:ContentInfo) : void
      {
         var waitInfo:WaitInfo = null;
         var cacheInfo:CacheInfo = null;
         var cacheItem:CacheInfo = null;
         var len:int = int(_waitList.length);
         for(var i:int = 0; i < len; i++)
         {
            waitInfo = _waitList[i];
            if(Boolean(waitInfo))
            {
               if(waitInfo.uid == contentInfo.url)
               {
                  _waitList.splice(i,1);
                  i--;
                  for each(cacheItem in _cacheList)
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
                     parseContent(cacheInfo,contentInfo);
                     parseCache(cacheInfo);
                  }
                  if(waitInfo.completeHandler != null)
                  {
                     this.parseOutput(waitInfo.uid,contentInfo.type,waitInfo.name,waitInfo.completeHandler,cacheInfo,waitInfo.data);
                  }
                  waitInfo.dispose();
               }
            }
         }
      }
   }
}

