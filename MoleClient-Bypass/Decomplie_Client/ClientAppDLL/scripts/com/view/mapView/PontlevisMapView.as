package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.logic.socket.giveMeMoney.giveMeMoneyReq;
   import com.logic.socket.giveMeMoney.giveMeMoneyRes;
   import com.module.AngelsAndDemons.AngelsAndDemonsCtl;
   import com.module.helpPanel.HelpPanel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   
   public class PontlevisMapView extends BasicMapView
   {
      
      public var mask_mc:MovieClip;
      
      private var myTimer:Timer;
      
      public function PontlevisMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.mask_mc = GV.MC_mapFrame["mask_mc"];
         botton_mc.Cloud_btn.buttonMode = true;
         BC.addEvent(this,botton_mc.Cloud_btn,MouseEvent.CLICK,this.cloudBtnClickHandler);
         BC.addEvent(this,target_mc.yun_btn,MouseEvent.CLICK,this.yunBtnHandler);
         BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.getGameNum);
         finishSomethingReq.sendReq(31814);
      }
      
      private function getGameNum(e:EventTaomee) : void
      {
         if(e.EventObj.Type == 31814)
         {
            BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.getGameNum);
            if(e.EventObj.Done >= 10)
            {
               controlLevel.item_1230015.visible = false;
            }
            else
            {
               controlLevel.item_1230015.visible = true;
               controlLevel.item_1230015.buttonMode = true;
               BC.addEvent(this,controlLevel.item_1230015,MouseEvent.CLICK,this.expItemFun);
            }
         }
      }
      
      private function expItemFun(e:MouseEvent) : void
      {
         controlLevel.item_1230015.visible = false;
         BC.addEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.getTodayItems);
         exchange.exchange_goods(3607);
      }
      
      private function getTodayItems(e:EventTaomee) : void
      {
         var i:int = 0;
         var obj:Object = null;
         BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.getTodayItems);
         var _msg:String = "恭喜你獲得";
         if(e.EventObj.Count > 0)
         {
            for(i = 0; i < e.EventObj.Count; i++)
            {
               obj = e.EventObj.arr[i];
               if(obj.itemID == 0)
               {
                  _msg += obj.count + "摩爾豆、";
                  LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + obj.count);
               }
               else
               {
                  _msg += GoodsInfo.getItemNameByID(obj.itemID) + "x" + obj.count + "、";
               }
            }
            Alert.smileAlart(_msg.substr(0,_msg.length - 1) + "。");
         }
      }
      
      private function onEnterAngel201(e:MouseEvent) : void
      {
         AngelsAndDemonsCtl.instance.LoadBeginPanelFun(AngelsAndDemonsCtl.begin_url,202);
      }
      
      private function cloudBtnClickHandler(event:MouseEvent) : void
      {
         this.myTimer = new Timer(700);
         if(GV.MAN_PEOPLE.Petlevel == 0 || GV.MAN_PEOPLE.Petlevel != 101)
         {
            botton_mc.Cloud_btn.gotoAndStop(2);
         }
         else if(GV.MAN_PEOPLE.Petlevel == 101)
         {
            botton_mc.Cloud_btn.visible = false;
            this.mask_mc.Cloud_mc.visible = true;
            this.myTimer.addEventListener(TimerEvent.TIMER,this.CloudSportsEvent);
            this.myTimer.start();
         }
      }
      
      private function CloudSportsEvent(event:TimerEvent) : void
      {
         this.mask_mc.Cloud_mc.addEventListener(MouseEvent.CLICK,this.cloudClickHandler);
         this.mask_mc.Cloud_mc.x = uint(Math.floor(Math.random() * 700) + 50);
         this.mask_mc.Cloud_mc.y = uint(Math.floor(Math.random() * 300) + 150);
      }
      
      private function cloudClickHandler(event:MouseEvent) : void
      {
         this.mask_mc.CloudMc_.startDrag(true);
         this.mask_mc.CloudMc_.visible = true;
         this.mask_mc.Cloud_mc.nextFrame();
         this.mask_mc.CloudMc_.nextFrame();
         this.mask_mc.Cloud_mc.removeEventListener(MouseEvent.CLICK,this.cloudClickHandler);
         this.myTimer.stop();
         var timerDelay:Timer = new Timer(1000,1);
         timerDelay.addEventListener(TimerEvent.TIMER_COMPLETE,this.ComHandler);
         timerDelay.start();
      }
      
      private function ComHandler(event:TimerEvent) : void
      {
         this.mask_mc.CloudMc_.visible = false;
         if(this.mask_mc.Cloud_mc.currentFrame == 5)
         {
            GV.onlineSocket.addEventListener("OVEN_CLOUD",this.ovenCloudHandler);
            this.myTimer.stop();
            return;
         }
         this.myTimer.start();
      }
      
      private function ovenCloudHandler(event:Event) : void
      {
         setTimeout(this.CloudEvent,200);
      }
      
      private function CloudEvent() : void
      {
         this.mask_mc.CloudMc_.visible = false;
         this.mask_mc.Cloud_mc.visible = false;
         this.mask_mc.Cloud_mc.x = 1300;
         this.buyBarbette();
         GV.onlineSocket.removeEventListener("OVEN_CLOUD",this.ovenCloudHandler);
      }
      
      private function buyBarbette() : void
      {
         var throwArr:Array = [];
         var getArr:Array = [{
            "kind":13246,
            "num":1
         }];
         GV.onlineSocket.addEventListener(giveMeMoneyRes.SERVER_GIVEMONEY,this.onBarbette);
         var giveCS:giveMeMoneyReq = new giveMeMoneyReq(throwArr,getArr);
      }
      
      private function onBarbette(event:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(giveMeMoneyRes.SERVER_GIVEMONEY,this.onBarbette);
         var msg:String = "    恭喜你！紫風靈雲已經放入你的百寶箱中了！";
         var url:String = "resource/cloth/icon/13246.swf";
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"iknow",true,false,"EMP_BUY");
      }
      
      private function yunBtnHandler(event:MouseEvent) : void
      {
         HelpPanel.getInstance().panelVisible("YUN_MC");
      }
      
      override public function destroy() : void
      {
         if(this.myTimer != null)
         {
            this.myTimer.stop();
            this.myTimer.removeEventListener(TimerEvent.TIMER,this.CloudSportsEvent);
            this.myTimer = null;
         }
         super.destroy();
      }
   }
}

