package com.view.LamuWorld
{
   import com.view.LamuWorld.attack.IAttack;
   import com.view.LamuWorld.attack.TreeFactory;
   
   public class TreeBoss extends ABoss
   {
      
      private var afactory:TreeFactory;
      
      private var saveNum:int = 0;
      
      public function TreeBoss(tree:*)
      {
         super(tree);
         attackTime = 5;
         this.afactory = new TreeFactory();
         currentTime = 1;
      }
      
      private function createRandom() : void
      {
         var attack:IAttack = null;
         var num:Number = NaN;
         currentTime = 0;
         if(lives <= 3)
         {
            num = Math.random();
            if(num > 0.7)
            {
               if(this.saveNum < 3)
               {
                  ++this.saveNum;
                  attack = this.afactory.createAddLive(this,target);
               }
               else
               {
                  attack = this.afactory.createAttack(this,target);
               }
            }
            else if(num > 0.3)
            {
               attack = this.afactory.createGodBody(this,target);
            }
            else
            {
               attack = this.afactory.createAttack(this,target);
            }
         }
         else
         {
            attack = this.afactory.createAttack(this,target);
         }
         if(Boolean(attack))
         {
            attack.start();
         }
      }
      
      override protected function bossAI() : void
      {
         super.bossAI();
         if(_boss.currentLabel == "被攻击")
         {
            return;
         }
         if(currentTime >= attackTime)
         {
            this.createRandom();
         }
      }
   }
}

