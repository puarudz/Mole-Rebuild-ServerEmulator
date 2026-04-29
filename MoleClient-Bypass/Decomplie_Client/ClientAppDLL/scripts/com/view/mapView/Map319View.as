package com.view.mapView
{
   import com.mole.app.activity.DreamActivity;
   import com.mole.app.map.MapBase;
   
   public class Map319View extends MapBase
   {
      
      public function Map319View()
      {
         super();
      }
      
      override protected function initView() : void
      {
         DreamActivity.inst.init();
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
   }
}

