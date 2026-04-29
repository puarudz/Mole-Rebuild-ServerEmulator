package com.greensock.loading
{
   import com.greensock.loading.core.LoaderItem;
   import flash.display.DisplayObject;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   
   public class SelfLoader extends LoaderItem
   {
      
      protected var _loaderInfo:LoaderInfo;
      
      public function SelfLoader(self:DisplayObject, vars:Object = null)
      {
         super(self.loaderInfo.url,vars);
         _type = "SelfLoader";
         this._loaderInfo = self.loaderInfo;
         this._loaderInfo.addEventListener(ProgressEvent.PROGRESS,_progressHandler,false,0,true);
         this._loaderInfo.addEventListener(Event.COMPLETE,_completeHandler,false,0,true);
         _cachedBytesTotal = this._loaderInfo.bytesTotal;
         _cachedBytesLoaded = this._loaderInfo.bytesLoaded;
         _status = _cachedBytesLoaded == _cachedBytesTotal ? LoaderStatus.COMPLETED : LoaderStatus.LOADING;
         _auditedSize = true;
         _content = self;
      }
      
      override protected function _dump(scrubLevel:int = 0, newStatus:int = 0, suppressEvents:Boolean = false) : void
      {
         if(scrubLevel >= 2)
         {
            this._loaderInfo.removeEventListener(ProgressEvent.PROGRESS,_progressHandler);
            this._loaderInfo.removeEventListener(Event.COMPLETE,_completeHandler);
         }
         super._dump(scrubLevel,newStatus,suppressEvents);
      }
   }
}

