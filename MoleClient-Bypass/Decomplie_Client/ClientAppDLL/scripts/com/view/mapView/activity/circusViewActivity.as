package com.view.mapView.activity
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.module.RunMushLoad.RunMushLoader;
   import com.module.activityModule.PolicDutyModule;
   import com.module.deal.Deal;
   import com.module.superPetModule.petItemModule;
   import com.mole.app.map.MapBase;
   import com.mole.app.map.MapManager;
   import com.view.mapView.activity.Task83.StatisticsClass;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class circusViewActivity extends MapBase
   {
      
      public function circusViewActivity()
      {
         super();
      }
      
      override protected function initView() : void
      {
         controlLevel.allitem.item190017.policeMC.gotoAndStop(1);
         controlLevel.allitem.item190017.policeMC.visible = false;
         GV.onlineSocket.addEventListener("POLICE_DUTY_EVENT",this.policeEvent);
         BC.addEvent(this,controlLevel.btn3,MouseEvent.MOUSE_OVER,this.btnOver);
         BC.addEvent(this,controlLevel.btn3,MouseEvent.MOUSE_OUT,this.btnOut);
         controlLevel.allitem.item190017.police_btn.addEventListener(MouseEvent.CLICK,this.finishPoliceJob);
         petItemModule.itemVisibleHandler(controlLevel);
         BC.addEvent(this,GV.onlineSocket,"take_sugar",this.getGift);
         RunMushLoader.showmogu(controlLevel["mogu"]);
         tip.tipTailDisPlayObject(controlLevel.btn_giftGame,"拉姆包禮物");
      }
      
      private function onGotoMap60(event:MouseEvent) : void
      {
         StatisticsClass.getInstance().init(67748757);
         MapManager.enterMap(60);
      }
      
      private function getGift(evt:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"take_gift",this.getGift);
         Deal.BuyItem(190506,1,this.successFun);
      }
      
      private function successFun(itemID:uint) : void
      {
         var name:String = GoodsInfo.getItemNameByID(itemID);
         var msg:String = "    恭喜你獲得一個" + name + "，快去粒粒小廣場裝飾聖誕樹吧！";
         var url:String = "resource/allJob/icon/" + itemID + ".swf";
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
      }
      
      private function policeEvent(evt:EventTaomee) : void
      {
         PolicDutyModule.getInstance().init(controlLevel);
      }
      
      public function finishPoliceJob(event:MouseEvent) : void
      {
         controlLevel.allitem.item190017.police_btn.visible = false;
         controlLevel.allitem.item190017.policeMC.gotoAndPlay(2);
         controlLevel.allitem.item190017.policeMC.visible = true;
         GV.onlineSocket.addEventListener("police_over_num_one",this.makeTimerFun);
      }
      
      private function makeTimerFun(E:*) : void
      {
         GV.onlineSocket.removeEventListener("police_over_num_one",this.makeTimerFun);
         var myBoolean:Boolean = false;
         var num:uint = 10;
         var okstr:String = "    太幸運了！挖到了沙之微粒已經放入你的百寶箱中。";
         var nostr:String = "    看來你運氣不太好，只挖到了一些沒用沙子。";
         var JobGoodsID:uint = 190017;
         controlLevel.allitem.item190017.policeMC.gotoAndStop(1);
         controlLevel.allitem.item190017.policeMC.visible = false;
         myBoolean = Boolean(GV.JobViews.finishRandomJob(num,okstr,nostr,JobGoodsID));
         if(!myBoolean)
         {
            controlLevel.allitem.item190017.police_btn.visible = true;
         }
      }
      
      private function houseOverHandler(evt:MouseEvent) : void
      {
         controlLevel.house_mc.gotoAndStop(2);
      }
      
      private function houseOutHandler(evt:MouseEvent) : void
      {
         controlLevel.house_mc.gotoAndStop(1);
      }
      
      private function musicBox(evt:MouseEvent) : void
      {
         if(evt.currentTarget.mc_1.currentFrame != 1)
         {
            evt.currentTarget.mc_1.gotoAndStop(1);
            evt.currentTarget.mc_2.gotoAndStop(1);
         }
         else
         {
            evt.currentTarget.mc_1.play();
            evt.currentTarget.mc_2.play();
         }
      }
      
      private function btnOver(evt:MouseEvent) : void
      {
         controlLevel.horse_car.gotoAndStop(2);
      }
      
      private function btnOut(evt:MouseEvent) : void
      {
         controlLevel.horse_car.gotoAndStop(1);
      }
      
      private function buffoonClickHandler(evt:MouseEvent) : void
      {
         evt.target.mc_2.alpha = 1;
         evt.target.mc_2.gotoAndPlay(2);
         evt.target.mc_1.alpha = 0;
      }
      
      private function buffoonOverHandler(evt:MouseEvent) : void
      {
         evt.target.mc_2.alpha = 0;
         evt.target.mc_1.alpha = 1;
         evt.target.mc_1.gotoAndPlay(2);
      }
      
      private function buffoonOutHandler(evt:MouseEvent) : void
      {
         evt.target.mc_2.alpha = 0;
         evt.target.mc_1.alpha = 1;
         evt.target.mc_1.gotoAndStop(1);
      }
      
      override public function destroy() : void
      {
         GV.onlineSocket.removeEventListener("POLICE_DUTY_EVENT",this.policeEvent);
         controlLevel.allitem.item190017.police_btn.removeEventListener(MouseEvent.CLICK,this.finishPoliceJob);
         super.destroy();
      }
   }
}

