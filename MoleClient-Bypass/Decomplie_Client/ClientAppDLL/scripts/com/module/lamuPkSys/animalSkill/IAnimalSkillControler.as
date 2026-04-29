package com.module.lamuPkSys.animalSkill
{
   import com.module.farm.IAnimal;
   
   public interface IAnimalSkillControler
   {
      
      function Init() : void;
      
      function get animal() : IAnimal;
      
      function ClearAnimal(param1:Boolean = true) : void;
      
      function ShowSkillPanelByPosition(param1:int, param2:int) : void;
      
      function PlaySkill(param1:int) : void;
   }
}

