package com.view.LamuWorld.attack
{
   public class GodBody extends Attack
   {
      
      public function GodBody()
      {
         super();
      }
      
      override public function start() : void
      {
         bossMC.gotoAndPlay("虚空防护罩");
      }
      
      override public function hurt() : void
      {
      }
   }
}

