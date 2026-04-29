package org.taomee.loader
{
   import flash.system.ApplicationDomain;
   
   public class ContentInfo
   {
      
      public var content:*;
      
      public var domain:ApplicationDomain;
      
      public var data:*;
      
      private var _url:String;
      
      private var _type:String;
      
      public function ContentInfo(url:String, type:String, content:*, domain:ApplicationDomain = null, data:* = null)
      {
         super();
         this._url = url;
         this._type = type;
         this.content = content;
         this.domain = domain;
         this.data = data;
      }
      
      public function dispose() : void
      {
         this.content = null;
         this.domain = null;
         this.data = null;
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function get type() : String
      {
         return this._type;
      }
   }
}

