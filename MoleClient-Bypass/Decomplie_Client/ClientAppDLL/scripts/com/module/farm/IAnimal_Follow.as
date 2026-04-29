package com.module.farm
{
   import com.core.field.animalInfo.AnimalInfo;
   import com.view.PeopleView.PeopleManageView;
   
   public interface IAnimal_Follow extends ILandAnimal
   {
      
      function showAnimal(param1:AnimalInfo) : void;
      
      function followMole(param1:PeopleManageView) : void;
      
      function doSpecialAciotn() : void;
   }
}

