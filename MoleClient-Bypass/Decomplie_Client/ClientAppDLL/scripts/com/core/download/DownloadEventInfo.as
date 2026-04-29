package com.core.download
{
   public class DownloadEventInfo
   {
      
      private var _resID:uint;
      
      private var _openFun:Function;
      
      private var _progressFun:Function;
      
      private var _completeFun:Function;
      
      private var _errorFun:Function;
      
      public function DownloadEventInfo(resID:uint, openFun:Function, progressFun:Function, completeFun:Function, errorFun:Function)
      {
         super();
         this._resID = resID;
         this._openFun = openFun;
         this._progressFun = progressFun;
         this._completeFun = completeFun;
         this._errorFun = errorFun;
      }
      
      public function get resID() : uint
      {
         return this._resID;
      }
      
      public function get openFun() : Function
      {
         return this._openFun;
      }
      
      public function get progressFun() : Function
      {
         return this._progressFun;
      }
      
      public function get completeFun() : Function
      {
         return this._completeFun;
      }
      
      public function get errorFun() : Function
      {
         return this._errorFun;
      }
   }
}

