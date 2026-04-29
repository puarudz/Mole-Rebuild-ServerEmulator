package com.view.LamuWorld
{
   import com.view.LamuWorld.attack.FireFactory;
   import com.view.LamuWorld.attack.IAttack;
   import com.view.mapView.Firescene;
   import flash.display.Sprite;
   
   public class FireBird extends ABoss
   {
      
      private var afactory:FireFactory;
      
      private var isRandom:int = 0;
      
      public function FireBird(bird:*)
      {
         super(bird);
         attackTime = 5;
         this.afactory = new FireFactory();
         currentTime = 4;
      }
      
      public function getmatrix() : Sprite
      {
         return null;
      }
      
      private function createRandom() : void
      {
         var attack:IAttack = null;
         currentTime = 0;
         attack = this.afactory.createRandom(this,target);
         attack.start();
         ++this.isRandom;
      }
      
      private function createSpecial() : void
      {
         var attack:IAttack = null;
         currentTime = 0;
         attack = this.afactory.createSpecial(this,target);
         attack.start();
         this.isRandom = 0;
      }
      
      override protected function bossAI() : void
      {
         super.bossAI();
         if(currentTime >= attackTime)
         {
            if(boss.currentLabel == "魔法阵")
            {
               if(currentTime / attackTime > 6)
               {
                  this.createRandom();
                  (scene as Firescene).toLamu();
               }
            }
            else if(boss.currentLabel != "召唤小火鸟")
            {
               if(isbehurt)
               {
                  this.createRandom();
                  isbehurt = false;
               }
               else if(this.isRandom >= 2)
               {
                  this.createSpecial();
               }
               else
               {
                  this.createRandom();
               }
            }
         }
      }
   }
}

