package com.module.homeBook.homeBookView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.util.DisplayUtil;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.home.homeSocket;
   import com.logic.socket.shopItem.BuyItemReq;
   import com.logic.socket.shopItem.BuyItemRes;
   import com.module.activityModule.checkCloth;
   import com.module.activityModule.superPetLogin;
   import com.module.clothBuyModule.clothBuyModule;
   import com.module.deal.Deal;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.setTimeout;
   
   public class homeSeedView extends MovieClip
   {
      
      private static var allPage:int = 10;
      
      public var buyItem:BuyItemReq;
      
      public var tempLoader:Loader;
      
      public var tempMC:MovieClip;
      
      public var targetMC:MovieClip;
      
      public var buyNum:Object;
      
      public var nowFrame:int;
      
      public var buyMach:int;
      
      public var halfPrice:uint;
      
      private var IsVIP:Boolean = false;
      
      private var IsHaveItm:Boolean = false;
      
      private var itemObj:Object;
      
      private var goodsObj:Object;
      
      private var startPage:uint = 12;
      
      private var endPage:uint = 19;
      
      private var frameNum:uint;
      
      public function homeSeedView(obj:*)
      {
         super();
         this.halfPrice = 1;
         this.targetMC = obj.main_mc;
         allPage = this.targetMC.totalFrames;
         this.IsVIP = LocalUserInfo.isVIP();
         this.IsHaveItm = checkCloth.PeopleHaveItemSO(12202);
         this.tempMC = new MovieClip();
         this.tempLoader = new Loader();
         this.buyItem = new BuyItemReq();
         this.targetMC.mc_1.visible = false;
         this.targetMC.mc_no.visible = false;
         this.targetMC.mc_3.visible = false;
         this.nowFrame = 1;
         this.targetMC.pet_btn.addEventListener(MouseEvent.CLICK,this.gotoSuperPage);
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeEvent);
         GV.onlineSocket.addEventListener("GetAwards",this.onGetAwards);
         GV.onlineSocket.addEventListener("GotoType",this.onGotoType);
         this.targetMC.addEventListener(Event.ENTER_FRAME,this.whenEnterFrame);
         this.bookViewInit();
      }
      
      public function gotoSuperPage(e:MouseEvent) : void
      {
         setTimeout(function():void
         {
            try
            {
               targetMC.pre_btn.addEventListener(MouseEvent.CLICK,preHandler);
            }
            catch(err:*)
            {
            }
         },100);
         this.targetMC.pet_btn.x = 220;
         this.nowFrame = this.startPage;
         this.updatePageState();
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
      
      public function onGotoType(evt:EventTaomee) : void
      {
         this.nowFrame = evt.EventObj.f;
         this.updatePageState();
      }
      
      private function whenEnterFrame(evt:Event) : void
      {
         if(this.nowFrame != this.frameNum && this.nowFrame == this.targetMC.currentFrame)
         {
            try
            {
               this.targetMC.pre_btn.addEventListener(MouseEvent.CLICK,this.preHandler);
               this.targetMC.next_btn.addEventListener(MouseEvent.CLICK,this.nextHandler);
               this.targetMC.close_btn.addEventListener(MouseEvent.CLICK,this.removeEvent);
            }
            catch(e:Error)
            {
            }
            if(this.pageOneInit())
            {
               this.frameNum = this.nowFrame;
            }
         }
      }
      
      private function updatePageState() : void
      {
         if(this.nowFrame >= 1 && this.nowFrame <= allPage)
         {
            this.targetMC.gotoAndStop(this.nowFrame);
         }
      }
      
      public function nextHandler(evt:MouseEvent) : void
      {
         this.removeBtnEvent();
         ++this.nowFrame;
         this.updatePageState();
      }
      
      public function preHandler(evt:MouseEvent) : void
      {
         this.removeBtnEvent();
         --this.nowFrame;
         this.updatePageState();
      }
      
      public function makePageMCInfo() : void
      {
         try
         {
            BC.addEvent(this,this.targetMC.pageMC.over_btn,MouseEvent.CLICK,this.overPageFun);
            BC.addEvent(this,this.targetMC.pageMC.getOne_btn,MouseEvent.CLICK,this.newInterFun);
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
      
      public function pageOneInit() : Boolean
      {
         var btn:DisplayObject = null;
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
         if(this.targetMC.currentFrame == this.startPage)
         {
            this.makePageMCInfo();
         }
         if(!this.targetMC.btnmc)
         {
            return false;
         }
         if(this.IsVIP && this.IsHaveItm)
         {
            this.targetMC.btnmc.visible = true;
         }
         else if(this.targetMC.currentFrame >= this.startPage && this.targetMC.currentFrame <= this.endPage)
         {
            this.targetMC.btnmc.visible = false;
         }
         else if(Boolean(this.targetMC.btnmc))
         {
            this.targetMC.btnmc.visible = true;
         }
         for(var j:int = 0; j < this.targetMC.btnmc.numChildren; j++)
         {
            btn = this.targetMC.btnmc.getChildAt(j);
            btn["obj"] = GoodsInfo.getInfoById(btn["id"]);
            btn["money_txt"].text = btn["obj"].price;
            btn.addEventListener(MouseEvent.CLICK,this.buyAction);
         }
         return true;
      }
      
      public function buyAction(evt:MouseEvent) : void
      {
         this.goodsObj = evt.currentTarget.obj;
         this.buyMach = this.goodsObj.price;
         this.buyNum = this.goodsObj.id;
         this.itemObj = new Object();
         this.itemObj.id = this.goodsObj.id;
         this.itemObj.price = 100;
         this.itemObj.info = "";
         var obj:Object = GoodsInfo.getInfoById(this.itemObj.id);
         if(obj.VipBuyable == 1)
         {
            if(LocalUserInfo.isVIP())
            {
               if(this.goodsObj.buyLevel == 0 || this.goodsObj.buyLevel == null)
               {
                  clothBuyModule.buyAction(this.itemObj,false);
               }
               else
               {
                  this.checkIsBuy();
               }
            }
            else
            {
               Alert.SLAlart("你還沒有超級拉姆，不能栽培QQ小芝麻種子哦，我們期待你的加入！");
            }
         }
         else if(this.goodsObj.buyLevel == 0 || this.goodsObj.buyLevel == null)
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
         GV.onlineSocket.addEventListener("read_" + 1911,this.onRead_1911);
         homeSocket.queryPlantAndFarm(LocalUserInfo.getUserID());
      }
      
      private function onRead_1911(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 1911,this.onRead_1911);
         var plantLVNum:uint = uint(evt.EventObj.plantLVNum);
         if(plantLVNum >= this.goodsObj.buyLevel)
         {
            clothBuyModule.buyAction(this.itemObj,false);
         }
         else
         {
            GF.showAlert(MainManager.getGameLevel(),"    你現在的種植等級是" + plantLVNum + "，購買" + this.goodsObj.name + "需要到達" + this.goodsObj.buyLevel + "級才可以哦。","",100,"iknow",true,false,"E");
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
      
      public function onBuySuccess(evt:*) : void
      {
         this.targetMC.mc_3.visible = true;
         this.targetMC.mc_3.info.text = "購買成功！\r物品已放入你的倉庫中";
         this.targetMC.mc_3.enter_btn.addEventListener(MouseEvent.CLICK,this.removeMC_3);
         this.buyMach = 0;
         GV.onlineSocket.dispatchEvent(new EventTaomee("depotAddGoods",{"obj":{"ID":this.buyNum}}));
      }
      
      public function removeMC_3(evt:MouseEvent) : void
      {
         this.targetMC.mc_3.enter_btn.removeEventListener(MouseEvent.CLICK,this.removeMC_3);
         this.targetMC.mc_3.visible = false;
      }
      
      private function onGetAwards(evt:Event) : void
      {
         var checkLV:int = int(LocalUserInfo.getPlanter());
         if(checkLV >= 15)
         {
            Deal.BuyItem(1220117,1,function(... e):void
            {
               Alert.getIconByID_Alart(1220117,"    恭喜你，獲得了" + GoodsInfo.getItemNameByID(1220117) + "已放入你的家園倉庫中了！");
            },function(... e):void
            {
               Alert.showAlert(MainManager.getGameLevel(),"    你已經擁有這件寶貝啦，所以不能再領取了哦！","",6,"E");
            });
         }
         else
         {
            Alert.showAlert(MainManager.getGameLevel(),"    這是花園巧匠專屬禮包，當你的種植等級到了15級就能領取！","",6,"E");
         }
      }
      
      public function removeEvent(event:* = null) : void
      {
         this.removeBtnEvent();
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEvent);
         GV.onlineSocket.removeEventListener("GetAwards",this.onGetAwards);
         GV.onlineSocket.removeEventListener("GotoType",this.onGotoType);
         var tempObj:* = this.targetMC.mc_3.parent;
         this.targetMC.mc_3.enter_btn.removeEventListener(MouseEvent.CLICK,this.removeMC_3);
         this.targetMC.mc_no.enter_btn.removeEventListener(MouseEvent.CLICK,this.visibleFalse);
         this.targetMC.mc_1.enter_btn.removeEventListener(MouseEvent.CLICK,this.pageOneHandler);
         this.targetMC.mc_1.cancel_btn.removeEventListener(MouseEvent.CLICK,this.visibleFalse);
         this.targetMC.pre_btn.removeEventListener(MouseEvent.CLICK,this.preHandler);
         this.targetMC.next_btn.removeEventListener(MouseEvent.CLICK,this.nextHandler);
         this.targetMC.close_btn.removeEventListener(MouseEvent.CLICK,this.removeEvent);
         this.targetMC.removeEventListener(Event.ENTER_FRAME,this.whenEnterFrame);
         GV.onlineSocket.removeEventListener(BuyItemRes.BUY_ITEM_SUCCESS,this.onBuySuccess);
         DisplayUtil.removeForParent(tempObj);
         var mc:DisplayObject = MainManager.getGameLevel().getChildByName("homeseedbook");
         DisplayUtil.removeForParent(mc);
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

