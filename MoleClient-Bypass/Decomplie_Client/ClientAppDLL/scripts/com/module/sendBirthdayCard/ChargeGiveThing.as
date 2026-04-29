package com.module.sendBirthdayCard
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.socket.giveMeMoney.giveMeMoneyReq;
   import com.logic.socket.giveMeMoney.giveMeMoneyRes;
   import com.logic.socket.shopItem.BuyItemReq;
   import com.logic.socket.shopItem.BuyItemRes;
   import com.module.activityModule.checkItem;
   import flash.events.Event;
   
   public class ChargeGiveThing
   {
      
      public static var ASK_ITEM:String = "ask_item";
      
      public static var GETITEM_EVENT:String = "getitem_event";
      
      private var _itemCount:uint = 0;
      
      private var _itemID:uint = 0;
      
      private var _msg:String;
      
      private var _url:String;
      
      private var _panle:uint = 0;
      
      private var first:uint = 0;
      
      private var myalter:*;
      
      private var giveCS:giveMeMoneyReq;
      
      public function ChargeGiveThing()
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
      
      public function checkItemID() : void
      {
         GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.checkHandler);
         checkItem.checkItemHandler(this.itemID);
      }
      
      private function checkHandler(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.checkHandler);
         var ckeckItemObj:Object = evt.EventObj;
         if(ckeckItemObj.num == 0)
         {
            this.buyChargeItem();
         }
         else
         {
            GV.onlineSocket.dispatchEvent(new Event(ASK_ITEM));
         }
      }
      
      private function buyChargeItem() : void
      {
         GV.onlineSocket.addEventListener(BuyItemRes.BUY_ITEM_SUCCESS,this.buyItemSucc);
         var buyItemReq:BuyItemReq = new BuyItemReq();
         buyItemReq.buyItems(this._itemID,this._itemCount);
         buyItemReq = null;
      }
      
      private function buyItemSucc(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(BuyItemRes.BUY_ITEM_SUCCESS,this.buyItemSucc);
         if(this._panle == 0)
         {
            this.myalter = Alert.showAlert(MainManager.getGameLevel(),this._url,this._msg,Alert.CHANG_ALERT,"ok",true,false,"EMP_BUY");
         }
         else if(this._panle == 1)
         {
            this.myalter = Alert.showAlert(MainManager.getAppLevel(),this._url,this._msg,Alert.CHANG_ALERT,"otherJob_konw",true,true,"SMCUI");
         }
      }
      
      public function getThing() : void
      {
         GV.onlineSocket.addEventListener("sameEvent",this.removeSameEvent);
         var buy_arr:Array = [{
            "kind":this._itemID,
            "num":this._itemCount
         }];
         var arr:Array = [];
         GV.onlineSocket.addEventListener(giveMeMoneyRes.SERVER_GIVEMONEY,this.onCard);
         this.giveCS = new giveMeMoneyReq(arr,buy_arr);
      }
      
      public function getSomething(throwArr:Array, getArr:Array) : void
      {
         GV.onlineSocket.addEventListener(giveMeMoneyRes.SERVER_GIVEMONEY,this.onCard);
         this.giveCS = new giveMeMoneyReq(throwArr,getArr);
      }
      
      private function onCard(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(giveMeMoneyRes.SERVER_GIVEMONEY,this.onCard);
         this.myalter = Alert.showAlert(MainManager.getAppLevel(),this._url,this._msg,Alert.CHANG_ALERT,"ok",true,false,"EMP_BUY");
         this.myalter.addEventListener(Alert.CLICK_ + "1",this.getItemEvent,false,0,true);
      }
      
      private function getItemEvent(evt:*) : void
      {
         GV.onlineSocket.dispatchEvent(new Event(GETITEM_EVENT));
      }
      
      private function removeSameEvent(evt:Event) : void
      {
         GV.onlineSocket.removeEventListener("sameEvent",this.removeSameEvent);
         GV.onlineSocket.removeEventListener(giveMeMoneyRes.SERVER_GIVEMONEY,this.onCard);
      }
   }
}

