package com.core.download
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.utils.ByteArray;
   
   public class DownLoadEvent extends Event
   {
      
      public static const COMPLETE:String = "DownLoadEvent_Complete";
      
      public static const OPEN:String = "DownLoadEvent_Open";
      
      public static const ERROR:String = "DownLoadEvent_Error";
      
      public static const PROGRESS:String = "DownLoadEvent_Progress";
      
      public static const CANCEL:String = "DownLoadEvent_Cancel";
      
      private var _data:*;
      
      private var _resInfo:ResLoadInfo;
      
      private var _loader:Loader;
      
      private var _byteData:ByteArray;
      
      public function DownLoadEvent(type:String, resInfo:ResLoadInfo, data:* = null, loader:Loader = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         this._data = data;
         this._resInfo = resInfo;
         this._loader = loader;
         super(type,bubbles,cancelable);
      }
      
      public function get resInfo() : ResLoadInfo
      {
         return this._resInfo;
      }
      
      public function set resInfo(value:ResLoadInfo) : void
      {
         this._resInfo = value;
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function get loader() : Loader
      {
         return this._loader;
      }
      
      override public function clone() : Event
      {
         return new DownLoadEvent(type,this._resInfo,this._data,this._loader,bubbles,cancelable);
      }
      
      public function get byteData() : ByteArray
      {
         return this._byteData;
      }
      
      public function set byteData(value:ByteArray) : void
      {
         this._byteData = value;
      }
   }
}

