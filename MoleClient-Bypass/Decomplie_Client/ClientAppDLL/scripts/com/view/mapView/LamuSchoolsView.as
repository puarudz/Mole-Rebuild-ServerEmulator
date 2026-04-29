package com.view.mapView
{
   import com.event.EventTaomee;
   import com.module.npc.I_NPC;
   import com.mole.app.map.MapBase;
   import flash.display.MovieClip;
   
   public class LamuSchoolsView extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var topMC:MovieClip;
      
      public var botton_mc:MovieClip;
      
      private var npcMc:I_NPC;
      
      private var rnd:int = int(Math.random() * 3 + 1);
      
      private var haveload:int = 0;
      
      public function LamuSchoolsView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.topMC = GV.MC_mapFrame["top_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.GointoLamuClassroom);
      }
      
      override public function destroy() : void
      {
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
         this.topMC = null;
         this.botton_mc = null;
         super.destroy();
      }
      
      private function GointoLamuClassroom(e:EventTaomee) : void
      {
         var type:int = int(e.EventObj.type);
         if(type == 0)
         {
         }
      }
   }
}

