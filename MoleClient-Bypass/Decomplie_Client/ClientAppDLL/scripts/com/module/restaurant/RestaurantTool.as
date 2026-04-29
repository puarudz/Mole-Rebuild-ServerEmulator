package com.module.restaurant
{
   public class RestaurantTool
   {
      
      public function RestaurantTool()
      {
         super();
      }
      
      public function queryMakeOverFoodCount() : int
      {
         var ret:int = 0;
         var foodArr:Array = RestaurantBeen.getInstance().getRestaurantInfo().houseFoodInfo.foodArr;
         for(var i:int = 0; i < foodArr.length; i++)
         {
            if(foodArr[i].foodLocation >= 51 && foodArr[i].foodLocation <= 100)
            {
               ret += 1;
            }
         }
         return ret;
      }
      
      public function queryMakeOverFoodCount200() : Boolean
      {
         var ret:Boolean = false;
         var foodArr:Array = RestaurantBeen.getInstance().getRestaurantInfo().houseFoodInfo.foodArr;
         for(var i:int = 0; i < foodArr.length; i++)
         {
            if(foodArr[i].foodLocation >= 51 && foodArr[i].foodLocation <= 100 && foodArr[i].foodCount > 200)
            {
               ret = true;
               break;
            }
         }
         return ret;
      }
      
      public function upDateFoodCountByFoodIndex(foodIndex:int, foodCount:int) : void
      {
         var foodArr:Array = RestaurantBeen.getInstance().getRestaurantInfo().houseFoodInfo.foodArr;
         for(var i:int = 0; i < foodArr.length; i++)
         {
            if(foodArr[i].foodIndex == foodIndex)
            {
               foodArr[i].foodCount -= foodCount;
               break;
            }
         }
      }
      
      public function getDay() : int
      {
         var ret:int = new Date().getDay();
         return ret == 0 ? 7 : ret;
      }
   }
}

