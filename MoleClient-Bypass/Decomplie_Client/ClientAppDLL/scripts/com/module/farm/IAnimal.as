package com.module.farm
{
   import com.core.field.animalInfo.AnimalInfo;
   import com.logic.FindPathLogic.MigrationPath;
   import flash.display.MovieClip;
   
   public interface IAnimal
   {
      
      function get MoveEngine() : MigrationPath;
      
      function get Level() : int;
      
      function get StarLevel() : int;
      
      function GrowFast() : void;
      
      function get HealthilyStatus() : int;
      
      function get Maturate_currentNum() : int;
      
      function get Maturate_MaxtNum() : int;
      
      function scaleXY(param1:Number) : void;
      
      function say(param1:String) : void;
      
      function get IdentityID() : uint;
      
      function get Name() : String;
      
      function getAnimalTopPosY() : int;
      
      function get PosX() : Number;
      
      function get PosY() : Number;
      
      function getFruitageInfo() : Object;
      
      function getGrowthInfo() : Object;
      
      function addEvent() : void;
      
      function removeEvent() : void;
      
      function removeTarget() : void;
      
      function Harvest() : void;
      
      function Follow() : void;
      
      function Letgo() : void;
      
      function upAnimalData(param1:AnimalInfo) : void;
      
      function getAnimalData() : AnimalInfo;
      
      function getAnimalTarget() : MovieClip;
      
      function set visible(param1:Boolean) : void;
      
      function get visible() : Boolean;
      
      function clearClass() : void;
   }
}

