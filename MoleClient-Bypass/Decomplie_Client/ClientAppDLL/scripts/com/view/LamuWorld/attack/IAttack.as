package com.view.LamuWorld.attack
{
   import com.view.LamuWorld.ABoss;
   
   public interface IAttack
   {
      
      function start() : void;
      
      function end() : void;
      
      function hurt() : void;
      
      function checkhurt() : void;
      
      function set boss(param1:ABoss) : void;
      
      function set target(param1:IAttackTarget) : void;
   }
}

