package com.common.data.goodsInfo
{
   import com.common.info.AngelStaticInfo;
   import com.global.staticData.XMLInfo;
   import com.mole.debug.DebugManager;
   import mx.core.ByteArrayAsset;
   
   public class GoodsInfo
   {
      
      private static var data:Object;
      
      private static var typeLimit:Object;
      
      public static var ClothArray:Array;
      
      public static var ClothObject:Object;
      
      public function GoodsInfo()
      {
         super();
      }
      
      public static function parseXML(suitXML:XML) : void
      {
         var tempName:String = null;
         var len:int = 0;
         var i:int = 0;
         var j:int = 0;
         var clothIDList:Array = null;
         var clothID:uint = 0;
         var tba:ByteArrayAsset = ByteArrayAsset(new XMLInfo.itemXmlData());
         tba.uncompress();
         tba.position = 0;
         data = tba.readObject();
         ClothArray = new Array();
         ClothObject = new Object();
         for(i = 0; i < suitXML.length(); i++)
         {
            len = suitXML.Item.length();
            if(len > 0)
            {
               for(j = 0; j < len; j++)
               {
                  clothID = j + 1;
                  clothIDList = String(suitXML.Item[j].@Cloth).split(",");
                  clothIDList.sort();
                  ClothArray[clothID] = ClothArray[String(suitXML.Item[j].@Name)] = clothIDList;
                  tempName = String(ClothArray[clothID]);
                  ClothObject[tempName] = uint(clothID);
                  ClothObject[clothID] = String(suitXML.Item[j].@Act_Name);
                  ClothObject["ActName_" + clothID] = String(suitXML.Item[j].@Action);
                  ClothObject["ActName2_" + clothID] = String(suitXML.Item[j].@Name);
                  ClothObject[ClothObject["ActName2_" + clothID]] = uint(clothID);
                  ClothObject["Action_" + clothID] = String(suitXML.Item[j].@Tag);
                  ClothObject["Menu_" + clothID] = int(suitXML.Item[j].@Menu);
                  ClothObject["vip_" + clothID] = int(suitXML.Item[j].@vip);
               }
            }
         }
      }
      
      public static function getSuitMenuStatus(SuitIndex:uint) : Boolean
      {
         return ClothObject["Menu_" + SuitIndex];
      }
      
      public static function getSuitVipOnly(SuitIndex:uint) : Boolean
      {
         return ClothObject["vip_" + SuitIndex];
      }
      
      public static function getSuitItemsArrayByIndex(SuitIndex:uint) : Array
      {
         return ClothArray[SuitIndex];
      }
      
      public static function getSuitItemsArrayByName(name:String) : Array
      {
         return ClothArray[name];
      }
      
      public static function getSuitIndexByName(SuitName:String) : int
      {
         return ClothObject[SuitName];
      }
      
      public static function getSuitActionTag(SuitIndex:uint) : String
      {
         return ClothObject["Action_" + SuitIndex];
      }
      
      public static function getSuitActionName(SuitIndex:uint) : String
      {
         return ClothObject["ActName_" + SuitIndex];
      }
      
      public static function getSuitName(SuitIndex:uint) : String
      {
         return ClothObject["ActName2_" + SuitIndex];
      }
      
      public static function hasItem(ItemID:int) : Boolean
      {
         return data[ItemID] != null;
      }
      
      public static function getType(ItemID:uint) : uint
      {
         var returnNum:Number = NaN;
         try
         {
            returnNum = Number(data[ItemID].typeObject.id);
         }
         catch(E:Error)
         {
            DebugManager.traceMsg("物品ID不存在(" + String(ItemID) + ")!!!");
            returnNum = 0;
         }
         return returnNum;
      }
      
      public static function getInfoById(ItemID:uint) : Object
      {
         var tempObj:Object = data[ItemID];
         if(tempObj == null)
         {
            if(DebugManager.DEBUG)
            {
               DebugManager.traceMsg("物品ID不存在(" + String(ItemID) + ")!!!");
            }
         }
         return tempObj;
      }
      
      public static function getItemPathByID(id:int) : String
      {
         return data[id].typeObject.resourePath + "icon/";
      }
      
      public static function getItemNameByID(id:int) : String
      {
         return getInfoById(id)["name"];
      }
      
      public static function getItemPlantNameByID(id:int) : String
      {
         return getInfoById(id)["plantName"];
      }
      
      public static function GetFullURLByItemId(id:uint) : String
      {
         var icoId:uint = 0;
         var url:String = "";
         if(id >= 1230001 && id < 1231000)
         {
            url = GoodsInfo.getIconPath_Seed(id);
         }
         else if(id >= 1270001 && id < 1279999)
         {
            url = "resource/farm/icon/" + id + ".swf";
         }
         else if(id == 0)
         {
            url = "resource/allJob/mainJobIcon/small/dou.swf";
         }
         else if(id >= 1300001 && id < 1300999)
         {
            url = "resource/car/icon/" + id + ".swf";
         }
         else if(id >= 1623000 && id < 1642999)
         {
            url = "resource/siren/icon/" + id + ".swf";
         }
         else if(id <= 10)
         {
            url = "resource/allJob/icon/" + id + ".swf";
         }
         else if(GoodsInfo.getType(id) == 26)
         {
            url = "resource/restaurant/icon/" + id + ".swf";
         }
         else if(id >= 1320001 && id < 1320999)
         {
            url = "resource/allJob/icon/" + id + ".swf";
         }
         else if(GoodsInfo.getType(id) == 22)
         {
            url = "resource/angelFight/icon/" + id + ".swf";
         }
         else if(id >= 1643000 && id <= 1652999)
         {
            icoId = GoodsInfo.getAngelInfoById(id).icon;
            if(icoId == 0)
            {
               icoId = id;
            }
            url = "resource/newAngel/icon/" + icoId + ".swf";
         }
         else if(id >= 1653000 && id <= 1662999)
         {
            url = "resource/newAngel/icon/" + id + ".swf";
         }
         else if(id >= 1663000 && id <= 1673007)
         {
            url = "resource/elementCard/icon/" + id + ".swf";
         }
         else if(id >= 2000000 && id <= 2000300)
         {
            id -= 2000000;
            url = "resource/dressGame/icon/" + id + ".swf";
         }
         else if(id >= 1720001 && id <= 1729999)
         {
            url = "resource/magicSpirit/icon/" + id + ".swf";
         }
         else if(id >= 1730001 && id <= 1739999)
         {
            url = "resource/magicSpirit/shop/" + id + ".swf";
         }
         else if(id >= 1740001 && id <= 1749999)
         {
            url = "resource/acclimationSMC/icon/" + id + ".swf";
         }
         else
         {
            url = GoodsInfo.getItemPathByID(id) + id + ".swf";
         }
         return url;
      }
      
      public static function getIconPath_Seed(ItemID:uint) : String
      {
         return getItemPathByID(ItemID) + ItemID + ".swf";
      }
      
      public static function getSwfPath_Seed(ItemID:uint) : String
      {
         return data[ItemID].typeObject.resourePath + "swf/" + ItemID + ".swf";
      }
      
      public static function GetAnimalSwfPath(itemID:int, star:int = 0) : String
      {
         var str:String = data[itemID].typeObject.resourePath;
         if(star == 0)
         {
            str += "swf/";
         }
         else
         {
            str += "swf/star_" + star + "/";
         }
         return str + itemID + ".swf";
      }
      
      public static function GetAnimalIconPath(itemID:int, star:int = 0) : String
      {
         var str:String = "resource/farm/";
         if(star == 0)
         {
            str += "icon/";
         }
         else
         {
            str += "icon/star_" + star + "/";
         }
         return str + itemID + ".swf";
      }
      
      public static function getItemCollectionBoxNameByID(ItemID:uint) : String
      {
         var t:int = 0;
         var type:int = int(getType(ItemID));
         if(type == 3 || type == 4)
         {
            return "投擲欄";
         }
         if(type == 48)
         {
            return "馴化獸背包";
         }
         if(type == 39 || type == 40)
         {
            return "海妖館倉庫";
         }
         if(type == 41 || type == 42)
         {
            return "天使園背包";
         }
         if(type == 5)
         {
            return "小屋倉庫";
         }
         if(type == 43 || type == 44)
         {
            return "元素騎士卡牌背包";
         }
         if(type == 46)
         {
            return "摩靈背包";
         }
         if(type == 6)
         {
            return "小屋";
         }
         if(type == 7 || type == 11 || type == 12 || type == 23)
         {
            return "拉姆背包";
         }
         if(type == 1 || type == 9 || type == 49)
         {
            return "百寶箱";
         }
         if(type == 13 || type == 14)
         {
            return "家園倉庫";
         }
         if(type == 17)
         {
            return "班級倉庫";
         }
         if(type == 18 || type == 19)
         {
            return "牧場倉庫";
         }
         if(type == 21)
         {
            return "車庫";
         }
         if(type == 30)
         {
            return "天使園倉庫";
         }
         if(type == 31)
         {
            t = int(getInfoById(ItemID).Type);
            if(t == 3)
            {
               return "藏寶閣倉庫";
            }
            return "探險背包";
         }
         if(type == 22 || type == 32 || type == 34)
         {
            return "戰鬥行囊";
         }
         if(ItemID >= 1290001 && ItemID <= 1299999)
         {
            return "《吉吉樂卡片王手冊》";
         }
         if(type == 36 || type == 37 || type == 38)
         {
            return "肥肥館背包";
         }
         return "百寶箱";
      }
      
      public static function getAngelInfoById(angelId:uint) : AngelStaticInfo
      {
         var angelInfo:AngelStaticInfo = null;
         var tempObj:Object = data[angelId];
         if(!(tempObj is AngelStaticInfo))
         {
            angelInfo = new AngelStaticInfo();
            angelInfo.typeObject = tempObj.typeObject;
            angelInfo.id = uint(tempObj.id);
            angelInfo.icon = uint(tempObj.icon);
            angelInfo.name = String(tempObj.name);
            angelInfo.change = uint(tempObj.change);
            angelInfo.tradability = uint(tempObj.tradability);
            angelInfo.price = uint(tempObj.price);
            angelInfo.young = uint(tempObj.young);
            angelInfo.token = uint(tempObj.token);
            angelInfo.race = uint(tempObj.race);
            angelInfo.step = uint(tempObj.step);
            angelInfo.egg = Boolean(tempObj.egg);
            angelInfo.gender = uint(tempObj.gender);
            angelInfo.constellation = uint(tempObj.constellation);
            angelInfo.no = uint(tempObj.no);
            angelInfo.evolution = uint(tempObj.evolution);
            angelInfo.hp = uint(tempObj.hp);
            angelInfo.act = uint(tempObj.act);
            angelInfo.def = uint(tempObj.def);
            angelInfo.speed = uint(tempObj.speed);
            angelInfo.distance = uint(tempObj.distance);
            angelInfo.power = uint(tempObj.power);
            angelInfo.parameter = uint(tempObj.parameter);
            data[angelId] = angelInfo;
            tempObj = angelInfo;
         }
         return tempObj as AngelStaticInfo;
      }
   }
}

