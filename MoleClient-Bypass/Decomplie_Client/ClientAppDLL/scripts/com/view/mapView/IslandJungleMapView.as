package com.view.mapView
{
   import com.common.tip.tip;
   import com.module.AngelsAndDemons.AngelsAndDemonsCtl;
   import com.mole.app.map.MapBase;
   import flash.display.MovieClip;
   import flash.events.*;
   
   public class IslandJungleMapView extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var topMC:MovieClip;
      
      public var button_mc:MovieClip;
      
      public function IslandJungleMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.topMC = GV.MC_mapFrame["top_mc"];
         this.button_mc = GV.MC_mapFrame["buttonLevel"];
         this.target_mc.openGame_btn.buttonMode = true;
         tip.tipTailDisPlayObject(this.target_mc.openGame_btn,"挑戰刺青");
         BC.addEvent(this,this.target_mc.openGame_btn,MouseEvent.CLICK,this.openGameEvent);
         BC.addEvent(this,this.target_mc.open_btn,MouseEvent.CLICK,this.openHandler);
      }
      
      private function openHandler(evt:MouseEvent) : void
      {
         AngelsAndDemonsCtl.instance.LoadExchangePanelFun();
      }
      
      private function openGameEvent(evt:MouseEvent) : void
      {
         AngelsAndDemonsCtl.instance.LoadBeginPanelFun(AngelsAndDemonsCtl.begin_url,4);
      }
      
      override public function destroy() : void
      {
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
         this.topMC = null;
         this.button_mc = null;
         super.destroy();
      }
   }
}

