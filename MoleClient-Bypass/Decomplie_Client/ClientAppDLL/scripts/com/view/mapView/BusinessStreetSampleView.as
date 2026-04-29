package com.view.mapView
{
   import com.mole.app.manager.StatisticsManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.map.MapManager;
   
   public class BusinessStreetSampleView extends MapBase
   {
      
      public function BusinessStreetSampleView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         controlLevel["police_mc"].visible = false;
         SystemEventManager.addEventListener("qiehuan",this.changeMapHandle);
      }
      
      private function changeMapHandle(e:*) : void
      {
         StatisticsManager.send(352);
         MapManager.enterMap(358);
      }
      
      override public function destroy() : void
      {
         SystemEventManager.removeEventListener("qiehuan",this.changeMapHandle);
         super.destroy();
      }
   }
}

