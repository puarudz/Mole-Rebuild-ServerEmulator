package com.module.tommyWork
{
   import com.common.Alert.Alert;
   import com.common.util.DisplayUtil;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.doWork.DoWorkSocket;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.logic.socket.shopItem.BuyItemReq;
   import com.logic.socket.shopItem.BuyItemRes;
   import com.module.activityModule.checkItem;
   import com.module.pet.petClassLearnStatus;
   import com.module.pet.petLogic;
   import com.mole.app.manager.SystemEventManager;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class tommyWork
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var itemID:Number;
      
      public var price:Number;
      
      public var TipStr:String;
      
      private var tipName:String;
      
      public var BuyTip:MovieClip;
      
      public var buy_Err:MovieClip;
      
      public var Buy_suc:MovieClip;
      
      private var working:Boolean;
      
      private var kaddish_mc:MovieClip;
      
      private var myAlert:*;
      
      private var petTimer:Timer;
      
      public var buyItem:BuyItemReq;
      
      public var tempLoader:Loader;
      
      private var ddk1_mc:MovieClip;
      
      private var ddk2_mc:MovieClip;
      
      private var ddk3_mc:MovieClip;
      
      public function tommyWork(mc:MovieClip)
      {
         super();
         this.target_mc = mc;
         this.init();
      }
      
      private function init() : void
      {
         var randomNum:int = Math.floor(Math.random() * 50);
         this.target_mc.discreteness_tommy.x -= randomNum;
         this.buyItem = new BuyItemReq();
         this.tempLoader = new Loader();
         this.target_mc.maozi_btn.addEventListener(MouseEvent.CLICK,this.getHat);
         this.target_mc.chanzi_btn.addEventListener(MouseEvent.CLICK,this.getShovel);
         this.target_mc.ddk_btn.addEventListener(MouseEvent.CLICK,this.getddk);
         SystemEventManager.addEventListener("tommy_doWork",this.tommyEvent);
      }
      
      private function tommyEvent(evt:*) : void
      {
         this.tommyTask();
      }
      
      private function getddk(evt:MouseEvent) : void
      {
         var tempMC:Class = null;
         if(!GV.MC_AppLever.getChildByName("ddk1_mc"))
         {
            tempMC = GV.Lib_Map.getClass("ddk1");
            this.ddk1_mc = new tempMC();
            this.ddk1_mc.name = "ddk1_mc";
            GV.MC_AppLever.addChild(this.ddk1_mc);
            this.ddk1_mc.x = (GV.stageWidth - this.ddk1_mc.width) / 2;
            this.ddk1_mc.y = (GV.stageHeight - this.ddk1_mc.height) / 2;
            this.ddk1_mc.yes_btn.addEventListener(MouseEvent.CLICK,this.ddk1yes);
            this.ddk1_mc.no_btn.addEventListener(MouseEvent.CLICK,this.ddk1no);
            this.ddk1_mc.closeBtn.addEventListener(MouseEvent.CLICK,this.closePanel1);
         }
      }
      
      private function closePanel1(evt:MouseEvent = null) : void
      {
         this.ddk1_mc.yes_btn.removeEventListener(MouseEvent.CLICK,this.ddk1yes);
         this.ddk1_mc.no_btn.removeEventListener(MouseEvent.CLICK,this.ddk1no);
         this.ddk1_mc.closeBtn.removeEventListener(MouseEvent.CLICK,this.closePanel1);
         GV.MC_AppLever.removeChild(this.ddk1_mc);
      }
      
      private function ddk1yes(evt:MouseEvent) : void
      {
         this.closePanel1();
         if(GV.MyInfo_PetObj.Level > 100)
         {
            this.isHaveddk();
         }
         else
         {
            Alert.showAlert(MainManager.getAppLevel(),"","你沒有把超級拉姆帶在身邊噢！",Alert.IKNOW_ALERT);
         }
      }
      
      private function ddk1no(evt:MouseEvent) : void
      {
         this.closePanel1();
      }
      
      private function isHaveddk() : void
      {
         checkItem.checkItemHandler(12205);
         GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.haveddkResult);
      }
      
      private function haveddkResult(evt:EventTaomee) : void
      {
         var tempMC:Class = null;
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.haveddkResult);
         if(evt.EventObj.count == 1)
         {
            if(!GV.MC_AppLever.getChildByName("ddk2_mc"))
            {
               tempMC = GV.Lib_Map.getClass("ddk2");
               this.ddk2_mc = new tempMC();
               this.ddk2_mc.name = "ddk2_mc";
               GV.MC_AppLever.addChild(this.ddk2_mc);
               this.ddk2_mc.x = (GV.stageWidth - this.ddk2_mc.width) / 2;
               this.ddk2_mc.y = (GV.stageHeight - this.ddk2_mc.height) / 2;
               this.ddk2_mc.iknow_btn.addEventListener(MouseEvent.CLICK,this.iknow2);
               this.ddk2_mc.closeBtn.addEventListener(MouseEvent.CLICK,this.iknow2);
            }
         }
         else
         {
            GV.onlineSocket.addEventListener(BuyItemRes.BUY_ITEM_SUCCESS,this.onBuyDDKSuccess);
            this.buyItem.buyItems(12205,1);
         }
      }
      
      private function onBuyDDKSuccess(evt:EventTaomee) : void
      {
         var tempMC:Class = null;
         GV.onlineSocket.removeEventListener(BuyItemRes.BUY_ITEM_SUCCESS,this.onBuyDDKSuccess);
         if(!GV.MC_AppLever.getChildByName("ddk3_mc"))
         {
            tempMC = GV.Lib_Map.getClass("ddk3");
            this.ddk3_mc = new tempMC();
            this.ddk3_mc.name = "ddk3_mc";
            GV.MC_AppLever.addChild(this.ddk3_mc);
            this.ddk3_mc.x = (GV.stageWidth - this.ddk3_mc.width) / 2;
            this.ddk3_mc.y = (GV.stageHeight - this.ddk3_mc.height) / 2;
            this.ddk3_mc.iknow_btn.addEventListener(MouseEvent.CLICK,this.iknow3);
            this.ddk3_mc.closeBtn.addEventListener(MouseEvent.CLICK,this.iknow3);
         }
      }
      
      private function iknow2(evt:MouseEvent) : void
      {
         this.ddk2_mc.iknow_btn.removeEventListener(MouseEvent.CLICK,this.iknow2);
         this.ddk2_mc.closeBtn.removeEventListener(MouseEvent.CLICK,this.iknow2);
         GV.MC_AppLever.removeChild(this.ddk2_mc);
      }
      
      private function iknow3(evt:MouseEvent) : void
      {
         this.ddk3_mc.iknow_btn.removeEventListener(MouseEvent.CLICK,this.iknow3);
         this.ddk3_mc.closeBtn.removeEventListener(MouseEvent.CLICK,this.iknow3);
         GV.MC_AppLever.removeChild(this.ddk3_mc);
      }
      
      private function getHat(evt:MouseEvent) : void
      {
         GV.itemID = 3;
         this.itemID = 12148;
         this.price = 0;
         this.TipStr = "安全頭盔";
         this.tipName = "是否要拿取安全頭盔？";
         this.buyAction();
      }
      
      private function getShovel(evt:MouseEvent) : void
      {
         GV.itemID = 3;
         this.itemID = 12149;
         this.price = 0;
         this.TipStr = "鐵鍬";
         this.tipName = "是否要拿取鐵鍬？";
         this.buyAction();
      }
      
      private function tommyTask() : void
      {
         var url:String = null;
         var btns:String = null;
         var info:String = null;
         if(Boolean(GV.JobLogics.chartbagClothFun([[12148,12149]])))
         {
            finishSomethingReq.sendReq(1);
            GV.onlineSocket.addEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,this.dofinishSomething);
         }
         else
         {
            url = "resource/allJob/AlertPic/tommy1.swf";
            btns = "iknow";
            info = "    你必須穿戴好安全頭盔和小鐵鍬才能進行施工哦！如果你還沒有領取的話，可以在我身邊的施工區域找到它們。";
            Alert.showAlert(GV.MC_AppLever,url,info,Alert.CHANG_ALERT,btns,true,false,"SMCUI");
         }
      }
      
      private function buyAction() : void
      {
         var tempMC:Class = null;
         if(!GV.MC_AppLever.getChildByName("BuyTip"))
         {
            tempMC = GV.Lib_Map.getClass("buy_tip1");
            this.BuyTip = new tempMC();
            this.BuyTip.name = "BuyTip";
            GV.MC_AppLever.addChild(this.BuyTip);
            this.BuyTip.x = (GV.stageWidth - this.BuyTip.width) / 2;
            this.BuyTip.y = (GV.stageHeight - this.BuyTip.height) / 2;
         }
         var iconMC:MovieClip = new MovieClip();
         this.tempLoader.unload();
         this.tempLoader.load(VL.getURLRequest("resource/cloth/icon/" + this.itemID + ".swf"));
         iconMC.addChild(this.tempLoader);
         this.BuyTip.addChild(iconMC);
         iconMC.y = 30;
         iconMC.x = 115;
         iconMC.scaleX = 1.8;
         iconMC.scaleY = 1.8;
         this.BuyTip.info.text = this.tipName;
         this.BuyTip.enter_btn.addEventListener(MouseEvent.CLICK,this.SendAction);
         this.BuyTip.cancel_btn.addEventListener(MouseEvent.CLICK,this.removeAction);
         this.BuyTip.drag_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.stargeAction);
         this.BuyTip.drag_mc.addEventListener(MouseEvent.MOUSE_UP,this.stopAction);
         this.BuyTip.drag_mc.addEventListener(MouseEvent.MOUSE_MOVE,this.moveAction);
      }
      
      private function removeAction(evt:MouseEvent = null) : void
      {
         this.BuyTip.enter_btn.removeEventListener(MouseEvent.CLICK,this.SendAction);
         this.BuyTip.cancel_btn.removeEventListener(MouseEvent.CLICK,this.removeAction);
         this.BuyTip.drag_mc.removeEventListener(MouseEvent.MOUSE_DOWN,this.stargeAction);
         this.BuyTip.drag_mc.removeEventListener(MouseEvent.MOUSE_UP,this.stopAction);
         this.BuyTip.drag_mc.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveAction);
         this.BuyTip.parent.removeChild(this.BuyTip);
         this.BuyTip = null;
      }
      
      private function SendAction(evt:MouseEvent = null) : void
      {
         var itemNum:int = 0;
         var errorTemp:Class = null;
         this.removeAction();
         if(LocalUserInfo.getYXQ() >= this.price)
         {
            GV.onlineSocket.addEventListener(BuyItemRes.BUY_ITEM_SUCCESS,this.onBuySuccess);
            GV.onlineSocket.addEventListener("sameEvent",this.removeHandler);
            itemNum = 1;
            this.buyItem.buyItems(int(this.itemID),itemNum);
         }
         else if(!GV.MC_AppLever.getChildByName("buy_Err1"))
         {
            errorTemp = GV.Lib_Map.getClass("buy_err1");
            this.buy_Err = new errorTemp();
            this.buy_Err.name = "buy_Err1";
            GV.MC_AppLever.addChild(this.buy_Err);
            this.buy_Err.x = (GV.stageWidth - this.buy_Err.width) / 2;
            this.buy_Err.y = (GV.stageHeight - this.buy_Err.height) / 2;
            this.buy_Err.enter_btn.addEventListener(MouseEvent.CLICK,this.errAction);
         }
      }
      
      private function errAction(evt:MouseEvent = null) : void
      {
         this.buy_Err.enter_btn.removeEventListener(MouseEvent.CLICK,this.errAction);
         GC.stopAllMC(this.buy_Err);
         GC.clearChildren(this.buy_Err);
         this.buy_Err.parent.removeChild(this.buy_Err);
         this.buy_Err = null;
      }
      
      private function dofinishSomething(e:EventTaomee) : void
      {
         var url:String = null;
         var btns:String = null;
         var info:String = null;
         GV.onlineSocket.removeEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,this.dofinishSomething);
         if(e.EventObj.Type == 1)
         {
            if(e.EventObj.Done == 1)
            {
               url = "resource/allJob/AlertPic/tommy2.swf";
               btns = "iknow";
               info = "    你可真是一個勤勞的小摩爾哦！不過你今天已經參加過施工建設，當心別累著自己，趕快回去好好休息，養足精神明天再來吧！";
               this.myAlert = Alert.showAlert(GV.MC_AppLever,url,info,Alert.CHANG_ALERT,btns,true,false,"SMCUI");
            }
            else
            {
               url = "resource/allJob/AlertPic/tommy3.swf";
               btns = "getReady,nextCome";
               info = "    嘿！" + GV.MyInfo_nickName + "，你想為莊園的建設出一份力嗎？只要戴上安全帽，拿起小鐵鍬，每天參與勞動2分鐘，你就能得一份不錯的報酬。勞動要專心，不能幹幹就跑了，那樣我可不發薪水喲！想現在開始今天的工作嗎？";
               this.myAlert = Alert.showAlert(GV.MC_AppLever,url,info,Alert.CHANG_ALERT,btns,true,false,"SMCUI");
               this.myAlert.addEventListener(Alert.CLICK_ + "1",this.dowork);
            }
         }
      }
      
      private function dowork(evt:*) : void
      {
         var str:String = null;
         var ran:Number = NaN;
         if(!this.working)
         {
            this.petTimer = new Timer(120000,1);
            this.petTimer.addEventListener(TimerEvent.TIMER,this.kaddishSuc);
            GV.onlineSocket.addEventListener("iskaddish",this.kaddishEndHandler);
            this.petTimer.reset();
            this.petTimer.start();
            this.loadMoleWorking();
            if(PeopleManageView(GV.MAN_PEOPLE).Petlevel > 1 && petLogic.PetCan(1))
            {
               str = "";
               ran = Math.random();
               if(ran > 0.7)
               {
                  str = LocalUserInfo.getNickName() + "加油！賺了錢給我買好吃的吧！";
               }
               else if(ran < 0.3)
               {
                  str = "加油加油，我也想幫你的忙。";
               }
               else
               {
                  str = "累不累啊" + LocalUserInfo.getNickName() + "？我給你擦擦汗。";
               }
               PeopleManageView(GV.MAN_PEOPLE).lamu_say(str);
            }
         }
      }
      
      private function kaddishEndHandler(evt:EventTaomee) : void
      {
         this.petTimer.removeEventListener(TimerEvent.TIMER,this.kaddishSuc);
         this.working = false;
         this.clearKaddish_mc();
         this.petTimer.stop();
         GV.onlineSocket.removeEventListener("iskaddish",this.kaddishEndHandler);
      }
      
      private function loadMoleWorking() : void
      {
         var peopleMC:MovieClip = null;
         var tempMC:Class = null;
         if(!this.working)
         {
            this.working = true;
            peopleMC = GV.MAN_PEOPLE.avatarMC.tomatoMC;
            if(!peopleMC.getChildByName("kaddish_mc"))
            {
               tempMC = GV.Lib_Map.getClass("mole_working") as Class;
               this.kaddish_mc = new tempMC();
               this.kaddish_mc.name = "kaddish_mc";
               peopleMC.addChild(this.kaddish_mc);
            }
         }
      }
      
      private function kaddishSuc(evt:TimerEvent) : void
      {
         trace("--------------------成功");
         DoWorkSocket.doWork_getMoney(1);
         GV.onlineSocket.addEventListener("read_" + 1481,this.dofinishwork);
         GV.onlineSocket.addEventListener("ERROR_CMD_" + 1481,this.errorDofinishwork);
         GV.onlineSocket.removeEventListener("iskaddish",this.kaddishEndHandler);
         this.clearKaddish_mc();
         this.kaddishEndHandler(null);
      }
      
      private function errorDofinishwork(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("ERROR_CMD_" + 1481,this.errorDofinishwork);
         var url:String = "resource/allJob/AlertPic/tommy2.swf";
         var btns:String = "iknow";
         var info:String = "　　你可真是一個勤勞的小摩爾哦！不過你今天已經參加過施工建設，當心別累著自己，趕快回去好好休息，養足精神明天再來吧！";
         this.myAlert = Alert.showAlert(GV.MC_AppLever,url,info,Alert.CHANG_ALERT,btns,true,false,"SMCUI");
      }
      
      private function dofinishwork(e:EventTaomee) : void
      {
         var info:String = null;
         GV.onlineSocket.removeEventListener("read_" + 1481,this.dofinishwork);
         var url:String = "resource/allJob/icon/" + "money" + ".swf";
         var btns:String = "iknow";
         LocalUserInfo.setYXQ(int(e.EventObj));
         var classObj:petClassLearnStatus = petLogic.getPetMagicClass(GV.MAN_PEOPLE as PeopleManageView);
         info = "　　感謝你的辛勤勞動，10000已經放入你的百寶箱中。";
         var task408Alert:* = Alert.showAlert(GV.MC_AppLever,url,info,Alert.CHANG_ALERT,btns,true,false,"EMP_BUY");
      }
      
      private function clearKaddish_mc() : void
      {
         DisplayUtil.removeForParent(this.kaddish_mc);
      }
      
      private function stargeAction(evt:MouseEvent) : void
      {
         GF.setDrag(evt.target.parent);
      }
      
      private function stopAction(evt:MouseEvent) : void
      {
         GF.stopDrag(evt.target.parent);
      }
      
      private function moveAction(evt:MouseEvent) : void
      {
         evt.updateAfterEvent();
      }
      
      private function onBuySuccess(evt:*) : void
      {
         var tempMC:Class = null;
         if(!GV.MC_AppLever.getChildByName("Buy_suc"))
         {
            tempMC = GV.Lib_Map.getClass("buy_suc1");
            this.Buy_suc = new tempMC();
            this.Buy_suc.name = "Buy_suc";
            GV.MC_AppLever.addChild(this.Buy_suc);
            this.Buy_suc.x = (GV.stageWidth - this.Buy_suc.width) / 2;
            this.Buy_suc.y = (GV.stageHeight - this.Buy_suc.height) / 2;
            if(GV.itemID == 1)
            {
               this.Buy_suc.info.text = "感謝你的慷慨捐助\n" + "做為獎勵" + this.TipStr + "已放入你的\n百寶箱中";
            }
            else
            {
               this.Buy_suc.info.text = this.TipStr + "已放入你的\n百寶箱中";
            }
            this.Buy_suc.enter_btn.addEventListener(MouseEvent.CLICK,this.removeSuc);
            GV.onlineSocket.removeEventListener(BuyItemRes.BUY_ITEM_SUCCESS,this.onBuySuccess);
         }
      }
      
      private function removeHandler(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(BuyItemRes.BUY_ITEM_SUCCESS,this.onBuySuccess);
         GV.onlineSocket.removeEventListener("sameEvent",this.removeHandler);
      }
      
      private function removeSuc(evt:MouseEvent = null) : void
      {
         this.Buy_suc.enter_btn.removeEventListener(MouseEvent.CLICK,this.removeSuc);
         GC.stopAllMC(this.Buy_suc);
         GC.clearChildren(this.Buy_suc);
         this.Buy_suc.parent.removeChild(this.Buy_suc);
         this.Buy_suc = null;
      }
      
      public function destroy() : void
      {
         BC.removeEvent(this);
         if(this.petTimer != null)
         {
            this.petTimer.stop();
            this.petTimer.removeEventListener(TimerEvent.TIMER,this.kaddishSuc);
            this.petTimer = null;
         }
         this.target_mc.maozi_btn.removeEventListener(MouseEvent.CLICK,this.getHat);
         this.target_mc.chanzi_btn.removeEventListener(MouseEvent.CLICK,this.getShovel);
         this.target_mc.ddk_btn.removeEventListener(MouseEvent.CLICK,this.getddk);
         GV.onlineSocket.removeEventListener("iskaddish",this.kaddishEndHandler);
         GV.onlineSocket.removeEventListener(BuyItemRes.BUY_ITEM_SUCCESS,this.onBuySuccess);
         GV.onlineSocket.removeEventListener("sameEvent",this.removeHandler);
         GV.onlineSocket.removeEventListener("ERROR_CMD_" + 1481,this.errorDofinishwork);
         this.target_mc = null;
         this.depth_mc = null;
         SystemEventManager.removeEventListener("tommy_doWork",this.tommyEvent);
      }
   }
}

