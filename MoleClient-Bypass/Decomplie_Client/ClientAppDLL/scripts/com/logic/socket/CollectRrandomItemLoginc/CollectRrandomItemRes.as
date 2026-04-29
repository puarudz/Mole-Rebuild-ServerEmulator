package com.logic.socket.CollectRrandomItemLoginc
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.getDefinitionByName;
   
   public class CollectRrandomItemRes extends EventDispatcher
   {
      
      public static var COLLECT_RANDOM:String = "collect_random_item";
      
      public static var GETITEM_ACINUS:String = "getitem_acinus";
      
      public static var COLLECT_GOODS:String = "collect_goods";
      
      public function CollectRrandomItemRes()
      {
         super();
      }
      
      public static function doAtcion() : void
      {
         var tempInfo:String = null;
         var Presented:* = undefined;
         var tempstr:XML = null;
         var itemID:int = int(GV.onlineSocket.readUnsignedInt());
         var count:int = int(GV.onlineSocket.readUnsignedInt());
         var itemName:String = "";
         if(count > 0)
         {
            switch(itemID)
            {
               case 150002:
                  itemName = "一個新鮮的番茄\n已經放進你的投擲道具中!";
                  break;
               case 17005:
                  itemName = "一個蘑菇果實\n已經放進你的投擲道具中!";
                  break;
               case 17006:
                  itemName = "一個西瓜果實\n已經放進你的投擲道具中!";
                  break;
               case 17007:
                  itemName = "一個石像果實\n已經放進你的投擲道具中!";
                  break;
               case 12137:
                  itemName = "一個綠色漿果\n已經放進你的百寶箱中!";
                  break;
               case 190195:
                  itemName = "一個奇異黑漿果\n已經放進你的百寶箱中!";
                  GV.onlineSocket.dispatchEvent(new Event(GETITEM_ACINUS));
                  break;
               case 12138:
                  itemName = "一個黑色漿果\n已經放進你的百寶箱中!";
                  break;
               case 190025:
                  itemName = "一朵七色花已經放進你的百寶箱中\n趕快去餐廳烹飪美味佳餚吧!";
                  break;
               case 190029:
                  itemName = "一個空氣結晶已經放進你的百寶箱中!";
                  break;
               case 190026:
                  itemName = "一個野生蘑菇已經放進你的百寶箱中\n趕快去餐廳烹飪美味佳餚吧!";
                  break;
               case 190027:
                  itemName = "一個茄子已經放進你的百寶箱中\n趕快去餐廳烹飪美味佳餚吧!";
                  break;
               case 190028:
                  itemName = "一個胡蘿蔔已經放進你的百寶箱中\n趕快去餐廳烹飪美味佳餚吧!";
                  break;
               case 190024:
                  itemName = "一個鴨蛋已經放進你的百寶箱中\n趕快去餐廳烹飪美味佳餚吧!";
                  break;
               case 190022:
                  itemName = "一個南瓜已經放進你的百寶箱中\n趕快去餐廳烹飪美味佳餚吧!";
                  break;
               case 190119:
                  itemName = "恭喜你獲得糯米，\n已經放入你的百寶箱中！";
                  break;
               case 190120:
                  itemName = "恭喜你獲得1份紅棗，\n已經放入你的百寶箱中！";
                  break;
               case 190053:
                  itemName = "一個蜘蛛絲已經放進你的百寶箱中!";
                  break;
               case 180029:
                  itemName = "一個爽爽果已經放進你的拉姆百寶箱中!";
                  break;
               case 190230:
                  itemName = "一個黑森林奇異果已經放進你的百寶箱中!";
                  break;
               case 190351:
                  itemName = "一株螢火草已經放進你的百寶箱中!";
                  break;
               case 180028:
                  itemName = "一個咕咕果已經放進你的拉姆百寶箱中!";
                  break;
               case 180027:
                  itemName = "一個可可果已經放進你的拉姆百寶箱中!";
                  break;
               case 190345:
                  itemName = "一個蘑漣花已經放進你的百寶箱中!";
                  break;
               case 180030:
                  itemName = "一個開心果已經放進你的拉姆百寶箱中!";
                  break;
               case 190196:
                  itemName = "一個毛毛豆已經放進你的百寶箱中!";
                  break;
               case 190203:
                  itemName = "一個毛毛花已經放進你的百寶箱中!";
                  break;
               case 17010:
                  itemName = "你撿到一個飛鳥果實，已放入你的投擲品欄中!";
                  break;
               case 1230018:
                  itemName = "蒲蘭花種子已放入你的家園倉庫中！";
                  break;
               case 191080:
                  itemName = "獲得可疑的金屬棍！";
                  break;
               case 191081:
                  itemName = "獲得丫麗的發帶！";
                  break;
               case 191082:
                  itemName = "獲得奇怪的鐵盒！";
                  break;
               case 38:
                  Presented = getDefinitionByName("com.module.activityModule.Presented");
                  Presented.getInstance().FreeReceive(25);
                  return;
               case 0:
                  itemName = "你已經撿到了" + count + "摩爾豆!";
                  LocalUserInfo.countYXQ(count);
            }
            Alert.showAlert(MainManager.getAppLevel(),itemName,"",6,"E");
            GV.onlineSocket.dispatchEvent(new EventTaomee(COLLECT_GOODS,{
               "goodsID":itemID,
               "goodsCount":count
            }));
         }
         else
         {
            tempstr = GF.getItemName(itemID);
            tempInfo = tempstr.@Name + "不在這裡了，再找找吧!";
            if(itemID == 0)
            {
               tempInfo = "摩爾豆已經被別人撿走了\n再到別的地方看看吧!";
            }
            Alert.showAlert(MainManager.getAppLevel(),tempInfo,"",6,"D");
         }
      }
   }
}

