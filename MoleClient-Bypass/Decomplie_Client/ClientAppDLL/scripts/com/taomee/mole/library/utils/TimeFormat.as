package com.taomee.mole.library.utils
{
   public class TimeFormat
   {
      
      public static const TIME_FORMAT_HHMM:String = "hh:mm";
      
      public static const TIME_FORMAT_MMSS:String = "mm:ss";
      
      public static const TIME_FORMAT_HHMMSS:String = "hh:mm:ss";
      
      public static const TIME_FORMAT_MMDD:String = "mm-dd";
      
      public static const TIME_FORMAT_YYMMDD:String = "yy-mm-dd";
      
      public static const TIME_FORMAT_YYMMDD_HHMMSS:String = "yy-mm-dd hh:mm:ss";
      
      public function TimeFormat()
      {
         super();
      }
      
      public static function getTimeStr(date:Date, formatStr:String = "hh:mm:ss") : String
      {
         var year:String = String(date.getFullYear());
         var month:String = String(date.getMonth() + 1);
         var dateStr:String = String(date.getDate());
         var hour:String = String(date.getHours() < 10 ? "0" + date.getHours() : date.getHours());
         var minu:String = String(date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes());
         var sec:String = String(date.getSeconds() < 10 ? "0" + date.getSeconds() : date.getSeconds());
         var rtnStr:String = "";
         switch(formatStr)
         {
            case TIME_FORMAT_HHMM:
               rtnStr = hour + ":" + minu;
               break;
            case TIME_FORMAT_MMSS:
               rtnStr = minu + ":" + sec;
               break;
            case TIME_FORMAT_HHMMSS:
               rtnStr = hour + ":" + minu + ":" + sec;
               break;
            case TIME_FORMAT_MMDD:
               rtnStr = month + "-" + dateStr;
               break;
            case TIME_FORMAT_YYMMDD:
               rtnStr = year + "-" + month + "-" + dateStr;
               break;
            case TIME_FORMAT_YYMMDD_HHMMSS:
               rtnStr = year + "-" + month + "-" + dateStr + " " + hour + ":" + minu + ":" + sec;
         }
         return rtnStr;
      }
      
      public static function getTimeStrFromSec(secNum:uint, formatStr:String = "hh:mm:ss") : String
      {
         var hour:String = String(int(secNum / 3600) < 10 ? "0" + int(secNum / 3600) : int(secNum / 3600));
         var minu:String = String(int(secNum % 3600 / 60) < 10 ? "0" + int(secNum % 3600 / 60) : int(secNum % 3600 / 60));
         var sec:String = String(int(secNum % 60) < 10 ? "0" + int(secNum % 60) : int(secNum % 60));
         var rtnStr:String = "";
         switch(formatStr)
         {
            case TIME_FORMAT_HHMM:
               rtnStr = hour + ":" + minu;
               break;
            case TIME_FORMAT_MMSS:
               rtnStr = minu + ":" + sec;
               break;
            case TIME_FORMAT_HHMMSS:
               rtnStr = hour + ":" + minu + ":" + sec;
         }
         return rtnStr;
      }
   }
}

