package com.mole.app.activity
{
   import com.mole.app.manager.StatisticsManager;
   import com.mole.app.map.MapManager;
   
   public class KFCStaticsManager
   {
      
      private static var instance:KFCStaticsManager;
      
      public function KFCStaticsManager()
      {
         super();
      }
      
      public static function getInstance() : KFCStaticsManager
      {
         if(!instance)
         {
            instance = new KFCStaticsManager();
         }
         return instance;
      }
      
      public function setUp() : void
      {
         if(203 == MapManager.curMapID)
         {
            StatisticsManager.send(198);
         }
         else if(57 == MapManager.curMapID)
         {
            StatisticsManager.send(199);
         }
      }
   }
}

