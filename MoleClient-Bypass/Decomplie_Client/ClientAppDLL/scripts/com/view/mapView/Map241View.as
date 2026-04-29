package com.view.mapView
{
   import com.mole.app.map.MapBase;
   import com.view.mapView.activity.Task83.DragonsTreasureActiviteCtl;
   
   public class Map241View extends MapBase
   {
      
      public function Map241View()
      {
         super();
      }
      
      override protected function initView() : void
      {
         DragonsTreasureActiviteCtl.instance.InitMap241(buttonLevel);
      }
      
      override public function destroy() : void
      {
         DragonsTreasureActiviteCtl.instance.destroy();
         super.destroy();
      }
   }
}

