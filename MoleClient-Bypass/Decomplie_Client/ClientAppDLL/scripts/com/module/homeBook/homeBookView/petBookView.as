package com.module.homeBook.homeBookView
{
   import com.logic.socket.shopItem.BuyItemReq;
   import com.module.clothBuyModule.clothBuyModule;
   import com.module.house.petXML;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.setTimeout;
   
   public class petBookView extends MovieClip
   {
      
      private static var allPage:int = 10;
      
      public var buyItem:BuyItemReq;
      
      public var tempLoader:Loader;
      
      public var tempMC:MovieClip;
      
      public var targetMC:MovieClip;
      
      public var buyNum:*;
      
      public var nowFrame:uint;
      
      public var buyMach:int;
      
      public function petBookView(obj:*)
      {
         super();
         this.targetMC = obj.main_mc;
         allPage = this.targetMC.totalFrames;
         petXML.loadPetXML();
         petXML.addEventListener("dispatchPetXMLLoaded",this.petXMLLoaded);
         this.tempMC = new MovieClip();
         this.tempLoader = new Loader();
         this.buyItem = new BuyItemReq();
         this.targetMC.mc_1.visible = false;
         this.targetMC.mc_no.visible = false;
         this.targetMC.mc_3.visible = false;
         this.nowFrame = 1;
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeEvent);
      }
      
      private function petXMLLoaded(e:*) : void
      {
         this.bookViewInit();
      }
      
      private function bookViewInit() : void
      {
         this.nowFrame = 1;
         this.lastPage();
      }
      
      public function lastPage() : void
      {
         this.targetMC.pre_btn.addEventListener(MouseEvent.CLICK,this.preHandler);
         this.targetMC.next_btn.addEventListener(MouseEvent.CLICK,this.nextHandler);
         this.targetMC.close_btn.addEventListener(MouseEvent.CLICK,this.removeMC);
      }
      
      public function fristPage() : void
      {
         this.targetMC.close_btn.addEventListener(MouseEvent.CLICK,this.removeMC);
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
               try
               {
                  pageOneInit();
               }
               catch(E:Error)
               {
                  trace(E);
               }
            },500);
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
            },500);
         }
      }
      
      public function preHandler(evt:MouseEvent) : void
      {
         this.removeBtnEvent();
         this.targetMC.pre_btn.removeEventListener(MouseEvent.CLICK,this.preHandler);
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
            },1000);
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
            },1000,this);
         }
      }
      
      public function pageOneInit() : void
      {
         var j:int = 0;
         var btn:Object = null;
         this.lastPage();
         try
         {
            for(j = 0; j < this.targetMC.btnmc.numChildren; j++)
            {
               btn = this.targetMC.btnmc.getChildAt(j);
               btn.obj = petXML.getGoodsObj(btn.id);
               btn.money_txt.text = btn.obj.Price;
               btn.addEventListener(MouseEvent.CLICK,this.buyAction);
            }
         }
         catch(e:*)
         {
            trace("error:::::");
         }
      }
      
      public function buyAction(evt:MouseEvent) : void
      {
         var goodsObj:Object = evt.currentTarget.obj;
         var itemObj:Object = new Object();
         itemObj.id = goodsObj.ID;
         itemObj.price = goodsObj.Price;
         itemObj.info = goodsObj.Name;
         if(goodsObj.Type == 2)
         {
            clothBuyModule.buyAction(itemObj,true);
         }
         else
         {
            clothBuyModule.buyAction(itemObj,false);
         }
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
      
      public function removeMC(evt:MouseEvent) : void
      {
         this.targetMC.pre_btn.removeEventListener(MouseEvent.CLICK,this.preHandler);
         this.targetMC.next_btn.removeEventListener(MouseEvent.CLICK,this.nextHandler);
         this.targetMC.close_btn.removeEventListener(MouseEvent.CLICK,this.removeMC);
         this.tempLoader.unload();
         this.targetMC.parent.parent.parent.parent.removeChild(this.targetMC.parent.parent.parent);
      }
      
      public function removeMC_3(evt:MouseEvent) : void
      {
         this.targetMC.mc_3.enter_btn.removeEventListener(MouseEvent.CLICK,this.removeMC_3);
         this.targetMC.mc_3.visible = false;
      }
      
      public function removeEvent(event:*) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEvent);
         var tempObj:MovieClip = this.targetMC.mc_3.parent;
         this.targetMC.mc_3.enter_btn.removeEventListener(MouseEvent.CLICK,this.removeMC_3);
         this.targetMC.mc_no.enter_btn.removeEventListener(MouseEvent.CLICK,this.visibleFalse);
         this.targetMC.mc_1.enter_btn.removeEventListener(MouseEvent.CLICK,this.pageOneHandler);
         this.targetMC.mc_1.cancel_btn.removeEventListener(MouseEvent.CLICK,this.visibleFalse);
         this.targetMC.pre_btn.removeEventListener(MouseEvent.CLICK,this.preHandler);
         this.targetMC.next_btn.removeEventListener(MouseEvent.CLICK,this.nextHandler);
         this.targetMC.close_btn.removeEventListener(MouseEvent.CLICK,this.removeMC);
         GC.stopAllMC(tempObj);
         GC.clearChildren(tempObj);
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

