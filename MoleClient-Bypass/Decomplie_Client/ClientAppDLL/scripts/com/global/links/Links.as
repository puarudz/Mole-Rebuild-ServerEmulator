package com.global.links
{
   public class Links
   {
      
      public static var stageMC:*;
      
      public static var Web:String;
      
      public static var version:String = "1";
      
      public static var regversion:String = "";
      
      public static var indexversion:String = "";
      
      public static var uiversion:String = "";
      
      public static var mapversion:String = "";
      
      public static var moduleversion:String = "";
      
      public static var ServerConfig:String = "conf/Server.xml";
      
      public static var ui:String = "resource/ui/ui.swf";
      
      public function Links()
      {
         super();
      }
      
      public static function getUrl(url:String, hasRandom:Boolean = false, QuestString:String = "", PRILevel:Object = null) : String
      {
         if(hasRandom)
         {
            if(url.indexOf("?") >= 0)
            {
               url = url + "&" + int(Math.random() * 999999) + (Boolean(QuestString) ? "&" + QuestString : "");
            }
            else
            {
               url = url + "?" + int(Math.random() * 999999) + (Boolean(QuestString) ? "&" + QuestString : "");
            }
         }
         else if(url.indexOf("?") >= 0)
         {
            url += Boolean(QuestString) ? "&" + QuestString : "";
         }
         else
         {
            url += Boolean(QuestString) ? "?" + QuestString : "";
         }
         return url;
      }
   }
}

