package com.view.mapView
{
   import com.event.EventTaomee;
   import com.mole.app.map.MapBase;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class MomoCradleView extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var type_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var button_mc:MovieClip;
      
      public var top_mc:MovieClip;
      
      public function MomoCradleView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.type_mc = GV.MC_mapFrame["type_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.button_mc = GV.MC_mapFrame["buttonLevel"];
         this.top_mc = GV.MC_mapFrame["top_mc"];
         MovieClip(this.target_mc.momoBaby).buttonMode = true;
      }
      
      private function cardleOvenEvent(evt:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"baby_oven",this.cardleOvenEvent);
      }
      
      private function removeEventHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
      }
   }
}

