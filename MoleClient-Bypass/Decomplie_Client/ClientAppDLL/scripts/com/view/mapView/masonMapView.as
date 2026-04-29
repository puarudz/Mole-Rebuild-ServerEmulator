package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.loading.Loading;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.NPCJob.NpcJobSocket;
   import com.logic.socket.giveMeMoney.giveMeMoneyReq;
   import com.logic.socket.giveMeMoney.giveMeMoneyRes;
   import com.logic.socket.randomItemLogic.randomItemReq;
   import com.logic.socket.randomItemLogic.randomItemRes;
   import com.logic.socket.smc.PickItem.PickItemRes;
   import com.module.LocusWork.CollectProp;
   import com.module.activityModule.checkCloth;
   import com.module.activityModule.checkItem;
   import com.module.activityModule.deleteItemModule;
   import com.module.activityModule.refurbishPeopleModule;
   import com.module.clothBuyModule.clothBuyModule;
   import com.module.deal.Deal;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.npc.NPC;
   import com.module.npc.npcInstance.MoleNPC;
   import com.module.throwThing.throwHitTest;
   import com.mole.app.info.NPCDialogInfo;
   import com.mole.app.info.NPCDialogOptionInfo;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.task.Task;
   import com.mole.app.task.TaskManager;
   import com.mole.app.task.type.TaskStateType;
   import com.mole.app.type.ActionType;
   import com.mole.app.type.ModuleType;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class masonMapView extends MapBase
   {
      
      public static const STRONG_GAME_WIN:String = "strongGameWin";
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var buyItem:giveMeMoneyReq;
      
      public var joinObj:*;
      
      private var dumplingMC:MovieClip;
      
      private var masonNPCLogic:MovieClip;
      
      public var itemBookViews:*;
      
      public var loadBookEvent:*;
      
      private var npc5:MoleNPC;
      
      private var checkID:int;
      
      public function masonMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         BC.addEvent(this,this.target_mc.bookBtn_3,MouseEvent.CLICK,this.openHomeItemBook);
         BC.addEvent(this,this.target_mc.bookBtn_4,MouseEvent.CLICK,this.openHomeItemBook);
         this.target_mc.buy_btn.addEventListener(MouseEvent.CLICK,this.foodClickHandler);
         this.target_mc.boiler_btn.buttonMode = true;
         this.target_mc.boiler_btn.addEventListener(MouseEvent.CLICK,this.boilerAction);
         this.target_mc.dumpling.addEventListener(MouseEvent.CLICK,this.dumplingHandler);
         var obj4:Object = {
            "btn":this.depth_mc.fire_mc.hitMC_btn,
            "mc":this.depth_mc.fire_mc.box,
            "id":"swf150003",
            "fre":4,
            "hide":false
         };
         var obj5:Object = {
            "btn":this.depth_mc.fire_mc.hitMC_btn,
            "mc":this.depth_mc.fire_mc.box,
            "id":"swf150001",
            "fre":1,
            "hide":false
         };
         throwHitTest.HitTestMC(obj4,obj5);
         this.initFood();
         this.initBate();
         var t:Loader = new Loader();
         var tempPath:String = "module/machine/MachineRecipe.swf";
         t.load(VL.getURLRequest(tempPath));
         MovieClip(this.target_mc.r4Loader).addChild(t);
         this.setWall();
         SystemEventManager.addEventListener("mason_sale",this.onOpenMason);
         SystemEventManager.addEventListener("task584",this.task584handle);
      }
      
      override public function init() : void
      {
         var npcOptionInfo:NPCDialogOptionInfo = null;
         var sayList:Array = new Array();
         npcOptionInfo = new NPCDialogOptionInfo("出售作物",ActionType.SYSTEM_ACT,"mason_sale");
         sayList.push(npcOptionInfo);
         npcOptionInfo = new NPCDialogOptionInfo("沒什麼事",ActionType.NONE);
         sayList.push(npcOptionInfo);
         var npcDialogInfo:NPCDialogInfo = new NPCDialogInfo(10041,"正常","你好{$username}，我是梅森，收購各種農作物。每天都會在梅森小屋等待你們的光臨哦！",sayList);
         this.npc5 = NPC.getNPCInstance(4);
         this.npc5.dialogInfo = npcDialogInfo;
      }
      
      private function task584handle(e:Event) : void
      {
         var task:Task = TaskManager.getTask(584);
         if(task.state == TaskStateType.OPEN && task.buffer.step == 2)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("meisengTaskGo"));
         }
         else
         {
            ModuleManager.openPanel(ModuleType.TOMATO_SAUCE_MAKE_PANEL);
         }
      }
      
      private function onOpenMason(e:Event) : void
      {
         this.reclaimEvent();
      }
      
      private function setWall() : void
      {
         NpcJobSocket.askNpcJob(24);
         BC.addEvent(this,GV.onlineSocket,NpcJobSocket.GET_JOB,this.getJobBack);
      }
      
      private function getJobBack(e:EventTaomee) : void
      {
         var obj:Object = e.EventObj;
         if(obj.jobID == 24)
         {
            if(obj.jobStatus == 1)
            {
               this.checkThing(190646);
               return;
            }
            if(obj.jobStatus == 0)
            {
               this.failureWall(1);
            }
            else
            {
               this.failureWall(3);
            }
         }
      }
      
      private function failureWall(frame:int = 3) : void
      {
         this.target_mc["qianglie"].gotoAndStop(frame);
         this.target_mc["qianglie"].mouseEnabled = false;
         this.target_mc["qianglie"].mouseChildren = false;
      }
      
      private function checkThing(id:int) : void
      {
         this.checkID = id;
         GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.itemSucHandler);
         checkItem.checkItemHandler(id);
      }
      
      private function itemSucHandler(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.itemSucHandler);
         var obj:Object = evt.EventObj;
         if(this.checkID == 190646)
         {
            if(obj.num < 1)
            {
               new CollectProp(this.target_mc["qianglie"],30,4);
               this.target_mc["qianglie"].gotoAndStop(4);
               BC.addEvent(this,GV.onlineSocket,CollectProp.GET_PROP,this.getPropFun);
            }
            else
            {
               this.failureWall();
            }
         }
      }
      
      private function getPropFun(e:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,CollectProp.GET_PROP,this.getPropFun);
         this.failureWall();
         Deal.BuyItem(190646,1,function(... e):*
         {
            Alert.getIconByID_Alart(190646,"    恭喜你得到" + GoodsInfo.getItemNameByID(190646) + "，快去找建設署的大郵箱交任務吧！");
         },function(... e):*
         {
            Alert.smileAlart("    你已經擁有這件寶貝啦，所以不能再領取了哦！");
         });
      }
      
      private function closeBord(e:MouseEvent) : void
      {
         this.target_mc.FertilizerBord.y = -400;
      }
      
      private function initBate() : void
      {
         var task80State:uint = TaskManager.getTaskState(80);
         if(task80State == 2)
         {
            this.target_mc.bate.visible = true;
         }
      }
      
      private function initFood() : void
      {
         this.target_mc.activMC.mc_0.mc.gotoAndStop(2);
         this.target_mc.activMC.mc_0.mc.mouseEnabled = false;
         GV.onlineSocket.addEventListener(randomItemRes.RANMOM_ITEM,this.activeHandler);
         randomItemReq.randomItemReqAction();
      }
      
      private function activeHandler(evt:EventTaomee) : void
      {
         var tempArray:Array = null;
         var itemID:int = 0;
         var j:int = 0;
         var num:int = 0;
         var tempNum:int = 0;
         this.target_mc.activMC.mc_0.mc.gotoAndStop(2);
         this.target_mc.activMC.mc_0.mc.mouseEnabled = false;
         var itemArray:Array = evt.EventObj.itemArray;
         for(var i:int = 0; i < itemArray.length; i++)
         {
            tempArray = itemArray[i].itemArray;
            itemID = int(itemArray[i].itemID);
            for(j = 0; j < tempArray.length; j++)
            {
               num = int(tempArray[j]);
               tempNum = tempArray.length - j - 1;
               if(num == 1)
               {
                  this.target_mc.activMC["mc_" + tempNum].mc.gotoAndStop(1);
                  this.target_mc.activMC["mc_" + tempNum].mc.mouseEnabled = true;
                  this.target_mc.activMC["mc_" + tempNum].discreteness.changeBool = false;
               }
            }
         }
      }
      
      private function dumplingHandler(evt:MouseEvent) : void
      {
         var tempMC:MCLoader = null;
         if(!MainManager.getAppLevel().getChildByName("dumplingMC"))
         {
            this.dumplingMC = new MovieClip();
            this.dumplingMC.name = "dumplingMC";
            MainManager.getGameLevel().addChild(this.dumplingMC);
            tempMC = new MCLoader("module/game/Dumplings.swf",this.dumplingMC,Loading.TITLE_AND_PERCENT,"正在打開遊戲");
            tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadGameOverHandler);
            tempMC.doLoad();
         }
      }
      
      private function loadGameOverHandler(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:* = evt.getLoader();
         mainMC.addChild(childMC);
         var mcloader:MCLoader = evt.target as MCLoader;
         mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.loadGameOverHandler);
         mcloader.clear();
      }
      
      private function foodClickHandler(evt:MouseEvent) : void
      {
         var itemObj:Object = new Object();
         itemObj.id = 12114;
         itemObj.price = 15;
         itemObj.info = "生粽子";
         clothBuyModule.buyAction(itemObj);
      }
      
      private function boilerAction(evt:MouseEvent) : void
      {
         var bool:Boolean = false;
         var msg:String = "";
         var mc:MovieClip = this.depth_mc.fire_mc.box;
         if(mc.currentFrame == 1 || mc.currentFrame == 2 || mc.currentFrame == 3)
         {
            msg = "你還沒有點火呢......";
            Alert.showAlert(GV.MC_AppLever,msg,"",Alert.CHANG_ALERT,"iknow",true,false,"E");
         }
         else
         {
            bool = checkCloth.doAction(12114);
            if(bool)
            {
               this.tradeItem();
            }
            else
            {
               msg = " 你手上沒有拿端午節的粽子呀！\n看看你的百寶箱裡有沒有!";
               Alert.showAlert(GV.MC_AppLever,msg,"",Alert.CHANG_ALERT,"iknow",true,false,"E");
            }
         }
      }
      
      private function tradeItem() : void
      {
         var explain:String = "要給你的寵物煮粽子吃嗎？";
         this.joinObj = Alert.showAlert(GV.MC_AppLever,"",explain,Alert.SELECT_ALERT);
         this.joinObj.addEventListener("CLICK" + 1,this.doActionHandler);
      }
      
      private function doActionHandler(evt:*) : void
      {
         GV.onlineSocket.addEventListener(deleteItemModule.DELETE_ITEM_SUCESS,this.initAction);
         deleteItemModule.doAction(12114);
      }
      
      private function initAction(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(deleteItemModule.DELETE_ITEM_SUCESS,this.initAction);
         GV.onlineSocket.addEventListener(refurbishPeopleModule.REFURBISH_PEOPLE_SUC,this.doAction);
         refurbishPeopleModule.doAction(12114);
      }
      
      private function doAction(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(refurbishPeopleModule.REFURBISH_PEOPLE_SUC,this.doAction);
         GV.onlineSocket.addEventListener(giveMeMoneyRes.SERVER_GIVEMONEY,this.getJokulAction);
         this.buyItem = new giveMeMoneyReq([],[{
            "kind":180007,
            "num":1
         }]);
      }
      
      private function getJokulAction(evt:EventTaomee) : void
      {
         var msg:String = "生粽子熟啦\n一個粽子已經在你的寵物背包裡";
         Alert.showAlert(GV.MC_AppLever,msg,"",Alert.CHANG_ALERT,"iknow",true,false,"E");
         GV.onlineSocket.removeEventListener(giveMeMoneyRes.SERVER_GIVEMONEY,this.getJokulAction);
         GF.revertPeople(GV.MyInfo_userID);
      }
      
      override public function destroy() : void
      {
         SystemEventManager.removeEventListener("mason_sale",this.onOpenMason);
         GV.onlineSocket.removeEventListener(randomItemRes.RANMOM_ITEM,this.activeHandler);
         GV.onlineSocket.removeEventListener(masonMapView.STRONG_GAME_WIN,this.stongManWinHandler);
         GV.onlineSocket.removeEventListener(PickItemRes.PICK_ITEM,this.onPickItem);
         this.target_mc.buy_btn.removeEventListener(MouseEvent.CLICK,this.foodClickHandler);
         this.target_mc.boiler_btn.removeEventListener(MouseEvent.CLICK,this.boilerAction);
         throwHitTest.removeHitTest();
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
         super.destroy();
      }
      
      private function initHandler() : void
      {
         SimpleButton(this.target_mc["hammerBtn"]).addEventListener(MouseEvent.CLICK,this.hammerGame);
         GV.onlineSocket.addEventListener(masonMapView.STRONG_GAME_WIN,this.stongManWinHandler);
         GV.onlineSocket.addEventListener(PickItemRes.PICK_ITEM,this.onPickItem);
      }
      
      private function hammerGame(event:MouseEvent) : void
      {
         var sprite:Sprite = null;
         var mcloader:MCLoader = null;
         if(!MainManager.getGameLevel().getChildByName("strongMan"))
         {
            sprite = new Sprite();
            sprite.name = "strongMan";
            MainManager.getGameLevel().addChild(sprite);
            mcloader = new MCLoader("module/game/StrongMan.swf",MainManager.getGameLevel(),1,"正在加載遊戲");
            mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,this.onLoadGame);
            mcloader.doLoad();
         }
      }
      
      private function onLoadGame(event:MCLoadEvent) : void
      {
         var container:DisplayObjectContainer = event.getParent();
         var content:DisplayObject = event.getContent();
         container.addChild(content);
      }
      
      private function stongManWinHandler(event:Event) : void
      {
         GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.onCheckItem);
         checkItem.checkItemHandler(190042);
      }
      
      private function onCheckItem(event:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.onCheckItem);
         var count:Number = Number(event.EventObj["count"]);
         if(count == 0)
         {
            GF.referItem(190042);
         }
      }
      
      private function onPickItem(event:EventTaomee) : void
      {
         Alert.showAlert(MainManager.getAppLevel(),"恭喜!\n" + GoodsInfo.getItemNameByID(190042) + "已經放入百寶箱中!","",6,"E");
      }
      
      private function reclaimEvent(e:* = null) : void
      {
         var path:String = "module/external/MasonTaomee.swf";
         var laodGame:LoadGame = new LoadGame(path,"正在加載果實交易面板......",MainManager.getAppLevel());
         laodGame = null;
      }
      
      private function openHomeItemBook(e:MouseEvent) : void
      {
         ModuleManager.openPanel("HouseShopsPanel");
      }
   }
}

