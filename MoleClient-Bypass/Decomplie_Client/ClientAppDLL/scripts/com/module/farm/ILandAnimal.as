package com.module.farm
{
   public interface ILandAnimal extends IAnimal
   {
      
      function get Speed() : int;
      
      function set Speed(param1:int) : void;
      
      function get aouoMove() : Boolean;
      
      function set aouoMove(param1:Boolean) : void;
      
      function MoveTo(param1:int, param2:int) : void;
   }
}

