package com.view.mapView
{
   import com.core.MainManager;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class queenBedroom
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var btn_mc:MovieClip;
      
      private var gift_MC:MovieClip;
      
      private var childMC:*;
      
      public function queenBedroom()
      {
         super();
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.btn_mc = GV.MC_mapFrame["buttonLevel"];
         setTimeout(this.init,100);
      }
      
      public function init() : void
      {
         this.depth_mc.mouseEnabled = false;
         this.depth_mc.mouseChildren = false;
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         this.btn_mc.bookMC.buttonMode = true;
         BC.addEvent(this,this.btn_mc.bookMC,MouseEvent.CLICK,this.onBookClick);
      }
      
      private function onLoadPanel(url:String) : void
      {
         this.gift_MC = new MovieClip();
         this.gift_MC.name = "gift_MC";
         MainManager.getAppLevel().addChild(this.gift_MC);
         var tempMC:MCLoader = new MCLoader(url,this.gift_MC,1,"請耐心等待......");
         tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadCallBoardHandler);
         tempMC.doLoad();
      }
      
      private function loadCallBoardHandler(e:*) : void
      {
         var mainMC:DisplayObjectContainer = e.getParent();
         this.childMC = e.getLoader();
         mainMC.addChild(this.childMC);
      }
      
      public function clearHandler(e:* = null) : void
      {
         GC.clearAll(this.gift_MC);
         this.childMC = null;
         this.gift_MC = null;
      }
      
      private function onBookClick(e:MouseEvent) : void
      {
         BC.addEvent(this,GV.onlineSocket,"closeBlackForest",this.clearHandler);
         this.onLoadPanel("resource/task/blackForestDiary.swf");
      }
      
      private function removeEventHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
      }
   }
}

