package com.module.restaurant
{
   import com.global.staticData.XMLInfo;
   
   public class RestaurantRandomSay
   {
      
      private static var instance:RestaurantRandomSay;
      
      private static var canotNew:Boolean = true;
      
      public function RestaurantRandomSay()
      {
         super();
         if(canotNew)
         {
            throw new Error("RestaurantRandomSay不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : RestaurantRandomSay
      {
         if(!instance)
         {
            canotNew = false;
            instance = new RestaurantRandomSay();
            canotNew = true;
         }
         return instance;
      }
      
      public function say(sayId:int, sayObj:Object) : void
      {
         var randomNum:int = 0;
         var randomSay:String = null;
         var randomSayObj:Object = XMLInfo.RestaurantRandomSayObj[sayId];
         var percentage:int = int(randomSayObj.percentage);
         var randomSayArr:Array = randomSayObj.say as Array;
         if(Math.random() * 100 < percentage)
         {
            randomNum = Math.random() * randomSayArr.length;
            randomSay = randomSayArr[randomNum];
            sayObj.say(randomSay);
         }
      }
      
      public function randomEmpSay() : void
      {
         var empArr:Array = RestaurantBeen.getInstance().getRestaurantInfo().housePeopleInfo.peopArr;
         var empNum:int = Math.random() * empArr.length;
         if(empNum != 0)
         {
            this.say(4,empArr[empNum].lamu);
         }
      }
   }
}

