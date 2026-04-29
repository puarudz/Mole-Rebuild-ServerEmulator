package com.module.restaurant
{
   import com.logic.TempFunctionLogic.TempFunctionLogic;
   
   public class RestaurantTheme
   {
      
      private static var instance:RestaurantTheme;
      
      private static var canotNew:Boolean = true;
      
      private var restaurantBeen:RestaurantBeen;
      
      public function RestaurantTheme()
      {
         super();
         if(canotNew)
         {
            throw new Error("RestaurantTheme不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : RestaurantTheme
      {
         if(!instance)
         {
            canotNew = false;
            instance = new RestaurantTheme();
            canotNew = true;
         }
         return instance;
      }
      
      public function init() : void
      {
         this.restaurantBeen = RestaurantBeen.getInstance();
         if(!this.restaurantBeen.isMyRestaurant())
         {
            new TempFunctionLogic(this.restaurantBeen.getRestaurantMC().control_mc,660,410);
         }
      }
   }
}

