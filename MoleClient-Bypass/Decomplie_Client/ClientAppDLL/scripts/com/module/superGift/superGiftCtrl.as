package com.module.superGift
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.HatchLongEgg.HatchLongEggSocket;
   import com.logic.socket.dragon.DragonBagSocket;
   import com.module.coin.CoinBuyModle;
   import com.module.query.QueryImpl;
   
   public class superGiftCtrl
   {
      
      private static var instance:superGiftCtrl;
      
      private static var canotNew:Boolean = true;
      
      private var chestID:int;
      
      private var CoinBuyModles:CoinBuyModle;
      
      private var commodityID:int;
      
      private var isVip:Boolean = false;
      
      private var longID:int;
      
      public function superGiftCtrl()
      {
         super();
         if(canotNew)
         {
            throw new Error("AgicalGoodsControl不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : superGiftCtrl
      {
         if(!instance)
         {
            canotNew = false;
            instance = new superGiftCtrl();
            canotNew = true;
         }
         return instance;
      }
      
      public function buyGiftFun(_commodityID:int, _chestID:int, _longID:int, _bool:Boolean = false) : void
      {
         if(this.CoinBuyModles == null)
         {
            this.CoinBuyModles = new CoinBuyModle();
         }
         this.isVip = _bool;
         this.commodityID = _commodityID;
         this.chestID = _chestID;
         this.longID = _longID;
         if(_bool)
         {
            if(LocalUserInfo.isVIP())
            {
               this.buyItemEvent();
            }
            else
            {
               Alert.SLAlart("    只有擁有超級拉姆的小摩爾，才能購買哦！");
            }
         }
         else
         {
            this.buyItemEvent();
         }
      }
      
      private function buyItemEvent() : void
      {
         QueryImpl.getInstance().QueryItem([this.chestID],this.setPropNumFun);
      }
      
      private function setPropNumFun(arr:Array) : void
      {
         if(arr[0].count == 0)
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + 1227,this.checkDragonBagFun);
            DragonBagSocket.getDragonBagRequest();
         }
         else
         {
            this.alertFun(1);
         }
      }
      
      private function checkDragonBagFun(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1227,this.checkDragonBagFun);
         var isHave:Boolean = true;
         var obj:Object = evt.EventObj;
         for(var i:int = 0; i < obj.arr.length; i++)
         {
            if(obj.arr[i].id == this.longID)
            {
               isHave = false;
            }
         }
         if(isHave)
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + 1237,this.checkDragonChangeFun);
            HatchLongEggSocket.getLongEggTimer();
         }
         else
         {
            this.alertFun(2);
         }
      }
      
      private function checkDragonChangeFun(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1237,this.checkDragonChangeFun);
         var obj:Object = evt.EventObj;
         if(obj.itemId == this.chestID)
         {
            this.alertFun(3);
         }
         else
         {
            this.CoinBuyModles.BuyModle(this.commodityID,1);
         }
      }
      
      private function alertFun(type:int) : void
      {
         var msg:String = null;
         switch(type)
         {
            case 1:
               msg = "    你已經擁有這種龍蛋了，不能購買囉,請選擇其他的龍蛋吧！";
               break;
            case 2:
               msg = "    你已經擁有這種龍坐騎了，不能購買龍蛋囉,請選擇其他的龍蛋吧！";
               break;
            case 3:
               msg = "    你的龍蛋已經在孵化了，不能購買這種龍蛋囉,請選擇其他的龍蛋吧！";
         }
         GF.showAlert(MainManager.getTopLevel(),msg,"",100,"iknow",true,false,"E");
      }
   }
}

