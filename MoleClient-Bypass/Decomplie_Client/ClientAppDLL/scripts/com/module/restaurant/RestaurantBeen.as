package com.module.restaurant
{
   import flash.display.MovieClip;
   
   public class RestaurantBeen
   {
      
      private static var instance:RestaurantBeen;
      
      private static var canotNew:Boolean = true;
      
      private var inRestaurant:Boolean;
      
      private var restaurantInfo:Object;
      
      private var restaurantBG:MovieClip;
      
      private var restaurantMC:MovieClip;
      
      private var myRestaurant:Boolean;
      
      private var addFoodCount:int;
      
      public function RestaurantBeen()
      {
         super();
         if(canotNew)
         {
            throw new Error("RestaurantBeen不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : RestaurantBeen
      {
         if(!instance)
         {
            canotNew = false;
            instance = new RestaurantBeen();
            canotNew = true;
         }
         return instance;
      }
      
      public function getAddFoodCount() : int
      {
         return this.addFoodCount;
      }
      
      public function setAddFoodCount(value:int) : void
      {
         this.addFoodCount = value;
      }
      
      public function setInRestaurant(value:Boolean) : void
      {
         this.inRestaurant = value;
      }
      
      public function isInRestaurant() : Boolean
      {
         return this.inRestaurant;
      }
      
      public function setRestaurantInfo(value:Object) : void
      {
         this.restaurantInfo = value;
      }
      
      public function getRestaurantInfo() : Object
      {
         return this.restaurantInfo;
      }
      
      public function setRestaurantMC(value:MovieClip) : void
      {
         this.restaurantMC = value;
      }
      
      public function getRestaurantMC() : MovieClip
      {
         return this.restaurantMC;
      }
      
      public function setRestaurantBG(value:MovieClip) : void
      {
         this.restaurantBG = value;
      }
      
      public function getRestaurantBG() : MovieClip
      {
         return this.restaurantBG;
      }
      
      public function setMyRestaurant(value:Boolean) : void
      {
         this.myRestaurant = value;
      }
      
      public function isMyRestaurant() : Boolean
      {
         return this.myRestaurant;
      }
   }
}

