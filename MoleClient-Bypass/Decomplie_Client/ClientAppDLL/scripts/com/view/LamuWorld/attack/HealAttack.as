package com.view.LamuWorld.attack
{
   import flash.events.Event;
   
   public class HealAttack extends Attack
   {
      
      public function HealAttack()
      {
         super();
      }
      
      override public function start() : void
      {
         super.start();
         bossMC.gotoAndPlay("吃水果");
         bossMC.addEventListener("add_boss_live",this.addBossLive);
         bossMC.addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
      }
      
      private function addBossLive(e:Event) : void
      {
         ++_boss.lives;
         end();
      }
      
      override protected function removed(e:Event = null) : void
      {
         bossMC.removeEventListener("add_boss_live",this.addBossLive);
         super.removed();
      }
   }
}

