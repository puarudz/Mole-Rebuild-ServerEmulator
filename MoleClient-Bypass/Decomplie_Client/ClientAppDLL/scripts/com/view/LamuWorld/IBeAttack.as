package com.view.LamuWorld
{
   import flash.display.Sprite;
   
   public interface IBeAttack
   {
      
      function set body(param1:Sprite) : void;
      
      function get body() : Sprite;
      
      function hurt() : void;
      
      function dead() : void;
   }
}

