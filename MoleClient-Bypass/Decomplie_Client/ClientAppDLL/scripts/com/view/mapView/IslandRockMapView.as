package com.view.mapView
{
   import com.common.tip.tip;
   import com.module.AngelsAndDemons.AngelsAndDemonsCtl;
   import com.mole.app.map.MapBase;
   import com.view.mapView.activity.activity201308.EliseDiary20130830;
   import com.view.mapView.activity.creatShareObject;
   import flash.display.MovieClip;
   import flash.events.*;
   
   public class IslandRockMapView extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var topMC:MovieClip;
      
      public var button_mc:MovieClip;
      
      private var doBool:Boolean = true;
      
      private var guiwu:MovieClip;
      
      private var playNum:int = 0;
      
      public function IslandRockMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.topMC = GV.MC_mapFrame["top_mc"];
         this.button_mc = GV.MC_mapFrame["buttonLevel"];
         this.guiwu = this.target_mc["guiwu"] as MovieClip;
         if(creatShareObject.getInstance().getDepression182() != 1)
         {
            this.doBool = false;
            this.guiwu.gotoAndStop(2);
         }
         this.target_mc.openGame_btn.buttonMode = true;
         tip.tipTailDisPlayObject(this.target_mc.openGame_btn,"挑戰青刺");
         BC.addEvent(this,this.target_mc.openGame_btn,MouseEvent.CLICK,this.openGameEvent);
         if(!this.doBool)
         {
            this.playNum = 0;
            BC.addEvent(this,GV.onlineSocket,"oven_Depression",this.ovenEvent);
         }
         BC.addEvent(this,this.target_mc.open_btn,MouseEvent.CLICK,this.openHandler);
         EliseDiary20130830.getInstance().serverInfo();
      }
      
      private function openHandler(evt:MouseEvent) : void
      {
         AngelsAndDemonsCtl.instance.LoadExchangePanelFun();
      }
      
      private function openGameEvent(evt:MouseEvent) : void
      {
         if(this.doBool)
         {
            AngelsAndDemonsCtl.instance.LoadBeginPanelFun(AngelsAndDemonsCtl.begin_url,5);
         }
         else
         {
            this.depth_mc.mc.gotoAndStop(2);
         }
      }
      
      private function ovenEvent(evt:Event) : void
      {
         ++this.playNum;
         if(this.playNum == 2)
         {
            this.doBool = true;
            creatShareObject.getInstance().setDepression182(1);
         }
      }
      
      override public function destroy() : void
      {
         EliseDiary20130830.getInstance().destroy();
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
         this.topMC = null;
         this.button_mc = null;
         super.destroy();
      }
   }
}

