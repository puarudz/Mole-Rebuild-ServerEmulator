package com.module.classroom
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.shopItem.BuyItemReq;
   import com.logic.socket.shopItem.BuyItemRes;
   import com.module.activityModule.checkCloth;
   import com.module.activityModule.superPetLogin;
   import com.module.clothBuyModule.clothBuyModule;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.setTimeout;
   
   public class classBookView extends MovieClip
   {
      
      private static var allPage:int = 10;
      
      public var buyItem:BuyItemReq;
      
      public var tempLoader:Loader;
      
      public var tempMC:MovieClip;
      
      public var targetMC:MovieClip;
      
      public var buyNum:*;
      
      public var nowFrame:int;
      
      public var buyMach:Number;
      
      public var halfPrice:uint;
      
      private var IsVIP:Boolean = false;
      
      private var IsHaveItm:Boolean = false;
      
      public function classBookView(obj:*)
      {
         super();
         this.halfPrice = 1;
         this.targetMC = obj.main_mc;
         allPage = this.targetMC.totalFrames;
         this.IsVIP = LocalUserInfo.isVIP();
         this.IsHaveItm = checkCloth.PeopleHaveItemSO(12202);
         setTimeout(function():void
         {
            try
            {
               bookViewInit();
            }
            catch(E:*)
            {
               trace(E);
            }
         },100);
         this.tempMC = new MovieClip();
         this.tempLoader = new Loader();
         this.buyItem = new BuyItemReq();
         this.targetMC.mc_1.visible = false;
         this.targetMC.mc_no.visible = false;
         this.targetMC.mc_3.visible = false;
         this.nowFrame = 1;
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeEvent);
      }
      
      private function bookViewInit() : void
      {
         this.nowFrame = 1;
         this.lastPage();
         if(this.halfPrice == 1)
         {
            this.targetMC.halfmc.visible = false;
         }
      }
      
      public function lastPage() : void
      {
         try
         {
            this.targetMC.pre_btn.addEventListener(MouseEvent.CLICK,this.preHandler);
         }
         catch(e:*)
         {
         }
         this.targetMC.next_btn.addEventListener(MouseEvent.CLICK,this.nextHandler);
         this.targetMC.close_btn.addEventListener(MouseEvent.CLICK,this.removeEvent);
      }
      
      public function fristPage() : void
      {
         this.targetMC.close_btn.addEventListener(MouseEvent.CLICK,this.removeEvent);
         this.targetMC.next_btn.addEventListener(MouseEvent.CLICK,this.nextHandler);
      }
      
      public function nextHandler(evt:MouseEvent) : void
      {
         this.removeBtnEvent();
         this.targetMC.next_btn.removeEventListener(MouseEvent.CLICK,this.nextHandler);
         ++this.nowFrame;
         if(this.nowFrame < allPage)
         {
            setTimeout(function():void
            {
               pageOneInit();
            },100);
            this.targetMC.gotoAndStop(this.nowFrame);
         }
         else if(this.nowFrame == allPage)
         {
            this.targetMC.gotoAndStop(this.nowFrame);
            setTimeout(function():void
            {
               try
               {
                  lastPage();
               }
               catch(E:Error)
               {
                  trace(E);
               }
            },100);
         }
      }
      
      public function preHandler(evt:MouseEvent) : void
      {
         this.removeBtnEvent();
         try
         {
            this.targetMC.pre_btn.removeEventListener(MouseEvent.CLICK,this.preHandler);
         }
         catch(e:*)
         {
         }
         --this.nowFrame;
         if(this.nowFrame > 1)
         {
            setTimeout(function():void
            {
               try
               {
                  pageOneInit();
               }
               catch(E:Error)
               {
                  trace(E);
               }
            },100);
            this.targetMC.gotoAndStop(this.nowFrame);
         }
         else if(this.nowFrame == 1)
         {
            this.targetMC.gotoAndStop(this.nowFrame);
            setTimeout(function():void
            {
               try
               {
                  bookViewInit();
               }
               catch(E:Error)
               {
                  trace(E);
               }
            },100);
         }
      }
      
      public function makePageMCInfo() : void
      {
         BC.addEvent(this,this.targetMC.pageMC.over_btn,MouseEvent.CLICK,this.overPageFun);
         BC.addEvent(this,this.targetMC.pageMC.getOne_btn,MouseEvent.CLICK,this.newInterFun);
      }
      
      public function overPageFun(event:MouseEvent) : void
      {
         BC.removeEvent(this,this.targetMC.pageMC.over_btn,MouseEvent.CLICK,this.overPageFun);
         BC.removeEvent(this,this.targetMC.pageMC.getOne_btn,MouseEvent.CLICK,this.newInterFun);
         this.nowFrame = 11;
         this.nextHandler(event);
      }
      
      public function newInterFun(event:MouseEvent) : void
      {
         superPetLogin.gotoPay();
      }
      
      public function pageOneInit() : void
      {
         var j:int = 0;
         var btn:Object = null;
         this.lastPage();
         if(Boolean(this.targetMC.btnmc))
         {
            for(j = 0; j < this.targetMC.btnmc.numChildren; j++)
            {
               btn = this.targetMC.btnmc.getChildAt(j);
               btn.obj = GoodsInfo.getInfoById(btn.id);
               btn.money_txt.text = btn.obj.price;
               btn.addEventListener(MouseEvent.CLICK,this.buyAction);
            }
         }
      }
      
      public function buyAction(evt:MouseEvent) : void
      {
         var goodsObj:Object = evt.currentTarget.obj;
         this.buyMach = goodsObj.price;
         this.buyNum = goodsObj.id;
         var itemObj:Object = new Object();
         itemObj.id = goodsObj.id;
         itemObj.price = 100;
         itemObj.info = "";
         clothBuyModule.buyAction(itemObj);
      }
      
      public function pageOneHandler(evt:MouseEvent) : void
      {
         evt.target.removeEventListener(MouseEvent.CLICK,this.pageOneHandler);
         this.targetMC.mc_1.visible = false;
         this.tempLoader.unload();
         this.tempMC.removeChild(this.tempLoader);
         var itemNum:int = 1;
         this.buyItem.buyItems(int(this.buyNum),itemNum);
      }
      
      public function visibleFalse(evt:MouseEvent) : void
      {
         evt.target.removeEventListener(MouseEvent.CLICK,this.visibleFalse);
         this.buyMach = 0;
         this.targetMC.mc_1.visible = false;
         this.targetMC.mc_no.visible = false;
      }
      
      public function onBuySuccess(evt:*) : void
      {
         this.targetMC.mc_3.visible = true;
         this.targetMC.mc_3.info.text = "購買成功！\r物品已放入你的倉庫中";
         this.targetMC.mc_3.enter_btn.addEventListener(MouseEvent.CLICK,this.removeMC_3);
         this.buyMach = 0;
         GV.onlineSocket.dispatchEvent(new EventTaomee("classdepotAddGoods",{"obj":{"ID":this.buyNum}}));
      }
      
      public function removeMC_3(evt:MouseEvent) : void
      {
         this.targetMC.mc_3.enter_btn.removeEventListener(MouseEvent.CLICK,this.removeMC_3);
         this.targetMC.mc_3.visible = false;
      }
      
      public function removeEvent(event:* = null) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEvent);
         var tempObj:* = this.targetMC.mc_3.parent;
         this.targetMC.mc_3.enter_btn.removeEventListener(MouseEvent.CLICK,this.removeMC_3);
         this.targetMC.mc_no.enter_btn.removeEventListener(MouseEvent.CLICK,this.visibleFalse);
         this.targetMC.mc_1.enter_btn.removeEventListener(MouseEvent.CLICK,this.pageOneHandler);
         this.targetMC.mc_1.cancel_btn.removeEventListener(MouseEvent.CLICK,this.visibleFalse);
         this.targetMC.pre_btn.removeEventListener(MouseEvent.CLICK,this.preHandler);
         this.targetMC.next_btn.removeEventListener(MouseEvent.CLICK,this.nextHandler);
         this.targetMC.close_btn.removeEventListener(MouseEvent.CLICK,this.removeEvent);
         GV.onlineSocket.removeEventListener(BuyItemRes.BUY_ITEM_SUCCESS,this.onBuySuccess);
         GC.stopAllMC(tempObj);
         GC.clearAllChildren(tempObj);
         tempObj.parent.removeChild(tempObj);
         tempObj = null;
         var p:DisplayObject = MainManager.getGameLevel().getChildByName("classbook");
         if(Boolean(p))
         {
            MainManager.getGameLevel().removeChild(p);
         }
      }
      
      public function removeBtnEvent() : void
      {
         var j:int = 0;
         var btn:DisplayObject = null;
         try
         {
            for(j = 0; j < this.targetMC.btnmc.numChildren; j++)
            {
               btn = this.targetMC.btnmc.getChildAt(j);
               btn.removeEventListener(MouseEvent.CLICK,this.buyAction);
            }
         }
         catch(e:*)
         {
         }
      }
   }
}

