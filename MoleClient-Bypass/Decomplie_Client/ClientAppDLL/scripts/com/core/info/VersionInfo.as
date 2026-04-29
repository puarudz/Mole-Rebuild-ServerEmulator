package com.core.info
{
   import com.global.links.Links;
   
   public class VersionInfo
   {
      
      private static var allversion:String;
      
      private static var ErrorWeb:String;
      
      private static var HouseWeb:String;
      
      private static var regversion:String;
      
      private static var indexversion:String;
      
      private static var uiversion:String;
      
      private static var mapversion:String;
      
      private static var moduleversion:String;
      
      public function VersionInfo()
      {
         super();
      }
      
      public static function parseXML(xml:XML) : void
      {
         allversion = xml.taomee.@allversion.toString();
         ErrorWeb = xml.taomee.@ErrorWeb.toString();
         HouseWeb = xml.taomee.@HouseWeb.toString();
         regversion = xml.taomee.@regversion.toString();
         indexversion = xml.taomee.@indexversion.toString();
         uiversion = xml.taomee.@uiversion.toString();
         mapversion = xml.taomee.@mapversion.toString();
         moduleversion = xml.taomee.@moduleversion.toString();
         Links.version = allversion;
         Links.regversion = regversion;
         Links.indexversion = indexversion;
         Links.uiversion = uiversion;
         Links.mapversion = mapversion;
         Links.moduleversion = moduleversion;
         Links.Web = "http://" + ErrorWeb;
         trace("Links.version",Links.version);
         trace("Links.regversion",Links.regversion);
         trace("Links.indexversion",Links.indexversion);
         trace("Links.uiversion",Links.uiversion);
         trace("Links.mapversion",Links.mapversion);
         trace("Links.moduleversion",Links.moduleversion);
         trace("Links.Web",Links.Web);
      }
      
      public static function getAllVersion() : String
      {
         return allversion;
      }
      
      public static function getErrorWeb() : String
      {
         return ErrorWeb;
      }
      
      public static function getHouseWeb() : String
      {
         return HouseWeb;
      }
      
      public static function getRegVersion() : String
      {
         return regversion;
      }
      
      public static function getIndexVersion() : String
      {
         return indexversion;
      }
      
      public static function getUIVersion() : String
      {
         return uiversion;
      }
      
      public static function getMapVersion() : String
      {
         return mapversion;
      }
      
      public static function getModuleVersion() : String
      {
         return moduleversion;
      }
   }
}

