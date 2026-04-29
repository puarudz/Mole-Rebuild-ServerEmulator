package com.view.mapView
{
   import com.module.digTreasure.DigTreasureViewCtl;
   import com.mole.app.map.MapBase;
   
   public class SquareSitesMapView extends MapBase
   {
      
      public function SquareSitesMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
      }
      
      override public function init() : void
      {
         var dig:DigTreasureViewCtl = new DigTreasureViewCtl();
         dig.Init(GV.MC_mapFrame,GV.MapInfo_mapID);
      }
   }
}

