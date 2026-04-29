package org.taomee.loader
{
   import flash.events.ProgressEvent;
   
   public class UILoader
   {
      
      public static var openHandler:Function;
      
      public static var completeHandler:Function;
      
      public static var errorHandler:Function;
      
      public static var progressHandler:Function;
      
      private static var _loader:QueueLoaderImpl = new QueueLoaderImpl();
      
      private static var _waitList:Array = [];
      
      public static var defaultOpen:Boolean = true;
      
      public static var defaultComplete:Boolean = true;
      
      public static var defaultError:Boolean = true;
      
      public static var defaultProgress:Boolean = true;
      
      public function UILoader()
      {
         super();
      }
      
      public static function set defaultAll(value:Boolean) : void
      {
         defaultOpen = value;
         defaultComplete = value;
         defaultError = value;
         defaultProgress = value;
      }
      
      public static function load(url:String, type:String, complete:Function, error:Function = null, title:String = "", data:* = null, open:Function = null, progress:Function = null) : void
      {
         if(hasWaitList(url,complete))
         {
            return;
         }
         var info:QueueInfo = new QueueInfo();
         info.url = url;
         info.type = type;
         info.title = title;
         info.data = data;
         info.completeHandler = complete;
         info.errorHandler = error;
         info.openHandler = open;
         info.progressHandler = progress;
         _waitList.push(info);
         _loader.load(url,type,onComplete,onError,null,2,onOpen,onProgress);
      }
      
      public static function cancel(url:String, complete:Function) : void
      {
         var info:QueueInfo = null;
         var b:Boolean = false;
         var len:int = int(_waitList.length);
         for(var i:int = 0; i < len; i++)
         {
            info = _waitList[i];
            if(info.url == url)
            {
               if(info.completeHandler == complete)
               {
                  _waitList.splice(i,1);
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
         for each(info in _waitList)
         {
            if(info.url == url)
            {
               return;
            }
         }
         _loader.cancel(url,onComplete);
      }
      
      private static function hasWaitList(url:String, complete:Function) : Boolean
      {
         var info:QueueInfo = null;
         for each(info in _waitList)
         {
            if(info.url == url)
            {
               if(info.completeHandler == complete)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private static function onOpen(contentInfo:ContentInfo) : void
      {
         var info:QueueInfo = null;
         var len:int = int(_waitList.length);
         for(var i:int = 0; i < len; i++)
         {
            info = _waitList[i];
            if(Boolean(info))
            {
               if(info.url == contentInfo.url)
               {
                  if(defaultOpen && openHandler != null)
                  {
                     openHandler(info.title);
                  }
                  if(info.openHandler != null)
                  {
                     info.openHandler(new ContentInfo(info.url,info.type,null,null,info.data));
                  }
                  break;
               }
            }
         }
      }
      
      private static function onComplete(contentInfo:ContentInfo) : void
      {
         var info:QueueInfo = null;
         if(defaultComplete && completeHandler != null)
         {
            completeHandler();
         }
         var len:int = int(_waitList.length);
         for(var i:int = 0; i < len; i++)
         {
            info = _waitList[i];
            if(Boolean(info))
            {
               if(info.url == contentInfo.url)
               {
                  _waitList.splice(i,1);
                  i--;
                  if(info.completeHandler != null)
                  {
                     info.completeHandler(new ContentInfo(info.url,info.type,contentInfo.content,contentInfo.domain,info.data));
                  }
                  info.dispose();
               }
            }
         }
      }
      
      private static function onError(contentInfo:ContentInfo) : void
      {
         var info:QueueInfo = null;
         if(defaultError && errorHandler != null)
         {
            errorHandler();
         }
         var len:int = int(_waitList.length);
         for(var i:int = 0; i < len; i++)
         {
            info = _waitList[i];
            if(Boolean(info))
            {
               if(info.url == contentInfo.url)
               {
                  _waitList.splice(i,1);
                  i--;
                  if(info.errorHandler != null)
                  {
                     info.errorHandler(new ContentInfo(info.url,info.type,null,null,info.data));
                  }
                  info.dispose();
               }
            }
         }
      }
      
      private static function onProgress(event:ProgressEvent) : void
      {
         var len:int = 0;
         var i:int = 0;
         var info:QueueInfo = null;
         if(defaultProgress && progressHandler != null)
         {
            progressHandler(event.bytesLoaded / event.bytesTotal);
         }
         if(Boolean(_loader.currentInfo))
         {
            len = int(_waitList.length);
            for(i = 0; i < len; i++)
            {
               info = _waitList[i];
               if(Boolean(info))
               {
                  if(info.url == _loader.currentInfo.url)
                  {
                     if(info.progressHandler != null)
                     {
                        info.progressHandler(event);
                     }
                     break;
                  }
               }
            }
         }
      }
   }
}

