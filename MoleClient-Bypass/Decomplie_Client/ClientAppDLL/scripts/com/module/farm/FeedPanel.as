package com.module.farm
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.newloader.LoaderList;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.logic.socket.farm.farmSocket;
   import com.module.activityModule.checkItem;
   import com.mole.app.task.TaskManager;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import org.taomee.utils.DisplayUtil;
   
   public class FeedPanel extends FieldPanel
   {
      
      public static var instance:FeedPanel;
      
      public var buyTip:*;
      
      public var buyNum:int;
      
      public var TotalNum:int;
      
      public var BuyID:int;
      
      public var BuyMC:Object;
      
      public function FeedPanel()
      {
         super();
         URL = "resource/allJob/iconBtn/";
         classLink = "feed_UI";
      }
      
      public static function getInstance() : FeedPanel
      {
         if(instance == null)
         {
            instance = new FeedPanel();
         }
         return instance;
      }
      
      override public function userPorp(e:MouseEvent) : void
      {
         this.BuyID = e.target.parent.ID;
         this.BuyMC = e.target.parent;
         this.getThisGoodsNum(this.BuyID);
      }
      
      public function getThisGoodsNum(id:int) : void
      {
         BC.addEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.tipsHandler);
         checkItem.checkItemHandler(id);
      }
      
      public function tipsHandler(e:EventTaomee) : void
      {
         var tempLoad:Loader = null;
         var classmc:Class = null;
         BC.removeEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.tipsHandler);
         this.buyNum = 1;
         this.TotalNum = e.EventObj.num;
         if(this.TotalNum >= 1)
         {
            tempLoad = new Loader();
            tempLoad.load(VL.getURLRequest(URL + this.BuyMC.ID + ".swf"));
            classmc = GV.Lib_Map.getClass("tip_mc");
            this.buyTip = new classmc();
            MainManager.getGameLevel().addChild(this.buyTip);
            this.buyTip.number_txt.text = 1;
            this.buyTip.x = (this.buyTip.stage.stageWidth - this.buyTip.width) / 2;
            this.buyTip.y = (this.buyTip.stage.stageHeight - this.buyTip.height) / 2;
            this.buyTip.mc_load.addChild(tempLoad);
            this.buyTip.bg.visible = true;
            this.buyTip.numTxt.visible = true;
            this.buyTip.number_txt.visible = true;
            this.buyTip.minus_btn.visible = true;
            this.buyTip.add_btn.visible = true;
            this.buyTip.mc_load.scaleX = 1;
            this.buyTip.mc_load.scaleY = 1;
            this.buyTip.mc_load.x = 61;
            this.buyTip.mc_load.y = 41.2;
            this.buyTip.add_btn.addEventListener(MouseEvent.CLICK,this.addAction);
            this.buyTip.minus_btn.addEventListener(MouseEvent.CLICK,this.minusAction);
            this.buyTip.number_txt.addEventListener(Event.CHANGE,this.txtChangeHandler);
            this.buyTip.enter_btn.addEventListener(MouseEvent.CLICK,this.buyClickHandler);
            this.buyTip.cancel_btn.addEventListener(MouseEvent.CLICK,this.buyCancelHandler);
         }
         else
         {
            Alert.showAlert(MainManager.getAppLevel(),"","你的百寶箱裡沒有這種飼料哦！",Alert.IKNOW_ALERT);
         }
      }
      
      public function buyClickHandler(e:MouseEvent) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 1364,this.addFeedSucc);
         if(this.BuyID == 190028 && TaskManager.getTaskState(411) == 1)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("add_feed_190028"));
         }
         farmSocket.add_feed(this.BuyID,this.buyNum);
      }
      
      public function addFeedSucc(e:Event = null) : void
      {
         this.buyCancelHandler();
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1364,this.addFeedSucc);
         farmSocket.animal_info_fish(1);
         this.updatePanel();
         FieldView.getInstance().FishingMC.feedMC.gotoAndStop(2);
         GV.onlineSocket.dispatchEvent(new EventTaomee("add_food_success",{"target":FieldView.getInstance().FishingMC.foodPos}));
      }
      
      public function updatePanel() : void
      {
         this.BuyMC.num_txt.text = Number(this.BuyMC.num_txt.text) + this.buyNum;
         this.BuyMC.filters = [];
      }
      
      public function buyCancelHandler(e:MouseEvent = null) : void
      {
         if(Boolean(this.buyTip))
         {
            this.buyTip.add_btn.removeEventListener(MouseEvent.CLICK,this.addAction);
            this.buyTip.minus_btn.removeEventListener(MouseEvent.CLICK,this.minusAction);
            this.buyTip.number_txt.removeEventListener(Event.CHANGE,this.txtChangeHandler);
            this.buyTip.enter_btn.removeEventListener(MouseEvent.CLICK,this.buyClickHandler);
            this.buyTip.cancel_btn.removeEventListener(MouseEvent.CLICK,this.buyCancelHandler);
            DisplayUtil.removeFromParent(this.buyTip);
            this.buyTip = null;
         }
      }
      
      public function addAction(e:MouseEvent) : void
      {
         if(this.buyNum < this.TotalNum)
         {
            ++this.buyNum;
            this.buyTip.number_txt.text = this.buyNum;
         }
      }
      
      public function minusAction(e:MouseEvent) : void
      {
         if(this.buyNum > 1)
         {
            --this.buyNum;
            this.buyTip.number_txt.text = this.buyNum;
         }
      }
      
      public function txtChangeHandler(e:Event) : void
      {
         var a:Number = Number(this.buyTip.number_txt.text);
         if(isNaN(a) || a <= 1)
         {
            this.buyTip.number_txt.text = this.buyNum;
         }
         else if(a < this.TotalNum)
         {
            this.buyNum = a;
         }
         else
         {
            this.buyNum = this.TotalNum;
            this.buyTip.number_txt.text = this.TotalNum;
         }
      }
      
      public function catchANM(e:Event) : void
      {
      }
      
      override public function onBtnOver(e:MouseEvent) : void
      {
         var loadingmc:DisplayObject = e.target.parent.loadimg.getChildAt(0);
         loadingmc.filters = [new GlowFilter(16776960,1,6,6,600)];
         var goods:Object = e.currentTarget.parent;
         goods.parent.tip_info_mc.name_txt.htmlText = goods.Name;
         goods.parent.tip_info_mc.msg_txt.htmlText = Boolean(XMLInfo.FoodSourcesInfo[goods.ID]) ? XMLInfo.FoodSourcesInfo[goods.ID] : "";
         goods.parent.tip_info_mc.x = goods.x;
         goods.parent.tip_info_mc.y = goods.y;
         GC.clearAllChildren(goods.parent.tip_info_mc.eggIcon_mc);
         var ticon:Loader = new Loader();
         ticon.scaleX = 0.6;
         ticon.scaleY = 0.6;
         var url:String = "resource/allJob/icon/" + goods.ID + ".swf";
         LoaderList.getInstance().addItem(ticon,VL.getURLRequest(url),LoaderList.HIGH,true);
         goods.parent.tip_info_mc.eggIcon_mc.addChild(ticon);
         ticon.x = -5;
         ticon.y = -5;
      }
      
      override public function onBtnOut(e:MouseEvent) : void
      {
         var loadingmc:DisplayObject = e.target.parent.loadimg.getChildAt(0);
         loadingmc.filters = [];
         var goods:Object = e.currentTarget.parent;
         goods.parent.tip_info_mc.x = 2000;
      }
      
      override public function ClosePanel(e:MouseEvent) : void
      {
         super.ClosePanel(e);
      }
   }
}

