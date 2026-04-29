package com.view.AltView
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.sellFruit.SellFruitReq;
   import com.logic.socket.sellFruit.SellFruitRes;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class AncientCoinsAlt extends Sprite
   {
      
      private var COINS_ID:uint = 190372;
      
      private var coin_num:int;
      
      private var exchange_num:int;
      
      public function AncientCoinsAlt()
      {
         super();
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
      }
      
      public function doAlt() : void
      {
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.checkCoinsHandler);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),this.COINS_ID,2);
      }
      
      private function checkCoinsHandler(eve:EventTaomee = null) : void
      {
         var myAlert:* = undefined;
         var _url:String = null;
         var _msg:String = null;
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.checkCoinsHandler);
         var obj:Object = eve.EventObj.obj;
         if(obj.Count == 0)
         {
            _url = "resource/allJob/AlertPic/BodhiTreasure/have_no_coin.swf";
            _msg = "    怎麼辦怎麼辦，舊城堡中的皇家展覽館中有大量的古董，它對於你來說沒有用，不過這可是國家財產呀！rr    如果你挖到了，就來拿給我吧。我會用摩爾豆和你兌換的！";
            myAlert = Alert.showAlert(MainManager.getAppLevel(),_url,_msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
            BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showBtn);
         }
         else
         {
            this.coin_num = obj.arr[0].itemCount;
            this.exchange_num = this.coin_num;
            _url = "resource/allJob/AlertPic/BodhiTreasure/have_coin.swf";
            _msg = "    喔嚯嚯嚯~~~這可是舊城堡中最古老的古幣了。現在你身上有" + obj.arr[0].itemCount + "枚古幣，如果你願意捐出來，我將會用" + obj.arr[0].itemCount * 50 + "摩爾豆與你兌換。";
            if(this.coin_num > 99)
            {
               this.exchange_num = 99;
               _msg = "    喔嚯嚯嚯~~~古幣！因為你身上的古幣過多，我暫時用99枚古幣，兌換4950個摩爾豆，如果你身上還有多餘的，再來找我兌換吧。";
            }
            myAlert = Alert.showAlert(MainManager.getAppLevel(),_url,_msg,Alert.CHANG_ALERT,"sure,cancel",true,false,"SMCUI");
            BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.exchangeCoinsHandler);
            BC.addEvent(this,myAlert,Alert.CLICK_ + "2",this.showBtn);
         }
      }
      
      private function exchangeCoinsHandler(eve:Event = null) : void
      {
         BC.addEvent(this,GV.onlineSocket,SellFruitRes.SOLD_FRUIT_SUCC,this.getMoerHandler);
         SellFruitReq.sendSellFruitReq(this.COINS_ID,this.exchange_num);
      }
      
      private function showBtn(eve:Event = null) : void
      {
         GV.onlineSocket.dispatchEvent(new Event("showBodhiBox"));
      }
      
      private function getMoerHandler(eve:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,SellFruitRes.SOLD_FRUIT_SUCC,this.getMoerHandler);
         var _msg:String = "    " + this.exchange_num * 50 + "摩爾豆已經放入你的百寶箱中了！";
         GF.showAlert(MainManager.getAppLevel(),_msg,"",100,"iknow",true,false,"E");
         var money:int = LocalUserInfo.getYXQ() + this.exchange_num * 50;
         LocalUserInfo.setYXQ(money);
         this.showBtn();
      }
      
      private function removeEventHandler(evetn:EventTaomee) : void
      {
         BC.removeEvent(this);
         GC.clear();
      }
   }
}

