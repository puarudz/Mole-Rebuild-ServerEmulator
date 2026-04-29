package com.logic.randomItemDrawLogic
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.giveMeMoney.giveMeMoneyReq;
   import com.logic.socket.giveMeMoney.giveMeMoneyRes;
   import flash.display.MovieClip;
   
   public class randomItemDrawLogic
   {
      
      private static var moneyReq:giveMeMoneyReq;
      
      public static var itemArray:Array = [12096];
      
      public static var itemBool:Array = [1];
      
      public static var itemNum:int = 0;
      
      public static var sendType:int = 0;
      
      public static var effectArray:Array = [17001,17002,17003,17004,17005,17006,17007];
      
      public static var effectName:Array = ["稻草人果實","工作錘果實","超級蘑菇","泡泡果實","蘑菇果實","西瓜果實","石像果實"];
      
      public static var randomEftNum:int = 0;
      
      public function randomItemDrawLogic()
      {
         super();
      }
      
      public static function randomItem() : void
      {
         var itemID:int = 0;
         var bool:int = 0;
         var isItemNum:int = 5;
         if(isItemNum == Math.floor(Math.random() * 10))
         {
            itemNum = Math.floor(Math.random() * itemArray.length);
            itemID = int(itemArray[itemNum]);
            bool = int(itemBool[itemNum]);
            getRandomItem(itemID,bool);
         }
         else
         {
            getRandomMoney();
         }
      }
      
      public static function getRandomItem(itemID:int, bool:int) : void
      {
         if(Boolean(bool))
         {
            GV.onlineSocket.addEventListener(GetItemCountRes.GET_ITEMCOUNT,getItemCountLogic);
            GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),itemID,2);
         }
         else
         {
            sendRandomItem();
         }
      }
      
      private static function getItemCountLogic(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(GetItemCountRes.GET_ITEMCOUNT,getItemCountLogic);
         var itemCount:int = int(evt.EventObj.obj.Count);
         if(itemCount == 0)
         {
            sendRandomItem();
         }
         else
         {
            getRandomMoney();
         }
      }
      
      public static function sendRandomItem() : void
      {
         var itemID:int = int(itemArray[itemNum]);
         var itemArray:Array = [{
            "kind":itemID,
            "num":1
         }];
         sendServerAction(itemArray);
      }
      
      public static function getRandomMoney() : void
      {
         var itemID:int = 0;
         var randomNum:int = Math.floor(Math.random() * 100);
         if(randomNum < 33)
         {
            itemID = 17005;
         }
         else if(randomNum < 66)
         {
            itemID = 17006;
         }
         else
         {
            itemID = 17007;
         }
         var moneyArray:Array = [{
            "kind":itemID,
            "num":1
         }];
         sendServerAction(moneyArray);
      }
      
      public static function sendServerAction(arr:Array, type:int = 0) : void
      {
         if(moneyReq == null)
         {
            moneyReq = new giveMeMoneyReq();
         }
         if(type == 0)
         {
            moneyReq.sendItemORMoney([],arr);
         }
         else
         {
            moneyReq.sendItemORMoney(arr,[]);
         }
         GV.onlineSocket.addEventListener(giveMeMoneyRes.SERVER_GIVEMONEY,sendSucess);
      }
      
      private static function sendSucess(evt:EventTaomee) : void
      {
         var str:String = null;
         var itemObj:Object = null;
         GV.onlineSocket.removeEventListener(giveMeMoneyRes.SERVER_GIVEMONEY,sendSucess);
         var msg:String = "";
         if(sendType == 1)
         {
            sendType = 0;
            str = effectName[randomEftNum];
            msg = "恭喜你獲得一個" + str + "\n已經放在你的投擲箱裡了!";
            Alert.showAlert(MainManager.getAppLevel(),msg,"",Alert.CHANG_ALERT,"iknow",true,false,"E");
            return;
         }
         if(sendType == 2)
         {
            sendType = 0;
            GV.onlineSocket.dispatchEvent(new EventTaomee("getLiveItem",evt));
            return;
         }
         if(sendType == 3)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("getJokulItem",evt));
            sendType = 0;
            return;
         }
         if(sendType == 4)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("giveMoneyEvent",evt));
            sendType = 0;
            return;
         }
         var arr:Array = evt.EventObj.arr;
         if(arr[0].kind == 0)
         {
            LocalUserInfo.countYXQ(Number(arr[0].num));
            msg = "快樂假期!\n恭喜你獲得" + arr[0].num + "摩爾豆\n再去領個氣球試試吧！";
         }
         else
         {
            itemObj = GF.getPropData(uint(arr[0].kind));
            if(itemObj.id < 12999)
            {
               msg = "快樂假期!\n恭喜你獲得" + itemObj.name + "\n已經放在你的百寶箱裡了";
            }
            else if(itemObj.id < 17999)
            {
               msg = "快樂假期!\n恭喜你獲得" + itemObj.name + "\n已經放在你的投擲箱裡了";
            }
            else
            {
               msg = "快樂假期!\n恭喜你獲得" + itemObj.name + "\n已經放在你的小屋倉庫裡了";
            }
         }
         Alert.showAlert(MainManager.getAppLevel(),msg,"",Alert.CHANG_ALERT,"iknow",true,false,"E");
      }
      
      public static function getRWAction(mc:MovieClip) : void
      {
         var moneyArray:Array = null;
         var aa:int = Math.floor(Math.random() * 100);
         if(aa < 20)
         {
            sendType = 1;
            mc.gotoAndPlay(9);
            randomEftNum = Math.floor(Math.random() * effectArray.length);
            moneyArray = [{
               "kind":effectArray[randomEftNum],
               "num":1
            }];
            sendServerAction(moneyArray);
         }
      }
      
      public static function getJokulAction(arr:Array) : void
      {
         sendType = 3;
         sendServerAction(arr);
      }
      
      public static function moneyAction(arr:Array, type:int = 0) : void
      {
         sendType = 4;
         sendServerAction(arr,type);
      }
   }
}

