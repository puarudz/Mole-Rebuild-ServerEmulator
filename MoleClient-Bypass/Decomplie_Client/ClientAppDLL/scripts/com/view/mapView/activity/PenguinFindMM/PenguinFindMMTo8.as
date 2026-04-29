package com.view.mapView.activity.PenguinFindMM
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.socket.PenguinFindSocket.PenguinFindSocket;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.module.activityModule.checkItem;
   import com.module.deal.Deal;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class PenguinFindMMTo8
   {
      
      private static var instance:PenguinFindMMTo8;
      
      private static var canotNew:Boolean = true;
      
      private var mainMc:MovieClip;
      
      private var joinObj:Object;
      
      private var eggTimer:Timer;
      
      private var penguinCount:int;
      
      public function PenguinFindMMTo8()
      {
         super();
         if(canotNew)
         {
            throw new Error("PenguinFindMMTo8不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : PenguinFindMMTo8
      {
         if(!instance)
         {
            canotNew = false;
            instance = new PenguinFindMMTo8();
            canotNew = true;
         }
         return instance;
      }
      
      public function init(tempMc:MovieClip) : void
      {
         this.mainMc = tempMc;
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         GV.onlineSocket.addEventListener("read_" + 1387,this.onRead1387Main);
         PenguinFindSocket.getPenguinData();
      }
      
      private function onRead1387Main(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 1387,this.onRead1387Main);
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.onPenguinMMHandler);
         this.penguinCount = evt.EventObj.penguinCount;
         if(evt.EventObj.saveData == 2)
         {
            PenguinFindMM.getInstance().removeMapEvent();
            BC.addEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.itemSucHandlerEgg);
            checkItem.checkItemHandler(190580);
         }
         else if(PenguinFindMM.getInstance().getHasPenguin())
         {
            this.mainMc.penguinMM.visible = true;
         }
      }
      
      private function itemSucHandlerEgg(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.itemSucHandlerEgg);
         if(evt.EventObj.num > 0)
         {
            this.mainMc.penguinMM.gotoAndStop(4);
         }
         else
         {
            this.mainMc.penguinMM.gotoAndStop(7);
         }
         this.mainMc.penguinMM.visible = true;
      }
      
      private function onPenguinMMHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"fireAction_select",this.onPenguinMMHandler);
         if(this.mainMc.penguinMM.currentFrame == 1)
         {
            GV.onlineSocket.addEventListener("read_" + 1388,this.onRead1388);
            PenguinFindSocket.setPenguinData(1,2);
         }
         else if(this.mainMc.penguinMM.currentFrame == 2)
         {
            Deal.BuyItem(190580,1,function(... e):void
            {
               Alert.getIconByID_Alart(190580,"    恭喜你得到" + GoodsInfo.getItemNameByID(190580) + "，快去問問企鵝爸爸怎麼孵出小寶寶吧？");
               GV.onlineSocket.addEventListener("giveEgg",onGiveEgg);
               mainMc.penguinMM.gotoAndStop(3);
            },function(... e):void
            {
               Alert.smileAlart("    你已經擁有這件寶貝啦，所以不能再領取了哦！");
            });
         }
         else if(this.mainMc.penguinMM.currentFrame == 3)
         {
            this.checkEgg();
         }
         else if(this.mainMc.penguinMM.currentFrame == 4)
         {
            BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.checkEggBack);
            finishSomethingReq.sendReq(219);
         }
         else if(this.mainMc.penguinMM.currentFrame == 6)
         {
            GV.onlineSocket.addEventListener("giveEgg",this.onGiveEgg);
            this.mainMc.penguinMM.gotoAndStop(7);
         }
         else if(this.mainMc.penguinMM.currentFrame == 7)
         {
            BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.onPenguinMMHandler);
            Deal.BuyItem(190580,1,function(... e):void
            {
               Alert.getIconByID_Alart(190580,"    恭喜你得到" + GoodsInfo.getItemNameByID(190580) + "，快去問問企鵝爸爸怎麼孵出小寶寶吧？");
               mainMc.penguinMM.gotoAndStop(4);
            },function(... e):void
            {
               Alert.smileAlart("    你已經擁有這件寶貝啦，所以不能再領取了哦！");
            });
         }
      }
      
      private function checkEggBack(evt:EventTaomee) : void
      {
         var message:String = null;
         var url:String = null;
         BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.checkEggBack);
         if(evt.EventObj.Done == 0)
         {
            message = "    你是來帶我的企鵝蛋孵化的嗎？你身上的企鵝蛋已經被孵化過" + this.penguinCount % 3 + "次了，只要每天孵30秒鐘三天後企鵝寶寶就會出世啦！\n" + "    確定現在要孵嗎？";
            url = "resource/allJob/AlertPic/PenguinFindMM/PenguinFindMM_01.swf";
            this.joinObj = Alert.showAlert(MainManager.getGameLevel(),url,message,Alert.CHANG_ALERT,"sure,cancel",true,false,"SMCUI");
            this.joinObj.addEventListener("CLICK" + 1,this.doActionHandler);
            this.joinObj.addEventListener("CLICK" + 2,this.doActionHandler);
         }
         else
         {
            Alert.smileAlart("    企鵝爸爸已經為你的企鵝蛋孵化過啦，明天再來吧！");
         }
      }
      
      private function onRead1388(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 1388,this.onRead1388);
         PenguinFindMM.getInstance().animal.visible = false;
         PenguinFindMM.getInstance().removeMapEvent();
         GV.onlineSocket.addEventListener("giveEgg",this.onGiveEgg);
         this.mainMc.penguinMM.gotoAndStop(2);
      }
      
      private function onGiveEgg(evt:Event) : void
      {
         GV.onlineSocket.removeEventListener("giveEgg",this.onGiveEgg);
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.onPenguinMMHandler);
      }
      
      private function checkEgg() : void
      {
         BC.addEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.itemSucHandler);
         checkItem.checkItemHandler(190580);
      }
      
      private function itemSucHandler(evt:EventTaomee) : void
      {
         if(evt.EventObj.num > 0)
         {
            BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.onPenguinMMHandler);
            this.mainMc.penguinMM.gotoAndStop(4);
         }
         else
         {
            Alert.smileAlart("    你身上還沒有企鵝蛋哦，快去企鵝爸爸身邊看看有沒有蛋啦？");
         }
      }
      
      private function doActionHandler(evt:Event) : void
      {
         this.joinObj.removeEventListener("CLICK" + 1,this.doActionHandler);
         this.joinObj.removeEventListener("CLICK" + 2,this.doActionHandler);
         if(evt.type == "CLICK2")
         {
            BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.onPenguinMMHandler);
         }
         else
         {
            GV.onlineSocket.addEventListener("iskaddish",this.kaddishEndHandler);
            this.eggTimer = new Timer(30000,1);
            this.eggTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onEggTimerComplete);
            this.eggTimer.start();
            this.mainMc.penguinMM.gotoAndStop(5);
         }
      }
      
      private function onEggTimerComplete(evt:TimerEvent) : void
      {
         this.eggTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onEggTimerComplete);
         GV.onlineSocket.removeEventListener("iskaddish",this.kaddishEndHandler);
         if(this.eggTimer != null)
         {
            this.eggTimer.reset();
            this.eggTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onEggTimerComplete);
            this.eggTimer = null;
         }
         GV.onlineSocket.addEventListener("read_" + 1388,this.onRead1388Egg);
         PenguinFindSocket.setPenguinData(0,1);
      }
      
      private function onRead1388Egg(evt:EventTaomee) : void
      {
         var count:int = int(evt.EventObj.penguinId);
         if(count == 0)
         {
            BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.onPenguinMMHandler);
            this.mainMc.penguinMM.gotoAndStop(4);
            Alert.smileAlart("    企鵝爸爸已經為你的企鵝蛋孵化過啦，明天再來吧！");
         }
         else
         {
            BC.removeEvent(this,GV.onlineSocket,"fireAction_select",this.onPenguinMMHandler);
            GV.onlineSocket.addEventListener("giveEgg",this.onGiveEgg);
            this.mainMc.penguinMM.gotoAndStop(6);
            Alert.smileAlart("    企鵝寶寶出世了，已經放入你的牧場倉庫啦，記得帶企鵝去神秘湖捕新鮮的磷蝦哦！");
         }
      }
      
      private function onRead1387Egg(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 1387,this.onRead1387Egg);
         var count:int = int(evt.EventObj.penguinCount);
         if(count == 3)
         {
            BC.removeEvent(this,GV.onlineSocket,"fireAction_select",this.onPenguinMMHandler);
            GV.onlineSocket.addEventListener("giveEgg",this.onGiveEgg);
            this.mainMc.penguinMM.gotoAndStop(6);
            Alert.smileAlart("    企鵝寶寶出世了，已經放入你的牧場倉庫啦，記得帶企鵝去神秘湖捕新鮮的磷蝦哦！");
         }
         else
         {
            BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.onPenguinMMHandler);
            this.mainMc.penguinMM.gotoAndStop(4);
            Alert.smileAlart("    企鵝爸爸已經為你的企鵝蛋孵化過啦，明天再來吧！");
         }
      }
      
      private function kaddishEndHandler(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("iskaddish",this.kaddishEndHandler);
         if(this.eggTimer != null)
         {
            this.eggTimer.reset();
            this.eggTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onEggTimerComplete);
            this.eggTimer = null;
         }
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.onPenguinMMHandler);
         this.mainMc.penguinMM.gotoAndStop(4);
         Alert.smileAlart("    孵蛋需要30秒鐘，請你不要走動哦！");
      }
      
      private function removeEventHandler(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 1387,this.onRead1387Main);
         GV.onlineSocket.removeEventListener("read_" + 1387,this.onRead1387Egg);
         GV.onlineSocket.removeEventListener("read_" + 1388,this.onRead1388);
         GV.onlineSocket.removeEventListener("read_" + 1388,this.onRead1388Egg);
         GV.onlineSocket.removeEventListener("giveEgg",this.onGiveEgg);
         GV.onlineSocket.removeEventListener("iskaddish",this.kaddishEndHandler);
         if(this.eggTimer != null)
         {
            this.eggTimer.reset();
            this.eggTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onEggTimerComplete);
            this.eggTimer = null;
         }
         if(this.joinObj != null)
         {
            this.joinObj.removeEventListener("CLICK" + 1,this.doActionHandler);
            this.joinObj.removeEventListener("CLICK" + 2,this.doActionHandler);
         }
         BC.removeEvent(this);
      }
   }
}

