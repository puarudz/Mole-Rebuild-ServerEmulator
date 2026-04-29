package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.ServerUpTime;
   import com.module.loadExtentPanel.LoadGame;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   
   public class SkyTreeMapView extends MapBase
   {
      
      public function SkyTreeMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         SystemEventManager.addEventListener("openSkyTreeQAHAHA",this.openSkyTreeQA);
         SystemEventManager.addEventListener("openSkyTreeAward",this.openSkyTreeAward);
      }
      
      private function openSkyTreeQA(e:*) : void
      {
         var loadGame:LoadGame = null;
         var date:Date = ServerUpTime.getInstance().date;
         if(date.month == 6 && date.date < 19)
         {
            Alert.smileAlart("7/19 開始挑戰，敬請期待!");
         }
         else
         {
            loadGame = new LoadGame("module/external/SkyTreeQA.swf?type=3","正在打開天空樹答題...",MainManager.getAppLevel());
            loadGame = null;
         }
      }
      
      private function openSkyTreeAward(e:*) : void
      {
         var loadGame:LoadGame = new LoadGame("module/external/SkyTreeAwardPanel.swf","正在打開兌換獎勵...",MainManager.getAppLevel());
         loadGame = null;
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
   }
}

