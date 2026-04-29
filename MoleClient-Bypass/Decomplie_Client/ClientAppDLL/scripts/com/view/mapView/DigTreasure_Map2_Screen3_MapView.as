package com.view.mapView
{
   import com.module.digTreasure.DigTreasureViewCtl;
   import com.mole.app.map.MapBase;
   
   public class DigTreasure_Map2_Screen3_MapView extends MapBase
   {
      
      public function DigTreasure_Map2_Screen3_MapView()
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

