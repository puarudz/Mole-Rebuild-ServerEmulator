package com.module.deal
{
   import com.common.Alert.Alert;
   import com.logic.ClothBuyLogic.ClothAccountLogic;
   import com.module.clothBuyModule.clothBuyModule;
   
   public class Deal
   {
      
      public function Deal()
      {
         super();
      }
      
      public static function BuyItem(itemID:uint, count:uint = 1, successFun:Function = null, failFun:Function = null, checkPriceFun:* = true, buyType:uint = 1) : void
      {
         var tc:IDeal = null;
         if(buyType == 1)
         {
            if(itemID < 1200001 || itemID > 1219999)
            {
               tc = new Deal_ComplexItem();
            }
            else
            {
               if(GV.MAN_PEOPLE.Petlevel <= 1)
               {
                  Alert.smileAlart("    你的拉姆沒有在你身邊哦！");
                  return;
               }
               tc = new Deal_PetItem();
            }
         }
         else if(buyType == 2)
         {
            tc = new Deal_DiDiDouItem();
         }
         tc.BuyItem(itemID,count,successFun,failFun);
      }
      
      public static function UI_Selective_BuyItemOK(itemID:uint, count:uint = 1, successFun:Function = null, failFun:Function = null) : void
      {
         clothBuyModule.minNum = count;
         var itemObj:Object = new Object();
         itemObj.id = itemID;
         itemObj.price = 0;
         itemObj.info = "0";
         clothBuyModule.buyAction(itemObj,false,false,successFun,failFun);
      }
      
      public static function UI_BuyItem(itemID:uint, count:uint = 1, successTip:String = "", fail_tipOrFun:* = null) : void
      {
         if(successTip == "")
         {
            successTip = "　　" + ClothAccountLogic.getAddress(itemID).split("\r").join("");
            if(successTip.indexOf("!") == -1)
            {
               successTip += "。";
            }
         }
         Deal.BuyItem(itemID,count,function(ItemnID:uint):void
         {
            if(itemID == ItemnID)
            {
               Alert.getIconByID_Alart(itemID,successTip);
            }
         },function(errorNum:int):void
         {
            if(Boolean(fail_tipOrFun))
            {
               if(Boolean(fail_tipOrFun as Function))
               {
                  fail_tipOrFun(errorNum);
               }
               else if(Boolean(fail_tipOrFun as String))
               {
                  Alert.smileAlart(fail_tipOrFun);
               }
            }
         });
      }
      
      public static function SwapItem(dropArray:Array, giveArray:Array, successFun:Function = null, failFun:Function = null, checkPriceFun:* = true) : void
      {
         ISwapDeal(new Deal_SwapItem()).SwapItem(dropArray,giveArray,successFun,failFun,checkPriceFun);
      }
      
      public static function DelItem(dropArray:Array, successFun:Function = null, failFun:Function = null, checkPriceFun:* = true) : void
      {
         ISwapDeal(new Deal_SwapItem()).DelItem(dropArray,successFun,failFun,checkPriceFun);
      }
   }
}

