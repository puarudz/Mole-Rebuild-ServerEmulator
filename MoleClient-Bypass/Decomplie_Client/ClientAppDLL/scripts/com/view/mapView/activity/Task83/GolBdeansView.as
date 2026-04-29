package com.view.mapView.activity.Task83
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.MoleShop.MoleShopSelect;
   import com.module.activityModule.superPetLogin;
   import com.module.coin.CoinBuyModle;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class GolBdeansView
   {
      
      private static var instance:GolBdeansView;
      
      private var payMC:MovieClip;
      
      private var count:int;
      
      private var childMC:*;
      
      private var mainMC:MovieClip;
      
      public function GolBdeansView()
      {
         super();
      }
      
      public static function getInstance() : GolBdeansView
      {
         if(!instance)
         {
            instance = new GolBdeansView();
         }
         return instance;
      }
      
      public function init() : void
      {
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         this.count = 0;
         BC.addEvent(this,GV.onlineSocket,"read_" + 2032,this.bakeCoinApply);
         MoleShopSelect.selectDou();
      }
      
      private function loadCallBoardHandler(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         this.childMC = evt.getLoader();
         mainMC.addChild(this.childMC);
         this.payMC = MovieClip(this.childMC.content.root.payMC);
         this.initEvent();
      }
      
      private function bakeCoinApply(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 2032,this.bakeCoinApply);
         this.count = evt.EventObj.count;
         this.mainMC = new MovieClip();
         this.mainMC.name = "mainMC";
         MainManager.getGameLevel().addChild(this.mainMC);
         var url:String = "resource/task/payMC.swf";
         var tempMC:MCLoader = new MCLoader(url,this.mainMC,1,"正在打開面板......");
         tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadCallBoardHandler);
         tempMC.doLoad();
      }
      
      private function initEvent() : void
      {
         this.texEvent();
         BC.addEvent(this,this.payMC.yes_btn,MouseEvent.CLICK,this.yesBtnHandler);
         BC.addEvent(this,this.payMC.close_btn,MouseEvent.CLICK,this.closeEvent);
         BC.addEvent(this,this.payMC.num_mc,Event.CHANGE,this.onTextChange);
         BC.addEvent(this,this.payMC.supBtn,MouseEvent.CLICK,this.supBtnHandler);
         BC.addEvent(this,this.payMC.no_btn,MouseEvent.CLICK,this.closeEvent);
      }
      
      private function supBtnHandler(evt:MouseEvent) : void
      {
         this.closeEvent();
         superPetLogin.gotoPay();
      }
      
      private function closeEvent(evt:MouseEvent = null) : void
      {
         this.removeEventHandler();
         GC.clearAll(this.mainMC);
         this.mainMC = null;
      }
      
      private function onTextChange(evt:Event) : void
      {
         this.texEvent();
      }
      
      private function texEvent() : void
      {
         if(LocalUserInfo.isVIP())
         {
            this.payMC.txt.htmlText = "    你確定花費<font color=\'#ff0000\'>" + this.payMC.num_mc.value / 1 + "</font>米幣兌換<font color=\'#ff0000\'>" + 2 * this.payMC.num_mc.value + "</font>個摩爾金豆嗎？";
            this.payMC.supBtn.visible = false;
         }
         else
         {
            this.payMC.no_btn.visible = false;
            this.payMC.txt.htmlText = "    你確定花費<font color=\'#ff0000\'>" + this.payMC.num_mc.value / 1 + "</font>米幣兌換<font color=\'#ff0000\'>" + this.payMC.num_mc.value + "</font>個摩爾金豆嗎？\n      超級拉姆兌換金豆5折優惠喲！";
         }
      }
      
      private function yesBtnHandler(evt:MouseEvent) : void
      {
         var CoinBuyModles:CoinBuyModle = new CoinBuyModle();
         if(LocalUserInfo.isVIP())
         {
            CoinBuyModles.BuyModle(199900,2 * this.payMC.num_mc.value,"個");
         }
         else
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + 2033,this.buyGoldBeanBack);
            CoinBuyModles.BuyModle(199900,this.payMC.num_mc.value,"個");
         }
      }
      
      private function buyGoldBeanBack(evt:EventTaomee) : void
      {
         Alert.smileAlart("兌換成功！快去摩爾商城看看吧！");
         this.closeEvent();
      }
      
      private function removeEventHandler(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this);
         this.payMC = null;
      }
   }
}

