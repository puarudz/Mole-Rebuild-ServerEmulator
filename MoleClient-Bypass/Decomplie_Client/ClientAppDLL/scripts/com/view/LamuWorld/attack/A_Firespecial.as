package com.view.LamuWorld.attack
{
   public class A_Firespecial extends Attack
   {
      
      public function A_Firespecial()
      {
         super();
      }
      
      override public function start() : void
      {
         super.start();
         bossMC.gotoAndPlay("召唤小火鸟");
      }
   }
}

