package org.taomee.loader
{
   public class QueueLoader
   {
      
      private static var _impl:QueueLoaderImpl = new QueueLoaderImpl();
      
      public function QueueLoader()
      {
         super();
      }
      
      public static function get currentInfo() : QueueInfo
      {
         return _impl.currentInfo;
      }
      
      public static function get waitList() : Array
      {
         return _impl.waitList;
      }
      
      public static function load(url:String, type:String, complete:Function, error:Function = null, data:* = null, priority:int = 2, open:Function = null, progress:Function = null) : void
      {
         _impl.load(url,type,complete,error,data,priority,open,progress);
      }
      
      public static function addBef(url:String, type:String) : void
      {
         _impl.addBef(url,type);
      }
      
      public static function hasCompleteHandlerFromData(url:String, attribute:String, complete:Function) : Boolean
      {
         return _impl.hasCompleteHandlerFromData(url,attribute,complete);
      }
      
      public static function cancel(url:String, complete:Function) : void
      {
         _impl.cancel(url,complete);
      }
      
      public static function cancelURL(url:String) : void
      {
         _impl.cancelURL(url);
      }
      
      public static function cancelHandler(complete:Function) : void
      {
         _impl.cancelHandler(complete);
      }
      
      public static function cancelData(attribute:String, value:*, url:String = null) : void
      {
         _impl.cancelData(attribute,value,url);
      }
      
      public static function cancelAll() : void
      {
         _impl.cancelAll();
      }
      
      public static function pause() : void
      {
         _impl.pause();
      }
      
      public static function resume() : void
      {
         _impl.resume();
      }
   }
}

