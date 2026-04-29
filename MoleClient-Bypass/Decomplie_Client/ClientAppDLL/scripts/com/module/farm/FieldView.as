package com.module.farm
{
   import com.common.Alert.Alert;
   import com.common.Alert.childAlert.simpleAlert;
   import com.common.data.HashMap;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.manager.AssetsManage;
   import com.core.newloader.LoaderList;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.links.Links;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.MapManageLogic.MapDepthManageLogic;
   import com.logic.MapManageLogic.MapManageLogic;
   import com.logic.MapManageLogic.MapModelLogic;
   import com.logic.socket.farm.farmSocket;
   import com.logic.socket.getSceneUserInfo.GetSceneUserInfoReq;
   import com.logic.socket.getSceneUserInfo.GetSceneUserRes;
   import com.logic.socket.home.GetHomeInfoReq;
   import com.logic.socket.home.GetHomeInfoRes;
   import com.logic.socket.home.homeSocket;
   import com.logic.socket.pig.PigSocket;
   import com.logic.switchMapLogic.switchMapLogic;
   import com.logic.task.TaskDiceCurse;
   import com.module.home.HomeEditView;
   import com.module.home.HomeHitTest;
   import com.module.home.HomeHot;
   import com.module.home.HomeView;
   import com.module.loadExtentPanel.LoadGame;
   import com.mole.app.manager.ActivityTmpDataManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.map.MapManager;
   import com.view.MapManageView.MapManageView;
   import com.view.mapView.activity.Task83.SwitchMapToAngelPark;
   import com.view.userPanelView.userPanelView;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.media.Sound;
   import flash.media.SoundLoaderContext;
   import flash.net.URLRequest;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   
   public class FieldView extends MovieClip
   {
      
      public static var instance:FieldView;
      
      public static var ismyhome:Boolean;
      
      public static var hostID:uint;
      
      public static var UserName:String;
      
      public static var FarmBGID:uint;
      
      public static var InHome:Boolean;
      
      public static var hasAlert:Boolean = false;
      
      public static var Field_Lib:AssetsManage = new AssetsManage(true);
      
      private var homeeditview:HomeEditView;
      
      public var itemBookViews:*;
      
      public var loadBookEvent:*;
      
      public var RootMC:MovieClip;
      
      public var farmWarehourseBar:FarmWarehouseBar;
      
      public var FishingMC:MovieClip;
      
      public var HomeObj:Object;
      
      public var HouseID:uint;
      
      private var mcloader:MCLoader;
      
      private var bgLoaderOver:Boolean = false;
      
      private var fieldLoaderOver:Boolean = false;
      
      public var farmlogic:FieldLogic;
      
      public var bgbmd:BitmapData;
      
      public var EditMode:Boolean;
      
      public var ChangeBGBool:Boolean;
      
      public var UIPosY:uint = 800;
      
      public var fieldManage:IFieldManage;
      
      public var backAlert:*;
      
      public var tempGoods:*;
      
      public var tempGoodsObj:*;
      
      public const FISHMAX:uint = 30;
      
      public const ANMMAX:uint = 15;
      
      public var FishNum:uint;
      
      public var AnmNum:uint;
      
      public var fishnetstatus:uint;
      
      public var fishnetui:MovieClip;
      
      public var FishArr:Array;
      
      public var insects:Array;
      
      public var AnmArr:Array;
      
      public var Locked:Boolean;
      
      public var isVip:Boolean;
      
      public var netFishingResult:Object;
      
      public var fish_btnXY:Point;
      
      private var goodsObj:Object;
      
      private var eggManage:Object;
      
      private var myalter:Object;
      
      private var hasShrimp:Boolean;
      
      private var _timeID:uint;
      
      public function FieldView()
      {
         super();
      }
      
      public static function getInstance() : FieldView
      {
         if(instance == null)
         {
            instance = new FieldView();
         }
         return instance;
      }
      
      public function setValue(tempObj:Loader, homeinfoObj:Object) : void
      {
         if(Boolean(ActivityTmpDataManager.task382OverPanel_obj))
         {
            if(ActivityTmpDataManager.task382OverPanel_obj._goId == 11)
            {
               if(ActivityTmpDataManager.task382OverPanel_obj._oneFlag == 2)
               {
                  ModuleManager.openPanel("Task382OverPanel",{"showUIType":11});
               }
            }
            if(ActivityTmpDataManager.task382OverPanel_obj._goId == 12)
            {
               if(ActivityTmpDataManager.task382OverPanel_obj._oneFlag == 1)
               {
                  ModuleManager.openPanel("Task382OverPanel",{"showUIType":12});
               }
            }
         }
         this.FishArr = new Array();
         this.AnmArr = new Array();
         this.insects = new Array();
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         this.HomeObj = homeinfoObj;
         FarmBGID = this.HomeObj.ItemInfoArr[0].ID;
         this.Locked = Boolean(this.HomeObj.PoolLock);
         this.farmlogic = FieldLogic.getInstance();
         this.farmlogic.setValue(this.HomeObj);
         this.RootMC = tempObj.content as MovieClip;
         this.farmWarehourseBar = new FarmWarehouseBar(this.RootMC.homeUIMC);
         BC.addEvent(this,GV.onlineSocket,FarmWarehouseBar.AddAnimalToFarmEvent,this.AddAnimalToFarm);
         this.farmWarehourseBar.visible = false;
         this.RootMC.btnMC.save_btn.visible = false;
         ismyhome = this.HomeObj.UserID == LocalUserInfo.getUserID();
         hostID = this.HomeObj.UserID;
         UserName = this.HomeObj.Name;
         this.isvip();
         this.initBtn();
         this.getLib();
         this.init();
         this.initHot();
         MainManager.getToolLevel().y = 0;
      }
      
      public function isvip() : void
      {
         if(ismyhome)
         {
            this.isVip = LocalUserInfo.isVIP();
            this.loadHomeground();
            return;
         }
         GV.onlineSocket.addEventListener(GetSceneUserRes.GET_SCENE_INFO,this.getSenceUserInfor);
         var info:GetSceneUserInfoReq = new GetSceneUserInfoReq();
         info.getSeceeUserInfo(hostID);
      }
      
      private function getSenceUserInfor(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(GetSceneUserRes.GET_SCENE_INFO,this.getSenceUserInfor);
         this.isVip = Boolean(GF.BT(e.EventObj.Vip,1));
         this.loadHomeground();
      }
      
      public function initHot() : void
      {
         HomeHot.init(hostID,HomeHot.HOT_TYPE_FARM);
      }
      
      public function init() : void
      {
         for(var i:uint = 0; i < this.HomeObj.AnmInfoArr.length; i++)
         {
            if(this.HomeObj.AnmInfoArr[i].Type == 0)
            {
               this.FishArr.push(this.HomeObj.AnmInfoArr[i]);
               if(this.HomeObj.AnmInfoArr[i].id == 1270021)
               {
                  this.hasShrimp = true;
               }
            }
            else if(this.HomeObj.AnmInfoArr[i].Outgo == 0 || this.HomeObj.AnmInfoArr[i].Outgo == 4 || this.HomeObj.AnmInfoArr[i].Outgo == 16)
            {
               this.AnmArr.push(this.HomeObj.AnmInfoArr[i]);
               if(this.HomeObj.AnmInfoArr[i].Type == 2)
               {
                  this.insects.push(this.HomeObj.AnmInfoArr[i]);
               }
            }
         }
         this._timeID = setInterval(this.updateLandAnm,8 * 60000);
      }
      
      public function changeBGSucc(evt:EventTaomee) : void
      {
         this.loadHomeground();
      }
      
      public function initBtn() : void
      {
         BC.addEvent(this,this.RootMC.btnMC.statusList_btn,MouseEvent.CLICK,this.openMoleHome);
         if(ismyhome)
         {
            BC.addEvent(this,this.RootMC.btnMC.pastureShop_btn,MouseEvent.CLICK,this.openPastureShopsPanel);
            BC.addEvent(this,this.RootMC.btnMC.farmdepot_btn,MouseEvent.CLICK,this.openFarmDepot);
            BC.addEvent(this,this.RootMC.btnMC.save_btn,MouseEvent.CLICK,this.dosaveFarm);
         }
         else
         {
            this.RootMC.btnMC.pastureShop_btn.visible = false;
            this.RootMC.btnMC.farmdepot_btn.visible = false;
            this.RootMC.btnMC.save_btn.visible = false;
         }
      }
      
      private function openPastureShopsPanel(e:MouseEvent = null) : void
      {
         ModuleManager.openPanel("PastureShopsPanel",null,"正在加載牧場商店",null);
      }
      
      public function putFishInFarm(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1365,this.putFishInFarm);
         if(e.EventObj.anmType == 0)
         {
            this.AddAnimalToFarmOkHandler(e);
            this.updateFishNum();
            FishJump.getInstance().FishToPool(e.EventObj.anmID);
         }
      }
      
      public function Door1(e:MouseEvent) : void
      {
         if(!this.EditMode)
         {
            try
            {
               e.currentTarget.parent.mc2.door_mc.door.gotoAndStop(1);
            }
            catch(e:Error)
            {
            }
         }
      }
      
      public function Door2(e:Event = null) : void
      {
         if(!this.EditMode)
         {
            try
            {
               e.currentTarget.parent.mc2.door_mc.door.gotoAndStop(2);
            }
            catch(e:Error)
            {
            }
         }
      }
      
      public function gotoHouse() : void
      {
         if(ismyhome)
         {
            this.switchMap();
         }
         else
         {
            BC.addEvent(this,GV.onlineSocket,GetHomeInfoRes.USER_FLAG_SUCC,this.isLockTheDoor);
            GetHomeInfoReq.UserFlag(hostID);
         }
      }
      
      public function isLockTheDoor(e:EventTaomee) : void
      {
         var lockHome:uint = uint(e.EventObj.Flag);
         if(Boolean(lockHome & 2))
         {
            trace("-----------關了門");
            Alert.showAlert(MainManager.getTopLevel(),"小屋已經被上鎖，你無法進入哦！","",6,"D");
         }
         else
         {
            trace("-----------開門");
            this.switchMap();
         }
      }
      
      public function switchMap() : void
      {
         if(GV.Room_DefaultRoomID != GV.MyInfo_userID && !GV.isChangeMap)
         {
            GV.Room_DefaultRoomID = hostID;
            GF.switchMap(hostID);
         }
      }
      
      public function moveHouseBG(e:Event) : void
      {
         var actionGoods:* = undefined;
         var movingMC:* = undefined;
         var parentMC:* = undefined;
         if(this.EditMode)
         {
            actionGoods = e.target.parent;
            movingMC = actionGoods.parent.parent;
            parentMC = actionGoods.parent.parent.parent;
            actionGoods.moving = !actionGoods.moving;
            if(Boolean(actionGoods.moving))
            {
               actionGoods.oldx = actionGoods.x;
               actionGoods.oldy = actionGoods.y;
               actionGoods.mc2.y -= 10;
               actionGoods.startDrag();
               HomeHitTest.moveHouseBG(actionGoods,movingMC);
               this.RootMC.addChild(actionGoods);
            }
            else
            {
               actionGoods.stopDrag();
               actionGoods.mc2.y += 10;
               this.doAction(actionGoods);
               HomeHitTest.stopMoveHouseBG();
               this.RootMC.tip_mc.visible = false;
               this.RootMC.tip_mc.x = 1000;
               this.RootMC.house_mc.addChild(actionGoods);
            }
         }
      }
      
      private function doAction(actionGoods:Object) : void
      {
         if(HomeHitTest.backOldPos)
         {
            trace("碰邊復位");
            actionGoods.x = actionGoods.oldx;
            actionGoods.y = actionGoods.oldy;
            actionGoods.alpha = 1;
         }
         else
         {
            this.homeeditview.homeItemArr[0].PosX = actionGoods.x;
            this.homeeditview.homeItemArr[0].PosY = actionGoods.y;
            this.homeeditview.homeItemArr[0].Direction = actionGoods.mc2.currentFrame;
         }
      }
      
      public function loadHomeground() : void
      {
         var url:String = "resource/farm/swf/" + FarmBGID + ".swf";
         this.mcloader = new MCLoader(url,this.RootMC,1,"正在加載牧場背景...");
         BC.addEvent(this,this.mcloader,MCLoadEvent.ON_SUCCESS,this.loadBGSucc);
         BC.addEvent(this,this.mcloader,MCLoadEvent.ERROR,this.loadBGErr);
         LoaderList.getInstance().addItem(this.mcloader,null,LoaderList.HIGH);
      }
      
      private function fishnetReq() : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 1901,this.netStatusSucc);
         farmSocket.netstatus();
      }
      
      private function netStatusSucc(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1901,this.netStatusSucc);
         this.fishnetstatus = e.EventObj.status;
         if(this.fishnetstatus != 0)
         {
            if(this.fishnetstatus == 1)
            {
               this.initnet();
            }
            else
            {
               this.initnet();
            }
         }
      }
      
      private function initnet() : void
      {
         var ui:Class = GV.Lib_Map.getClass("fishnetUI");
         this.fishnetui = new ui();
         this.FishingMC.fishNetMC.addChild(this.fishnetui);
         this.fishnetui.btn.addEventListener(MouseEvent.CLICK,this.getAllFish);
         this.fishnetui.gotoAndStop(this.fishnetstatus);
      }
      
      private function getAllFish(e:MouseEvent) : void
      {
         if(!ismyhome)
         {
            return;
         }
         if(this.FishArr.length < 1)
         {
            Alert.showAlert(MainManager.getGameLevel(),"    魚塘裡沒有可以撈的魚哦。","",6,"D");
            return;
         }
         this.myalter = GF.showAlert(MainManager.getGameLevel(),"    使用漁網一次可以網起多條魚，你確定使用嗎？","",100,"sure,cancel",true,false,"E");
         this.myalter.addEventListener(Alert.CLICK_ + "1",this.againSureEvent);
      }
      
      private function againSureEvent(evt:Event) : void
      {
         if(this.fishnetstatus > 1)
         {
            this.fishnetui.visible = false;
            BC.addEvent(this,GV.onlineSocket,"read_" + 1902,this.netFishingSucc);
            farmSocket.netfishing();
         }
         else
         {
            Alert.showAlert(MainManager.getGameLevel(),"    啊呀，漁網已經破了，快去尤尤那買把新的吧。","",6,"D");
         }
      }
      
      private function fishing_over(e:Event) : void
      {
         GF.showAlert(GV.MC_AppLever,"這次一共打撈起" + this.netFishingResult.fishNum + "條魚，大豐收哦！","",100,"iknow",true,false,"E");
         this.fishnetui.visible = true;
      }
      
      private function netFishingSucc(e:EventTaomee) : void
      {
         var ui:Class = null;
         var uimc:DisplayObject = null;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1902,this.netFishingSucc);
         this.netFishingResult = e.EventObj;
         this.fishnetstatus = this.netFishingResult.netstatus;
         var len:uint = uint(this.netFishingResult.fisharr.length);
         if(len > 0)
         {
            ui = GV.Lib_Map.getClass("fishing_anm");
            uimc = new ui();
            GV.MC_AppLever.addChild(uimc);
            uimc.x = this.fish_btnXY.x;
            uimc.y = this.fish_btnXY.y;
            uimc.addEventListener("fishing_over",this.fishing_over);
            this.updateFishNum();
         }
         else
         {
            Alert.showAlert(MainManager.getGameLevel(),"    魚塘裡沒有可以撈的魚哦!","",6,"D");
            this.fishnetui.visible = true;
         }
      }
      
      private function loadBGErr(event:MCLoadEvent) : void
      {
         trace("加載出錯");
      }
      
      private function updateLandAnm() : void
      {
         farmSocket.animal_info_fish(1);
      }
      
      private function addWater(e:MouseEvent) : void
      {
         if(this.FishingMC.waterpot.currentFrame == 1)
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + 1367,this.addWaterSucc);
            farmSocket.animal_info_addwater();
         }
      }
      
      private function showFeedDepot(e:MouseEvent) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 1369,this.getFeedInfo);
         farmSocket.farm_feedroom();
      }
      
      private function updateFishNum() : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 1366,this.updateFishInfo);
         farmSocket.animal_info_fish(0);
      }
      
      private function updateFishInfo(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1366,this.updateFishInfo);
         this.FishArr = e.EventObj.AnmInfoArr;
      }
      
      private function showFish(e:MouseEvent = null) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 1366,this.getFishInfo);
         farmSocket.animal_info_fish(0);
      }
      
      private function addWaterSucc(e:EventTaomee) : void
      {
         this.FishingMC.waterpot.gotoAndPlay(2);
         GV.onlineSocket.dispatchEvent(new EventTaomee("add_water_success",{"target":this.FishingMC.waterPos}));
         var request:URLRequest = VL.getURLRequest("resource/farm/Animal/sound/addWater.mp3");
         var currentSound:Sound = new Sound(null,new SoundLoaderContext(1000));
         currentSound.load(request);
         try
         {
            currentSound.play(0,1);
         }
         catch(E:*)
         {
         }
      }
      
      private function getFeedInfo(e:EventTaomee) : void
      {
         var j:uint = 0;
         var serverArr:Array = e.EventObj.arr;
         var foodStr:String = GoodsInfo.getInfoById(1270001).typeObject.Food;
         var foodArr:Array = foodStr.split(",");
         var foodObjArr:Array = new Array();
         for(var i:uint = 0; i < foodArr.length; i++)
         {
            foodObjArr[i] = new Object();
            foodObjArr[i].ID = foodArr[i];
            foodObjArr[i].Count = 0;
            for(j = 0; j < serverArr.length; j++)
            {
               if(uint(serverArr[j].id) == uint(foodArr[i]))
               {
                  foodObjArr[i].Count = serverArr[j].count;
                  foodObjArr[i].ID = serverArr[j].id;
               }
            }
         }
         FeedPanel.getInstance().showPanel(foodObjArr);
      }
      
      private function getFishInfo(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1366,this.getFishInfo);
         FishPanel.getInstance().showPanel(e.EventObj.AnmInfoArr);
      }
      
      private function showHostInfo(e:MouseEvent) : void
      {
         GF.switchMap(hostID,false,2);
      }
      
      private function showkcwDepot(evt:MouseEvent) : void
      {
         GV.onlineSocket.dispatchEvent(new Event("show_insect"));
      }
      
      private function loadBGSucc(event:MCLoadEvent) : void
      {
         var a:DisplayObjectContainer;
         var b:Loader;
         var c:DisplayObject;
         var fishgame:FishingGame;
         var mcloader:MCLoader = null;
         var fieldManageClass:Class = null;
         GC.clearAllChildren(this.RootMC.control_mc);
         GC.clearAllChildren(this.RootMC.bg_mc);
         GC.clearAllChildren(this.RootMC.type_mc);
         BC.removeEvent(this,mcloader,MCLoadEvent.ON_SUCCESS,this.loadBGSucc);
         BC.removeEvent(this,mcloader,MCLoadEvent.ERROR,this.loadBGErr);
         a = event.getParent();
         b = event.getLoader();
         c = event.getContent();
         this.RootMC.type_mc.addChild(c["mc"]);
         this.RootMC.control_mc.addChild(c["out_btn"]);
         this.RootMC.control_mc.addChild(c["fish_btn"]);
         this.RootMC.control_mc.addChild(c["output_btn"]);
         this.RootMC.control_mc.addChild(c["FishingMC"]);
         this.fish_btnXY = new Point(c["fish_btn"].x,c["fish_btn"].y);
         this.FishingMC = c["FishingMC"];
         this.FishingMC.waterpot.buttonMode = true;
         this.FishingMC.LockFishMC.buttonMode = true;
         this.FishingMC.feedMC.buttonMode = true;
         this.FishingMC.kcwMC.buttonMode = true;
         if(this.Locked)
         {
            this.FishingMC.LockFishMC.gotoAndStop(2);
         }
         this.FishingMC.waterMC.gotoAndStop(this.HomeObj.PoolState + 1);
         if(this.HomeObj.PoolState == 0)
         {
         }
         fishgame = new FishingGame(this.FishingMC);
         if(this.HomeObj.FeedCount > 0)
         {
            this.FishingMC.feedMC.gotoAndStop(2);
         }
         if(ismyhome)
         {
            if(this.hasShrimp)
            {
               this.FishingMC.fishOrShrimp.gotoAndStop(2);
            }
         }
         this.RootMC.username_mc.txt.text = this.HomeObj.Name;
         BC.addEvent(this,GV.onlineSocket,"HOME_HIT",this.outHomeORinHouse);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1371,this.lockOrunlockPool);
         BC.addEvent(this,this.FishingMC.waterpot,MouseEvent.CLICK,this.addWater);
         BC.addEvent(this,this.FishingMC.LockFishMC,MouseEvent.CLICK,this.lockPool);
         BC.addEvent(this,c["output_btn"],MouseEvent.CLICK,this.showOutput);
         BC.addEvent(this,c["fish_btn"],MouseEvent.CLICK,this.showFish);
         BC.addEvent(this,this.FishingMC.feedMC,MouseEvent.CLICK,this.showFeedDepot);
         BC.addEvent(this,this.FishingMC.feedMC,MouseEvent.MOUSE_OVER,this.tips);
         BC.addEvent(this,this.FishingMC.feedMC,MouseEvent.MOUSE_OUT,this.hidetips);
         BC.addEvent(this,this.FishingMC.kcwMC,MouseEvent.CLICK,this.showkcwDepot);
         BC.addEvent(this,this.FishingMC.kcwMC,MouseEvent.MOUSE_OVER,this.tips);
         BC.addEvent(this,this.FishingMC.kcwMC,MouseEvent.MOUSE_OUT,this.hidetips);
         BC.addEvent(this,c["output_btn"],MouseEvent.MOUSE_OVER,this.tips);
         BC.addEvent(this,c["fish_btn"],MouseEvent.MOUSE_OVER,this.tips);
         BC.addEvent(this,c["output_btn"],MouseEvent.MOUSE_OUT,this.hidetips);
         BC.addEvent(this,c["fish_btn"],MouseEvent.MOUSE_OUT,this.hidetips);
         BC.addEvent(this,this.RootMC.username_mc.btnContain.homeBtn,MouseEvent.CLICK,this.gotoHome);
         BC.addEvent(this,this.RootMC.username_mc.btnContain.angelBtn,MouseEvent.CLICK,this.gotoAngelFun);
         BC.addEvent(this,this.RootMC.username_mc.btnContain.seaBtn,MouseEvent.CLICK,this.gotoSeaHouse);
         BC.addEvent(this,this.RootMC.username_mc.btnContain.pigHouseBtn,MouseEvent.CLICK,this.gotoPigHouse);
         BC.addEvent(this,this.RootMC.username_mc.btnContain.restaurantBtn,MouseEvent.CLICK,this.gotoRestaurant);
         BC.addEvent(this,this.RootMC.username_mc.btnContain,MouseEvent.ROLL_OVER,this.showBtnPanel);
         BC.addEvent(this,this.RootMC.username_mc.btnContain,MouseEvent.ROLL_OUT,this.hideBtnPanel);
         BC.addEvent(this,this.RootMC.username_mc.btnContain.mapBtn,MouseEvent.CLICK,this.openMap);
         tip.tipTailDisPlayObject(this.RootMC.username_mc.btnContain.homeBtn,"我的家園");
         tip.tipTailDisPlayObject(this.RootMC.username_mc.btnContain.angelBtn,"天使園");
         tip.tipTailDisPlayObject(this.RootMC.username_mc.btnContain.seaBtn,"海妖館");
         tip.tipTailDisPlayObject(this.RootMC.username_mc.btnContain.pigHouseBtn,"肥肥館");
         tip.tipTailDisPlayObject(this.RootMC.username_mc.btnContain.restaurantBtn,"餐廳");
         this.initslMessBtn();
         FishJump.getInstance().init(this.FishArr,this.RootMC.doorName_mc,new Point(c["fish_btn"].x,c["fish_btn"].y));
         mcloader = event.target as MCLoader;
         mcloader.clear();
         this.bgLoaderOver = true;
         trace(c["numChildren"]);
         GC.clearAllChildren(this.RootMC.hittest_mc);
         this.RootMC.hittest_mc.addChild(c["item_mc"]);
         this.RootMC.hittest_mc.addChild(c["housebg_mc"]);
         trace(this.RootMC.hittest_mc.numChildren);
         if(Boolean(this.RootMC.bg_mc))
         {
            this.RootMC.bg_mc.addChild(c["bg"]);
         }
         if(this.ChangeBGBool)
         {
            MapManageLogic.addBackgroud(c["bg"]);
            if(Boolean(this.fieldManage))
            {
               this.fieldManage.clearCrop();
            }
            this.fieldManage = null;
            fieldManageClass = Field_Lib.getClass("FieldManage");
            this.fieldManage = new fieldManageClass();
            this.fieldManage.editMode = this.EditMode;
            this.fieldManage.setRootMC(this.RootMC);
            this.fieldManage.hostUseID = hostID;
            setTimeout(function():void
            {
               fieldManage.showAnimals(AnmArr);
            },1000);
            MapModelLogic.owner.makeMapArray(true);
         }
         else
         {
            this.checkLoadedOver(c);
         }
         this.fishnetReq();
      }
      
      private function showBtnPanel(evt:MouseEvent) : void
      {
         if(this.RootMC.username_mc.btnContain.currentFrame == 1)
         {
            this.RootMC.username_mc.btnContain.gotoAndPlay(2);
            this.RootMC.username_mc.map_mc.gotoAndPlay(2);
         }
      }
      
      private function hideBtnPanel(evt:MouseEvent) : void
      {
         this.RootMC.username_mc.btnContain.gotoAndStop(1);
         this.RootMC.username_mc.map_mc.gotoAndStop(1);
      }
      
      private function openMap(evt:MouseEvent) : void
      {
         ModuleManager.openPanel("HomeMapPanel");
      }
      
      public function gotoHome(evt:MouseEvent) : void
      {
         MapManager.enterMap(0,1);
      }
      
      private function gotoAngelFun(e:MouseEvent) : void
      {
         BC.removeEvent(this,e.currentTarget,MouseEvent.CLICK,this.gotoAngelFun);
         SwitchMapToAngelPark.instance.loadSwitchMV(hostID,this.RootMC.btnMC);
      }
      
      private function gotoSeaHouse(event:MouseEvent) : void
      {
         TaskDiceCurse.inst.openSystem();
      }
      
      private function gotoPigHouse(event:MouseEvent) : void
      {
         var obj:Object = null;
         if(hostID != LocalUserInfo.getUserID())
         {
            obj = {"friend":hostID};
            BC.addOnceEvent(this,GV.onlineSocket,"read_" + PigSocket.GetFriendsInfoCmd,this.GetFriendInfoHandler);
            PigSocket.GetFriendsInfo([obj]);
         }
         else
         {
            GF.switchToPigHouse(hostID);
         }
      }
      
      private function GetFriendInfoHandler(e:EventTaomee) : void
      {
         var obj:HashMap = e.EventObj as HashMap;
         var tmp:int = obj.getValue(hostID);
         if(tmp == 0)
         {
            Alert.smileAlart("        它的肥肥館還沒有建好哦！");
         }
         else
         {
            GF.switchToPigHouse(hostID);
         }
      }
      
      private function gotoRestaurant(evt:MouseEvent) : void
      {
         MapManageView.inst.gotoRestaurant();
      }
      
      private function initslMessBtn() : void
      {
         BC.addEvent(this,GV.onlineSocket,"get_scene_info",this.onIsVip);
         new GetSceneUserInfoReq().getSeceeUserInfo(this.HomeObj.UserID);
      }
      
      private function onIsVip(evt:EventTaomee) : void
      {
         var syday:int = 0;
         BC.removeEvent(this,GV.onlineSocket,"get_scene_info",this.onIsVip);
         var vip:Boolean = Boolean(evt.EventObj.Vip >> 0 & 1);
         if(vip)
         {
            if(HomeView.ismyhome)
            {
               syday = LocalUserInfo.vipDays;
               if(syday <= 7)
               {
                  this.RootMC.username_mc.slMessBtn.gotoAndStop(1);
                  this.RootMC.username_mc.slMessBtn.gotoAndStop(2);
               }
            }
            this.RootMC.username_mc.slMessBtn.visible = true;
            this.RootMC.username_mc.slMessBtn.buttonMode = true;
            BC.addEvent(this,this.RootMC.username_mc.slMessBtn,MouseEvent.CLICK,this.onSlMessBtn);
         }
         else if(HomeView.ismyhome)
         {
            if(Boolean(LocalUserInfo.getVip() >> 5 & 1))
            {
               this.RootMC.username_mc.slMessBtn.gotoAndStop(3);
               this.RootMC.username_mc.slMessBtn.visible = true;
               this.RootMC.username_mc.slMessBtn.buttonMode = true;
               BC.addEvent(this,this.RootMC.username_mc.slMessBtn,MouseEvent.CLICK,this.onSlMessBtn);
            }
         }
      }
      
      private function onSlMessBtn(e:MouseEvent) : void
      {
         var loadGame:LoadGame = null;
         if(!this.EditMode)
         {
            loadGame = new LoadGame("module/external/SuperLamuMessageMain.swf","正在加載超級拉姆面板",MainManager.getGameLevel());
            loadGame = null;
         }
      }
      
      private function gotohome(e:MouseEvent) : void
      {
         if(!this.EditMode)
         {
            GV.Room_DefaultRoomID = 0;
            LocalUserInfo.setMapID(0);
            MainManager.getToolLevel().y = 0;
            GV.Room_DefaultRoomID = hostID + GV.TwentyBillion;
            switchMapLogic.switchMapLogicHandler(hostID + GV.TwentyBillion);
         }
      }
      
      private function showUserInfo(e:MouseEvent) : void
      {
         userPanelView.showUserPanel(hostID);
      }
      
      private function tips(e:MouseEvent) : void
      {
         var tar:Object = e.currentTarget;
         if(tar.name == "fish_btn")
         {
            GF.showTip("摩爾魚塘",{
               "noDelay":true,
               "x":e.stageX,
               "y":e.stageY - 50
            });
         }
         else if(tar.name == "output_btn")
         {
            GF.showTip("摩摩倉庫",{
               "noDelay":true,
               "x":e.stageX,
               "y":e.stageY - 50
            });
         }
         else if(tar.name == "feedMC")
         {
            GF.showTip("添加飼料",{
               "noDelay":true,
               "x":e.stageX,
               "y":e.stageY - 50
            });
         }
         else if(tar.name == "kcwMC")
         {
            GF.showTip("昆蟲小屋",{
               "noDelay":true,
               "x":e.stageX,
               "y":e.stageY - 20
            });
         }
      }
      
      private function hidetips(e:MouseEvent) : void
      {
         GF.clearTip();
      }
      
      private function outHomeORinHouse(e:EventTaomee) : void
      {
         if(e.EventObj == 1)
         {
            GV.Room_DefaultRoomID = 0;
            LocalUserInfo.setMapID(0);
            switchMapLogic.switchMapLogicHandler(GV.MyInfo_PrevMap);
         }
         else
         {
            this.gotoHouse();
         }
      }
      
      private function showOutput(e:MouseEvent) : void
      {
         OutputPanel.getInstance().getOutputNum();
      }
      
      private function lockOrunlockPool(e:EventTaomee) : void
      {
         if(e.EventObj.Flag == 0)
         {
            this.Locked = false;
            this.FishingMC.LockFishMC.gotoAndStop(1);
         }
         else if(e.EventObj.Flag == 2)
         {
            this.Locked = true;
            this.FishingMC.LockFishMC.gotoAndStop(2);
         }
      }
      
      private function unlockpool(e:Event) : void
      {
         farmSocket.lockPool(0);
      }
      
      private function dolockpool(e:Event) : void
      {
         farmSocket.lockPool(2);
      }
      
      private function lockPool(e:MouseEvent) : void
      {
         var msg:String = null;
         var myAlert:simpleAlert = null;
         if(ismyhome)
         {
            if(this.Locked)
            {
               msg = "    你真的想開放自己的魚塘嗎？這樣其他小摩爾就能來你家釣魚啦！";
               myAlert = Alert.showAlert(MainManager.getAppLevel(),"",msg,Alert.SELECT_ALERT);
               BC.addEvent(this,myAlert,"CLICK" + 1,this.unlockpool);
            }
            else
            {
               msg = "    你真的想鎖上自己的魚塘嗎？這樣其他小摩爾就不能來你家釣魚啦！";
               myAlert = Alert.showAlert(MainManager.getAppLevel(),"",msg,Alert.SELECT_ALERT);
               BC.addEvent(this,myAlert,"CLICK" + 1,this.dolockpool);
            }
         }
      }
      
      private function checkLoadedOver(c:* = null) : void
      {
         var eggManageClass:Class = null;
         var fieldManageClass:Class = null;
         if(this.bgLoaderOver && this.fieldLoaderOver)
         {
            eggManageClass = Field_Lib.getClass("EggManage");
            this.eggManage = new eggManageClass();
            this.eggManage.init(this.HomeObj.EggInfoArr,this.FishingMC.eggRoom);
            BC.addEvent(this,GV.onlineSocket,"set_egg",this.AddAnimalToFarmOkHandler);
            fieldManageClass = Field_Lib.getClass("FieldManage");
            this.fieldManage = new fieldManageClass();
            BC.addEvent(this,this.fieldManage,FieldEvent.FIELD_SUCCEED,this.AddAnimalToFarmOkHandler);
            this.fieldManage.editMode = this.EditMode;
            this.fieldManage.setRootMC(this.RootMC);
            this.fieldManage.hostUseID = hostID;
            setTimeout(function():void
            {
               fieldManage.showAnimals(AnmArr);
            },1000);
            GV.onlineSocket.dispatchEvent(new EventTaomee("allFarmGoodsLoaded"));
            MapDepthManageLogic.compositorMapDepth();
            GC.setGTimeout(function():void
            {
               MapDepthManageLogic.compositorMapDepth();
               MapDepthManageLogic.setAllPeopleDepth();
            },100);
         }
      }
      
      private function buyGoods(e:EventTaomee) : void
      {
         var temp:MovieClip = null;
         for(var i:uint = 0; i < 10; i++)
         {
            temp = this.farmWarehourseBar.GetItemByIndex(i);
            if(temp["ID"] > 0 && temp["ID"] == e.EventObj.obj.ID)
            {
               return;
            }
         }
      }
      
      private function AddAnimalToFarmOkHandler(e:EventTaomee) : void
      {
         this.farmWarehourseBar.updateWarehouseData(e);
      }
      
      private function getLib() : void
      {
         BC.addEvent(this,Field_Lib,AssetsManage.ON_COMPLETE,this.loadLibcomplete);
         Field_Lib.IncludeLib("Field_Lib",Links.getUrl("module/field/FieldManage.swf"),"正在加載牧場...");
      }
      
      private function loadLibcomplete(E:Event) : void
      {
         BC.removeEvent(this,Field_Lib,AssetsManage.ON_COMPLETE,this.loadLibcomplete);
         this.fieldLoaderOver = true;
         this.checkLoadedOver();
      }
      
      private function openMoleHome(e:MouseEvent) : void
      {
         HomeView.hostID = FieldView.hostID;
         HomeView.ismyhome = FieldView.ismyhome;
         HomeHot.showPanel();
      }
      
      private function dosaveFarm(e:MouseEvent) : void
      {
         this.EditMode = false;
         HomeEditView.Editable = this.EditMode;
         this.fieldManage.editMode = this.EditMode;
         this.farmWarehourseBar.visible = false;
         this.RootMC.btnMC.save_btn.visible = false;
         MainManager.getToolLevel().y = 0;
         MoveTo.CanMove = true;
         this.farmlogic.showPeople();
         MapDepthManageLogic.compositorMapDepth();
      }
      
      private function openFarmDepot(e:MouseEvent) : void
      {
         if(!this.EditMode)
         {
            this.farmWarehourseBar.visible = true;
            this.EditMode = !this.EditMode;
            this.fieldManage.editMode = this.EditMode;
            this.RootMC.btnMC.save_btn.visible = this.EditMode;
            GF.clearPeoples();
            MainManager.getToolLevel().y = 1000;
            MoveTo.CanMove = false;
         }
         else
         {
            this.farmWarehourseBar.OpenOrCloseBar();
         }
      }
      
      private function AddAnimalToFarm(e:EventTaomee) : void
      {
         this.goodsObj = GoodsInfo.getInfoById(int(e.EventObj));
         var water:int = int(this.goodsObj.water);
         if(water == 0)
         {
            if(this.FishArr.length < this.FISHMAX)
            {
               if(this.goodsObj.buyLevel == 0 || this.goodsObj.buyLevel == null)
               {
                  BC.addEvent(this,GV.onlineSocket,"read_" + 1365,this.putFishInFarm);
                  farmSocket.feed_animal(this.goodsObj.ID);
               }
               else
               {
                  this.checkIsBuy();
               }
            }
            else
            {
               Alert.showAlert(MainManager.getGameLevel(),"    你的魚塘太擁擠了，已經不能再養更多的魚了！","",6,"D");
            }
         }
         else if(this.goodsObj.water == 2 || this.goodsObj.water == 4)
         {
            if(this.insects.length < (this.HomeObj.InsectsType + 1) * 8)
            {
               if(this.goodsObj.buyLevel == 0 || this.goodsObj.buyLevel == null)
               {
                  this.fieldManage.planting(this.goodsObj.ID);
               }
               else
               {
                  this.checkIsBuy();
               }
            }
            else
            {
               Alert.showAlert(MainManager.getGameLevel(),"    你的昆蟲小屋太擁擠了，已經不能再養更多的動物了！","",6,"D");
            }
         }
         else if(this.goodsObj.water == 1)
         {
            if(this.goodsObj.buyLevel == 0 || this.goodsObj.buyLevel == null)
            {
               this.fieldManage.planting(this.goodsObj.ID);
            }
            else
            {
               this.checkIsBuy();
            }
         }
         else if(this.goodsObj.water == 3)
         {
            if(this.goodsObj.buyLevel == 0 || this.goodsObj.buyLevel == null)
            {
               this.eggManage.addEgg(this.goodsObj.ID);
            }
            else
            {
               this.checkIsBuy();
            }
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
         if(this.goodsObj.water == 0)
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + 1365,this.putFishInFarm);
            farmSocket.feed_animal(this.goodsObj.ID);
         }
         else if(this.goodsObj.water == 3)
         {
            this.eggManage.addEgg(this.goodsObj.ID);
         }
         else
         {
            this.fieldManage.planting(this.goodsObj.ID);
         }
      }
      
      private function removeEventHandler(E:Event) : void
      {
         clearInterval(this._timeID);
         MainManager.getToolLevel().y = 0;
         this.ChangeBGBool = false;
         this.fieldManage.clearCrop();
         InHome = false;
         ismyhome = false;
         this.bgLoaderOver = false;
         this.fieldLoaderOver = false;
         this.EditMode = false;
         BC.removeEvent(this);
         this.farmWarehourseBar.Clear();
      }
   }
}

