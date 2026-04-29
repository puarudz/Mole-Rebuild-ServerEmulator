package com.view.mapView
{
   import com.common.tip.tip;
   import com.module.AngelsAndDemons.AngelsAndDemonsCtl;
   import com.mole.app.map.MapBase;
   import flash.events.*;
   
   public class IslandCaveMapView extends MapBase
   {
      
      public function IslandCaveMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         controlLevel.openGame_btn.buttonMode = true;
         tip.tipTailDisPlayObject(controlLevel.openGame_btn,"挑戰傑拉德");
         BC.addEvent(this,controlLevel.openGame_btn,MouseEvent.CLICK,this.openGameEvent);
         BC.addEvent(this,controlLevel.open_btn,MouseEvent.CLICK,this.openHandler);
      }
      
      private function openHandler(evt:MouseEvent) : void
      {
         AngelsAndDemonsCtl.instance.LoadExchangePanelFun();
      }
      
      private function openGameEvent(evt:MouseEvent) : void
      {
         AngelsAndDemonsCtl.instance.LoadBeginPanelFun(AngelsAndDemonsCtl.begin_url,6);
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
   }
}

