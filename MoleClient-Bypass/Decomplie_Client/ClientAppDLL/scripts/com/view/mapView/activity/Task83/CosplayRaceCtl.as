package com.view.mapView.activity.Task83
{
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.type.ModuleType;
   
   public class CosplayRaceCtl
   {
      
      private static var _instance:CosplayRaceCtl;
      
      public function CosplayRaceCtl()
      {
         super();
      }
      
      public static function get instance() : CosplayRaceCtl
      {
         if(_instance == null)
         {
            _instance = new CosplayRaceCtl();
         }
         return _instance;
      }
      
      public function JoinRace(result:Object) : void
      {
         ModuleManager.openPanel(ModuleType.COSPLAY_RACE_PANEL,result);
      }
   }
}

