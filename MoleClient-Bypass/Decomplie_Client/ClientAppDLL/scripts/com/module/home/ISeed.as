package com.module.home
{
   import flash.display.MovieClip;
   
   public interface ISeed
   {
      
      function get Level() : int;
      
      function get HealthilyStatus() : int;
      
      function get Maturate_currentNum() : int;
      
      function get Maturate_MaxtNum() : int;
      
      function get PosX() : Number;
      
      function get PosY() : Number;
      
      function get PlantID() : uint;
      
      function get CanThief() : Boolean;
      
      function get SeedID() : uint;
      
      function get isDie() : Boolean;
      
      function get Name() : String;
      
      function getSeedTopPosY() : int;
      
      function getPollination() : int;
      
      function getFruitageCount() : int;
      
      function getFruitageInfo() : Object;
      
      function getSeedInfo() : Object;
      
      function removeSeed() : void;
      
      function addEvent() : void;
      
      function removeEvent() : void;
      
      function removeTarget() : void;
      
      function IrrigateWater() : void;
      
      function Pollination() : void;
      
      function Fertilizer() : void;
      
      function UseInsecticide() : void;
      
      function Harvest() : void;
      
      function Thief() : void;
      
      function upSeedData(param1:Object) : void;
      
      function getSeedTarget() : MovieClip;
      
      function clearClass() : void;
   }
}

