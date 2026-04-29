package com.mole.app.manager
{
   import org.taomee.ds.HashMap;
   
   public class NewStatisticsManager
   {
      
      private static var xmlClass:Class = NewStatisticsManager_xmlClass;
      
      private static var _statistics:HashMap = new HashMap();
      
      setup();
      
      public function NewStatisticsManager()
      {
         super();
      }
      
      private static function setup() : void
      {
         var xml:XML = null;
         var statisticsXML:XML = XML(new xmlClass());
         var itemList:XMLList = statisticsXML.descendants("name");
         for each(xml in itemList)
         {
            _statistics.add(uint(xml.@id),{
               "mainName":String(xml.@mainName),
               "partName":String(xml.@partName),
               "key":String(xml.@key),
               "staticsKey":String(xml.@staticsKey),
               "url":String(xml.@url),
               "urlTimes":String(xml.@urlTimes)
            });
         }
      }
      
      public static function send(staticsticsId:uint) : void
      {
      }
   }
}

