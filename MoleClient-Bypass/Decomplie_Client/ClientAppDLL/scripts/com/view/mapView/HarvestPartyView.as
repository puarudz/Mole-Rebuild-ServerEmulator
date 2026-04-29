package com.view.mapView
{
   import com.module.activityModule.SoundControlModule;
   import com.module.npc.I_NPC;
   import com.mole.app.map.MapBase;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class HarvestPartyView extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var topMC:MovieClip;
      
      public var button_mc:MovieClip;
      
      private var npcMc:I_NPC;
      
      private var rnd:int = int(Math.random() * 3 + 1);
      
      private var haveload:int = 0;
      
      public function HarvestPartyView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.topMC = GV.MC_mapFrame["top_mc"];
         this.button_mc = GV.MC_mapFrame["buttonLevel"];
         SoundControlModule.getInstance().initSound();
         MovieClip(this.target_mc["manPartyDog_mc"]).buttonMode = true;
         MovieClip(this.target_mc["bird_mc"]).buttonMode = true;
         MovieClip(this.target_mc["fred_mc"]).buttonMode = true;
         MovieClip(this.target_mc["superPig_mc"]).buttonMode = true;
         BC.addEvent(this,this.target_mc["manPartyDog_mc"],MouseEvent.CLICK,this.NpcTalkHandler);
         BC.addEvent(this,this.target_mc["bird_mc"],MouseEvent.CLICK,this.NpcTalkHandler);
         BC.addEvent(this,this.target_mc["fred_mc"],MouseEvent.CLICK,this.NpcTalkHandler);
         BC.addEvent(this,this.target_mc["superPig_mc"],MouseEvent.CLICK,this.NpcTalkHandler);
      }
      
      private function NpcTalkHandler(e:MouseEvent) : void
      {
         var npcMC:MovieClip = e.currentTarget as MovieClip;
         var npcid:int = 1104;
         if(npcMC.name == "manPartyDog_mc")
         {
            npcid = 1104;
         }
         if(npcMC.name == "bird_mc")
         {
            npcid = 1049;
         }
         if(npcMC.name == "fred_mc")
         {
            npcid = 6;
         }
         if(npcMC.name == "superPig_mc")
         {
            npcid = 1034;
         }
      }
      
      override public function destroy() : void
      {
         this.target_mc = null;
         this.depth_mc = null;
         this.topMC = null;
         this.button_mc = null;
         super.destroy();
      }
   }
}

