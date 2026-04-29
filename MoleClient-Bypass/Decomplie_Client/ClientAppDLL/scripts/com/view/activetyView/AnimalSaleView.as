package com.view.activetyView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.animalDeal.AnimalDealSocket;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class AnimalSaleView extends Sprite
   {
      
      private var animalID:uint;
      
      public function AnimalSaleView()
      {
         super();
      }
      
      public function checkBuyInfo() : void
      {
         var url:String = null;
         var msg:String = null;
         if(!LocalUserInfo.isVIP())
         {
            url = "resource/allJob/AlertPic/yoyo/yoyosheep1.swf";
            msg = "    小羊綿數量還太少，只能賣給莊園守護者超級拉姆的主人。不過你可以得到超級拉姆朋友贈送給你的小羊哦。";
            Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
         }
         else
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + 1959,this.checkAnimalNumBack);
            AnimalDealSocket.askAnimalCount(0);
         }
      }
      
      private function checkAnimalNumBack(evt:EventTaomee = null) : void
      {
         var url:String = null;
         var msg:String = null;
         var myAlert:* = undefined;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1959,this.checkAnimalNumBack);
         var num:uint = uint(evt.EventObj.animalCount);
         if(num <= 0)
         {
            url = "resource/allJob/AlertPic/yoyo/yoyosheep3.swf";
            msg = "     唉呀，在你猶豫的時候，小羊綿已經全賣完啦，下個整點我會再出售一批，到時候再來吧。";
            Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
         }
         else
         {
            url = "resource/allJob/AlertPic/yoyo/yoyosheep2.swf";
            msg = "    多可愛的小綿羊呀，長大後可是很有作用的哦。每頭小羊售價400摩爾豆，現在只剩下" + num + "隻了，要買趕快啊！";
            myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"buyOne,nextCome",true,false,"SMCUI");
            BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.buyAnimalFun,false,0,true);
         }
      }
      
      private function buyAnimalFun(evt:Event = null) : void
      {
         var url:String = null;
         var msg:String = null;
         if(LocalUserInfo.getYXQ() < 400)
         {
            url = "resource/allJob/AlertPic/yoyo/yoyosheep1.swf";
            msg = "     你的摩爾豆不夠買一隻小羊哦，等攢夠了豆再過來我這邊吧。";
            Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
         }
         else
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + 1925,this.buyAnimalBack);
            AnimalDealSocket.buyAnimalCount(0);
         }
      }
      
      private function buyAnimalBack(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1925,this.buyAnimalBack);
         var obj:Object = evt.EventObj;
         this.animalID = obj.animalID;
         LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() - 400);
         var url:String = "resource/allJob/AlertPic/yoyo/yoyosheep1.swf";
         var msg:String = "     恩，正好400摩爾豆。你的小羊已經送到牧場倉庫了。rr     長到成年期，就能帶來剪羊毛。那可是很有用的做衣服的材料哦。";
         var alert:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
         BC.addEvent(this,alert,Alert.CLICK_ + "1",this.showGetAnimal,false,0,true);
      }
      
      private function showGetAnimal(evt:Event = null) : void
      {
         var name:String = GoodsInfo.getItemNameByID(this.animalID);
         var msg:String = "     一隻" + name + "已經放入你的牧場倉庫中。快回去看看吧！";
         var url:String = "resource/farm/icon/" + this.animalID + ".swf";
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
      }
   }
}

