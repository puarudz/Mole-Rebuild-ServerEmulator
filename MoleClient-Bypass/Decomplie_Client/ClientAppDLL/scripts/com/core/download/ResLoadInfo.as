package com.core.download
{
   import flash.system.ApplicationDomain;
   
   public class ResLoadInfo
   {
      
      private var _resId:uint;
      
      private var _url:String;
      
      private var _type:String;
      
      private var _desc:String;
      
      private var _isKey:Boolean;
      
      private var _appDomain:ApplicationDomain;
      
      private var _data:*;
      
      private var _errMsg:String;
      
      public function ResLoadInfo(resId:uint, url:String, type:String, desc:String, isKey:Boolean, appDomain:ApplicationDomain = null, data:* = null, errMsg:String = "")
      {
         super();
         this._resId = resId;
         this._url = url;
         this._type = type;
         this._desc = desc;
         this._isKey = isKey;
         this._appDomain = appDomain;
         this._data = data;
         this._errMsg = errMsg;
      }
      
      public function get isKey() : Boolean
      {
         return this._isKey;
      }
      
      public function set isKey(value:Boolean) : void
      {
         this._isKey = value;
      }
      
      public function get desc() : String
      {
         return this._desc;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function get resId() : uint
      {
         return this._resId;
      }
      
      public function get appDomain() : ApplicationDomain
      {
         return this._appDomain;
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function toString() : String
      {
         var msg:String = "資源ID:" + this._resId + "\t";
         msg += "地址:" + this._url + "\t";
         msg += "資源類型:" + this._type + "\t";
         msg += "加載面板提示消息:" + this._desc + "\t";
         msg += "是否為關鍵資源:" + this._isKey + "\t";
         msg += "加載域:" + this._appDomain;
         return msg + ("錯誤提示:" + this._errMsg);
      }
      
      public function get errMsg() : String
      {
         return this._errMsg;
      }
   }
}

