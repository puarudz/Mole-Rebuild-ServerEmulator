package com.module.sendBirthdayCard
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.socket.giveMeMoney.giveMeMoneyReq;
   import com.logic.socket.giveMeMoney.giveMeMoneyRes;
   import com.module.activityModule.checkItem;
   
   public class SendCard
   {
      
      private var itemID:uint = 180025;
      
      private var url:String = "resource/pet/icon/" + this.itemID + ".swf";
      
      private var msg:String = "   你的手藝真棒！獎勵你1份跳跳布丁，拉姆很喜歡吃的哦!";
      
      public function SendCard()
      {
         super();
      }
      
      public function set _itemID(id:uint) : void
      {
         this.itemID = id;
      }
      
      public function get _itemID() : uint
      {
         return this.itemID;
      }
      
      public function set _url(str:String) : void
      {
         this.url = str;
      }
      
      public function get _url() : String
      {
         return this.url;
      }
      
      public function set _msg(str:String) : void
      {
         this.msg = str;
      }
      
      public function get _msg() : String
      {
         return this.msg;
      }
      
      public function checkItemID() : void
      {
         GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.checkHandler);
         checkItem.checkItemHandler(this.itemID);
      }
      
      public function getThing() : void
      {
         var buy_arr:Array = [{
            "kind":this.itemID,
            "num":1
         }];
         var arr:Array = [];
         GV.onlineSocket.addEventListener(giveMeMoneyRes.SERVER_GIVEMONEY,this.onCard);
         var giveCS:giveMeMoneyReq = new giveMeMoneyReq(arr,buy_arr);
      }
      
      private function checkHandler(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.checkHandler);
         var ckeckItemObj:Object = evt.EventObj;
         if(ckeckItemObj.num <= 0)
         {
            this.getThing();
         }
      }
      
      private function onCard(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(giveMeMoneyRes.SERVER_GIVEMONEY,this.onCard);
         var myalter:* = Alert.showAlert(MainManager.getAppLevel(),this.url,this.msg,Alert.CHANG_ALERT,"ok",true,false,"EMP_BUY");
      }
   }
}

