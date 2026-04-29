package com.module.superPetModule
{
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.ClothBuyLogic.ClothAccountLogic;
   import com.module.activityModule.checkItem;
   import com.module.clothBuyModule.clothBuyModule;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class petItemModule
   {
      
      private static var itemMapList:Dictionary;
      
      private static var targetMC:MovieClip;
      
      public function petItemModule()
      {
         super();
      }
      
      public static function itemVisibleHandler(target:MovieClip) : void
      {
         var mapNum:int = 0;
         GV.onlineSocket.addEventListener("removeMapEvent",removeEventHandler);
         targetMC = target;
         if(LocalUserInfo.isVIP())
         {
            if(GF.getPeopleObj(GV.MyInfo_userID).Petlevel == 101)
            {
               resetDic();
               mapNum = LocalUserInfo.getMapID();
               if(mapNum != 18)
               {
                  checkItemHandler();
               }
            }
         }
      }
      
      private static function checkItemHandler() : void
      {
         var num:int = LocalUserInfo.getMapID();
         var mapItem:* = itemMapList["map_" + num];
         trace("itemNum@@@@@@@@@@@@@@@@@@@",num);
         if(mapItem != null)
         {
            GV.onlineSocket.addEventListener(checkItem.chekItem_suc,checkItemSuc);
            checkItem.checkItemHandler(mapItem);
         }
      }
      
      private static function checkItemSuc(evt:EventTaomee) : void
      {
         var num:int = 0;
         var ItemID:* = undefined;
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,checkItemSuc);
         var count:int = int(evt.EventObj.count);
         if(count == 0)
         {
            setPetEffectHandler(null,2);
            num = LocalUserInfo.getMapID();
            ItemID = itemMapList["map_" + num];
            targetMC["superItem"]["item_" + ItemID].visible = true;
            GV.onlineSocket.addEventListener("SUPER_PETITEM_SUC",buySuperItemHandler);
            GV.onlineSocket.addEventListener(ClothAccountLogic.SUPER_PET_GET_ITEM,setPetEffectHandler);
         }
      }
      
      private static function buySuperItemHandler(evt:Event) : void
      {
         var num:int = LocalUserInfo.getMapID();
         var mapItem:* = itemMapList["map_" + num];
         GV.itemID = 3;
         var itemObj:Object = new Object();
         itemObj.id = mapItem;
         itemObj.price = 0;
         itemObj.info = "";
         clothBuyModule.buyAction(itemObj);
      }
      
      private static function resetDic() : void
      {
         if(itemMapList == null)
         {
            itemMapList = new Dictionary(true);
            itemMapList["map_" + 3] = 12205;
            itemMapList["map_" + 7] = 12204;
            itemMapList["map_" + 27] = 12201;
            itemMapList["map_" + 32] = 12202;
            itemMapList["map_" + 14] = 12247;
            itemMapList["map_" + 53] = 12203;
            itemMapList["map_" + 24] = 12336;
            itemMapList["map_" + 18] = 2;
         }
      }
      
      public static function setPetEffectHandler(evt:Event = null, frame:int = 1) : void
      {
         var tempMC:MovieClip = null;
         var peopleMC:MovieClip = GF.getPeopleByID(GV.MyInfo_userID);
         try
         {
            tempMC = peopleMC.avatarMC.pet_mc.getChildAt(0);
            tempMC.findgoods_mc.gotoAndStop(frame);
         }
         catch(E:*)
         {
         }
      }
      
      private static function removeEventHandler(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",removeEventHandler);
         GV.onlineSocket.removeEventListener("SUPER_PETITEM_SUC",buySuperItemHandler);
         GV.onlineSocket.removeEventListener(ClothAccountLogic.SUPER_PET_GET_ITEM,setPetEffectHandler);
      }
      
      private static function giftHandler() : void
      {
      }
   }
}

