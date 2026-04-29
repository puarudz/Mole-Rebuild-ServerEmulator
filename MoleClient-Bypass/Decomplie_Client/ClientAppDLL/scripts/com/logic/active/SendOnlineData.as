package com.logic.active
{
   import com.common.util.StringUtil;
   import com.core.info.LocalUserInfo;
   import com.global.staticData.CommandID;
   import flash.external.ExternalInterface;
   import flash.system.Capabilities;
   import flash.utils.ByteArray;
   
   public class SendOnlineData
   {
      
      private static var _inst:SendOnlineData;
      
      public function SendOnlineData()
      {
         super();
      }
      
      public static function get inst() : SendOnlineData
      {
         if(_inst == null)
         {
            _inst = new SendOnlineData();
         }
         return _inst;
      }
      
      public static function get browserVersion() : String
      {
         var type:String = null;
         var ver:String = null;
         if(ExternalInterface.available)
         {
            type = ExternalInterface.call("getBrowserType");
            ver = ExternalInterface.call("getBrowserVersion");
            return type + ":" + ver;
         }
         return "null";
      }
      
      public static function get ad() : String
      {
         if(ExternalInterface.available)
         {
            return ExternalInterface.call("getAd");
         }
         return "null";
      }
      
      public function init() : void
      {
         trace(GF.leve(LocalUserInfo.getExp()));
         trace(Capabilities.version);
         if(!ExternalInterface.available)
         {
            return;
         }
         ExternalInterface.call("eval","function getBrowserType() { var typeList = [\"chrome\", \"firefox\", \"msie\", \"opera\", \"safari\"]; var browser = window.T.browser; for (var i = 0; i < typeList.length; i++) { if (browser[typeList[i]]) { return typeList[i]; } } return \"unknown\"; }");
         ExternalInterface.call("eval","function getBrowserVersion(){return window.T.browser.version;}");
         ExternalInterface.call("eval","function getAd() { try { return ad.get.g(); } catch (e) { return \"none\" }");
         trace(browserVersion);
         var lv:uint = uint(GF.leve(LocalUserInfo.getExp()));
         var ip:uint = 0;
         var navigate:ByteArray = StringUtil.FillString(browserVersion,19);
         var os:ByteArray = StringUtil.FillString(Capabilities.version,19);
         var ads:ByteArray = StringUtil.FillString("0",19);
         GF.sendSocket(CommandID.LAND_ONLINE_DATA_PLANT,lv,navigate,os,ads);
      }
   }
}

