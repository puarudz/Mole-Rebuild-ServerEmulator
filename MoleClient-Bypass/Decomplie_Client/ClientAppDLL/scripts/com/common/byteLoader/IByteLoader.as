package com.common.byteLoader
{
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   
   public interface IByteLoader
   {
      
      function load(param1:URLRequest) : void;
      
      function addCheckTimeout(param1:uint = 15000) : void;
      
      function reTry(param1:String = "") : void;
      
      function getByteArray() : ByteArray;
      
      function getURLRequest() : URLRequest;
      
      function get loadtimer() : Number;
      
      function get hasBreakTimeout() : Boolean;
      
      function get reTryCount() : uint;
      
      function get timeoutCount() : uint;
      
      function get delay() : uint;
      
      function get bytesAvailable() : uint;
      
      function get bytesLoaded() : uint;
      
      function get bytesTotal() : uint;
      
      function close() : void;
   }
}

