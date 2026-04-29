package com.module.sendBirthdayCard
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.shopItem.BuyItemReq;
   import com.logic.socket.shopItem.BuyItemRes;
   import com.module.activityModule.checkItem;
   import flash.events.Event;
   
   public class ChargeBuyItem
   {
      
      public static var ONCE_CLICK:String = "once_click";
      
      public static var ONCE_GET:String = "once_get";
      
      public static var ASK_ITEM:String = "ask_item";
      
      private var _itemCount:uint = 0;
      
      private var _itemID:uint = 0;
      
      private var _msg:String;
      
      private var _url:String;
      
      private var _panle:uint = 0;
      
      private var first:uint = 0;
      
      private var myalter:*;
      
      private var jobBool:Boolean = false;
      
      public function ChargeBuyItem()
      {
         super();
      }
      
      public function set itemCount(count:uint) : void
      {
         this._itemCount = count;
      }
      
      public function get itemCount() : uint
      {
         return this._itemCount;
      }
      
      public function set itemID(id:uint) : void
      {
         this._itemID = id;
      }
      
      public function get itemID() : uint
      {
         return this._itemID;
      }
      
      public function set msg(str:String) : void
      {
         this._msg = str;
      }
      
      public function get msg() : String
      {
         return this._msg;
      }
      
      public function set url(_url:String) : void
      {
         this._url = _url;
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function get panle() : uint
      {
         return this._panle;
      }
      
      public function set panle(i:uint) : void
      {
         this._panle = i;
      }
      
      public function get bool() : Boolean
      {
         return this.jobBool;
      }
      
      public function set bool(b:Boolean) : void
      {
         this.jobBool = b;
      }
      
      public function checkHaveItem() : void
      {
         GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.checkHandler);
         checkItem.checkItemHandler(this._itemID);
      }
      
      private function checkHandler(evt:EventTaomee) : void
      {
         var myalter:Class = null;
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.checkHandler);
         var checkObj:Object = evt.EventObj;
         if(checkObj.num == 0 && !this.jobBool)
         {
            this.buyChargeItem();
         }
         else
         {
            if(this._itemID == 190571)
            {
               this.buyChargeItem();
            }
            if(this._panle == 1)
            {
               GV.onlineSocket.dispatchEvent(new Event(ASK_ITEM));
               myalter = Alert.showAlert(MainManager.getAppLevel(),this._url,this._msg,Alert.CHANG_ALERT,"otherJob_konw",true,true,"SMCUI") as Class;
            }
            if(this._panle == 2)
            {
               GV.onlineSocket.dispatchEvent(new Event(ASK_ITEM));
               myalter = Alert.showAlert(MainManager.getGameLevel(),this._url,this._msg,Alert.CHANG_ALERT,"ok",true,false,"EMP_BUY") as Class;
            }
         }
      }
      
      public function buyChargeItem() : void
      {
         GV.onlineSocket.addEventListener(BuyItemRes.BUY_ITEM_SUCCESS,this.buyItemSucc);
         var buyItemReq:BuyItemReq = new BuyItemReq();
         buyItemReq.buyItems(this._itemID,this._itemCount);
         buyItemReq = null;
      }
      
      private function buyItemSucc(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(BuyItemRes.BUY_ITEM_SUCCESS,this.buyItemSucc);
         if(this._panle == 0 || this._panle == 2)
         {
            this.myalter = Alert.showAlert(MainManager.getGameLevel(),this._url,this._msg,Alert.CHANG_ALERT,"ok",true,false,"EMP_BUY");
         }
         else if(this._panle == 1)
         {
            this.myalter = Alert.showAlert(MainManager.getAppLevel(),this._url,this._msg,Alert.CHANG_ALERT,"otherJob_konw",true,true,"SMCUI");
         }
      }
      
      public function getItem() : void
      {
         BC.addEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.getHandler);
         exchange.exchange_goods(125);
      }
      
      private function getHandler(evt:EventTaomee) : void
      {
         var id:int = 0;
         var count:int = 0;
         if(evt.EventObj.type == 125)
         {
            id = int(evt.EventObj.arr[0].itemID);
            count = int(evt.EventObj.arr[0].count);
            BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.getHandler);
            Alert.smileAlart("    恭喜你獲得" + count + "個" + GoodsInfo.getItemNameByID(id));
         }
      }
   }
}

