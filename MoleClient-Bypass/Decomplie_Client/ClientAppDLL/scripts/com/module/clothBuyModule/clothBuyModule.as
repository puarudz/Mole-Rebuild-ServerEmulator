package com.module.clothBuyModule
{
   import com.common.Alert.*;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.manager.IndexManager;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.logic.ClothBuyLogic.ClothAccountLogic;
   import com.logic.socket.shopItem.BuyItemReq;
   import com.logic.socket.shopItem.BuyItemRes;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.*;
   
   public class clothBuyModule
   {
      
      public static var buyNum:Number;
      
      public static var ErrorMC:MovieClip;
      
      public static var buyTip:MovieClip;
      
      public static var tempLoad:Loader;
      
      public static var iconMC:MovieClip;
      
      public static var success_mc:MovieClip;
      
      public static var clientID:int;
      
      public static var clientPrice:Number;
      
      public static var clientName:String;
      
      public static var isConcat:Boolean;
      
      public static var isSelect:Boolean;
      
      public static var alertObj:*;
      
      public static var buyItemReq:BuyItemReq;
      
      public static var concatNum:Number;
      
      private static var _successFun:Function;
      
      private static var _failFun:Function;
      
      public static var clientBool:Boolean = false;
      
      public static var itemArray:Array = new Array();
      
      public static var minNum:Number = 1;
      
      public function clothBuyModule()
      {
         super();
      }
      
      public static function buyAction(itemObj:Object, isselect:Boolean = true, type:Boolean = false, successFun:Function = null, failFun:Function = null) : void
      {
         var infoObj:Object = null;
         _successFun = successFun;
         _failFun = failFun;
         GV.onlineSocket.addEventListener("removeMapEvent",removeHandler);
         GV.onlineSocket.addEventListener("ERROR_CMD_-10015",removeHandler);
         concatNum = 1;
         isSelect = isselect;
         buyNum = minNum;
         isConcat = type;
         if(isConcat)
         {
            itemArray = itemObj.itemArray;
            clientID = itemArray[concatNum - 1];
            clientPrice = itemObj.price;
            clientName = itemObj.info;
         }
         else
         {
            clientID = itemObj.id;
            infoObj = GoodsInfo.getInfoById(clientID);
            clientPrice = infoObj.price;
            clientName = infoObj.name;
         }
         if(tempLoad == null)
         {
            tempLoad = new Loader();
            buyItemReq = new BuyItemReq();
         }
         initBuy();
      }
      
      public static function initBuy() : void
      {
         var itemInfo:String = null;
         trace("------------------------統一購買",clientID);
         if(!MainManager.getAlertLevel().getChildByName("buyTip"))
         {
            if(buyTip != null)
            {
               buyCancelHandler();
            }
            successClickHandler();
            tempLoad.unload();
            tempLoad.load(VL.getURLRequest(ClothAccountLogic.getURL(clientID)));
            buyTip = new MovieClip();
            buyTip.name = "buyTip";
            buyTip = IndexManager.getInstance().getMovieClip("tip_mc");
            MainManager.getAlertLevel().addChild(buyTip);
            buyTip.x = (buyTip.stage.stageWidth - buyTip.width) / 2;
            buyTip.y = (buyTip.stage.stageHeight - buyTip.height) / 2;
            buyTip.mc_load.addChild(tempLoad);
            if(isSelect)
            {
               buyTip.bg.visible = false;
               buyTip.numTxt.visible = false;
               buyTip.number_txt.visible = false;
               buyTip.minus_btn.visible = false;
               buyTip.add_btn.visible = false;
               buyTip.mc_load.scaleX = 1.5;
               buyTip.mc_load.scaleY = 1.5;
               buyTip.mc_load.x = 110;
               buyTip.mc_load.y = 41.2;
               buyTip.info.text = clientName + "需花費" + clientPrice * buyNum + "摩爾豆，你現在擁有" + LocalUserInfo.getYXQ().toString() + "摩爾豆，要確認購買嗎？";
               if(Boolean(XMLInfo.ClothHint[clientID]))
               {
                  buyTip.info.text = XMLInfo.ClothHint[clientID];
               }
               else if(ClothAccountLogic.isVipItem(clientID))
               {
                  itemInfo = GF.getItemName(clientID).@Name;
                  buyTip.info.text = "你的超級拉姆幫你找到了" + itemInfo;
               }
            }
            else
            {
               buyTip.bg.visible = true;
               buyTip.numTxt.visible = true;
               buyTip.number_txt.visible = true;
               buyTip.minus_btn.visible = true;
               buyTip.add_btn.visible = true;
               buyTip.mc_load.scaleX = 1;
               buyTip.mc_load.scaleY = 1;
               buyTip.mc_load.x = 61;
               buyTip.mc_load.y = 41.2;
               buyTip.info.text = String(buyNum) + ClothAccountLogic.getQuantifier(clientID) + clientName + "需花費" + clientPrice * buyNum + "摩爾豆，你現在擁有" + LocalUserInfo.getYXQ().toString() + "摩爾豆，要確認購買嗎？";
               buyTip.add_btn.addEventListener(MouseEvent.CLICK,addAction);
               buyTip.minus_btn.addEventListener(MouseEvent.CLICK,minusAction);
               buyTip.number_txt.addEventListener(Event.CHANGE,txtChangeHandler);
            }
            buyTip.number_txt.text = String(buyNum);
            buyTip.enter_btn.addEventListener(MouseEvent.CLICK,buyClickHandler);
            buyTip.cancel_btn.addEventListener(MouseEvent.CLICK,buyCancelHandler);
         }
      }
      
      private static function addAction(evt:MouseEvent) : void
      {
         if(buyNum * clientPrice < LocalUserInfo.getYXQ() && buyNum < 99)
         {
            buyNum += 1;
            buyTip.number_txt.text = String(buyNum);
            buyTip.info.text = String(buyNum) + ClothAccountLogic.getQuantifier(clientID) + clientName + "需花費" + clientPrice * buyNum + "摩爾豆，你現在擁有" + LocalUserInfo.getYXQ().toString() + "摩爾豆，要確認購買嗎？";
         }
      }
      
      private static function minusAction(evt:MouseEvent) : void
      {
         if(buyNum <= minNum)
         {
            buyNum = minNum;
            buyTip.number_txt.text = String(buyNum);
         }
         else
         {
            buyNum -= 1;
            buyTip.number_txt.text = String(buyNum);
         }
         buyTip.info.text = String(buyNum) + ClothAccountLogic.getQuantifier(clientID) + clientName + "需花費" + clientPrice * buyNum + "摩爾豆，你現在擁有" + LocalUserInfo.getYXQ().toString() + "摩爾豆，要確認購買嗎？";
      }
      
      private static function txtChangeHandler(evt:Event) : void
      {
         var a:Number = Number(buyTip.number_txt.text);
         if(isNaN(a) || a <= 0)
         {
            buyTip.number_txt.text = buyNum;
         }
         else
         {
            buyNum = a;
            buyTip.info.text = String(buyNum) + ClothAccountLogic.getQuantifier(clientID) + clientName + "需花費" + clientPrice * buyNum + "摩爾豆，你現在擁有" + LocalUserInfo.getYXQ().toString() + "摩爾豆，要確認購買嗎？";
         }
      }
      
      private static function buyClickHandler(evt:MouseEvent) : void
      {
         var tempAlert:* = undefined;
         buyCancelHandler();
         if(clientPrice * buyNum <= LocalUserInfo.getYXQ())
         {
            GV.onlineSocket.addEventListener(BuyItemRes.BUY_ITEM_SUCCESS,onBuySuccess);
            GV.onlineSocket.addEventListener("ERROR_CMD_" + 501,onBuyFail);
            buyItemReq.buyItems(int(clientID),buyNum);
         }
         else
         {
            tempAlert = Alert.showAlert(MainManager.getGameLevel(),"你的摩爾豆不夠囉......","",6,"D");
            GV.onlineSocket.removeEventListener(BuyItemRes.BUY_ITEM_SUCCESS,onBuySuccess);
            GV.onlineSocket.addEventListener("ERROR_CMD_" + 501,onBuyFail);
            GV.onlineSocket.dispatchEvent(new EventTaomee("ERROR_CMD_501",-11117));
            GV.onlineSocket.dispatchEvent(new EventTaomee("ERROR_CMD_-11117",501));
         }
      }
      
      private static function buyCancelHandler(evt:MouseEvent = null) : void
      {
         if(Boolean(evt))
         {
            GV.onlineSocket.addEventListener("ERROR_CMD_" + 501,onBuyFail);
            GV.onlineSocket.dispatchEvent(new EventTaomee("ERROR_CMD_501",-1));
            GV.onlineSocket.dispatchEvent(new EventTaomee("ERROR_CMD_-1",501));
            GV.onlineSocket.removeEventListener("ERROR_CMD_" + 501,onBuyFail);
         }
         buyTip.enter_btn.removeEventListener(MouseEvent.CLICK,buyClickHandler);
         buyTip.cancel_btn.removeEventListener(MouseEvent.CLICK,buyCancelHandler);
         GC.stopAllMC(buyTip);
         GC.clearChildren(buyTip);
         buyTip.parent.removeChild(buyTip);
         buyTip = null;
         tempLoad.unload();
      }
      
      private static function concatBuy() : void
      {
         var buyID:int = 0;
         if(concatNum < itemArray.length)
         {
            buyID = int(itemArray[concatNum]);
            ++concatNum;
            if(concatNum >= itemArray.length)
            {
               isConcat = false;
            }
            buyItemReq.buyItems(int(buyID),buyNum);
         }
      }
      
      private static function onBuySuccess(evt:*) : void
      {
         if(isConcat)
         {
            concatBuy();
         }
         else
         {
            if(buyTip != null)
            {
               buyCancelHandler();
            }
            if(!MainManager.getGameLevel().getChildByName("success_mc"))
            {
               success_mc = new MovieClip();
               success_mc.name = "success_mc";
               success_mc = IndexManager.getInstance().getMovieClip("buy_Success");
               MainManager.getGameLevel().addChild(success_mc);
               success_mc.x = (success_mc.stage.stageWidth - success_mc.width) / 2;
               success_mc.y = (success_mc.stage.stageHeight - success_mc.height) / 2;
               success_mc.info.text = ClothAccountLogic.getAddress(clientID);
               success_mc.enter_btn.addEventListener(MouseEvent.CLICK,successClickHandler);
               GV.onlineSocket.removeEventListener(BuyItemRes.BUY_ITEM_SUCCESS,onBuySuccess);
               GV.onlineSocket.dispatchEvent(new Event("BUYPET_SUCCESS"));
               GV.onlineSocket.dispatchEvent(new EventTaomee("HomedepotAddGoods",{"obj":{
                  "ID":clientID,
                  "NUM":buyNum
               }}));
            }
            if(_successFun != null)
            {
               _successFun(clientID);
            }
            minNum = 1;
         }
      }
      
      private static function onBuyFail(E:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("ERROR_CMD_" + 501,onBuyFail);
         if(_failFun != null)
         {
            _failFun(E.EventObj as int);
         }
         minNum = 1;
      }
      
      private static function successClickHandler(evt:* = null) : void
      {
         try
         {
            success_mc.enter_btn.removeEventListener(MouseEvent.CLICK,successClickHandler);
            success_mc.parent.removeChild(success_mc);
            success_mc = null;
         }
         catch(E:*)
         {
         }
      }
      
      private static function removeHandler(evt:EventTaomee) : void
      {
         isSelect = true;
         isConcat = false;
         GV.onlineSocket.removeEventListener(BuyItemRes.BUY_ITEM_SUCCESS,onBuySuccess);
         GV.onlineSocket.removeEventListener("ERROR_CMD_" + 501,onBuyFail);
         GV.onlineSocket.removeEventListener("removeMapEvent",removeHandler);
         GV.onlineSocket.removeEventListener("sameEvent",removeHandler);
         GV.onlineSocket.removeEventListener("ERROR_CMD_-10015",removeHandler);
         if(buyTip != null)
         {
            buyCancelHandler();
         }
         if(success_mc != null)
         {
            successClickHandler();
         }
      }
   }
}

