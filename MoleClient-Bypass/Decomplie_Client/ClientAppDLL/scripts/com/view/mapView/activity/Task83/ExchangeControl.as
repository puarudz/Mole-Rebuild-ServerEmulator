package com.view.mapView.activity.Task83
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.ChristmasGiftSocket;
   import com.module.activityModule.superPetLogin;
   import com.module.deal.Deal;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.setTimeout;
   
   public class ExchangeControl
   {
      
      public static var instance:ExchangeControl;
      
      private var target_mc:MovieClip;
      
      private var gift_MC:MovieClip;
      
      private var childMC:*;
      
      private var panelMC:*;
      
      private var type:int = 0;
      
      private var flag:int = 0;
      
      private var max:int = 0;
      
      private var count:int = 0;
      
      private var itemId:int = 0;
      
      public function ExchangeControl()
      {
         super();
      }
      
      public static function getInstance() : ExchangeControl
      {
         if(instance == null)
         {
            instance = new ExchangeControl();
         }
         return instance;
      }
      
      public function addGameEvent(_type:int, _max:int, _flag:int) : void
      {
         this.type = _type;
         this.max = _max;
         this.flag = _flag;
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.closeClickHandler);
         BC.addEvent(this,GV.onlineSocket,"ExchangeGoods",this.onExchangeGoodsFun);
         BC.addEvent(this,GV.onlineSocket,"NoExchangeGoods",this.onCancelExchangeGoodsFun);
         BC.addEvent(this,GV.onlineSocket,"closeExchangePanel",this.onCloseExchangeGoodsFun);
         BC.addEvent(this,GV.onlineSocket,"gotoOpenSuper",this.onOpenSuperFun);
         this.onLoadPanel();
      }
      
      private function onOpenSuperFun(e:Event) : void
      {
         superPetLogin.gotoPay();
      }
      
      private function onLoadPanel() : void
      {
         this.gift_MC = new MovieClip();
         this.gift_MC.name = "gift_MC";
         MainManager.getAppLevel().addChild(this.gift_MC);
         var url:String = "resource/task/ExchangeIngot.swf";
         var tempMC:MCLoader = new MCLoader(url,this.gift_MC,1,"正在打開面板......");
         tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadCallBoardHandler);
         tempMC.doLoad();
      }
      
      private function loadCallBoardHandler(e:*) : void
      {
         var mainMC:DisplayObjectContainer = e.getParent();
         this.childMC = e.getLoader();
         mainMC.addChild(this.childMC);
         this.panelMC = MovieClip(this.childMC.content.root.panelMC);
         this.panelMC.gotoAndStop(this.flag);
         setTimeout(function():void
         {
            if(type != 0)
            {
               panelMC["num_mc"].max = max;
               panelMC["num_mc"].min = 1;
               panelMC["num_mc"].stepSize = 1;
               panelMC["num_mc"].value = 1;
            }
         },200);
      }
      
      private function clearHandler(e:*) : void
      {
         BC.removeEvent(this);
         GC.clearAll(this.gift_MC);
         this.gift_MC = null;
      }
      
      private function onExchangeGoodsFun(e:Event) : void
      {
         if(this.type == 1)
         {
            this.itemId = 190601;
            this.count = int(this.panelMC["num_mc"].t_txt.text);
            Alert.smileAlart("    你確認要花費" + this.count + "個金元寶兌換" + this.count * 2 + "個" + GoodsInfo.getItemNameByID(190602) + "嗎？",this.ExchangeYB,"sure,cancel");
         }
         else if(this.type == 2)
         {
            this.itemId = 190602;
            this.count = int(this.panelMC["num_mc"].t_txt.text);
            Deal.BuyItem(this.itemId,this.count,this.buyYBForDealSuccessFun,this.buyYBForDealFailureFun,true,2);
         }
      }
      
      private function ExchangeYB(e:*) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 1986,this.exSuccFun);
         ChristmasGiftSocket.exYuanBao(this.itemId,this.count);
      }
      
      private function onCancelExchangeGoodsFun(e:Event) : void
      {
         this.clearHandler(null);
      }
      
      private function onCloseExchangeGoodsFun(e:Event) : void
      {
         this.clearHandler(null);
      }
      
      private function exSuccFun(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1986,this.exSuccFun);
         this.clearHandler(null);
         Alert.getIconByID_Alart(190602,"    恭喜你，" + this.count * 2 + "個銀元寶已經放入你的背包");
      }
      
      private function buyYBForDealSuccessFun(... e) : void
      {
         this.clearHandler(null);
         Alert.getIconByID_Alart(190602,"    恭喜你，" + this.count + "個銀元寶已經放入你的背包");
      }
      
      private function buyYBForDealFailureFun(e:* = null) : void
      {
      }
      
      private function closeClickHandler(e:*) : void
      {
         var temp:DisplayObject = null;
         BC.removeEvent(this);
         if(Boolean(MainManager.getAppLevel().getChildByName("otherJobMC")))
         {
            temp = MainManager.getAppLevel().getChildByName("otherJobMC");
            MainManager.getAppLevel().removeChild(temp);
            temp = null;
         }
      }
   }
}

