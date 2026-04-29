package com.core.info
{
   public class ServerInfo
   {
      
      public static var MobileOperatorURL:String;
      
      private static var Email_Info:Object = {};
      
      private static var DirSer_Info:Object = {};
      
      private static var GetPassWord_Info:Object = {};
      
      private static var ModPassword_Info:Object = {};
      
      private static var PassWord_Info:Object = {};
      
      private static var RegistSer_Info:Object = {};
      
      private static var Visitor_Info:Object = {};
      
      private static var Game_Info:Object = {};
      
      public static const IP:String = "Ip";
      
      public static const PORT:String = "Port";
      
      public function ServerInfo()
      {
         super();
      }
      
      public static function parseXML(xml:XML) : void
      {
         MobileOperatorURL = "http://" + xml.taomee.@MOUrl.toString() + "/";
         Email_Info = {
            "Ip":xml.Email.@ip.toString(),
            "Port":xml.Email.@port.toString()
         };
         DirSer_Info = {
            "Ip":xml.DirSer.@ip.toString(),
            "Port":xml.DirSer.@port.toString()
         };
         GetPassWord_Info = {
            "Ip":xml.GetPassWord.@ip.toString(),
            "Port":xml.GetPassWord.@port.toString()
         };
         ModPassword_Info = {
            "Ip":xml.ModPassword.@ip.toString(),
            "Port":xml.ModPassword.@port.toString()
         };
         PassWord_Info = {
            "Ip":xml.PassWord.@ip.toString(),
            "Port":xml.PassWord.@port.toString()
         };
         RegistSer_Info = {
            "Ip":xml.RegistSer.@ip.toString(),
            "Port":xml.RegistSer.@port.toString()
         };
         Visitor_Info = {
            "Ip":xml.Visitor.@ip.toString(),
            "Port":xml.Visitor.@port.toString()
         };
         Game_Info = {
            "Ip":xml.GameSer.@ip.toString(),
            "Port":xml.GameSer.@port.toString()
         };
      }
      
      public static function getEmailInfo(KEY:String) : *
      {
         return Email_Info[KEY];
      }
      
      public static function getDirSerInfo(KEY:String) : *
      {
         return DirSer_Info[KEY];
      }
      
      public static function getGetPassWordInfo(KEY:String) : *
      {
         return GetPassWord_Info[KEY];
      }
      
      public static function getModPassWordInfo(KEY:String) : *
      {
         return ModPassword_Info[KEY];
      }
      
      public static function getPassWordInfo(KEY:String) : *
      {
         return PassWord_Info[KEY];
      }
      
      public static function getRegistSerInfo(KEY:String) : *
      {
         return RegistSer_Info[KEY];
      }
      
      public static function getVisitorInfo(KEY:String) : *
      {
         return Visitor_Info[KEY];
      }
      
      public static function getGameInfo(KEY:String) : *
      {
         return Game_Info[KEY];
      }
   }
}

