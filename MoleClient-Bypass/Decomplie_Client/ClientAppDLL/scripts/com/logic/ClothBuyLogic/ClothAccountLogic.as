package com.logic.ClothBuyLogic
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.global.staticData.XMLInfo;
   import flash.events.Event;
   
   public class ClothAccountLogic
   {
      
      public static var SUPER_PET_GET_ITEM:String = "supet_pet_get_item";
      
      public function ClothAccountLogic()
      {
         super();
      }
      
      public static function getAddress(itemID:int) : String
      {
         var sucString:String = "";
         if(itemID >= 17001 && itemID < 17999 || itemID >= 150001 && itemID < 159999)
         {
            sucString = "恭喜！" + GoodsInfo.getItemNameByID(itemID) + "已放入你的投擲道具箱中";
         }
         else if(itemID >= 160001 && itemID < 169999)
         {
            sucString = "恭喜！" + GoodsInfo.getItemNameByID(itemID) + "已放入你的小屋倉庫中";
         }
         else if(Boolean(XMLInfo.ClothHint[itemID]) || isVipItem(itemID))
         {
            sucString = "恭喜！" + GoodsInfo.getItemNameByID(itemID) + "已放入你的百寶箱中";
         }
         else if(itemID > 180000 && itemID < 190000)
         {
            sucString = "恭喜！" + GoodsInfo.getItemNameByID(itemID) + "已放入拉姆的背包中";
         }
         else if(itemID > 1260000 && itemID < 1270000)
         {
            sucString = "恭喜！" + GoodsInfo.getItemNameByID(itemID) + "已放入班級倉庫中";
         }
         else if(itemID > 1270000 && itemID < 1280000)
         {
            sucString = "恭喜！" + GoodsInfo.getItemNameByID(itemID) + "已放入牧場倉庫中";
         }
         else if(itemID > 1220000 && itemID < 1230000 || itemID > 1230000 && itemID < 1240000)
         {
            sucString = "恭喜！" + GoodsInfo.getItemNameByID(itemID) + "已經放入你的家園倉庫中";
         }
         else
         {
            sucString = "恭喜！" + GoodsInfo.getItemNameByID(itemID) + "已放入你的百寶箱中";
         }
         if(itemID == 1220018)
         {
            sucString = "恭喜！" + GoodsInfo.getItemNameByID(itemID) + "已經放入你的家園倉庫中";
         }
         if(itemID == 1220040)
         {
            sucString = "恭喜！" + GoodsInfo.getItemNameByID(itemID) + "已經放入你的家園倉庫中!";
         }
         return sucString;
      }
      
      public static function getURL(itemID:int) : String
      {
         var itemURL:String = "";
         if(itemID < 15000 || itemID >= 18000 && itemID < 30000)
         {
            itemURL = "resource/cloth/icon/" + itemID + ".swf";
         }
         else if(itemID > 160000 && itemID < 169999)
         {
            itemURL = "resource/goods/icon/" + itemID + ".swf";
         }
         else if(itemID > 1220000 && itemID < 1230000)
         {
            itemURL = "resource/home/item/icon/" + itemID + ".swf";
         }
         else if(itemID > 1230000 && itemID < 1240000)
         {
            itemURL = "resource/home/seed/icon/" + itemID + ".swf";
         }
         else if(itemID > 1260000 && itemID < 1270000)
         {
            itemURL = "resource/classroom/icon/" + itemID + ".swf";
         }
         else if(itemID > 1270000 && itemID < 1280000)
         {
            itemURL = "resource/farm/icon/" + itemID + ".swf";
         }
         else if(itemID > 190000)
         {
            itemURL = "resource/allJob/icon/" + itemID + ".swf";
         }
         else if(itemID > 180000)
         {
            itemURL = "resource/pet/icon/" + itemID + ".swf";
         }
         else
         {
            itemURL = "resource/effect/icon/" + itemID + ".swf";
         }
         return itemURL;
      }
      
      public static function isVipItem(ID:int) : Boolean
      {
         GV.onlineSocket.dispatchEvent(new Event(SUPER_PET_GET_ITEM));
         var itemArray:Array = [12205,12204,12206,12202,12201,12203,12247,12299,12300,160169,12336,160192,12398,12444,190137,190180,12563,12618,1220018,12619];
         for(var i:int = 0; i < itemArray.length; i++)
         {
            if(ID == itemArray[i])
            {
               return true;
            }
         }
         return false;
      }
      
      public static function getQuantifier(ID:int) : String
      {
         var str:String = "個";
         if(ID > 16000 && ID < 16011 || ID > 180049 && ID < 180053)
         {
            str = "瓶";
         }
         else if(ID == 190360)
         {
            str = "張";
         }
         return str;
      }
   }
}

