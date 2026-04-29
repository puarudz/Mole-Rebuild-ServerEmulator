package com.view.mapView
{
   import com.module.npc.I_NPC;
   import com.mole.app.map.MapBase;
   import flash.display.MovieClip;
   import flash.events.*;
   
   public class centerNewUserClothView extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var botton_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var effect_mc:MovieClip;
      
      public var top_mc:MovieClip;
      
      public var npc:I_NPC;
      
      public function centerNewUserClothView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.effect_mc = GV.MC_mapFrame["effect_mc"];
         this.top_mc = GV.MC_mapFrame["top_mc"];
      }
      
      override public function destroy() : void
      {
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
         this.effect_mc = null;
         this.top_mc = null;
         this.npc = null;
         super.destroy();
      }
   }
}

