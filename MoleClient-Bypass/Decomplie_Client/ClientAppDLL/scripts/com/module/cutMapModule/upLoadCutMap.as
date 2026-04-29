package com.module.cutMapModule
{
   import com.event.EventTaomee;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   import flash.net.URLRequestMethod;
   import flash.system.Security;
   import flash.utils.ByteArray;
   
   public class upLoadCutMap extends EventDispatcher
   {
      
      public static var onSuc:String = "onSucceed";
      
      public static var onFail:String = "onFail";
      
      public var link:String;
      
      public function upLoadCutMap(cutMapInfo:ByteArray, _ip:String, _port:int)
      {
         super();
         this.sendCutMap(cutMapInfo,_ip,_port);
      }
      
      private function sendCutMap(cutMapInfo:ByteArray, _ip:String, _port:int) : void
      {
         var loader:URLLoader;
         var header:URLRequestHeader;
         var request:URLRequest;
         cutMapInfo.position = 0;
         Security.loadPolicyFile("http://" + _ip + ":" + String(_port) + "/crossdomain.xml");
         loader = new URLLoader();
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         this.configureListeners(loader);
         header = new URLRequestHeader("user-ID",String(GV.MyInfo_userID));
         request = VL.getURLRequest("http://" + _ip + ":" + String(_port) + "/cgi-bin/processor/screenshot_upload_processor.php");
         request.data = cutMapInfo;
         request.method = URLRequestMethod.POST;
         request.contentType = "text/plain";
         request.requestHeaders.push(header);
         try
         {
            loader.load(request);
         }
         catch(error:Error)
         {
            trace("Unable to load requested document.");
         }
      }
      
      private function configureListeners(dispatcher:IEventDispatcher) : void
      {
         dispatcher.addEventListener(Event.COMPLETE,this.completeHandler);
         dispatcher.addEventListener(Event.OPEN,this.openHandler);
         dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
         dispatcher.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
      }
      
      private function completeHandler(event:Event) : void
      {
         var loader:URLLoader = URLLoader(event.target);
         var returnByteArray:ByteArray = loader.data as ByteArray;
         trace(loader.data);
         if(loader.data != 0)
         {
            this.link = "http://" + loader.data;
            trace("link: " + this.link);
            dispatchEvent(new EventTaomee(onSuc,this.link));
         }
         else
         {
            dispatchEvent(new EventTaomee(onSuc,"error"));
         }
      }
      
      private function openHandler(event:Event) : void
      {
         trace("openHandler: " + event);
      }
      
      private function securityErrorHandler(event:SecurityErrorEvent) : void
      {
         trace("securityErrorHandler: " + event);
         dispatchEvent(new EventTaomee(onFail,event));
      }
      
      private function ioErrorHandler(event:IOErrorEvent) : void
      {
         trace("ioErrorHandler: " + event);
         dispatchEvent(new EventTaomee(onFail,event));
      }
   }
}

