package com.mole.app.manager
{
   import com.mole.app.map.MapManager;
   import com.mole.app.module.AppModuleControl;
   import com.mole.app.module.ModuleEvent;
   import com.mole.app.type.ModuleType;
   
   public class WineshopManager
   {
      
      public function WineshopManager()
      {
         super();
      }
      
      public static function openGame() : void
      {
         MapManager.clearMap();
         var wineGame:AppModuleControl = ModuleManager.openGame(ModuleType.WINESHOP_OPERATE_GAME);
         wineGame.addEventListener(ModuleEvent.DESTROY,onExitWineGame);
      }
      
      private static function onExitWineGame(e:ModuleEvent) : void
      {
         var wineGame:AppModuleControl = e.currentTarget as AppModuleControl;
         wineGame.removeEventListener(ModuleEvent.DESTROY,onExitWineGame);
         if(Boolean(e.data))
         {
            if(MapManager.curMapID < 10000)
            {
               MapManager.refreshMap();
            }
            else
            {
               MapManager.enterMap(1);
            }
         }
      }
   }
}

