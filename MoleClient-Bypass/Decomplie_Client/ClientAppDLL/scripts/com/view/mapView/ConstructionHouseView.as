package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.manager.AssetsManage;
   import com.core.newloader.BaseMCLoader;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.staticData.CommandID;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.JobLogic.JobLogic;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.NPCJob.NpcJobSocket;
   import com.logic.socket.ParseSocketErrorCode;
   import com.logic.socket.ballot.NpcBallotSocket;
   import com.logic.socket.oneBigStreetSocket.oneBigStreetSocket;
   import com.logic.socket.propMake.propMakeSocket;
   import com.module.activityModule.Presented;
   import com.module.deal.Deal;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.npc.NPC;
   import com.module.npc.NPCEvent;
   import com.module.npc.npcInstance.MoleNPC;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.OnlineManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.map.MapManager;
   import com.mole.app.task.Task;
   import com.mole.app.task.TaskManager;
   import com.mole.app.task.type.TaskStateType;
   import com.mole.info.ItemInfo;
   import com.mole.net.events.SocketEvent;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class ConstructionHouseView extends MapBase
   {
      
      public var button_mc:MovieClip;
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var top_mc:MovieClip;
      
      private var smcAlert:*;
      
      private var smcAlert2:*;
      
      private var npc5:MoleNPC;
      
      private var hasPaas1:Boolean;
      
      private var hasPaas2:Boolean;
      
      private var hasPaas3:Boolean;
      
      private var createShopAssets:AssetsManage;
      
      private var hasPushfoodPan:Boolean = false;
      
      private var iscancal:Boolean = false;
      
      private var makePropID:int;
      
      private var makePropNum:int;
      
      private var makePropMC:MovieClip;
      
      private var constructionBook:MovieClip;
      
      public function ConstructionHouseView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.top_mc = GV.MC_mapFrame["top_mc"];
         this.button_mc = GV.MC_mapFrame["buttonLevel"];
         BC.addEvent(this,this.button_mc.hit2MC,"onHit",this.gameStartHandler);
         BC.addEvent(this,this.button_mc.hit2MC2,"onHit",this.gotoElevatorHandler);
         BC.addEvent(this,GV.onlineSocket,"construction_paper_game_event",this.construction_paper_game_eventHandler);
         BC.addEvent(this,this.target_mc.book_btn,MouseEvent.CLICK,this.book_btnClickHandler);
         BC.addEvent(this,this.button_mc.bookMc_btn,MouseEvent.CLICK,this.book_btnClickHandler);
         BC.addEvent(this,this.depth_mc.elevator_mc,"elevator_up_event",this.elevator_up_eventHandler);
         BC.addEvent(this,this.depth_mc.elevator_mc,"elevator_down_event",this.elevator_down_eventHandler);
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getPayNumHandler);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),190643,2,190646);
         if(JobLogic.hasgot190645)
         {
            this.smcAlert2 = Alert.getIconByID_Alart(190645,"    你得到了一個" + GoodsInfo.getItemNameByID(190645) + "，已經放入你的百寶箱中了！");
            this.smcAlert2.addEventListener("CLICK" + 1,this.smcAlert2Click1);
            this.hasPaas3 = true;
            JobLogic.hasgot190645 = false;
         }
         if(JobLogic.got180065)
         {
            JobLogic.got180065 = false;
            Presented.getInstance().FreeReceiveBy1117(34);
         }
         BC.addEvent(this,this.target_mc["toukui_btn"],MouseEvent.CLICK,this.toukuiClick);
         this.makePropMC = this.target_mc["makePropMC"] as MovieClip;
         this.makePropMC.colorObj = GV.MAN_PEOPLE.colorObj;
         BC.addEvent(this,this.makePropMC,MouseEvent.CLICK,this.makePropFun);
         BC.addEvent(this,this.makePropMC,MouseEvent.MOUSE_OVER,this.makePropFun);
         BC.addEvent(this,this.makePropMC,MouseEvent.MOUSE_OUT,this.makePropFun);
         BC.addEvent(this,GV.onlineSocket,"make_prop",this.makePropHandler);
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_-100154",this.makePropError);
         BC.addEvent(this,this.makePropMC,"play_over",this.makePropFun);
         BC.addEvent(this,GV.onlineSocket,"build_over",this.build_overHandler);
         BC.addEvent(this,NPCEvent,NPCEvent.ON_NPC_LOADED,this.checkTask561);
      }
      
      private function onNPCOldJob(e:Event) : void
      {
         var id:uint = 221;
         var Tasks:Task = TaskManager.getTask(id);
         var State:uint = TaskManager.getTaskState(id);
         var _t:MapBase = this;
         if(State == 1)
         {
            if(this.hasPaas1 != true && this.hasPaas2 != true && this.hasPaas3 != true)
            {
               mapSay(1001);
            }
            else if(this.hasPaas1 == true && this.hasPaas2 != true && this.hasPaas3 != true)
            {
               mapSay(1002);
            }
            else if(this.hasPaas1 == true && this.hasPaas2 == true && this.hasPaas3 != true)
            {
               mapSay(1003);
            }
            else if(this.hasPaas1 == true && this.hasPaas2 == true && this.hasPaas3 == true)
            {
               if(LocalUserInfo.getStrong() >= 20)
               {
                  Tasks.over();
                  Tasks.checkEnterMap(100000003);
               }
            }
         }
         else if(State == 0)
         {
            Tasks.checkEnterMap(100000001);
         }
         else if(State == 2)
         {
            Tasks.checkEnterMap(100000004);
         }
      }
      
      private function overTaskTip(e:Event) : void
      {
         var url:String = GoodsInfo.getItemPathByID(13310) + "13310.swf";
         var msg:String = "    恭喜你獲得建築師套裝！快穿齊它吧！";
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
      }
      
      private function onTask221ingame1(e:SystemEvent) : void
      {
         BC.addEvent(this,GV.onlineSocket,"SMC_ITEMID_ONE",this.smc_itemed_oneHandler);
         ModuleManager.openPanel("Task221Game1");
      }
      
      private function onTask221ingame2(e:SystemEvent) : void
      {
         this.button_mc.chair_mc.buttonMode = true;
         this.target_mc.jiantou_mc.visible = true;
         this.target_mc.jiantou_mc.play();
      }
      
      private function onTask221ingame3(e:SystemEvent) : void
      {
      }
      
      override public function init() : void
      {
         super.init();
         SystemEventManager.addEventListener("tommy_task221_ingame1",this.onTask221ingame1);
         SystemEventManager.addEventListener("tommy_task221_ingame2",this.onTask221ingame2);
         SystemEventManager.addEventListener("tommy_task221_ingame3",this.onTask221ingame3);
         SystemEventManager.addEventListener("tommy_checkHasCard",this.onCheckHasCard);
         SystemEventManager.addEventListener("tommy_hasYXB",this.onCheckYXB);
         SystemEventManager.addEventListener("tommy_createShop",this.onCreateShop);
         SystemEventManager.addEventListener("tommy_createShopAndSetName",this.onCreateShopAndSetName);
         SystemEventManager.addEventListener("tommy_gotoMyShop",this.onGotoMyShop);
         this.npc5 = NPC.getNPCInstance(8);
         setTimeout(function():void
         {
            npc5.dialogInfo = _mapControl.getNpcDialogInfo(1);
         },1500);
         GV.onlineSocket.addEventListener("NPCOldJob",this.onNPCOldJob);
         GV.onlineSocket.addEventListener("OVERNPCOldJob",this.overTaskTip);
      }
      
      private function checkTask561(e:Event) : void
      {
         var task:Task = TaskManager.getTask(561);
         if(Boolean(task) && task.state == TaskStateType.OPEN)
         {
            if(task.buffer.step == 6)
            {
               this.npc5.visible = false;
            }
         }
      }
      
      private function onGotoMyShop(e:SystemEvent) : void
      {
         GV.onlineSocket.addEventListener("read_1027",this.onRead1027);
         oneBigStreetSocket.queryHouseByUid(GV.MyInfo_userID,31);
      }
      
      private function onRead1027(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_1027",this.onRead1027);
         if(evt.EventObj.count > 0)
         {
            GF.switchMap(evt.EventObj.uid,false,evt.EventObj.type);
         }
         else
         {
            GF.showAlert(MainManager.getGameLevel(),"    這個米米號沒有店鋪！","",100,"iknow",true,true,"E");
         }
      }
      
      private function onCreateShopAndSetName(e:SystemEvent) : void
      {
         this.createShopAndSetName();
      }
      
      private function onCreateShop(e:SystemEvent) : void
      {
         if(LocalUserInfo.getYXQ() < 3000)
         {
            mapSay(19);
            return;
         }
         if(!this.createShopAssets)
         {
            this.createShopAssets = new AssetsManage();
         }
         this.createShopAssets.IncludeLib("createShop_Lib","resource/oneBigStree/other/createShop.swf","正在打開...",true);
         MainManager.getAppLevel().addChild(this.createShopAssets.getLoader());
         this.hasPushfoodPan = true;
         this.createShopAssets.getLoader().contentLoaderInfo.sharedEvents.addEventListener("ok",this.setNameOk);
         this.createShopAssets.getLoader().contentLoaderInfo.sharedEvents.addEventListener("no",this.setNameNo);
      }
      
      private function setNameOk(E:EventTaomee) : void
      {
         this.createShopAssets.getLoader().contentLoaderInfo.sharedEvents.removeEventListener("ok",this.setNameOk);
         this.createShopAssets.getLoader().contentLoaderInfo.sharedEvents.removeEventListener("no",this.setNameNo);
         this.hasPushfoodPan = false;
         GC.clearAll(this.createShopAssets.getLoader());
         this.createShopAssets = null;
         this.createShopAndSetName(String(E.EventObj));
      }
      
      private function setNameNo(E:EventTaomee) : void
      {
         this.createShopAssets.getLoader().contentLoaderInfo.sharedEvents.removeEventListener("ok",this.setNameOk);
         this.createShopAssets.getLoader().contentLoaderInfo.sharedEvents.removeEventListener("no",this.setNameNo);
         this.hasPushfoodPan = false;
         GC.clearAll(this.createShopAssets.getLoader());
         this.createShopAssets = null;
         this.iscancal = true;
         this.createShopAndSetName();
         mapSay(16);
      }
      
      private function createShopAndSetName(name:String = "摩摩餐廳") : void
      {
         if(LocalUserInfo.getYXQ() < 3000)
         {
            mapSay(19);
            return;
         }
         GV.onlineSocket.addEventListener("read_" + 996,this.onRead996Suc);
         GV.onlineSocket.addEventListener(ParseSocketErrorCode.ERROR_CMD_ + "-100172",this.onRead996Fail_100172);
         GV.onlineSocket.addEventListener(ParseSocketErrorCode.ERROR_CMD_ + "-100176",this.onRead996Fail_100176);
         GV.onlineSocket.addEventListener(ParseSocketErrorCode.ERROR_CMD_ + "-11117",this.onRead996Fail_11117);
         GV.onlineSocket.addEventListener(ParseSocketErrorCode.ERROR_CMD_ + "-10012",this.onRead996Fail_10012);
         oneBigStreetSocket.creatHouse(name,31);
      }
      
      private function onRead996Suc(E:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 996,this.onRead996Suc);
         GV.onlineSocket.removeEventListener(ParseSocketErrorCode.ERROR_CMD_ + "-100172",this.onRead996Fail_100172);
         GV.onlineSocket.removeEventListener(ParseSocketErrorCode.ERROR_CMD_ + "-100176",this.onRead996Fail_100176);
         GV.onlineSocket.removeEventListener(ParseSocketErrorCode.ERROR_CMD_ + "-11117",this.onRead996Fail_11117);
         GV.onlineSocket.removeEventListener(ParseSocketErrorCode.ERROR_CMD_ + "-10012",this.onRead996Fail_10012);
         if(!this.iscancal)
         {
            mapSay(15);
         }
         else
         {
            mapSay(18);
         }
         LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() - 3000);
         LocalUserInfo.setHasDining(true);
      }
      
      private function onRead996Fail_100172(E:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(ParseSocketErrorCode.ERROR_CMD_ + "-100172",this.onRead996Fail_100172);
         GV.onlineSocket.removeEventListener(ParseSocketErrorCode.ERROR_CMD_ + "-100176",this.onRead996Fail_100176);
         GV.onlineSocket.removeEventListener(ParseSocketErrorCode.ERROR_CMD_ + "-11117",this.onRead996Fail_11117);
         GV.onlineSocket.removeEventListener(ParseSocketErrorCode.ERROR_CMD_ + "-10012",this.onRead996Fail_10012);
         mapSay(12);
      }
      
      private function onRead996Fail_100176(E:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(ParseSocketErrorCode.ERROR_CMD_ + "-100172",this.onRead996Fail_100172);
         GV.onlineSocket.removeEventListener(ParseSocketErrorCode.ERROR_CMD_ + "-100176",this.onRead996Fail_100176);
         GV.onlineSocket.removeEventListener(ParseSocketErrorCode.ERROR_CMD_ + "-11117",this.onRead996Fail_11117);
         GV.onlineSocket.removeEventListener(ParseSocketErrorCode.ERROR_CMD_ + "-10012",this.onRead996Fail_10012);
         mapSay(13);
      }
      
      private function onRead996Fail_11117(E:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(ParseSocketErrorCode.ERROR_CMD_ + "-100172",this.onRead996Fail_100172);
         GV.onlineSocket.removeEventListener(ParseSocketErrorCode.ERROR_CMD_ + "-100176",this.onRead996Fail_100176);
         GV.onlineSocket.removeEventListener(ParseSocketErrorCode.ERROR_CMD_ + "-11117",this.onRead996Fail_11117);
         GV.onlineSocket.removeEventListener(ParseSocketErrorCode.ERROR_CMD_ + "-10012",this.onRead996Fail_10012);
         mapSay(19);
      }
      
      private function onRead996Fail_10012(E:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(ParseSocketErrorCode.ERROR_CMD_ + "-100172",this.onRead996Fail_100172);
         GV.onlineSocket.removeEventListener(ParseSocketErrorCode.ERROR_CMD_ + "-100176",this.onRead996Fail_100176);
         GV.onlineSocket.removeEventListener(ParseSocketErrorCode.ERROR_CMD_ + "-11117",this.onRead996Fail_11117);
         GV.onlineSocket.removeEventListener(ParseSocketErrorCode.ERROR_CMD_ + "-10012",this.onRead996Fail_10012);
         oneBigStreetSocket.creatHouse("摩摩餐廳",31);
      }
      
      private function onCheckYXB(e:SystemEvent) : void
      {
         var target_mc:MovieClip = null;
         var f:Function = null;
         if(LocalUserInfo.getYXQ() < 3000)
         {
            mapSay(19);
         }
         else
         {
            target_mc = GV.MC_mapFrame["control_mc"];
            if(Boolean(target_mc) && Boolean(target_mc.gr_mc))
            {
               target_mc.gr_mc.gotoAndStop(2);
               f = function(E:Event):void
               {
                  target_mc.gr_mc.removeEventListener("over",f);
                  mapSay(21);
               };
               target_mc.gr_mc.addEventListener("over",f);
            }
            else
            {
               mapSay(21);
            }
         }
      }
      
      public function onCheckHasCard(e:SystemEvent) : void
      {
         OnlineManager.addCmdListener(CommandID.ITEMCOUNT,this.onCheckItem190658);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),190658,2);
      }
      
      private function onCheckItem190658(e:SocketEvent) : void
      {
         var itemPro:GetItemCountRes = e.bodyInfo;
         var item190658:ItemInfo = itemPro.itemHash.getValue(190658);
         if(Boolean(item190658) && item190658.count > 0)
         {
            GV.onlineSocket.addEventListener("read_" + 1027,this.onRead1027Suc);
            GV.onlineSocket.addEventListener(ParseSocketErrorCode.ERROR_CMD_ + 1027,this.onRead1027Fail);
            oneBigStreetSocket.queryHouseByUid(GV.MyInfo_userID,31);
         }
         else
         {
            mapSay(12);
         }
      }
      
      private function onRead1027Suc(E:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 1027,this.onRead1027Suc);
         GV.onlineSocket.removeEventListener(ParseSocketErrorCode.ERROR_CMD_ + 1027,this.onRead1027Fail);
         if(Boolean(E.EventObj.count))
         {
            GV.onlineSocket.addEventListener("read_" + 2008,this.onRead102008Suc);
            GV.onlineSocket.addEventListener(ParseSocketErrorCode.ERROR_CMD_ + 2008,this.onRead102008Fail);
            NpcBallotSocket.NpcBallotReq();
         }
         else if(LocalUserInfo.isVIP())
         {
            mapSay(20);
         }
         else
         {
            mapSay(14);
         }
      }
      
      private function onRead102008Suc(E:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 2008,this.onRead102008Suc);
         GV.onlineSocket.removeEventListener(ParseSocketErrorCode.ERROR_CMD_ + 2008,this.onRead102008Fail);
         if(!GF.getBitBool(int(E.EventObj.type),7))
         {
            mapSay(22);
         }
         else
         {
            mapSay(13);
         }
      }
      
      private function onRead102008Fail(E:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 2008,this.onRead102008Suc);
         GV.onlineSocket.removeEventListener(ParseSocketErrorCode.ERROR_CMD_ + 2008,this.onRead102008Fail);
         mapSay(13);
      }
      
      private function onRead1027Fail(E:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 1027,this.onRead1027Suc);
         GV.onlineSocket.removeEventListener(ParseSocketErrorCode.ERROR_CMD_ + 1027,this.onRead1027Fail);
         mapSay(14);
      }
      
      private function getPropHandler(e:EventTaomee) : void
      {
         var obj:Object = e.EventObj;
         var item:Object = GoodsInfo.getInfoById(obj.arr[0].itemID);
         var t:int = int(GoodsInfo.getType(obj.arr[0].itemID));
         if(t == 13)
         {
            GF.showAlert(MainManager.getGameLevel(),"恭喜你獲得" + item.name + " " + obj.arr[0].count + "個，已放入你的家園倉庫中!","",100,"iknow",true,false,"E");
         }
         else if(t == 5)
         {
            GF.showAlert(MainManager.getGameLevel(),"恭喜你獲得" + item.name + " " + obj.arr[0].count + "個，已放入你的小屋倉庫中!","",100,"iknow",true,false,"E");
         }
      }
      
      private function makePropError(e:Event) : void
      {
         GF.showAlert(MainManager.getGameLevel(),"你還沒有達到條件無法製作家具哦，在仔細檢查下缺少什麼道具吧！","",100,"iknow",true,false,"E");
      }
      
      private function makePropHandler(e:EventTaomee) : void
      {
         this.makePropID = e.EventObj.typeID;
         this.makePropNum = e.EventObj.num;
         if(this.makePropID != -1)
         {
            this.makePropMC.gotoAndPlay(3);
         }
         else
         {
            this.showPeople();
         }
      }
      
      private function mpUIHandler(event:MCLoadEvent) : void
      {
         event.currentTarget.addEventListener(MCLoadEvent.ON_SUCCESS,this.mpUIHandler);
         var content:DisplayObject = event.getContent();
         var mc:Sprite = event.getParent() as Sprite;
         mc.addChild(content);
         BaseMCLoader(event.currentTarget).clear();
      }
      
      private function makePropFun(e:Event) : void
      {
         var p:PeopleManageView = null;
         var tempMC:Sprite = null;
         var mcloader:BaseMCLoader = null;
         if(e.type == MouseEvent.CLICK)
         {
            if(MainManager.getTopLevel().getChildByName("makePropSWF") == null)
            {
               MoveTo.CanMove = false;
               p = GV.MAN_PEOPLE as PeopleManageView;
               p.hitBtn.visible = false;
               p.visible = false;
               if(Boolean(p.pet_hitBtn))
               {
                  p.pet_hitBtn.visible = false;
               }
               this.makePropMC.gotoAndStop(2);
               tempMC = new Sprite();
               tempMC.name = "makePropSWF";
               MainManager.getTopLevel().addChild(tempMC);
               mcloader = new BaseMCLoader("module/external/PropWork.swf",tempMC);
               mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,this.mpUIHandler);
               mcloader.doLoad();
            }
         }
         else if(e.type == MouseEvent.MOUSE_OVER)
         {
            if(this.makePropMC.currentFrame == 1)
            {
               this.makePropMC.buttonMode = true;
               GF.showTip("建築師工作區");
            }
            else
            {
               this.makePropMC.buttonMode = false;
            }
         }
         else if(e.type == MouseEvent.MOUSE_OUT)
         {
            GF.clearTip();
         }
         else if(e.type == "play_over")
         {
            this.showPeople();
            if(this.makePropID != -1)
            {
               BC.addEvent(this,GV.onlineSocket,"read_" + 1995,this.getPropHandler);
               propMakeSocket.propmake(this.makePropID,this.makePropNum);
            }
         }
      }
      
      private function showPeople() : void
      {
         MoveTo.CanMove = true;
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         p.hitBtn.visible = true;
         p.visible = true;
         if(Boolean(p.pet_hitBtn))
         {
            p.pet_hitBtn.visible = true;
         }
         this.makePropMC.gotoAndStop(1);
      }
      
      private function getSmcDataBack(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,NpcJobSocket.GET_SMC_INFO,this.getSmcDataBack);
         if(evt.EventObj.ser >= 5)
         {
            Deal.BuyItem(13368,1,function(... e):void
            {
               BC.removeEvent(this,target_mc["toukui_btn"],MouseEvent.CLICK,toukuiClick);
               target_mc["toukui_btn"].visible = false;
               Alert.smileAlart("    恭喜你，你拿到了皇家建築師頭盔，已經放入你的百寶箱！");
            },function(... e):void
            {
               Alert.showAlert(MainManager.getGameLevel(),"    你已經有皇家建築師頭盔囉！不能再拿啦！","",6,"E");
            });
         }
         else
         {
            Alert.smileAlart("    只有皇家建築師才能拿這個頭盔！快去建設署外面的郵箱做任務提升建築師等級吧！");
         }
      }
      
      private function toukuiClick(e:MouseEvent) : void
      {
         if(TaskManager.getTaskState(221) == 2)
         {
            BC.addEvent(this,GV.onlineSocket,NpcJobSocket.GET_SMC_INFO,this.getSmcDataBack);
            NpcJobSocket.architectInfo();
         }
         else
         {
            Alert.smileAlart("    只有皇家建築師才能拿這個頭盔！快去建設署外面的郵箱做任務提升建築師等級吧！");
         }
      }
      
      private function book_btnClickHandler(evt:MouseEvent) : void
      {
         var tempMC:MCLoader = null;
         if(!MainManager.getGameLevel().getChildByName("ConstructionBook"))
         {
            this.constructionBook = new MovieClip();
            this.constructionBook.name = "ConstructionBook";
            MainManager.getGameLevel().addChild(this.constructionBook);
            tempMC = new MCLoader("module/external/BooksUI/ConstructionBook.swf",this.constructionBook,1,"正在打開建築師手冊");
            BC.addEvent(this,tempMC,MCLoadEvent.ON_SUCCESS,this.momoDiaryLoadOver);
            tempMC.doLoad();
         }
      }
      
      private function momoDiaryLoadOver(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:* = evt.getLoader();
         mainMC.addChild(childMC);
         BC.addEvent(this,GV.onlineSocket,"monthlyCloseEvent",this.closeMomoDiaryBook);
         var mcloader:MCLoader = evt.target as MCLoader;
         BC.removeEvent(this,mcloader,MCLoadEvent.ON_SUCCESS,this.momoDiaryLoadOver);
         mcloader.clear();
      }
      
      private function closeMomoDiaryBook(evt:Event = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"monthlyCloseEvent",this.closeMomoDiaryBook);
         GC.stopAllMC(this.constructionBook);
         GC.clearChildren(this.constructionBook);
         this.constructionBook.parent.removeChild(this.constructionBook);
         this.constructionBook = null;
      }
      
      private function build_overHandler(e:EventTaomee) : void
      {
         GV.MAN_PEOPLE.visible = true;
         if(Boolean(e.EventObj.flag))
         {
            if(TaskManager.getTaskState(221) != 2)
            {
               if(TaskManager.getTaskState(221) == 1)
               {
                  Deal.BuyItem(190645,1,function(ItemnID:uint):void
                  {
                     smcAlert2 = Alert.getIconByID_Alart(190645,"    你得到了一個" + GoodsInfo.getItemNameByID(190645) + "，已經放入你的百寶箱中了！");
                     smcAlert2.addEventListener("CLICK" + 1,smcAlert2Click1);
                     hasPaas3 = true;
                  },function(E:*):void
                  {
                     Alert.getIconByID_Alart(190645,"你已經有" + GoodsInfo.getItemNameByID(190645) + "，不要太貪心哦!");
                  });
               }
            }
         }
      }
      
      private function elevator_up_eventHandler(e:Event) : void
      {
         GV.MAN_PEOPLE.visible = false;
      }
      
      private function elevator_down_eventHandler(e:Event) : void
      {
         var url:String = "module/game/BuildGame.swf";
         var msg:String = "正在加載遊戲";
         MapManager.clearMap();
         var loadGame:LoadGame = new LoadGame(url,msg,MainManager.getGameLevel());
         loadGame = null;
      }
      
      private function getPayNumHandler(eve:EventTaomee) : void
      {
         var obj:Object = null;
         var arr:Array = eve.EventObj.obj.arr;
         for each(obj in arr)
         {
            if(obj.id == 190643)
            {
               if(obj.itemCount > 0)
               {
                  this.hasPaas1 = true;
               }
            }
            else if(obj.id == 190644)
            {
               if(obj.itemCount > 0)
               {
                  this.hasPaas2 = true;
               }
            }
            else if(obj.id == 190645)
            {
               if(obj.itemCount > 0)
               {
                  this.hasPaas3 = true;
               }
            }
         }
         if(TaskManager.getTaskState(221) == 1 && this.hasPaas1 == true && this.hasPaas2 == false)
         {
            this.button_mc.chair_mc.buttonMode = true;
            this.target_mc.jiantou_mc.visible = true;
            this.target_mc.jiantou_mc.play();
         }
         else
         {
            this.button_mc.chair_mc.buttonMode = false;
         }
      }
      
      private function smc_itemed_oneHandler(e:Event) : void
      {
         Deal.BuyItem(190643,1,function(ItemnID:uint):void
         {
            smcAlert = Alert.getIconByID_Alart(190643,"    你得到了一個" + GoodsInfo.getItemNameByID(190643) + "，已經放入你的百寶箱中了！");
            hasPaas1 = true;
            button_mc.chair_mc.buttonMode = true;
            target_mc.jiantou_mc.visible = true;
            target_mc.jiantou_mc.play();
         },function(E:*):void
         {
            Alert.getIconByID_Alart(190643,"你已經有" + GoodsInfo.getItemNameByID(190643) + "，不要太貪心哦!");
         });
      }
      
      private function gotoElevatorHandler(e:Event) : void
      {
         if(TaskManager.getTaskState(221) == 2)
         {
            this.depth_mc.elevator_mc.gotoAndStop(2);
         }
         else if(TaskManager.getTaskState(221) == 1)
         {
            if(this.hasPaas1 && this.hasPaas2 && this.hasPaas3 == false)
            {
               this.depth_mc.elevator_mc.gotoAndStop(2);
            }
            else if(this.hasPaas1 && this.hasPaas2 && this.hasPaas3)
            {
               Alert.smileAlart("　　你已經完成第三個考驗，先去找湯米成為建築師再來玩夢想建築師吧！");
            }
            else
            {
               Alert.smileAlart("　　你還沒有完成湯米的前兩個考驗，才能玩夢想建築師哦！");
            }
         }
         else if(TaskManager.getTaskState(221) == 0)
         {
            Alert.smileAlart("　　你還沒有成為建築師，快去找湯米成為初級建築師吧！");
         }
      }
      
      private function construction_paper_game_eventHandler(e:EventTaomee) : void
      {
         if(e.EventObj.pass == true)
         {
            Deal.BuyItem(190644,1,function(ItemnID:uint):void
            {
               smcAlert = Alert.getIconByID_Alart(190644,"    你得到了一個" + GoodsInfo.getItemNameByID(190644) + "，已經放入你的百寶箱中了！");
               smcAlert.addEventListener("CLICK" + 1,smcAlertClick1);
               hasPaas2 = true;
               target_mc.jiantou_mc.visible = false;
               button_mc.chair_mc.buttonMode = false;
               target_mc.jiantou_mc.stop();
            },function(E:*):void
            {
               Alert.getIconByID_Alart(190644,"你已經有" + GoodsInfo.getItemNameByID(190644) + "，不要太貪心哦!");
            });
         }
      }
      
      private function smcAlertClick1(evt:*) : void
      {
         this.smcAlert.removeEventListener("CLICK" + 1,this.smcAlertClick1);
         mapSay(4);
      }
      
      private function smcAlert2Click1(evt:*) : void
      {
         this.smcAlert2.removeEventListener("CLICK" + 1,this.smcAlertClick1);
         mapSay(1);
      }
      
      private function gameStartHandler(e:Event) : void
      {
         if(this.target_mc.jiantou_mc.visible == false)
         {
            return;
         }
         var url:String = "module/game/manuscript.swf";
         var msg:String = "正在加載建築手稿";
         var loadGame:LoadGame = new LoadGame(url,msg,MainManager.getGameLevel());
         loadGame = null;
      }
      
      override public function destroy() : void
      {
         GV.onlineSocket.removeEventListener("NPCOldJob",this.onNPCOldJob);
         GV.onlineSocket.removeEventListener("OVERNPCOldJob",this.overTaskTip);
         SystemEventManager.removeEventListener("tommy_task221_ingame1",this.onTask221ingame1);
         SystemEventManager.removeEventListener("tommy_task221_ingame2",this.onTask221ingame2);
         SystemEventManager.removeEventListener("tommy_task221_ingame3",this.onTask221ingame3);
         SystemEventManager.removeEventListener("tommy_checkHasCard",this.onCheckHasCard);
         SystemEventManager.removeEventListener("tommy_hasYXB",this.onCheckYXB);
         SystemEventManager.removeEventListener("tommy_createShop",this.onCreateShop);
         SystemEventManager.removeEventListener("tommy_createShopAndSetName",this.onCreateShopAndSetName);
         SystemEventManager.removeEventListener("tommy_gotoMyShop",this.onGotoMyShop);
         GV.MAN_PEOPLE.visible = true;
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
         this.top_mc = null;
         GC.clearAll(this);
         super.destroy();
      }
   }
}

