package com.module.homeBook.homeBookView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.home.homeSocket;
   import com.logic.socket.shopItem.BuyItemReq;
   import com.module.activityModule.checkCloth;
   import com.module.activityModule.superPetLogin;
   import com.module.clothBuyModule.clothBuyModule;
   import com.module.deal.Deal;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.setTimeout;
   
   public class farmBookView extends MovieClip
   {
      
      private static var _instance:farmBookView;
      
      private static var allPage:int;
      
      public var buyItem:BuyItemReq;
      
      public var tempLoader:Loader;
      
      public var tempMC:MovieClip;
      
      public var targetMC:MovieClip;
      
      public var buyNum:uint;
      
      public var nowFrame:uint;
      
      public var buyMach:uint;
      
      public var halfPrice:uint;
      
      private var IsVIP:Boolean = false;
      
      private var IsHaveItm:Boolean = false;
      
      private var itemObj:Object;
      
      private var goodsObj:Object;
      
      private var startPage:uint = 20;
      
      private var endPage:uint = 33;
      
      public function farmBookView(obj:*)
      {
         super();
         _instance = this;
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
            }
         },100);
         this.tempMC = new MovieClip();
         this.tempLoader = new Loader();
         this.buyItem = new BuyItemReq();
         this.targetMC.mc_1.visible = false;
         this.targetMC.mc_no.visible = false;
         this.targetMC.mc_3.visible = false;
         this.nowFrame = 1;
         BC.addEvent(_instance,this.targetMC.pet_btn,MouseEvent.CLICK,this.gotoSuperPage);
         BC.addEvent(_instance,GV.onlineSocket,"farmbookView jump page",this.JumpFrame);
         BC.addEvent(_instance,GV.onlineSocket,"removeMapEvent",this.removeEvent);
         BC.addEvent(_instance,GV.onlineSocket,"GetAwards",this.onGetAwards);
      }
      
      public function gotoSuperPage(e:MouseEvent) : void
      {
         setTimeout(function():void
         {
            try
            {
               BC.addEvent(_instance,targetMC.pre_btn,MouseEvent.CLICK,preHandler);
            }
            catch(e:*)
            {
            }
         },100);
         this.targetMC.pet_btn.x = 220;
         this.targetMC.gotoAndStop("superpage");
         this.nowFrame = this.startPage;
         setTimeout(function():void
         {
            makePageMCInfo();
         },100);
      }
      
      private function bookViewInit() : void
      {
         this.targetMC.pet_btn.x = 220;
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
            BC.addEvent(_instance,this.targetMC.pre_btn,MouseEvent.CLICK,this.preHandler);
         }
         catch(e:*)
         {
         }
         try
         {
            BC.addEvent(_instance,this.targetMC.next_btn,MouseEvent.CLICK,this.nextHandler);
         }
         catch(e:*)
         {
         }
         try
         {
            BC.addEvent(_instance,this.targetMC.close_btn,MouseEvent.CLICK,this.removeEvent);
         }
         catch(e:*)
         {
         }
      }
      
      public function fristPage() : void
      {
         BC.addEvent(_instance,this.targetMC.close_btn,MouseEvent.CLICK,this.removeEvent);
         BC.addEvent(_instance,this.targetMC.next_btn,MouseEvent.CLICK,this.nextHandler);
      }
      
      private function JumpFrame(e:Event) : void
      {
         this.nowFrame = this.targetMC.currentFrame;
         setTimeout(function():void
         {
            try
            {
               pageOneInit();
            }
            catch(E:*)
            {
            }
         },100);
      }
      
      public function nextHandler(evt:MouseEvent) : void
      {
         this.removeBtnEvent();
         BC.removeEvent(_instance,this.targetMC.next_btn,MouseEvent.CLICK,this.nextHandler);
         ++this.nowFrame;
         if(this.nowFrame < allPage)
         {
            setTimeout(function():void
            {
               try
               {
                  pageOneInit();
               }
               catch(E:*)
               {
               }
            },100);
            this.targetMC.gotoAndStop(this.nowFrame);
         }
         else if(this.nowFrame >= allPage)
         {
            this.nowFrame = allPage;
            this.targetMC.gotoAndStop(allPage);
            setTimeout(function():void
            {
               try
               {
                  lastPage();
               }
               catch(err:Error)
               {
               }
            },100);
         }
      }
      
      public function preHandler(evt:MouseEvent) : void
      {
         this.removeBtnEvent();
         try
         {
            BC.removeEvent(_instance,this.targetMC.pre_btn,MouseEvent.CLICK,this.preHandler);
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
               catch(err:Error)
               {
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
               catch(err:Error)
               {
               }
            },100);
         }
      }
      
      public function makePageMCInfo() : void
      {
         try
         {
            BC.addEvent(_instance,this.targetMC.pageMC.over_btn,MouseEvent.CLICK,this.overPageFun);
            BC.addEvent(_instance,this.targetMC.pageMC.getOne_btn,MouseEvent.CLICK,this.newInterFun);
         }
         catch(err:Error)
         {
         }
      }
      
      public function overPageFun(event:MouseEvent) : void
      {
         BC.removeEvent(this,this.targetMC.pageMC.over_btn,MouseEvent.CLICK,this.overPageFun);
         BC.removeEvent(this,this.targetMC.pageMC.getOne_btn,MouseEvent.CLICK,this.newInterFun);
         this.nowFrame = this.endPage;
         this.nextHandler(event);
      }
      
      public function newInterFun(event:MouseEvent) : void
      {
         superPetLogin.gotoPay();
      }
      
      public function pageOneInit() : void
      {
         var btn:Object = null;
         trace("in pageInit",this.nowFrame);
         try
         {
            this.targetMC.mc_1.visible = false;
            this.targetMC.mc_no.visible = false;
            this.targetMC.mc_3.visible = false;
         }
         catch(err:Error)
         {
         }
         this.targetMC.pet_btn.visible = true;
         if(this.nowFrame == 1)
         {
            this.targetMC.pet_btn.x = 220;
         }
         else if(this.nowFrame >= this.startPage)
         {
            this.targetMC.pet_btn.visible = false;
         }
         else
         {
            this.targetMC.pet_btn.x = 367;
         }
         this.lastPage();
         if(this.targetMC.currentFrame == this.startPage)
         {
            this.makePageMCInfo();
         }
         if(this.IsVIP && this.IsHaveItm)
         {
            this.targetMC.btnmc.visible = true;
         }
         else if(this.targetMC.currentFrame >= this.startPage && this.targetMC.currentFrame <= this.endPage)
         {
            this.targetMC.btnmc.visible = false;
         }
         else
         {
            this.targetMC.btnmc.visible = true;
         }
         for(var j:int = 0; j < this.targetMC.btnmc.numChildren; j++)
         {
            btn = this.targetMC.btnmc.getChildAt(j);
            btn.obj = GoodsInfo.getInfoById(btn.id);
            btn.money_txt.text = btn.obj.price;
            BC.addEvent(_instance,btn,MouseEvent.CLICK,this.buyAction);
         }
      }
      
      public function buyAction(evt:MouseEvent) : void
      {
         this.goodsObj = evt.currentTarget.obj;
         this.buyMach = this.goodsObj.price;
         this.buyNum = this.goodsObj.id;
         var buyName:String = this.goodsObj.name;
         this.itemObj = new Object();
         this.itemObj.id = this.goodsObj.id;
         this.itemObj.price = 100;
         this.itemObj.info = "";
         if(this.goodsObj.buyLevel == 0 || this.goodsObj.buyLevel == null)
         {
            clothBuyModule.buyAction(this.itemObj,false);
         }
         else
         {
            this.checkIsBuy();
         }
      }
      
      private function checkIsBuy() : void
      {
         BC.addEvent(_instance,GV.onlineSocket,"read_" + 1911,this.onRead_1911);
         homeSocket.queryPlantAndFarm(LocalUserInfo.getUserID());
      }
      
      private function onRead_1911(evt:EventTaomee) : void
      {
         BC.removeEvent(_instance,GV.onlineSocket,"read_" + 1911,this.onRead_1911);
         var farmLVNum:uint = uint(evt.EventObj.farmLVNum);
         if(farmLVNum >= this.goodsObj.buyLevel)
         {
            clothBuyModule.buyAction(this.itemObj,false);
         }
         else
         {
            GF.showAlert(MainManager.getGameLevel(),"    你現在的養殖等級是" + farmLVNum + "，購買" + this.goodsObj.name + "需要到達" + this.goodsObj.buyLevel + "級才可以哦。","",100,"iknow",true,false,"E");
         }
      }
      
      public function pageOneHandler(evt:MouseEvent) : void
      {
         BC.removeEvent(_instance,evt.target,MouseEvent.CLICK,this.pageOneHandler);
         this.targetMC.mc_1.visible = false;
         this.tempLoader.unload();
         this.tempMC.removeChild(this.tempLoader);
         var itemNum:int = 1;
         this.buyItem.buyItems(int(this.buyNum),itemNum);
      }
      
      public function visibleFalse(evt:MouseEvent) : void
      {
         BC.removeEvent(_instance,evt.target,MouseEvent.CLICK,this.visibleFalse);
         this.buyMach = 0;
         this.targetMC.mc_1.visible = false;
         this.targetMC.mc_no.visible = false;
      }
      
      public function onBuySuccess(evt:*) : void
      {
         this.targetMC.mc_3.visible = true;
         this.targetMC.mc_3.info.text = "購買成功！\r物品已放入你的倉庫中";
         BC.addEvent(_instance,this.targetMC.mc_3.enter_btn,MouseEvent.CLICK,this.removeMC_3);
         this.buyMach = 0;
         GV.onlineSocket.dispatchEvent(new EventTaomee("depotAddGoods",{"obj":{"ID":this.buyNum}}));
      }
      
      public function removeMC_3(evt:MouseEvent) : void
      {
         BC.removeEvent(_instance,this.targetMC.mc_3.enter_btn,MouseEvent.CLICK,this.removeMC_3);
         this.targetMC.mc_3.visible = false;
      }
      
      private function onGetAwards(evt:Event) : void
      {
         var checkLV:int = int(LocalUserInfo.getFarmer());
         if(checkLV >= 15)
         {
            Deal.BuyItem(1270029,1,function(... e):void
            {
               var msg:String = "    恭喜你，獲得了" + GoodsInfo.getItemNameByID(1270029) + "已放入你的牧場倉庫中了！";
               var url:String = "resource/farm/icon/1270029.swf";
               Alert.showAlert(MainManager.getGameLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
            },function(... e):void
            {
               Alert.showAlert(MainManager.getGameLevel(),"    你已經擁有這件寶貝啦，所以不能再領取了哦！","",6,"E");
            });
         }
         else
         {
            Alert.showAlert(MainManager.getGameLevel(),"    這是超級牧場主專屬禮包，當你養殖等級到15級就能來領取！","",6,"E");
         }
      }
      
      public function removeEvent(event:* = null) : void
      {
         BC.removeEvent(_instance);
         var p:DisplayObject = this.targetMC.parent.parent.parent;
         GC.clearAll(p);
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
               BC.removeEvent(_instance,btn,MouseEvent.CLICK,this.buyAction);
            }
         }
         catch(e:*)
         {
         }
      }
   }
}

