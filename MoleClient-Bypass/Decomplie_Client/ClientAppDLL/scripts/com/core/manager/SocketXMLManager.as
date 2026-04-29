package com.core.manager
{
   import flash.utils.Dictionary;
   
   public class SocketXMLManager
   {
      
      private static var xmlData:XML;
      
      private static var socketDataMap:Dictionary;
      
      public static const ONLINE_SERVER:String = "onlineServer";
      
      public static const GAME_SERVER:String = "gameServer";
      
      public function SocketXMLManager()
      {
         super();
      }
      
      public static function initXML(_xml:XML) : void
      {
         xmlData = _xml;
         socketDataMap = new Dictionary(true);
         parseXML();
      }
      
      private static function parseXML() : void
      {
         var i:XML = null;
         var _xml:XMLList = null;
         for each(i in xmlData.elements())
         {
            _xml = xmlData.elements(i.name().toString());
            socketDataMap[i.name().toString()] = new SocketDataManager(_xml);
         }
      }
      
      public static function getSocketData(KEY:String) : SocketDataManager
      {
         return socketDataMap[KEY];
      }
   }
}

