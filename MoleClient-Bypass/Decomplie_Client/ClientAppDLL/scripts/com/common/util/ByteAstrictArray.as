package com.common.util
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   
   use namespace flash_proxy;
   
   public dynamic class ByteAstrictArray extends Proxy
   {
      
      public static var ON_INPUT:String = "onInputData";
      
      public static var ON_OUTPUT:String = "onOutputData";
      
      public static var ON_CHANGE:String = "onChangeData";
      
      public static var ON_OVERRUN:String = "onOverrunData";
      
      public static var ON_FULL:String = "onFullData";
      
      public var dispatchEvent:Function;
      
      public var addEventListener:Function;
      
      public var removeEventListener:Function;
      
      public var limitLength:uint;
      
      private var memoryByteArray:ByteArray;
      
      private var oldMemoryByteArray:ByteArray;
      
      public function ByteAstrictArray(_limitLength:uint = 0)
      {
         super();
         this.limitLength = _limitLength;
         this.memoryByteArray = new ByteArray();
         var ed:EventDispatcher = new EventDispatcher();
         this.dispatchEvent = ed.dispatchEvent;
         this.addEventListener = ed.addEventListener;
         this.removeEventListener = ed.removeEventListener;
      }
      
      override flash_proxy function callProperty(methodName:*, ... args) : *
      {
         var res:* = undefined;
         var str:String = methodName.toString();
         this.oldMemoryByteArray = this.copyByteArray(this.memoryByteArray);
         res = this.memoryByteArray[str].apply(this.memoryByteArray,args);
         if(str.indexOf("write") == 0)
         {
            this.dispatchEvent(new Event(ON_INPUT));
            this.dispatchEvent(new Event(ON_CHANGE));
         }
         else if(str.indexOf("read") == 0)
         {
            this.dispatchEvent(new Event(ON_OUTPUT));
            this.dispatchEvent(new Event(ON_CHANGE));
         }
         this.memoryByteArray.position = 0;
         if(this.memoryByteArray.length > this.limitLength)
         {
            this.memoryByteArray = this.copyByteArray(this.oldMemoryByteArray);
            this.dispatchEvent(new Event(ON_OVERRUN));
         }
         else if(this.memoryByteArray.length == this.limitLength)
         {
            this.dispatchEvent(new Event(ON_FULL));
         }
         return res;
      }
      
      override flash_proxy function getProperty(name:*) : *
      {
         return this.memoryByteArray[name];
      }
      
      override flash_proxy function setProperty(name:*, value:*) : void
      {
         this.memoryByteArray[name] = value;
      }
      
      public function get value() : ByteArray
      {
         return this.memoryByteArray;
      }
      
      public function get oldByteArray() : ByteArray
      {
         return this.oldMemoryByteArray;
      }
      
      public function clear() : void
      {
         this.memoryByteArray = new ByteArray();
      }
      
      public function copyByteArray(soureByteArray:ByteArray) : ByteArray
      {
         var tempByteArray:ByteArray = new ByteArray();
         var tp:uint = soureByteArray.position;
         soureByteArray.position = 0;
         tempByteArray.writeBytes(soureByteArray,0,soureByteArray.length);
         soureByteArray.position = tp;
         return tempByteArray;
      }
   }
}

