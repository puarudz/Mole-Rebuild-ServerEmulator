package com.module.clothBuyModule
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.shopItem.BuyItemReq;
   import com.logic.socket.shopItem.BuyItemRes;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class effectBuyModule
   {
      
      private static var instance:effectBuyModule;
      
      private var effect_num:int;
      
      private var effect_id:int;
      
      private var effect_name:String;
      
      private var effect_Price:int;
      
      private var effectIDarr:Array = [17001,17002,17004,17003,17005,17006,17007];
      
      private var effectNamearr:Array = ["稻草人果實","勞動錘果實","泡泡果實","超級蘑菇","蘑菇果實","西瓜果實","石像果實"];
      
      private var effectPriceArr:Array = [200,200,200,200,200,200,200,200];
      
      private var effect_buy:MovieClip;
      
      private var success_mc:MovieClip;
      
      private var buyItemReq:BuyItemReq;
      
      public function effectBuyModule()
      {
         super();
      }
      
      public static function getInstance() : effectBuyModule
      {
         if(instance == null)
         {
            instance = new effectBuyModule();
         }
         return instance;
      }
      
      public function effectClick() : void
      {
         var efffect:Class = null;
         var j:int = 0;
         this.effect_num = 1;
         this.effect_name = "稻草人果實";
         this.effect_Price = 200;
         this.effect_id = 17001;
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeAllHandler);
         if(!MainManager.getAppLevel().getChildByName("effect_buy"))
         {
            efffect = GV.Lib_Map.getClass("effect_buy") as Class;
            this.effect_buy = new efffect();
            this.effect_buy.name = "effect_buy";
            MainManager.getAppLevel().addChild(this.effect_buy);
            this.effect_buy.x = (this.effect_buy.stage.stageWidth - this.effect_buy.width) / 2;
            this.effect_buy.y = (this.effect_buy.stage.stageHeight - this.effect_buy.height) / 2;
            this.effect_buy.change_mc.gotoAndStop("e_1");
            this.effect_buy.close_btn.addEventListener(MouseEvent.CLICK,this.effectClose);
            this.effect_buy.num.text = String(this.effect_num);
            this.effect_buy.info.text = this.effect_num + "個" + this.effect_name + "需花費" + this.effect_Price + "摩爾豆\n是否確認購買?";
            for(j = 1; j <= this.effectIDarr.length; j++)
            {
               this.effect_buy.select_mc["btn_" + j].buttonMode = true;
               this.effect_buy.select_mc["btn_" + j].addEventListener(MouseEvent.CLICK,this.ballClick);
            }
            this.effect_buy.add_btn.addEventListener(MouseEvent.CLICK,this.effectAdd);
            this.effect_buy.minus_btn.addEventListener(MouseEvent.CLICK,this.effectMinus);
            this.effect_buy.num.addEventListener(Event.CHANGE,this.effectNumChange);
            this.effect_buy.buy_btn.addEventListener(MouseEvent.CLICK,this.effectBuyAction);
         }
      }
      
      private function ballClick(evt:MouseEvent) : void
      {
         this.effect_num = 1;
         var tempName:String = evt.currentTarget.name;
         var str:String = tempName.substr(4);
         this.effect_name = this.effectNamearr[Number(str) - 1];
         this.effect_id = this.effectIDarr[Number(str) - 1];
         this.effect_Price = this.effectPriceArr[Number(str) - 1];
         this.effect_buy.change_mc.gotoAndStop("e_" + str);
         this.effect_buy.num.text = String(this.effect_num);
         this.effect_buy.info.text = this.effect_num + "個" + this.effect_name + "需花費" + this.effect_Price + "摩爾豆,是否確認購買?";
      }
      
      private function effectAdd(evt:MouseEvent) : void
      {
         if(this.effect_num * this.effect_Price < LocalUserInfo.getYXQ() && this.effect_num < 99)
         {
            this.effect_num += 1;
            this.effect_buy.num.text = String(this.effect_num);
            this.effect_buy.info.text = this.effect_num + "個" + this.effect_name + "需花費" + this.effect_Price * this.effect_num + "摩爾豆\n是否確認購買?";
         }
      }
      
      private function effectMinus(evt:MouseEvent) : void
      {
         if(this.effect_num > 1)
         {
            this.effect_num -= 1;
         }
         this.effect_buy.num.text = String(this.effect_num);
         this.effect_buy.info.text = this.effect_num + "個" + this.effect_name + "需花費" + this.effect_Price * this.effect_num + "摩爾豆\n是否確認購買?";
      }
      
      private function effectNumChange(evt:Event) : void
      {
         var a:Number = Number(this.effect_buy.num.text);
         if(isNaN(a) || a <= 0)
         {
            this.effect_buy.num.text = this.effect_num;
         }
         else
         {
            this.effect_num = a;
            this.effect_buy.info.text = this.effect_num + "個" + this.effect_name + "需花費" + this.effect_Price * this.effect_num + "摩爾豆\n是否確認購買?";
         }
      }
      
      private function effectBuyAction(evt:MouseEvent) : void
      {
         var tempAlert:* = undefined;
         if(this.effect_Price * this.effect_num <= LocalUserInfo.getYXQ())
         {
            GV.onlineSocket.addEventListener(BuyItemRes.BUY_ITEM_SUCCESS,this.onBuySuccess);
            if(this.buyItemReq == null)
            {
               this.buyItemReq = new BuyItemReq();
            }
            this.buyItemReq.buyItems(int(this.effect_id),this.effect_num);
            this.effectClose();
         }
         else
         {
            this.effectClose();
            tempAlert = Alert.showAlert(MainManager.getAppLevel(),"你的摩爾豆不夠囉......","",6,"D");
         }
      }
      
      private function onBuySuccess(evt:EventTaomee) : void
      {
         var sucMC:Class = null;
         if(!MainManager.getAppLevel().getChildByName("success_mc"))
         {
            sucMC = GV.Lib_Map.getClass("buy_Success") as Class;
            this.success_mc = new sucMC();
            this.success_mc.name = "success_mc";
            MainManager.getAppLevel().addChild(this.success_mc);
            this.success_mc.x = (this.success_mc.stage.stageWidth - this.success_mc.width) / 2;
            this.success_mc.y = (this.success_mc.stage.stageHeight - this.success_mc.height) / 2;
            if(this.effect_id >= 17001 && this.effect_id <= 17008)
            {
               this.success_mc.info.text = "購買成功！\r物品已放入你的投擲道具箱中";
            }
            this.success_mc.enter_btn.addEventListener(MouseEvent.CLICK,this.successClickHandler);
            GV.onlineSocket.removeEventListener(BuyItemRes.BUY_ITEM_SUCCESS,this.onBuySuccess);
         }
      }
      
      private function successClickHandler(evt:* = null) : void
      {
         this.success_mc.enter_btn.removeEventListener(MouseEvent.CLICK,this.successClickHandler);
         this.success_mc.parent.removeChild(this.success_mc);
         this.success_mc = null;
      }
      
      private function effectClose(evt:MouseEvent = null) : void
      {
         this.effect_buy.close_btn.removeEventListener(MouseEvent.CLICK,this.effectClose);
         this.effect_buy.select_mc.btn_1.removeEventListener(MouseEvent.CLICK,this.ballClick);
         this.effect_buy.add_btn.removeEventListener(MouseEvent.CLICK,this.effectAdd);
         this.effect_buy.minus_btn.removeEventListener(MouseEvent.CLICK,this.effectMinus);
         this.effect_buy.num.removeEventListener(Event.CHANGE,this.effectNumChange);
         this.effect_buy.buy_btn.removeEventListener(MouseEvent.CLICK,this.effectBuyAction);
         GC.stopAllMC(this.effect_buy);
         GC.clearChildren(this.effect_buy);
         this.effect_buy.parent.removeChild(this.effect_buy);
         this.effect_buy = null;
      }
      
      private function removeAllHandler(evt:EventTaomee) : void
      {
         if(this.effect_buy != null)
         {
            this.effectClose();
         }
         if(this.success_mc != null)
         {
            this.successClickHandler();
         }
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeAllHandler);
      }
   }
}

