package com.module.thansGiveDayTask
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.socket.shopItem.BuyItemReq;
   import com.logic.socket.shopItem.BuyItemRes;
   import com.module.activityModule.checkItem;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ThanksDayTask
   {
      
      public static var FOOD:String = "food";
      
      private var mainMC:MovieClip;
      
      private var prePositionX:Number = 0;
      
      private var prePositionY:Number = 0;
      
      private var staus:uint = 0;
      
      public function ThanksDayTask(mc:MovieClip)
      {
         super();
         this.mainMC = mc;
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         for(var i:uint = 0; i < 8; i++)
         {
            this.mainMC["mc" + i].buttonMode = true;
            this.mainMC["mc" + i].addEventListener(MouseEvent.MOUSE_DOWN,this.mianDownHandler);
            this.mainMC["mc" + i].addEventListener(MouseEvent.MOUSE_UP,this.mianUpHandler);
         }
      }
      
      private function mianDownHandler(event:MouseEvent) : void
      {
         var ham:Sprite = event.currentTarget as Sprite;
         this.prePositionX = ham.x;
         this.prePositionY = ham.y;
         GF.setDrag(ham);
      }
      
      private function mianUpHandler(event:MouseEvent) : void
      {
         var num:uint = Number(String(event.currentTarget.name).substr(2));
         var food:Sprite = event.currentTarget as Sprite;
         if(food.hitTestObject(this.mainMC.chickenMC))
         {
            ++this.staus;
            trace("staus------------",this.staus);
            this.mainMC["mc" + num].removeEventListener(MouseEvent.MOUSE_DOWN,this.mianDownHandler);
            this.mainMC["mc" + num].removeEventListener(MouseEvent.MOUSE_UP,this.mianUpHandler);
            if(num != 7)
            {
               this.mainMC.chickenMC["mc" + num].visible = true;
            }
            this.mainMC.chickenMC.gotoAndStop(this.staus);
            this.mainMC["mc" + num].buttonMode = false;
            this.mainMC["mc" + num].visible = false;
         }
         else
         {
            food.x = this.prePositionX;
            food.y = this.prePositionY;
            GF.stopDrag(food);
         }
         this.checkChicken(this.staus);
      }
      
      private function checkChicken(foodNum:uint) : void
      {
         if(foodNum == 8)
         {
            GV.onlineSocket.dispatchEvent(new Event(FOOD));
         }
      }
      
      private function checkItemHandler(evt:EventTaomee) : void
      {
         var buyItemReq:BuyItemReq = null;
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.checkItemHandler);
         var checkFood:Object = new Object();
         checkFood = evt.EventObj;
         if(checkFood.num == 0)
         {
            buyItemReq = new BuyItemReq();
            GV.onlineSocket.addEventListener(BuyItemRes.BUY_ITEM_SUCCESS,this.buyItemSucc);
            buyItemReq.buyItems(160141,1);
            buyItemReq = null;
         }
      }
      
      private function buyItemSucc(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(BuyItemRes.BUY_ITEM_SUCCESS,this.buyItemSucc);
         var url:String = "resource/allJob/icon/cook.swf";
         var msg:String = "    你做出一盤火雞大餐，已放入你的小屋倉庫中。別忘記聖誕節時拿出來招待聖誕老人哦！";
         var myalter:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"ok",true,false,"EMP_BUY");
         trace("myalter",myalter);
      }
   }
}

