package com.module.teacherDay
{
   import com.common.Alert.Alert;
   import com.event.EventTaomee;
   import com.logic.socket.giveMeMoney.giveMeMoneyReq;
   import com.logic.socket.giveMeMoney.giveMeMoneyRes;
   import com.module.activityModule.checkCloth;
   import com.module.activityModule.checkItem;
   import com.module.activityModule.deleteItemModule;
   import com.module.activityModule.refurbishPeopleModule;
   import com.mole.app.manager.BagViewManager;
   import flash.events.Event;
   
   public class Teacherday
   {
      
      private var npc:String;
      
      private var fruitID:uint;
      
      private var bookID:uint = 12194;
      
      public function Teacherday(npcname:String)
      {
         super();
         this.npc = npcname;
         this.init();
      }
      
      public function init() : void
      {
         var url:String = null;
         var msg:String = null;
         var myAlert:* = undefined;
         if(this.havFruit())
         {
            url = "resource/allJob/AlertPic/fruit.swf";
            msg = "老師辛苦啦！！這是我親手摘的漿果哦！快嘗嘗吧^_^";
            myAlert = Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"giveFruit,nextCome",true,true,"SMCUI");
            myAlert.addEventListener(Alert.CLICK_ + "1",this.dogive);
         }
         else
         {
            trace("沒帶");
            GV.onlineSocket.dispatchEvent(new Event("NO_FRUIT"));
         }
      }
      
      public function dogive(e:Event) : void
      {
         if(this.havFruit())
         {
            GV.onlineSocket.addEventListener(deleteItemModule.DELETE_ITEM_SUCESS,this.initAction);
            deleteItemModule.doAction(this.fruitID);
         }
      }
      
      public function initAction(e:Event) : void
      {
         GV.onlineSocket.removeEventListener(deleteItemModule.DELETE_ITEM_SUCESS,this.initAction);
         GV.onlineSocket.addEventListener(refurbishPeopleModule.REFURBISH_PEOPLE_SUC,this.doAction);
         trace("fruitID:",this.fruitID);
         refurbishPeopleModule.doAction(this.fruitID);
         checkItem.checkItemHandler(this.bookID);
         GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.hadBook);
      }
      
      public function doAction(e:Event) : void
      {
         GV.onlineSocket.addEventListener(refurbishPeopleModule.REFURBISH_PEOPLE_SUC,this.doAction);
         GF.revertPeople(GV.MyInfo_userID);
      }
      
      public function hadBook(e:EventTaomee) : void
      {
         var url:String = null;
         var msg:String = null;
         var myAlert:* = undefined;
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.hadBook);
         if(e.EventObj.count > 0)
         {
            url = "resource/allJob/AlertPic/" + this.npc + "eat.swf";
            msg = "這是我們應該做的哦！謝謝你，很新鮮的漿果啊^_^";
            myAlert = Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,true,"SMCUI");
         }
         else
         {
            url = "resource/allJob/AlertPic/" + this.npc + "eat.swf";
            msg = "親愛的" + GV.MyInfo_nickName + "，你還沒有輔導書吧！！作為漿果的回禮，我送你一本輔導書吧^_^把書拿在手上，坐下來試試當一天的老師吧！！";
            myAlert = Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"fetch,nextCome",true,true,"SMCUI");
            myAlert.addEventListener(Alert.CLICK_ + "1",this.getBook);
         }
         try
         {
            BagViewManager.updateBag();
         }
         catch(E:*)
         {
         }
      }
      
      public function getBook(e:Event) : void
      {
         var give:giveMeMoneyReq = new giveMeMoneyReq([],[{
            "kind":this.bookID,
            "num":1
         }]);
         GV.onlineSocket.addEventListener(giveMeMoneyRes.SERVER_GIVEMONEY,this.getBookSucc);
      }
      
      public function getBookSucc(e:Event) : void
      {
         GV.onlineSocket.removeEventListener(giveMeMoneyRes.SERVER_GIVEMONEY,this.getBookSucc);
         Alert.showAlert(GV.MC_AppLever,"","一本輔導書在你的百寶箱裡了！",Alert.IKNOW_ALERT);
      }
      
      public function havFruit() : Boolean
      {
         var arr:Array = [12134,12135,12136,12137,12138];
         for(var i:uint = 0; i < 5; i++)
         {
            if(checkCloth.doAction(arr[i]))
            {
               this.fruitID = arr[i];
               return true;
            }
         }
         return false;
      }
   }
}

