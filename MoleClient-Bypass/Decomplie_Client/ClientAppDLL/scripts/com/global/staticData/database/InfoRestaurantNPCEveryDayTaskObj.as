package com.global.staticData.database
{
   public class InfoRestaurantNPCEveryDayTaskObj
   {
      
      public static const RestaurantNPCEveryDayTaskObj:Object = new Object();
      
      RestaurantNPCEveryDayTaskObj[42] = {
         "npcID":1099,
         "probability":50,
         "goodsNum":3,
         "npcSay":99,
         "activaPoint":[0,1],
         "alterMsg":["    你在灶台縫隙中，發現了一個精巧的模型部件。","    事件解決之後，你在腳邊發現了一個精巧的模型部件。"],
         "otherAlterMsg":"    你已經找齊全部3個零件了，回到餐廳中交給傷心地泰迪吧。"
      };
      
      public function InfoRestaurantNPCEveryDayTaskObj()
      {
         super();
      }
   }
}

