package com.mole.app.manager
{
   import org.taomee.ds.HashMap;
   
   public class StatisticsManager
   {
      
      private static var xmlClass:Class = StatisticsManager_xmlClass;
      
      private static var _statistics:HashMap = new HashMap();
      
      setup();
      
      public function StatisticsManager()
      {
         super();
      }
      
      private static function setup() : void
      {
         var xml:XML = null;
         var statisticsXML:XML = XML(new xmlClass());
         var itemList:XMLList = statisticsXML.descendants("item");
         for each(xml in itemList)
         {
            _statistics.add(uint(xml.@id),{
               "type":uint(xml.@type),
               "url":String(xml.@url),
               "timeId":uint(xml.@timeId)
            });
         }
      }
      
      public static function send(staticsticsId:uint) : void
      {
      }
      
      public static function whenOpenModule(moduleName:String) : void
      {
         if(moduleName == "WakeUpAtFivePanel")
         {
            NewStatisticsManager.send(309);
         }
         else if(moduleName == "WakeUpAtFiveGame")
         {
            NewStatisticsManager.send(310);
         }
         else if(moduleName == "DreamBookBasePanel")
         {
            NewStatisticsManager.send(137);
         }
         else if(moduleName == "SweetPastryPanel")
         {
            NewStatisticsManager.send(138);
         }
         else if(moduleName == "DecorateScencesHappyPanel")
         {
            NewStatisticsManager.send(139);
         }
      }
      
      public static function whenGoMap(mapID:uint) : void
      {
         switch(mapID)
         {
            case 60:
               NewStatisticsManager.send(140);
               break;
            case 47:
               NewStatisticsManager.send(141);
               break;
            case 16:
               NewStatisticsManager.send(142);
               break;
            case 2:
               NewStatisticsManager.send(130);
               NewStatisticsManager.send(126);
         }
      }
      
      public static function whenTask(taskID:uint) : void
      {
         switch(taskID)
         {
            case 645:
               StatisticsManager.send(512);
               break;
            case 639:
               StatisticsManager.send(513);
         }
      }
   }
}

