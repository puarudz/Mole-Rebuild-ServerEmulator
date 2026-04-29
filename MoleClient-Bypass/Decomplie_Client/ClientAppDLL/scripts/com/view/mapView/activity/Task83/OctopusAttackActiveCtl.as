package com.view.mapView.activity.Task83
{
   import com.common.tip.tip;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.module.AppModuleControl;
   import com.mole.app.type.ModuleType;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class OctopusAttackActiveCtl
   {
      
      private static var _instance:OctopusAttackActiveCtl;
      
      private var target:MovieClip;
      
      private var app:AppModuleControl;
      
      public function OctopusAttackActiveCtl()
      {
         super();
      }
      
      public static function get instance() : OctopusAttackActiveCtl
      {
         if(_instance == null)
         {
            _instance = new OctopusAttackActiveCtl();
         }
         return _instance;
      }
      
      public function Init(mc:MovieClip) : void
      {
         this.InitBoss();
         this.target = mc;
         this.target.buttonMode = true;
         tip.tipTailDisPlayObject(this.target,"攻擊入侵者");
         BC.addEvent(this,GV.onlineSocket,"hideBoss",this.CloseBoss);
         BC.addEvent(this,GV.onlineSocket,"showBoss",this.ShowBoss);
         BC.addEvent(this,this.target,MouseEvent.CLICK,this.onClickTarget);
      }
      
      public function InitBoss() : void
      {
         this.app = ModuleManager.openPanel(ModuleType.OCTOPUS_ATTACK_ACTIVE);
      }
      
      public function CloseBoss(event:Event) : void
      {
         if(Boolean(this.app))
         {
            this.app.close();
         }
      }
      
      public function ShowBoss(event:Event) : void
      {
         if(this.app == null)
         {
            this.InitBoss();
         }
      }
      
      private function onClickTarget(event:MouseEvent) : void
      {
         BC.addOnceEvent(this,GV.MAN_PEOPLE,PeopleManageView.ON_GO_OVER,this.man_over_event);
         GV.MAN_PEOPLE.moveTo(this.target.x,this.target.y);
      }
      
      private function man_over_event(event:Event) : void
      {
         if(Boolean(GV.MAN_PEOPLE.hitTestPoint(this.target.x,this.target.y)))
         {
            ModuleManager.openPanel(ModuleType.OCTOPUS_ATTACK_PANEL,null,"正在加載面板，請耐心等待.....",GV.MC_mapFrame["buttonLevel"]);
         }
      }
   }
}

