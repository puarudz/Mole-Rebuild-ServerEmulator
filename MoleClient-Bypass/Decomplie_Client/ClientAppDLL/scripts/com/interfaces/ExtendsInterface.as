package com.interfaces
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   
   public class ExtendsInterface
   {
      
      private static var dispatcher:EventDispatcher = new EventDispatcher();
      
      public static var addEventListener:* = dispatcher.addEventListener;
      
      public static var dispatchEvent:* = dispatcher.dispatchEvent;
      
      public static var removeEventListener:* = dispatcher.removeEventListener;
      
      public static var Read:String = "Read_";
      
      public function ExtendsInterface()
      {
         super();
      }
      
      public static function parse(tempByteArr:ByteArray, Command:int) : void
      {
         var ReturnObj:* = null;
         switch(Command)
         {
            case 0:
               ReturnObj = {};
         }
         ExtendsInterface.dispatchEvent(new EventTaomee(Read + Command,{
            "cmd":Command,
            "data":ReturnObj
         }));
      }
   }
}

