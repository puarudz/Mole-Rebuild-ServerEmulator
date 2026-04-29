package com.taomee.mole.resource
{
   import flash.utils.setTimeout;
   
   public class RESLoader
   {
      
      public var progressHandler:Function;
      
      public var completeHandler:Function;
      
      public var errorHandler:Function;
      
      private var _url:String;
      
      private var _reloadCount:int = 2;
      
      protected var _currentdomain:Boolean;
      
      protected var _urlRnd:int = 0;
      
      public function RESLoader()
      {
         super();
      }
      
      public function load(url:String, currentdomain:Boolean = false) : void
      {
         this._url = url;
         this._currentdomain = currentdomain;
         this.startListener();
      }
      
      protected function startListener() : void
      {
      }
      
      protected function stopListener() : void
      {
      }
      
      protected function delayToLoad() : void
      {
         if(this._reloadCount <= 0)
         {
            this.stopListener();
            if(this.errorHandler != null)
            {
               this.errorHandler(this);
            }
            return;
         }
         --this._reloadCount;
         setTimeout(this.reload,100);
      }
      
      private function reload() : void
      {
         ++this._urlRnd;
         this.load(this._url);
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      protected function get loadurl() : String
      {
         if(this._urlRnd > 0)
         {
            return this._url;
         }
         if(this._url.indexOf("?") >= 0)
         {
            return this._url + "&rnd=" + this._urlRnd;
         }
         return this._url + "?rnd=" + this._urlRnd;
      }
      
      public function clear() : void
      {
         this.stopListener();
      }
      
      public function get data() : *
      {
         return null;
      }
      
      public function destroy() : void
      {
         this.progressHandler = null;
         this.completeHandler = null;
         this.errorHandler = null;
      }
   }
}

