package com.view.mapView
{
   import com.common.Tween.TweenLite;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.logic.MapManageLogic.MapModelLogic;
   import com.module.AngelsAndDemons.AngelsAndDemonsCtl;
   import com.mole.app.map.MapBase;
   import com.view.mapView.activity.creatShareObject;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.geom.Point;
   
   public class IslandDepressionMapView extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var topMC:MovieClip;
      
      public var button_mc:MovieClip;
      
      public var type_mc:MovieClip;
      
      private var openBool:Boolean = false;
      
      private var gunzi:MovieClip;
      
      private var startPoint:Point;
      
      private var startBool:Boolean = false;
      
      private var guiwu:MovieClip;
      
      private var clcikNum:int = 0;
      
      public function IslandDepressionMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.topMC = GV.MC_mapFrame["top_mc"];
         this.button_mc = GV.MC_mapFrame["buttonLevel"];
         this.type_mc = GV.MC_mapFrame["type_mc"];
         this.gunzi = this.topMC["gunzi"] as MovieClip;
         this.guiwu = this.target_mc["guiwu"] as MovieClip;
         this.target_mc.openGame_btn.buttonMode = true;
         BC.addEvent(this,this.target_mc.openGame_btn,MouseEvent.CLICK,this.openGameEvent);
         if(creatShareObject.getInstance().getDepression() != 1)
         {
            this.openBool = false;
            MainManager.getAppLevel().addChild(this.gunzi);
            this.gunzi.buttonMode = true;
            this.guiwu.gotoAndStop(2);
            this.interactionEvent();
         }
         else
         {
            tip.tipTailDisPlayObject(this.target_mc.openGame_btn,"挑戰啊嗚花");
            this.openBool = true;
            this.gunzi.visible = false;
            this.guiwu.visible = false;
            this.guiwu.mouseEnabled = false;
            this.gunzi.mouseEnabled = false;
            this.newMap();
         }
         BC.addEvent(this,this.target_mc.open_btn,MouseEvent.CLICK,this.openHandler);
      }
      
      private function openHandler(evt:MouseEvent) : void
      {
         AngelsAndDemonsCtl.instance.LoadExchangePanelFun();
      }
      
      private function openGameEvent(evt:MouseEvent) : void
      {
         if(this.openBool)
         {
            AngelsAndDemonsCtl.instance.LoadBeginPanelFun(AngelsAndDemonsCtl.begin_url,3);
         }
         else
         {
            this.guiwu.gotoAndStop(3);
         }
      }
      
      private function interactionEvent() : void
      {
         this.startPoint = new Point(this.gunzi.x,this.gunzi.y);
         BC.addEvent(this,this.gunzi,MouseEvent.CLICK,this.gunziClickFun);
         BC.addEvent(this,this.guiwu.btn.stage,MouseEvent.CLICK,this.guiwuClickFun);
      }
      
      private function gunziClickFun(evt:MouseEvent) : void
      {
         if(this.startBool)
         {
            if(Boolean(this.guiwu.btn.hitTestPoint(this.gunzi.x,this.gunzi.y)) && this.guiwu.currentFrame < 4)
            {
               this.clcikNum = 1;
               this.guiwu.gotoAndStop(4);
               this.gunzi.gotoAndStop(3);
               this.gunzi.startDrag(true);
            }
            else if(Boolean(this.guiwu.btn.hitTestPoint(this.gunzi.x,this.gunzi.y)) && this.guiwu.currentFrame == 4)
            {
               if(this.guiwu.mc.currentFrame >= 100)
               {
                  this.clcikNum = 2;
                  this.guiwu.gotoAndStop(5);
                  this.gunzi.gotoAndStop(3);
                  this.gunzi.startDrag(true);
                  this.ovenEvent();
               }
               else
               {
                  this.gunzi.gotoAndStop(3);
                  this.gunzi.startDrag(true);
               }
            }
            else
            {
               this.romoveEvent();
            }
         }
         else
         {
            this.startBool = true;
            this.gunzi.gotoAndStop(2);
            this.gunzi.startDrag(true);
         }
      }
      
      private function romoveEvent() : void
      {
         this.startBool = false;
         this.gunzi.gotoAndStop(1);
         this.gunzi.stopDrag();
         TweenLite.to(this.gunzi,1,{
            "x":this.startPoint.x,
            "y":this.startPoint.y
         });
      }
      
      private function ovenEvent() : void
      {
         this.romoveEvent();
         this.guiwu.mouseEnabled = false;
         this.gunzi.mouseEnabled = false;
         BC.removeEvent(this,this.gunzi,MouseEvent.CLICK,this.gunziClickFun);
         BC.removeEvent(this,this.guiwu.btn,MouseEvent.CLICK,this.guiwuClickFun);
         creatShareObject.getInstance().setDepression(1);
         tip.tipTailDisPlayObject(this.target_mc.openGame_btn,"挑戰啊嗚花");
         this.openBool = true;
         this.newMap();
      }
      
      private function newMap() : void
      {
         this.type_mc.mc.parent.removeChild(this.type_mc.mc);
         MapModelLogic.owner.makeMapArray(true);
      }
      
      private function guiwuClickFun(evt:MouseEvent) : void
      {
         if(this.clcikNum == 0)
         {
            this.guiwu.gotoAndStop(3);
         }
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

