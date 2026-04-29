package com.module.present
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.presentGoods.PresentGoodsReq;
   import com.logic.socket.shopItem.BuyItemReq;
   import com.module.activityModule.superPetLogin;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.setTimeout;
   
   public class presentBookView extends MovieClip
   {
      
      private static var allPage:int = 10;
      
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
      
      private var id:uint;
      
      public function presentBookView(obj:*)
      {
         super();
         this.halfPrice = 1;
         this.targetMC = obj.main_mc;
         allPage = this.targetMC.totalFrames;
         this.IsVIP = LocalUserInfo.isVIP();
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
         var btn:DisplayObject = null;
         this.lastPage();
         if(Boolean(this.targetMC.btnmc))
         {
            for(j = 0; j < this.targetMC.btnmc.numChildren; j++)
            {
               btn = this.targetMC.btnmc.getChildAt(j);
               btn.addEventListener(MouseEvent.CLICK,this.buyAction);
            }
         }
      }
      
      public function buyAction(evt:MouseEvent) : void
      {
         this.id = evt.currentTarget.id;
         if(this.id == 160446 || this.id == 160447 || this.id == 160448 || this.id == 160449 || this.id == 160474 || this.id == 160475)
         {
            GV.onlineSocket.addEventListener("read_" + 1354,this.getNum);
            PresentGoodsReq.sendPresentNum();
            return;
         }
         PresentManager.init(this.id);
      }
      
      public function getNum(e:EventTaomee) : void
      {
         var url:String = null;
         var msg:String = null;
         var backAlert:* = undefined;
         GV.onlineSocket.removeEventListener("read_" + 1354,this.getNum);
         if(e.EventObj.num >= 3)
         {
            url = "resource/goods/icon/" + this.id + ".swf";
            msg = "    你要領取一個" + GoodsInfo.getItemNameByID(this.id) + "嗎？";
            backAlert = Alert.showAlert(MainManager.getGameLevel(),url,msg,Alert.CHANG_ALERT,"sure,cancel",true,false,"EMP_BUY");
            backAlert.addEventListener("CLICK" + 1,this.buyTheItem);
         }
         else
         {
            Alert.showAlert(MainManager.getGameLevel(),"你還需要贈送" + (3 - e.EventObj.num) + "次禮物給好友，才可以領取這樣物品哦！","",6,"D");
         }
      }
      
      public function buyTheItem(e:*) : void
      {
         GV.onlineSocket.addEventListener("read_" + 1353,this.getItemSucc);
         PresentGoodsReq.getMyPresent(this.id);
      }
      
      public function getItemSucc(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 1353,this.getItemSucc);
         var url:String = "resource/goods/icon/" + this.id + ".swf";
         var msg:String = "    一個" + GoodsInfo.getItemNameByID(this.id) + "已經放入你的小屋倉庫中。";
         Alert.showAlert(MainManager.getGameLevel(),url,msg,Alert.CHANG_ALERT,"sure",true,false,"EMP_BUY");
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
      
      public function removeEvent(event:* = null) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEvent);
         var tempObj:* = this.targetMC.mc_3.parent;
         this.targetMC.mc_no.enter_btn.removeEventListener(MouseEvent.CLICK,this.visibleFalse);
         this.targetMC.mc_1.enter_btn.removeEventListener(MouseEvent.CLICK,this.pageOneHandler);
         this.targetMC.mc_1.cancel_btn.removeEventListener(MouseEvent.CLICK,this.visibleFalse);
         this.targetMC.pre_btn.removeEventListener(MouseEvent.CLICK,this.preHandler);
         this.targetMC.next_btn.removeEventListener(MouseEvent.CLICK,this.nextHandler);
         this.targetMC.close_btn.removeEventListener(MouseEvent.CLICK,this.removeEvent);
         GC.stopAllMC(tempObj);
         GC.clearAllChildren(tempObj);
         var p:* = tempObj.parent.parent.parent;
         tempObj.parent.removeChild(tempObj);
         tempObj = null;
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

