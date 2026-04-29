package org.taomee.log
{
   import flash.utils.getQualifiedClassName;
   
   public class Logger
   {
      
      public static var enabled:Boolean;
      
      public static var level:int = 0;
      
      public function Logger()
      {
         super();
      }
      
      public static function debug(context:Object, msg:String, appender:Object = null) : void
      {
         log(context,LogLevel.DEBUG,msg);
      }
      
      public static function info(context:Object, msg:String, appender:Object = null) : void
      {
         log(context,LogLevel.INFO,msg);
      }
      
      public static function warn(context:Object, msg:String, appender:Object = null) : void
      {
         log(context,LogLevel.WARN,msg);
      }
      
      public static function error(context:Object, msg:String, appender:Object = null) : void
      {
         log(context,LogLevel.ERROR,msg);
      }
      
      public static function fatal(context:Object, msg:String, appender:Object = null) : void
      {
         log(context,LogLevel.FATAL,msg);
      }
      
      private static function log(context:Object, level:int, msg:String, appender:Object = null) : void
      {
         if(enabled)
         {
            if(appender == null)
            {
               appender = TraceAppender;
            }
            if(level >= Logger.level)
            {
               appender.append(getLevelString(level),getQualifiedClassName(context),msg);
            }
         }
      }
      
      private static function getLevelString(level:int) : String
      {
         switch(level)
         {
            case 1:
               return "Debug";
            case 2:
               return "Info";
            case 3:
               return "Warn";
            case 4:
               return "Error";
            case 5:
               return "Fatal";
            default:
               return "";
         }
      }
   }
}

