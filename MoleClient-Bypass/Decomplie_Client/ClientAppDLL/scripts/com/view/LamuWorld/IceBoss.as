package com.view.LamuWorld
{
   import com.view.LamuWorld.attack.IAttack;
   import com.view.LamuWorld.attack.IceAttack;
   import flash.display.Sprite;
   
   public class IceBoss extends ABoss
   {
      
      private var isRandom:int = 0;
      
      public function IceBoss(boss:*)
      {
         super(boss);
         attackTime = 5;
         currentTime = 4;
      }
      
      private function createRandom() : void
      {
         var attack:IAttack = null;
         currentTime = 0;
         attack = new IceAttack();
         attack.target = target;
         attack.boss = this;
         attack.start();
         ++this.isRandom;
      }
      
      override protected function bossAI() : void
      {
         super.bossAI();
         if(currentTime >= attackTime)
         {
            this.createRandom();
         }
      }
      
      override public function initBossLive(mc:Sprite) : void
      {
         bossLive = new BossLive(mc);
         bossLive.mode = 1;
         bossLive.maxLive = 10;
         bossLive.live = 10;
      }
   }
}

