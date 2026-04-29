package com.view.LamuWorld.attack
{
   public interface IAttackTarget
   {
      
      function set lives(param1:int) : void;
      
      function get lives() : int;
      
      function get x() : Number;
      
      function get y() : Number;
      
      function get width() : Number;
      
      function get height() : Number;
      
      function behurt(param1:Number = 1) : Object;
      
      function dead() : void;
   }
}

