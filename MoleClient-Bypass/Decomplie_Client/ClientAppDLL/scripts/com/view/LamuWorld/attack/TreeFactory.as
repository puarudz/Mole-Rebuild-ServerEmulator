package com.view.LamuWorld.attack
{
   import com.view.LamuWorld.ABoss;
   
   public class TreeFactory
   {
      
      public function TreeFactory()
      {
         super();
      }
      
      public function createAddLive(boss:ABoss, target:IAttackTarget) : IAttack
      {
         var attack:IAttack = new HealAttack();
         attack.target = target;
         attack.boss = boss;
         return attack;
      }
      
      public function createAttack(boss:ABoss, target:IAttackTarget) : IAttack
      {
         var attack:IAttack = null;
         attack = new TreeAttack();
         attack.target = target;
         attack.boss = boss;
         return attack;
      }
      
      public function createGodBody(boss:ABoss, target:IAttackTarget) : IAttack
      {
         var attack:IAttack = null;
         attack = new GodBody();
         attack.target = target;
         attack.boss = boss;
         return attack;
      }
   }
}

