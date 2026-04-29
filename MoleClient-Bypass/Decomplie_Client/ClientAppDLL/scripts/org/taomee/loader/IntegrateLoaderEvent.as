package org.taomee.loader
{
   import flash.events.Event;
   import flash.system.ApplicationDomain;
   
   internal class IntegrateLoaderEvent extends Event
   {
      
      public static const COMPLETE:String = "complete";
      
      private var _content:*;
      
      private var _domain:ApplicationDomain;
      
      private var _url:String;
      
      public function IntegrateLoaderEvent(type:String, url:String, content:*, domain:ApplicationDomain = null)
      {
         super(type);
         this._content = content;
         this._domain = domain;
         this._url = url;
      }
      
      public function get content() : *
      {
         return this._content;
      }
      
      public function get domain() : ApplicationDomain
      {
         return this._domain;
      }
      
      public function get url() : String
      {
         return this._url;
      }
   }
}

