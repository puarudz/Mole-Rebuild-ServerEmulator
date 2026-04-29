package com.taomee.mole.player
{
   import com.taomee.mole.cache.CacheManager;
   import flash.system.ApplicationDomain;
   import flash.utils.Dictionary;
   import org.taomee.loader.ContentInfo;
   import org.taomee.log.Logger;
   import org.taomee.player.FramePlayer;
   import org.taomee.player.data.FrameInfo;
   
   public class SheetPlayer extends FramePlayer implements ISheet
   {
      
      private var _resourceURL:String;
      
      private var _newResourceURL:String;
      
      private var _index:uint = 1;
      
      private var _newIndex:uint = 1;
      
      private var _sheetList:Dictionary;
      
      private var _isGeting:Boolean;
      
      public function SheetPlayer()
      {
         super();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._sheetList = null;
      }
      
      override public function clear() : void
      {
         this.cancelSheet();
         super.clear();
         this._index = 1;
         this._newIndex = 1;
         this._resourceURL = null;
         this._newResourceURL = null;
         this._sheetList = null;
      }
      
      override public function setSheets(value:Vector.<FrameInfo>, isReset:Boolean = true) : void
      {
         super.setSheets(value,isReset);
         super._isPlaying = true;
      }
      
      public function set resourceURL(url:String) : void
      {
         if(url == this._resourceURL || url == null || url == "" || url == this._newResourceURL)
         {
            return;
         }
         this.cancelSheet();
         this._isGeting = true;
         this._newResourceURL = url;
         CacheManager.getSheetContent(this._newResourceURL,this.onComplete,this.onError);
      }
      
      public function get resourceURL() : String
      {
         return this._resourceURL;
      }
      
      public function setDomain(uid:String, domain:ApplicationDomain) : void
      {
         if(uid == this._resourceURL || uid == null || uid == "" || uid == this._newResourceURL)
         {
            return;
         }
         this.cancelSheet();
         this._isGeting = true;
         this._newResourceURL = uid;
         CacheManager.getSheetContentFromDomain(this._newResourceURL,domain,this.onComplete);
      }
      
      public function set sheetsList(value:Dictionary) : void
      {
         this._sheetList = value;
      }
      
      public function setIndex(index:uint, isReset:Boolean = true) : void
      {
         if(index != this._index || index != this._newIndex)
         {
            if(this._isGeting == false)
            {
               this._index = index;
               this._newIndex = index;
               this.parseSetSheets(isReset);
            }
            else
            {
               this._newIndex = index;
            }
         }
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      private function cancelSheet() : void
      {
         if(this._isGeting && this._newResourceURL != null)
         {
            CacheManager.cancelSheet(this._newResourceURL,this.onComplete);
         }
      }
      
      private function parseSetSheets(isReset:Boolean = true) : void
      {
         if(this._sheetList != null)
         {
            if(this._index in this._sheetList)
            {
               this.setSheets(this._sheetList[this._index],isReset);
            }
            else
            {
               Logger.error(this,"no index:" + this._index);
            }
         }
      }
      
      private function onComplete(info:ContentInfo) : void
      {
         this._isGeting = false;
         this._index = this._newIndex;
         CacheManager.disconnectSheet(this._resourceURL);
         this._resourceURL = this._newResourceURL;
         this._sheetList = info.content;
         this.parseSetSheets();
         this._newResourceURL = null;
      }
      
      private function onError(info:ContentInfo) : void
      {
         this.clear();
         this._isGeting = false;
      }
      
      public function get isGeting() : Boolean
      {
         return this._isGeting;
      }
   }
}

