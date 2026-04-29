package com.view.LamuWorld.attack
{
   import com.view.LamuWorld.ABoss;
   
   public class FireFactory
   {
      
      public function FireFactory()
      {
         super();
      }
      
      public function createSpecial(boss:ABoss, target:IAttackTarget) : IAttack
      {
         var attack:IAttack = new A_Firespecial();
         attack.target = target;
         attack.boss = boss;
         return attack;
      }
      
      public function createRandom(boss:ABoss, target:IAttackTarget) : IAttack
      {
         var attack:IAttack = null;
         var num:int = Math.random() * 3;
         if(num == 1)
         {
            attack = new BigFireAttack();
         }
         else if(num == 2)
         {
            attack = new SmallFireAttack();
         }
         else
         {
            attack = new NormalFire();
         }
         attack.target = target;
         attack.boss = boss;
         return attack;
      }
   }
}

