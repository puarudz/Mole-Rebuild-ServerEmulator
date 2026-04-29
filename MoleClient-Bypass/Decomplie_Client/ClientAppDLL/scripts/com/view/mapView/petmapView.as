package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.loading.Loading;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.NPCJob.NpcJobSocket;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.logic.socket.petSocket.adoptPet.adoptPetReq;
   import com.logic.socket.petSocket.adoptPet.adoptPetRes;
   import com.logic.socket.petSocket.adoptPet.petNumReq;
   import com.logic.socket.petSocket.adoptPet.petNumRes;
   import com.module.clothBuyModule.clothBuyModule;
   import com.module.homeBook.homeBookView.petBookView;
   import com.module.lamu.lamuKeeping;
   import com.module.pet.PlayShopPet;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.BufferManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.task.TaskManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.utils.Timer;
   
   public class petmapView extends MapBase
   {
      
      public var buyPet:adoptPetReq;
      
      public var colorNum:Number;
      
      public var colorPet:String;
      
      public var petBuy:MovieClip;
      
      public var buySuccess:MovieClip;
      
      public var buy_Err:MovieClip;
      
      public var petTotalNum:Number = 0;
      
      public var bookView:MovieClip;
      
      public var loadBookEvent:MCLoader;
      
      public var petHelpMC:MovieClip;
      
      public var petInfoMC:MovieClip;
      
      private var tree:MovieClip;
      
      public var childMC:*;
      
      public var playpetclass:*;
      
      private var maomaoT:Timer;
      
      public function petmapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         NpcJobSocket.askNpcJob(32);
         this.buyPet = new adoptPetReq();
         this.playpetclass = new PlayShopPet(controlLevel);
         petNumReq.sendNumReq(LocalUserInfo.getUserID());
         GV.onlineSocket.addEventListener(petNumRes.GET_PETNUM_SUCC,this.getPetCount);
         GV.onlineSocket.addEventListener(adoptPetRes.ADOPTPET_OVER,this.buyOver);
         controlLevel.petbook_btn.addEventListener(MouseEvent.CLICK,this.petbookHandler);
         controlLevel.petbook_btn.addEventListener(MouseEvent.MOUSE_OVER,this.petbookOverHandler);
         controlLevel.petbook_btn.addEventListener(MouseEvent.MOUSE_OUT,this.petbookOutHandler);
         controlLevel.room_btn.addEventListener(MouseEvent.MOUSE_OVER,this.doorOverHandler);
         controlLevel.room_btn.addEventListener(MouseEvent.MOUSE_OUT,this.doorOutHandler);
         controlLevel.petHelp_btn.buttonMode = true;
         controlLevel.petHelp_btn.addEventListener(MouseEvent.CLICK,this.petHelpHandler);
         new lamuKeeping(controlLevel);
         topLevel.pet_mc.pet_mc.buttonMode = true;
         controlLevel.pet2.pet_mc.addEventListener(MouseEvent.MOUSE_OVER,this.petOverHandler);
         controlLevel.pet2.pet_mc.addEventListener(MouseEvent.MOUSE_OUT,this.petOutHandler);
         topLevel.pet_mc.pet_mc.addEventListener(MouseEvent.MOUSE_OVER,this.petOverHandler);
         topLevel.pet_mc.pet_mc.addEventListener(MouseEvent.MOUSE_OUT,this.petOutHandler);
         controlLevel.petInfo_btn.buttonMode = true;
         controlLevel.petInfo_btn.addEventListener(MouseEvent.MOUSE_OVER,this.petInfoOverHandler);
         controlLevel.petInfo_btn.addEventListener(MouseEvent.MOUSE_OUT,this.petInfoOutHandler);
         controlLevel.petInfo_btn.addEventListener(MouseEvent.CLICK,this.petInfoHandler);
         tip.tipTailDisPlayObject(controlLevel.newPet_1,"拉姆手冊");
         tip.tipTailDisPlayObject(controlLevel.newPet_2,"拉姆生活");
         controlLevel.newPet_1.addEventListener(MouseEvent.CLICK,this.petbookHandler);
         controlLevel.foodtable_btn.addEventListener(MouseEvent.CLICK,this.petbookHandler);
         controlLevel.newPet_2.addEventListener(MouseEvent.CLICK,this.petInfoHandler);
         controlLevel.treeTip.addEventListener(MouseEvent.CLICK,this.treeHandler);
         controlLevel.treeBuy.addEventListener(MouseEvent.CLICK,this.treeBuyHandler);
         SystemEventManager.addEventListener("rainbow_joinRainbowSMC",this.onJoinRainbowSMC);
         SystemEventManager.addEventListener("rainbow_Work",this.onRainBowWork);
         this.chartTask382();
      }
      
      private function chartTask382() : void
      {
         if(TaskManager.getTask(382).state >= 2)
         {
            BufferManager.addBufferEvent(BufferManager.TASK_382_201408_1,this.backTask382_1);
            BufferManager.getBuffer(BufferManager.TASK_382_201408_1);
         }
      }
      
      private function backTask382_1(e:EventTaomee) : void
      {
         BufferManager.removeBufferEvent(BufferManager.TASK_382_201408_1,this.backTask382_1);
         var flag:int = int(e.EventObj);
         if(flag == 1)
         {
            BufferManager.setBuffer(BufferManager.TASK_382_201408_1,2);
            ModuleManager.openPanel("Task382Flag_1",{"URL":"newTaskMap21MC"});
         }
      }
      
      private function onRainBowWork(e:SystemEvent) : void
      {
         BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.CheckIsHelped);
         finishSomethingReq.sendReq(31020);
      }
      
      private function CheckIsHelped(e:EventTaomee) : void
      {
         var loader:Loader = null;
         if(e.EventObj.Type == 31020)
         {
            BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.CheckIsHelped);
            if(e.EventObj.Done == 1)
            {
               Alert.smileAlart("    今天已經打過工了，太辛苦了，休息一下吧！");
            }
            else
            {
               loader = new Loader();
               loader.load(VL.getURLRequest("module/external/HelpRainbowWork.swf"));
               MainManager.getAppLevel().addChild(loader);
            }
         }
      }
      
      private function onJoinRainbowSMC(e:SystemEvent) : void
      {
         controlLevel.lamuNPC_btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      }
      
      private function treeBuyHandler(vet:MouseEvent) : void
      {
         GV.itemID = 3;
         var itemObj:Object = new Object();
         itemObj.id = 160142;
         itemObj.price = 0;
         itemObj.info = "酋長帽";
         clothBuyModule.buyAction(itemObj);
      }
      
      private function treeHandler(event:MouseEvent) : void
      {
         var TREE:Class = null;
         if(!MainManager.getGameLevel().getChildByName("tree"))
         {
            TREE = GV.Lib_Map.getClass("maomaoTree");
            this.tree = new TREE() as MovieClip;
            this.tree.name = "tree";
            MainManager.getGameLevel().addChild(this.tree);
            this.tree.x = (MainManager.getStageWidth() - this.tree.width) / 2;
            this.tree.y = (MainManager.getStageHeight() - this.tree.height) / 2;
            this.tree.closeBtn.addEventListener(MouseEvent.CLICK,this.closeBtntree);
         }
      }
      
      private function closeBtntree(event:MouseEvent) : void
      {
         this.tree.closeBtn.removeEventListener(MouseEvent.CLICK,this.closeBtntree);
         MainManager.getGameLevel().removeChild(this.tree);
      }
      
      private function petInfoOverHandler(evt:MouseEvent) : void
      {
         depthLevel.petMC.book_mc.gotoAndPlay(2);
      }
      
      private function petInfoOutHandler(evt:MouseEvent) : void
      {
         depthLevel.petMC.book_mc.gotoAndStop(1);
      }
      
      private function petInfoHandler(evt:MouseEvent) : void
      {
         var tempMC:MCLoader = null;
         if(!MainManager.getGameLevel().getChildByName("petInfoMC"))
         {
            this.petInfoMC = new MovieClip();
            this.petInfoMC.name = "petInfoMC";
            MainManager.getGameLevel().addChild(this.petInfoMC);
            tempMC = new MCLoader("module/external/BooksUI/petInfoView.swf",this.petInfoMC,1,"正在打開拉姆生活手冊......");
            tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.petBookLoadOver);
            tempMC.doLoad();
         }
      }
      
      private function petBookLoadOver(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         this.childMC = evt.getLoader();
         mainMC.addChild(this.childMC);
         GV.onlineSocket.addEventListener("removeGuideHandler",this.removePetInfoHandler);
         var mcloader:MCLoader = evt.target as MCLoader;
         mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.petBookLoadOver);
         mcloader.clear();
      }
      
      private function removePetInfoHandler(evt:Event = null) : void
      {
         var main:MovieClip = this.childMC.content.root["main"];
         GC.clearAllChildren(main);
         this.petInfoMC.parent.removeChild(this.petInfoMC);
         this.petInfoMC = null;
         GV.onlineSocket.removeEventListener("removeGuideHandler",this.removePetInfoHandler);
      }
      
      private function petOverHandler(evt:MouseEvent) : void
      {
         evt.currentTarget.parent.gotoAndStop(2);
      }
      
      private function petOutHandler(evt:MouseEvent) : void
      {
         evt.currentTarget.parent.gotoAndStop(1);
      }
      
      private function petHelpHandler(evt:MouseEvent) : void
      {
         var tempMC:Class = null;
         if(!MainManager.getGameLevel().getChildByName("petHelpMC"))
         {
            tempMC = GV.Lib_Map.getClass("help_mc");
            this.petHelpMC = new tempMC();
            this.petHelpMC.name = "petHelpMC";
            MainManager.getGameLevel().addChild(this.petHelpMC);
            this.petHelpMC.x = (MainManager.getStageWidth() - this.petHelpMC.width) / 2;
            this.petHelpMC.y = (MainManager.getStageHeight() - this.petHelpMC.height) / 2;
            this.petHelpMC.closeBtn.addEventListener(MouseEvent.CLICK,this.removePetHelpMC);
         }
      }
      
      private function removePetHelpMC(evt:MouseEvent = null) : void
      {
         this.petHelpMC.closeBtn.removeEventListener(MouseEvent.CLICK,this.removePetHelpMC);
         GC.stopAllMC(this.petHelpMC);
         GC.clearChildren(this.petHelpMC);
         this.petHelpMC.parent.removeChild(this.petHelpMC);
         this.petHelpMC = null;
      }
      
      private function petbookHandler(evt:MouseEvent) : void
      {
         if(this.petTotalNum >= 1)
         {
            if(!MainManager.getGameLevel().getChildByName("petbookView"))
            {
               this.bookView = new MovieClip();
               this.bookView.name = "petbookView";
               MainManager.getGameLevel().addChild(this.bookView);
               this.loadBookEvent = new MCLoader("module/house/petBookView.swf",this.bookView,Loading.TITLE_AND_PERCENT,"正在打開寵物用品......");
               this.loadBookEvent.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadHouseBookHandler);
               this.loadBookEvent.doLoad();
            }
         }
         else
         {
            Alert.showAlert(MainManager.getGameLevel(),"","目前你還沒有拉姆暫時無法購買\n你可以在寵物店購買到拉姆種子哦！",Alert.IKNOW_ALERT);
         }
      }
      
      private function loadHouseBookHandler(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:* = evt.getLoader();
         mainMC.addChild(childMC);
         mainMC.x = (MainManager.getStageWidth() - mainMC.width) / 2;
         mainMC.y = (MainManager.getStageHeight() - mainMC.height) / 2;
         var petbook:petBookView = new petBookView(childMC.content.root);
         this.loadBookEvent.removeEventListener(MCLoadEvent.ON_SUCCESS,this.loadHouseBookHandler);
         this.loadBookEvent.clear();
      }
      
      private function petbookOverHandler(evt:MouseEvent) : void
      {
         depthLevel.tree_mc.petbook_mc.gotoAndPlay(2);
      }
      
      private function petbookOutHandler(evt:MouseEvent) : void
      {
         depthLevel.tree_mc.petbook_mc.gotoAndStop(1);
      }
      
      private function doorOverHandler(evt:MouseEvent) : void
      {
         controlLevel.door_mc.mc_1.gotoAndPlay(2);
         controlLevel.door_mc.mc_2.gotoAndPlay(2);
      }
      
      private function doorOutHandler(evt:MouseEvent) : void
      {
         controlLevel.door_mc.mc_1.gotoAndStop(1);
         controlLevel.door_mc.mc_2.gotoAndStop(1);
      }
      
      private function getPetCount(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(petNumRes.GET_PETNUM_SUCC,this.getPetCount);
         this.petTotalNum = evt.EventObj.Count;
         for(var i:int = 1; i <= 4; i++)
         {
            controlLevel["btn_" + i].buttonMode = true;
            controlLevel["btn_" + i].addEventListener(MouseEvent.CLICK,this.clickHandler);
         }
      }
      
      private function clickHandler(evt:MouseEvent) : *
      {
         var _array:Array = null;
         var tempMC:Class = null;
         var tempPet:Class = null;
         var petMC:* = undefined;
         var Pettemp:* = undefined;
         var levelNum:int = GF.leve(LocalUserInfo.getExp());
         if(this.petTotalNum >= 4)
         {
            Alert.showAlert(MainManager.getGameLevel(),"您的寵物超過了上限,不能再購買!","",6,"D");
            return false;
         }
         this.colorNum = Number(evt.target.name.substr(4));
         _array = GV["petColor_" + this.colorNum];
         this.colorPet = _array[8];
         if(!MainManager.getGameLevel().getChildByName("petBuy"))
         {
            tempMC = GV.Lib_Map.getClass("buy_tip");
            this.petBuy = new tempMC();
            this.petBuy.name = "petBuy";
            MainManager.getGameLevel().addChild(this.petBuy);
            this.petBuy.x = (MainManager.getStageWidth() - this.petBuy.width) / 2;
            this.petBuy.y = (MainManager.getStageHeight() - this.petBuy.height) / 2;
            tempPet = GV.Lib_Map.getClass("pet");
            petMC = new tempPet();
            petMC.x = 175;
            petMC.y = 73;
            petMC.name = "petMC";
            petMC.transform.colorTransform = new ColorTransform(_array[0],_array[1],_array[2],_array[3],_array[4],_array[5],_array[6],_array[7]);
            this.petBuy.info.text = this.colorPet + "拉姆種子需要花費1000摩爾豆,目前你所擁有的摩爾豆為" + LocalUserInfo.getYXQ().toString() + ",是否確認購買?";
            this.petBuy.addChild(petMC);
            this.petBuy.enter_btn.addEventListener(MouseEvent.CLICK,this.buyAction);
            this.petBuy.cancel_btn.addEventListener(MouseEvent.CLICK,this.removeAction);
            this.petBuy.drag_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.stargeAction);
            this.petBuy.drag_mc.addEventListener(MouseEvent.MOUSE_UP,this.stopAction);
            this.petBuy.drag_mc.addEventListener(MouseEvent.MOUSE_MOVE,this.moveAction);
         }
         else
         {
            Pettemp = this.petBuy.getChildByName("petMC");
            Pettemp.transform.colorTransform = new ColorTransform(_array[0],_array[1],_array[2],_array[3],_array[4],_array[5],_array[6],_array[7]);
            this.petBuy.info.text = this.colorPet + "種子需要花費1000摩爾豆,目前你所\n擁有的摩爾豆為" + LocalUserInfo.getYXQ().toString() + ",是否確認購買?";
         }
      }
      
      private function buyAction(evt:MouseEvent) : void
      {
         var errorTemp:Class = null;
         this.removeAction();
         if(LocalUserInfo.getYXQ() >= 1000)
         {
            this.buyPet.adoptPetAction(170001,this.colorNum,GV["petColor_" + this.colorNum][8]);
         }
         else if(!MainManager.getGameLevel().getChildByName("buy_Err"))
         {
            errorTemp = GV.Lib_Map.getClass("buy_err");
            this.buy_Err = new errorTemp();
            this.buy_Err.name = "buy_Err";
            MainManager.getGameLevel().addChild(this.buy_Err);
            this.buy_Err.x = (MainManager.getStageWidth() - this.buy_Err.width) / 2;
            this.buy_Err.y = (MainManager.getStageHeight() - this.buy_Err.height) / 2;
            this.buy_Err.enter_btn.addEventListener(MouseEvent.CLICK,this.errAction);
         }
      }
      
      private function buyOver(evt:EventTaomee) : void
      {
         var tempSuc:Class = null;
         if(!MainManager.getGameLevel().getChildByName("buySuccess"))
         {
            LocalUserInfo.countYXQ(-1000);
            tempSuc = GV.Lib_Map.getClass("buy_suc") as Class;
            this.buySuccess = new tempSuc();
            this.buySuccess.name = "buySuccess";
            MainManager.getGameLevel().addChild(this.buySuccess);
            this.buySuccess.x = (MainManager.getStageWidth() - this.buySuccess.width) / 2;
            this.buySuccess.y = (MainManager.getStageHeight() - this.buySuccess.height) / 2;
            this.buySuccess.info.text = this.colorPet + "拉姆已擺放在您的小屋中,請趕快回家看看吧!";
            this.buySuccess.enter_btn.addEventListener(MouseEvent.CLICK,this.succRemove);
            ++this.petTotalNum;
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
      
      private function succRemove(evt:MouseEvent = null) : void
      {
         this.buySuccess.enter_btn.removeEventListener(MouseEvent.CLICK,this.succRemove);
         GC.stopAllMC(this.buySuccess);
         GC.clearChildren(this.buySuccess);
         this.buySuccess.parent.removeChild(this.buySuccess);
         this.buySuccess = null;
      }
      
      private function removeAction(evt:MouseEvent = null) : void
      {
         this.petBuy.enter_btn.removeEventListener(MouseEvent.CLICK,this.buyAction);
         this.petBuy.cancel_btn.removeEventListener(MouseEvent.CLICK,this.removeAction);
         this.petBuy.drag_mc.removeEventListener(MouseEvent.MOUSE_DOWN,this.stargeAction);
         this.petBuy.drag_mc.removeEventListener(MouseEvent.MOUSE_UP,this.stopAction);
         this.petBuy.drag_mc.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveAction);
         GC.stopAllMC(this.petBuy);
         GC.clearChildren(this.petBuy);
         this.petBuy.parent.removeChild(this.petBuy);
         this.petBuy = null;
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
      
      override public function destroy() : void
      {
         GC.clearGInterval(this.maomaoT);
         BC.removeEvent(this);
         if(this.petHelpMC != null)
         {
            this.removePetHelpMC();
         }
         if(this.petBuy != null)
         {
            this.removeAction();
         }
         if(this.buySuccess != null)
         {
            this.succRemove();
         }
         if(this.buy_Err != null)
         {
            this.errAction();
         }
         if(this.petInfoMC != null)
         {
            this.removePetInfoHandler();
         }
         GV.onlineSocket.removeEventListener(adoptPetRes.ADOPTPET_OVER,this.buyOver);
         for(var i:int = 1; i <= 4; i++)
         {
            controlLevel["btn_" + i].removeEventListener(MouseEvent.CLICK,this.clickHandler);
         }
         controlLevel.petbook_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.petbookOverHandler);
         controlLevel.petbook_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.petbookOutHandler);
         controlLevel.petbook_btn.removeEventListener(MouseEvent.CLICK,this.petbookHandler);
         controlLevel.room_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.doorOverHandler);
         controlLevel.room_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.doorOutHandler);
         controlLevel.petHelp_btn.removeEventListener(MouseEvent.CLICK,this.petHelpHandler);
         controlLevel.pet2.pet_mc.removeEventListener(MouseEvent.MOUSE_OVER,this.petOverHandler);
         controlLevel.pet2.pet_mc.removeEventListener(MouseEvent.MOUSE_OUT,this.petOutHandler);
         topLevel.pet_mc.pet_mc.removeEventListener(MouseEvent.MOUSE_OVER,this.petOverHandler);
         topLevel.pet_mc.pet_mc.removeEventListener(MouseEvent.MOUSE_OUT,this.petOutHandler);
         controlLevel.petInfo_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.petInfoOverHandler);
         controlLevel.petInfo_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.petInfoOutHandler);
         controlLevel.petInfo_btn.removeEventListener(MouseEvent.CLICK,this.petInfoHandler);
         controlLevel.newPet_1.removeEventListener(MouseEvent.CLICK,this.petbookHandler);
         controlLevel.newPet_2.removeEventListener(MouseEvent.CLICK,this.petInfoHandler);
         this.playpetclass = null;
         SystemEventManager.removeEventListener("rainbow_joinRainbowSMC",this.onJoinRainbowSMC);
         SystemEventManager.removeEventListener("rainbow_Work",this.onRainBowWork);
         super.destroy();
      }
   }
}

