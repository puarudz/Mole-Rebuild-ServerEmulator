package com.view.mapView
{
   import com.mole.app.map.MapBase;
   import flash.display.MovieClip;
   
   public class BoatMapOutSideView extends MapBase
   {
      
      public var button_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var target_mc:MovieClip;
      
      public function BoatMapOutSideView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.button_mc = GV.MC_mapFrame["buttonLevel"];
         debugLevel.mouseChildren = true;
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
   }
}

