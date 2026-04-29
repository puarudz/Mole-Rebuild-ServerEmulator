package com.module.sendBirthdayCard
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.socket.shopItem.BuyItemReq;
   import com.logic.socket.shopItem.BuyItemRes;
   import com.module.activityModule.checkItem;
   import flash.events.Event;
   
   public class BuyTwoItem
   {
      
      public static var ANGIN_BUY:String = "again_buy";
      
      public static var ASK_ITEM:String = "ask_item";
      
      private var _itemCount:uint = 0;
      
      private var _itemID:uint = 0;
      
      private var _msg:String;
      
      private var _url:String;
      
      private var _panle:uint = 0;
      
      private var myalter:*;
      
      private var once:uint = 0;
      
      public function BuyTwoItem()
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
      
      public function get onceTime() : uint
      {
         return this.once;
      }
      
      public function set onceTime(time:uint) : void
      {
         this.once = time;
      }
      
      public function checkHaveItem() : void
      {
         GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.checkHandler);
         checkItem.checkItemHandler(this._itemID);
      }
      
      private function checkHandler(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.checkHandler);
         var checkObj:Object = evt.EventObj;
         if(checkObj.num == 0)
         {
            this.buyChargeItem();
         }
         else
         {
            this.once = 0;
            GV.onlineSocket.dispatchEvent(new Event(ASK_ITEM));
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
         var myalter:* = undefined;
         GV.onlineSocket.removeEventListener(BuyItemRes.BUY_ITEM_SUCCESS,this.buyItemSucc);
         if(this.once == 1)
         {
            this.once = 0;
            GV.onlineSocket.dispatchEvent(new Event(ANGIN_BUY));
         }
         if(this._panle == 0)
         {
            myalter = Alert.showAlert(MainManager.getGameLevel(),this._url,this._msg,Alert.CHANG_ALERT,"ok",true,false,"EMP_BUY");
         }
         else if(this._panle == 1)
         {
            myalter = Alert.showAlert(MainManager.getAppLevel(),this._url,this._msg,Alert.CHANG_ALERT,"otherJob_konw",true,true,"SMCUI");
         }
      }
   }
}

