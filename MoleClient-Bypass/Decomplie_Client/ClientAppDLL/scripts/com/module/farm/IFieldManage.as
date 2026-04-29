package com.module.farm
{
   import com.core.field.animalInfo.AnimalInfo;
   import flash.display.MovieClip;
   
   public interface IFieldManage
   {
      
      function setRootMC(param1:MovieClip) : void;
      
      function set editMode(param1:Boolean) : void;
      
      function get editMode() : Boolean;
      
      function set hostUseID(param1:uint) : void;
      
      function get hostUseID() : uint;
      
      function showAnimal(param1:AnimalInfo, param2:int = -1) : void;
      
      function showAnimals(param1:Array) : void;
      
      function getAnimalObjectByID(param1:uint) : IAnimal;
      
      function planting(param1:uint) : void;
      
      function clearCrop() : void;
   }
}

