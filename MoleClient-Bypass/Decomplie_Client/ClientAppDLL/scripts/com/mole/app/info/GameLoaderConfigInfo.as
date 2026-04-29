package com.mole.app.info
{
   public class GameLoaderConfigInfo
   {
      
      private var _id:uint;
      
      private var _url:String;
      
      private var _explain:String;
      
      private var _clearBg:Boolean;
      
      private var _needVip:Boolean;
      
      private var _needVipMsg:String;
      
      private var _newLoad:Boolean;
      
      public function GameLoaderConfigInfo(infoXml:XML)
      {
         super();
         this._id = uint(infoXml.@ID);
         this._url = String(infoXml.@Url);
         this._explain = String(infoXml.@Explain);
         this._clearBg = Boolean(uint(infoXml.@NeedClearBG) == 1);
         this._needVip = Boolean(uint(infoXml.@NeedVip) == 1);
         this._needVipMsg = String(infoXml.@NeedVipMsg);
         this._newLoad = Boolean(uint(infoXml.@NewLoad) == 1);
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function get explain() : String
      {
         return this._explain;
      }
      
      public function get clearBg() : Boolean
      {
         return this._clearBg;
      }
      
      public function get needVip() : Boolean
      {
         return this._needVip;
      }
      
      public function get needVipMsg() : String
      {
         return this._needVipMsg;
      }
      
      public function get newLoad() : Boolean
      {
         return this._newLoad;
      }
   }
}

