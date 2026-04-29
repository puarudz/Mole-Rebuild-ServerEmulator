package com.core.newloader
{
   import com.event.XMLLoadEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   
   [Event(name="error",type="com.event.XMLLoadEvent")]
   [Event(name="onSuccess",type="com.event.XMLLoadEvent")]
   public class XMLLoader extends URLLoader
   {
      
      private var url:String;
      
      public function XMLLoader(url:String)
      {
         super();
         this.url = url;
         this.addEventListener(Event.COMPLETE,this._onLoad);
         this.addEventListener(IOErrorEvent.IO_ERROR,this._error);
      }
      
      public function doLoad(newURL:String = "") : void
      {
         if(newURL == "")
         {
            this.load(VL.getURLRequest(this.url));
         }
         else
         {
            this.addEventListener(Event.COMPLETE,this._onLoad);
            this.addEventListener(IOErrorEvent.IO_ERROR,this._error);
            this.load(VL.getURLRequest(newURL));
         }
      }
      
      private function _onLoad(event:Event) : void
      {
         this.removeEventListener(Event.COMPLETE,this._onLoad);
         this.removeEventListener(IOErrorEvent.IO_ERROR,this._error);
         dispatchEvent(new XMLLoadEvent(XMLLoadEvent.ON_SUCCESS,this));
      }
      
      private function _error(event:IOErrorEvent) : void
      {
         this.removeEventListener(Event.COMPLETE,this._onLoad);
         this.removeEventListener(IOErrorEvent.IO_ERROR,this._error);
         dispatchEvent(new XMLLoadEvent(XMLLoadEvent.ERROR,this));
      }
   }
}

