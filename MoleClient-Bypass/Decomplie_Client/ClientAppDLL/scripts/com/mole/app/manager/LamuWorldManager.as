package com.mole.app.manager
{
   import com.core.manager.LevelManager;
   import com.module.loadExtentPanel.LoadGame;
   import com.mole.app.event.SystemEvent;
   import com.view.mapView.activity.lamuWorldConver.lamuWorldConverNPCState;
   
   public class LamuWorldManager
   {
      
      public function LamuWorldManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         SystemEventManager.addEventListener("Lamu_LamuWorldConver",onLamuWorldConver);
      }
      
      private static function onLamuWorldConver(e:SystemEvent) : void
      {
         var npcID:int = e.data;
         lamuWorldConverNPCState.getInstance().setClickObjId(npcID);
         new LoadGame("module/external/LamuWorldConvertMain.swf","正在加載拉姆碎片兌換",LevelManager.appLevel);
      }
   }
}

