package com.view.mapView
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class bigSpiderView extends BasicMapView
   {
      
      private var button_mc:MovieClip;
      
      public function bigSpiderView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.button_mc = GV.MC_mapFrame["buttonLevel"];
         BC.addEvent(this,this.button_mc.bigzzBtn,MouseEvent.CLICK,this.onBigzz);
      }
      
      private function onBigzz(evt:MouseEvent) : void
      {
         GF.switchPrevMap();
      }
   }
}

