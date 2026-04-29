package com.view.mapView
{
   import com.core.info.LocalUserInfo;
   import com.logic.switchMapLogic.switchMapLogic;
   import com.mole.app.map.MapBase;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class LamuCloundsSee extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var top_mc:MovieClip;
      
      public var botton_mc:MovieClip;
      
      private var lightBallMC:MovieClip;
      
      public function LamuCloundsSee()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.top_mc = GV.MC_mapFrame["top_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         BC.addEvent(this,this.top_mc.greenlights,"greenlightEvent",this.greenlightEventHandler);
      }
      
      private function greenlightEventHandler(e:Event) : void
      {
         GV.Room_DefaultRoomID = 0;
         LocalUserInfo.setMapID(0);
         switchMapLogic.switchMapLogicHandler(121);
      }
      
      override public function destroy() : void
      {
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
         this.botton_mc = null;
         super.destroy();
      }
   }
}

