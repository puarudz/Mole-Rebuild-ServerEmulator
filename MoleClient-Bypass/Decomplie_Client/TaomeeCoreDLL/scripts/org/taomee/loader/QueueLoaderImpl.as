package org.taomee.loader
{
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.system.ApplicationDomain;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   internal class QueueLoaderImpl
   {
      
      private static const SORT_NAME:String = "priority";
      
      private static const TIMEOUT_MAX:uint = 2;
      
      private var _waitList:Array = [];
      
      private var _isStop:Boolean = false;
      
      private var _loader:IntegrateLoader = new IntegrateLoader();
      
      private var _timeoutID:uint;
      
      public function QueueLoaderImpl()
      {
         super();
      }
      
      public function get currentInfo() : QueueInfo
      {
         return this._loader.info;
      }
      
      public function get waitList() : Array
      {
         return this._waitList;
      }
      
      public function load(url:String, type:String, complete:Function, error:Function = null, data:* = null, priority:int = 2, open:Function = null, progress:Function = null) : void
      {
         var info:QueueInfo = null;
         if(this.hasCompleteHandler(url,complete))
         {
            return;
         }
         info = new QueueInfo();
         info.url = url;
         info.type = type;
         info.data = data;
         info.priority = priority;
         info.completeHandler = complete;
         info.errorHandler = error;
         info.openHandler = open;
         info.progressHandler = progress;
         this._waitList.push(info);
         this._waitList.sortOn(SORT_NAME,Array.NUMERIC);
         if(priority == QueuePriority.COERCE)
         {
            if(this._loader.info.priority != QueuePriority.COERCE)
            {
               this.nextLoad(true);
               return;
            }
         }
         this.nextLoad();
      }
      
      public function addBef(url:String, type:String) : void
      {
         var info:QueueInfo = null;
         for each(info in this._waitList)
         {
            if(info.url == url)
            {
               return;
            }
         }
         info = new QueueInfo();
         info.priority = QueuePriority.LOW;
         info.url = url;
         info.type = type;
         this._waitList.push(info);
         this.nextLoad();
      }
      
      public function pause() : void
      {
         this._isStop = true;
         this.close();
      }
      
      public function resume() : void
      {
         if(this._isStop)
         {
            this._isStop = false;
            this.nextLoad(true);
         }
      }
      
      public function cancelAll() : void
      {
         var info:QueueInfo = null;
         this.close();
         for each(info in this._waitList)
         {
            info.dispose();
         }
         this._waitList.length = 0;
      }
      
      public function cancel(url:String, complete:Function) : void
      {
         var info:QueueInfo = null;
         if(complete == null)
         {
            return;
         }
         var len:int = int(this._waitList.length);
         for(var i:int = 0; i < len; i++)
         {
            info = this._waitList[i];
            if(info.url == url)
            {
               if(info.completeHandler == complete)
               {
                  this._waitList.splice(i,1);
                  info.dispose();
                  break;
               }
            }
         }
      }
      
      public function cancelURL(url:String) : void
      {
         var info:QueueInfo = this._loader.info;
         if(Boolean(info))
         {
            if(info.url == url)
            {
               this.close();
            }
         }
         this.removeURL(url);
         this.nextLoad();
      }
      
      public function cancelHandler(complete:Function) : void
      {
         if(complete == null)
         {
            return;
         }
         var info:QueueInfo = this._loader.info;
         if(Boolean(info))
         {
            if(info.completeHandler == complete)
            {
               this.close();
            }
         }
         this.removeHandler(complete);
         this.nextLoad();
      }
      
      public function cancelData(attribute:String, value:*, url:String = null) : void
      {
         if(attribute == null || attribute == "")
         {
            return;
         }
         var info:QueueInfo = this._loader.info;
         if(Boolean(info) && Boolean(info.data))
         {
            if(url == null)
            {
               if(attribute in info.data)
               {
                  if(info.data[attribute] == value)
                  {
                     this.close();
                  }
               }
            }
            else if(info.url == url)
            {
               if(attribute in info.data)
               {
                  if(info.data[attribute] == value)
                  {
                     this.close();
                  }
               }
            }
         }
         this.removeData(attribute,value,url);
         this.nextLoad();
      }
      
      public function hasCompleteHandlerFromData(url:String, attribute:String, complete:Function) : Boolean
      {
         var info:QueueInfo = null;
         for each(info in this._waitList)
         {
            if(info.url == url && Boolean(info.data))
            {
               if(attribute in info.data)
               {
                  if(info.data[attribute] == complete)
                  {
                     return true;
                  }
               }
            }
         }
         return false;
      }
      
      private function hasCompleteHandler(url:String, complete:Function) : Boolean
      {
         var info:QueueInfo = null;
         for each(info in this._waitList)
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
      
      private function close() : void
      {
         this._loader.removeEventListener(Event.OPEN,this.onOpen);
         this._loader.removeEventListener(Event.COMPLETE,this.onComplete);
         this._loader.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
         this._loader.removeEventListener(ErrorEvent.ERROR,this.onError);
         this._loader.close();
      }
      
      private function removeURL(url:String) : void
      {
         var info:QueueInfo = null;
         var len:int = int(this._waitList.length);
         for(var i:int = 0; i < len; i++)
         {
            info = this._waitList[i];
            if(Boolean(info))
            {
               if(info.url == url)
               {
                  this._waitList.splice(i,1);
                  i--;
                  info.dispose();
               }
            }
         }
      }
      
      private function removeHandler(complete:Function) : void
      {
         var info:QueueInfo = null;
         var len:int = int(this._waitList.length);
         for(var i:int = 0; i < len; i++)
         {
            info = this._waitList[i];
            if(Boolean(info))
            {
               if(info.completeHandler == complete)
               {
                  this._waitList.splice(i,1);
                  i--;
                  info.dispose();
               }
            }
         }
      }
      
      private function removeData(attribute:String, value:*, url:String = null) : void
      {
         var info:QueueInfo = null;
         var len:int = int(this._waitList.length);
         for(var i:int = 0; i < len; i++)
         {
            info = this._waitList[i];
            if(Boolean(info) && Boolean(info.data))
            {
               if(url == null)
               {
                  if(attribute in info.data)
                  {
                     if(info.data[attribute] == value)
                     {
                        this._waitList.splice(i,1);
                        i--;
                        info.dispose();
                     }
                  }
               }
               else if(info.url == url)
               {
                  if(attribute in info.data)
                  {
                     if(info.data[attribute] == value)
                     {
                        this._waitList.splice(i,1);
                        i--;
                        info.dispose();
                     }
                  }
               }
            }
         }
      }
      
      private function nextLoad(coerce:Boolean = false) : void
      {
         var info:QueueInfo = null;
         if(coerce)
         {
            this.close();
         }
         else if(Boolean(this._loader.info))
         {
            return;
         }
         clearTimeout(this._timeoutID);
         if(this._isStop)
         {
            return;
         }
         if(this._waitList.length > 0)
         {
            this._loader.addEventListener(Event.OPEN,this.onOpen);
            this._loader.addEventListener(Event.COMPLETE,this.onComplete);
            this._loader.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this._loader.addEventListener(ErrorEvent.ERROR,this.onError);
            info = this._waitList[0];
            this._loader.load(info);
            this._timeoutID = setTimeout(this.onTimeout,5000);
            if(info.openHandler != null)
            {
               info.openHandler(new ContentInfo(info.url,info.type,null,null,info.data));
            }
            trace("QueueLoader nextLoad " + info.url);
         }
      }
      
      private function onTimeout() : void
      {
         if(Boolean(this._loader.info))
         {
            if(this._loader.info.timeCount >= TIMEOUT_MAX)
            {
               this.removeURL(this._loader.info.url);
            }
            else
            {
               ++this._loader.info.timeCount;
            }
            this.nextLoad(true);
         }
      }
      
      private function getOuts(url:String) : Array
      {
         var info:QueueInfo = null;
         var outs:Array = [];
         var len:int = int(this._waitList.length);
         for(var i:int = 0; i < len; i++)
         {
            info = this._waitList[i];
            if(Boolean(info))
            {
               if(info.url == url)
               {
                  this._waitList.splice(i,1);
                  i--;
                  outs.push(info);
               }
            }
         }
         return outs;
      }
      
      private function onOpen(event:Event) : void
      {
         clearTimeout(this._timeoutID);
      }
      
      private function onComplete(event:IntegrateLoaderEvent) : void
      {
         trace("QueueLoader onComplete " + event.url);
         var outs:Array = this.getOuts(event.url);
         this.outComplete(outs,event.content,event.domain);
         this.close();
         this.nextLoad();
      }
      
      private function outComplete(outs:Array, content:*, domain:ApplicationDomain) : void
      {
         var info:QueueInfo = null;
         for each(info in outs)
         {
            if(info.completeHandler != null)
            {
               info.completeHandler(new ContentInfo(info.url,info.type,content,domain,info.data));
            }
            info.dispose();
         }
      }
      
      private function onError(event:ErrorEvent) : void
      {
         clearTimeout(this._timeoutID);
         var info:QueueInfo = this._loader.info;
         this.close();
         trace("QueueLoader onError " + info.url);
         var outs:Array = this.getOuts(info.url);
         this.nextLoad();
         this.outError(outs);
      }
      
      private function outError(outs:Array) : void
      {
         var info:QueueInfo = null;
         for each(info in outs)
         {
            if(info.errorHandler != null)
            {
               info.errorHandler(new ContentInfo(info.url,info.type,null,null,info.data));
            }
            info.dispose();
         }
      }
      
      private function onProgress(event:ProgressEvent) : void
      {
         var info:QueueInfo = this._loader.info;
         if(info.progressHandler != null)
         {
            info.progressHandler(event);
         }
      }
   }
}

