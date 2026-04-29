package com.module.home
{
   import flash.display.MovieClip;
   
   public interface ICropManage
   {
      
      function setRootMC(param1:MovieClip) : void;
      
      function set editMode(param1:Boolean) : void;
      
      function get editMode() : Boolean;
      
      function set hostUseID(param1:uint) : void;
      
      function get hostUseID() : uint;
      
      function startDragSeed(param1:Object) : Boolean;
      
      function showSeed(param1:Object, param2:int = -1) : void;
      
      function showSeeds(param1:Array) : void;
      
      function getSeedObjectByID(param1:uint) : ISeed;
      
      function clearCrop() : void;
      
      function deleteAllSeed() : void;
   }
}

