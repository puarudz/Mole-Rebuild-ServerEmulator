package com.view.mapView
{
   import com.module.digTreasure.DigTreasureViewCtl;
   import com.mole.app.map.MapBase;
   
   public class MysteriousTreasureRoomMapView extends MapBase
   {
      
      public function MysteriousTreasureRoomMapView()
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

