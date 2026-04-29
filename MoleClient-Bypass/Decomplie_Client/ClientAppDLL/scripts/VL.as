package
{
   import flash.net.URLRequest;
   
   public final class VL
   {
      
      private static var _o:Object;
      
      private static var _debugRnd:int;
      
      private static var _debug:Boolean = false;
      
      public function VL()
      {
         super();
      }
      
      public static function setup(o:Object, debug:Boolean = false) : void
      {
         _o = o;
         _debug = debug;
         _debugRnd = Math.random() * 999999 + 1;
      }
      
      public static function get debug() : Boolean
      {
         return _debug;
      }
      
      public static function get versionTime() : Number
      {
         return (_o.getInstance().lastModifiedDate as Date).time * 0.001;
      }
      
      public static function get version() : String
      {
         return getVersionView(_o.getInstance().lastModifiedDate as Date);
      }
      
      private static function getVersionView(t:Date) : String
      {
         return t.fullYear + "." + (t.month + 1) + "." + t.date + " " + t.hours + ":" + t.minutes + ":" + t.seconds + " " + (t.hours >= 12 ? "PM" : "AM");
      }
      
      public static function getURL(path:String) : String
      {
         return addDebugVars(_o.getInstance().getVerURLByNameSpace(path) as String);
      }
      
      public static function getURLRequest(url:String = "", nameSpace:String = "all", addDebug:Boolean = true) : URLRequest
      {
         var request:URLRequest = _o.getInstance(nameSpace).getURLRequest(url);
         if(addDebug)
         {
            request.url = addDebugVars(request.url);
         }
         return request;
      }
      
      private static function addDebugVars(url:String) : String
      {
         if(_debug)
         {
            url += (url.indexOf("?") == -1 ? "?dr=" : "&dr=") + _debugRnd;
         }
         return url;
      }
   }
}

