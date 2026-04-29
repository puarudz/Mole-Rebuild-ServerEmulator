package com.view.MapManageView
{
   import com.common.Alert.Alert;
   import com.common.LibLogic.LibLogic;
   import com.common.data.HashMap;
   import com.common.tip.tip;
   import com.common.util.DisplayUtil;
   import com.core.MainEntry;
   import com.core.info.LocalUserInfo;
   import com.core.loading.Loading;
   import com.core.manager.LevelManager;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.staticData.MapsConfig;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.MapManageLogic.MapManageLogic;
   import com.logic.socket.angelPark.valueObj.AngelParkVO;
   import com.logic.socket.enterMapOrRoom.EnterMapOrRoomReq;
   import com.logic.socket.oneBigStreetSocket.oneBigStreetSocket;
   import com.logic.task.TaskDiceCurse;
   import com.module.activityModule.checkItem;
   import com.module.angelPark.AngelParkView;
   import com.module.classroom.ClassroomView;
   import com.module.farm.FieldView;
   import com.module.home.HomeView;
   import com.module.lahmClassRoom.lahmClassRoomView;
   import com.module.newAngel.NewAngelParkView;
   import com.module.newHouse.newHouseView;
   import com.module.pig.BeautyHouseEntrance;
   import com.module.pig.MachinistSquareEntrance;
   import com.module.pig.PigHouseEntrance;
   import com.module.restaurant.RestaurantView;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.PeopleManager;
   import com.mole.app.manager.StatisticsManager;
   import com.mole.app.map.MapControl;
   import com.mole.app.map.MapLevel;
   import com.mole.app.map.MapManager;
   import com.mole.app.map.MapMaterialBase;
   import com.mole.app.task.TaskManager;
   import com.mole.debug.DebugManager;
   import com.view.toolView.tool.ToolSystemMenu;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MapManageView extends MovieClip
   {
      
      private static var _inst:MapManageView;
      
      private var _mapLogic:MapManageLogic;
      
      private var tempLoadClass:MCLoader;
      
      private var objEvent:Object;
      
      private var _mapControl:MapControl;
      
      private var _isTaskChangeMap:Boolean = false;
      
      private var _loadHash:HashMap = new HashMap();
      
      private var joinMap:int;
      
      private var alertObj:Object;
      
      public function MapManageView()
      {
         super();
         _inst = this;
         this._mapLogic = new MapManageLogic();
         this._mapLogic.addEventListener(MapManageLogic.data_OVER,this.onLoadMap);
         this._mapLogic.addEventListener(MapManageLogic.room_OVER,this.onLoadRoomMap);
         this._mapLogic.addEventListener(MapManageLogic.home_OVER,this.onLoadHomeMap);
         this._mapLogic.addEventListener(MapManageLogic.class_OVER,this.onLoadClassMap);
         this._mapLogic.addEventListener(MapManageLogic.farm_OVER,this.onLoadFarmMap);
         this._mapLogic.addEventListener(MapManageLogic.people_OVER,this.onPeopleOver);
         this._mapLogic.addEventListener(MapManageLogic.restaurant_OVER,this.onLoadRestaurantMap);
         this._mapLogic.addEventListener(MapManageLogic.lamuClassRoom_OVER,this.onLoadLamuClassRoomMap);
         this._mapLogic.addEventListener(MapManageLogic.AngelPark_OVER,this.onLoadAngelParkMap);
         this._mapLogic.addEventListener(MapManageLogic.PigHouse_OVER,this.onEntryPigHouse);
         this._mapLogic.addEventListener(MapManageLogic.BeautyHouse_OVER,this.onEntryBeautyHouse);
         this._mapLogic.addEventListener(MapManageLogic.MachinistSquare_OVER,this.onEntryMachinistSquare);
         this._mapLogic.addEventListener(MapManageLogic.NEW_ANGEL_PARK_OVER,this.onNewAngelEnterHandler);
      }
      
      public static function get inst() : MapManageView
      {
         return _inst;
      }
      
      private function removeControl() : void
      {
         if(Boolean(this._mapControl))
         {
            this._mapControl.destroy();
            this._mapControl = null;
         }
      }
      
      public function defaultMap(mcloader:MCLoader = null) : void
      {
         this.changeMap(LocalUserInfo.getMapID());
      }
      
      public function refreshMap() : void
      {
         this._mapLogic.refreshMap();
      }
      
      public function changeMap(mapID:uint, type:int = 0) : void
      {
         GV.isSwitchMap = true;
         this._isTaskChangeMap = true;
         this.removeAllCon();
         this._mapLogic.changeMap(mapID,type);
         switch(mapID)
         {
            case 1:
               StatisticsManager.send(61);
               break;
            case 2:
               StatisticsManager.send(62);
               break;
            case 3:
               StatisticsManager.send(63);
               break;
            case 9:
               StatisticsManager.send(64);
               break;
            case 10:
               StatisticsManager.send(65);
               break;
            case 28:
               StatisticsManager.send(66);
               break;
            case 4:
               StatisticsManager.send(67);
               break;
            case 8:
               StatisticsManager.send(68);
         }
      }
      
      private function removeAllCon() : void
      {
         this.removeMap();
         DisplayUtil.removeAllChild(LevelManager.alertLevel);
         DisplayUtil.removeAllChild(LevelManager.appLevel);
         DisplayUtil.removeAllChild(LevelManager.gameLevel);
         DisplayUtil.removeAllChild(LevelManager.dialogLevel);
         DisplayUtil.removeAllChild(LevelManager.mapMovieLevel);
         DisplayUtil.removeAllChild(LevelManager.topLevel);
         if(LevelManager.mapLevel.mouseChildren == false)
         {
            LevelManager.mapLevel.mouseChildren = true;
         }
      }
      
      public function removeMap() : void
      {
         this.removeControl();
         DisplayUtil.removeAllChild(LevelManager.mapLevel);
         GV.MC_mapFrame = null;
         MapButtonView.getTarget().destroy();
      }
      
      private function loadMap(url:String, loadDesc:String, compFun:Function, failFun:Function) : void
      {
         this.removeLoad();
         this.tempLoadClass = new MCLoader(url,null,Loading.MAIN_LOAD,loadDesc);
         this._loadHash.add(this.tempLoadClass.loader,{
            "url":url,
            "loadDesc":loadDesc,
            "compFun":compFun,
            "failFun":failFun
         });
         this.tempLoadClass.addEventListener(MCLoadEvent.ON_SUCCESS,this.onLoadComplete);
         this.tempLoadClass.addEventListener(MCLoadEvent.ERROR,this.onLoadFail);
         this.tempLoadClass.load();
      }
      
      private function onLoadComplete(e:MCLoadEvent) : void
      {
         this.removeLoad();
         this.initMap(e.getLoader());
         var loadInfo:Object = this._loadHash.remove(e.getLoader());
         if(Boolean(loadInfo))
         {
            loadInfo.compFun.call(null,e);
         }
         GV.isSwitchMap = false;
         if(Boolean(MainEntry.instance.gameBg))
         {
            DisplayUtil.removeForParent(MainEntry.instance.gameBg);
         }
      }
      
      public function initMap(mapLoader:Loader) : void
      {
         var map_mc:MovieClip = mapLoader.content as MovieClip;
         if(this.isNewMap)
         {
            map_mc = map_mc.map_mc;
         }
         LevelManager.mapLevel.addChild(map_mc);
         GV.MC_mapFrame = MovieClip(map_mc);
         GV.Lib_Map = new LibLogic(mapLoader);
         GV.MC_mapFrame.GV_Class = GV;
         GV.MC_mapFrame.GF_Class = GF;
         GV.MC_mapFrame.MoveTo_Class = MoveTo;
      }
      
      private function get isNewMap() : Boolean
      {
         var infoObj:Object = MapsConfig.MapsInfo[GV.MapInfo_mapID];
         return Boolean(infoObj) && Boolean(infoObj.isNewMap) || (LocalUserInfo.getMapID() >= 264 && LocalUserInfo.getMapID() != 327 || LocalUserInfo.getMapID() == 260 || LocalUserInfo.getMapID() == 258) && LocalUserInfo.getMapID() < 10000 && !(LocalUserInfo.getMapID() > 300 && LocalUserInfo.getMapID() <= 316);
      }
      
      private function onLoadFail(e:MCLoadEvent) : void
      {
         this.removeLoad();
         var loadInfo:Object = this._loadHash.remove(e.url);
         if(Boolean(loadInfo))
         {
            loadInfo.failFun.apply(null,e);
         }
         else if(EnterMapOrRoomReq.OldMapID > 0 && EnterMapOrRoomReq.OldMapID < 10000)
         {
            MapManager.enterMap(EnterMapOrRoomReq.OldMapID);
         }
         else
         {
            MapManager.enterMap(1);
         }
         DebugManager.traceMsg("地圖加載失敗！MapID：" + LocalUserInfo.getMapID());
      }
      
      private function removeLoad() : void
      {
         if(Boolean(this.tempLoadClass))
         {
            this.tempLoadClass.removeEventListener(MCLoadEvent.ON_SUCCESS,this.onLoadComplete);
            this.tempLoadClass.removeEventListener(MCLoadEvent.ERROR,this.onLoadMapFail);
            this.tempLoadClass.clear();
            this.tempLoadClass = null;
         }
      }
      
      private function onLoadFarmMap(evt:*) : void
      {
         GV.MapInfo_isHouse = true;
         this.objEvent = evt.EventObj;
         this.loadMap("module/farm/farm.swf","正在進入牧場中......",this.onLoadFarmSWFComplete,this.onLoadMapFail);
      }
      
      private function onLoadRestaurantMap(evt:*) : void
      {
         this.objEvent = evt.EventObj;
         this.loadMap("module/restaurant/restaurant.swf","正在進入餐廳中......",this.onLoadRestaurantComplete,this.onLoadMapFail);
      }
      
      private function onLoadLamuClassRoomMap(evt:*) : void
      {
         this.objEvent = evt.EventObj;
         this.loadMap("module/lahmClassRoom/lahmClassRoom.swf","正在進入拉姆教室中......",this.onLoadLamuClassRoomComplete,this.onLoadMapFail);
      }
      
      private function onLoadAngelParkMap(evt:*) : void
      {
         this.objEvent = evt.EventObj;
         this.loadMap("module/angelPark/AngelPark.swf","正在進入天使園......",this.onLoadAngelParkComplete,this.onLoadMapFail);
      }
      
      private function onNewAngelEnterHandler(evt:Event) : void
      {
         this.loadMap("module/newAngelPark/newAngelPark.swf","正在進入天使園......",this.onLoadNewAngelParkComplete,this.onLoadMapFail);
      }
      
      private function onEntryPigHouse(evt:*) : void
      {
         PigHouseEntrance.instance.EnterHouse(GV.MapInfo_mapID);
         GV.isSwitchMap = false;
      }
      
      private function onEntryBeautyHouse(evt:*) : void
      {
         BeautyHouseEntrance.getInstance().EnterHouse(GV.MapInfo_mapID);
         GV.isSwitchMap = false;
      }
      
      private function onEntryMachinistSquare(evt:*) : void
      {
         MachinistSquareEntrance.instance.EnterHouse(GV.MapInfo_mapID);
         GV.isSwitchMap = false;
      }
      
      private function onLoadClassMap(evt:*) : void
      {
         GV.Room_DefaultRoomID = 1;
         GV.MapInfo_isHouse = true;
         this.objEvent = evt.EventObj;
         this.loadMap("module/classroom/classroom.swf","正在進入班級中......",this.onLoadClassComplete,this.onLoadMapFail);
      }
      
      private function onLoadHomeMap(evt:*) : void
      {
         GV.MapInfo_isHouse = true;
         this.objEvent = evt.EventObj;
         this.loadMap("module/home/home.swf","正在進入家園中......",this.onLoadHomeComplete,this.onLoadMapFail);
      }
      
      private function onLoadRoomMap(evt:*) : void
      {
         GV.MapInfo_isHouse = true;
         this.objEvent = evt.EventObj.obj;
         this.loadMap("module/house/house.swf","正在進入小屋中......",this.onLoadHouseComplete,this.onLoadMapFail);
      }
      
      private function onLoadMap(evt:EventTaomee) : void
      {
         var url:String = null;
         var mapObj:Object = null;
         var mapid:uint = 0;
         GV.MapInfo_isHouse = false;
         if(Boolean(evt.EventObj))
         {
            mapObj = evt.EventObj.obj;
            mapid = uint(mapObj.maps.MapID);
            GV.hasActive = mapObj.maps.type;
            GV.MapInfo_mapID = mapid;
            GV.backup_mapID = mapid;
            if(Boolean(MapsConfig.MapsInfo[mapid]))
            {
               GV.MapInfo_name = MapsConfig.MapsInfo[mapid].note;
            }
            else if(mapid > 2000000000)
            {
               GV.MapInfo_name = "家園";
            }
            else
            {
               GV.MapInfo_name = "牧場或小屋";
            }
         }
         var mapName:String = "正在進入" + GV.MapInfo_name;
         if(GV.MapInfo_mapID < 1000)
         {
            if(this.isNewMap)
            {
               url = "resource/map/Map_" + (LocalUserInfo.getMapID() + 10000) + ".swf";
            }
            else if(GV.hasActive == 0)
            {
               url = "resource/map/" + GV.MapInfo_mapID + ".swf";
            }
            else
            {
               url = "resource/map/activity/" + GV.MapInfo_mapID + ".swf";
            }
         }
         else
         {
            url = "resource/map/" + 100 + ".swf";
            mapName = "正在進入小屋中......";
         }
         this.loadMap(url,mapName,this.onLoadMapComplete,this.onLoadFail);
      }
      
      private function onLoadMapComplete(evt:MCLoadEvent) : void
      {
         this._mapLogic.initFindPath(false);
         var map_mc:MapMaterialBase = evt.getContent() as MapMaterialBase;
         this._mapControl = new MapControl(map_mc,evt.getLoader().contentLoaderInfo.applicationDomain);
         this._mapControl.addEventListener(MapControl.MAP_XML_COMPLETE,this.mapXmlLoaderComplete);
      }
      
      private function mapXmlLoaderComplete(evt:Event) : void
      {
         this._mapLogic.getMapUser();
      }
      
      private function onLoadClassComplete(evt:MCLoadEvent) : void
      {
         PeopleManager.isHideMount = false;
         var childMC:* = evt.getLoader();
         GV.onlineSocket.addEventListener("allClassGoodsLoaded",this.restaurantGoodsOver);
         ClassroomView.getInstance().setValue(childMC,this.objEvent);
      }
      
      private function onLoadFarmSWFComplete(evt:MCLoadEvent) : void
      {
         PeopleManager.isHideMount = false;
         var childMC:* = evt.getLoader();
         GV.onlineSocket.addEventListener("allFarmGoodsLoaded",this.farmGoodsOver);
         FieldView.getInstance().setValue(childMC,this.objEvent);
      }
      
      private function onLoadRestaurantComplete(evt:MCLoadEvent) : void
      {
         PeopleManager.isHideMount = false;
         var childMC:* = evt.getContent();
         GV.onlineSocket.addEventListener("allRestaurantGoodsLoaded",this.restaurantGoodsOver);
         RestaurantView.getInstance().setValue(childMC,this.objEvent);
      }
      
      private function onLoadLamuClassRoomComplete(evt:MCLoadEvent) : void
      {
         var childMC:* = evt.getLoader();
         GV.onlineSocket.addEventListener("allLamuClassRoomGoodsLoaded",this.restaurantGoodsOver);
         lahmClassRoomView.getInstance().setValue(childMC,this.objEvent);
      }
      
      private function onLoadAngelParkComplete(evt:MCLoadEvent) : void
      {
         PeopleManager.isHideMount = false;
         var childMC:Loader = evt.getLoader();
         GV.onlineSocket.addEventListener(AngelParkView.MapInitOk,this.AngelParkMapInitOK);
         AngelParkView.instance.Init(childMC.content as MovieClip,AngelParkVO(this.objEvent));
      }
      
      private function onLoadNewAngelParkComplete(evt:MCLoadEvent) : void
      {
         PeopleManager.isHideMount = false;
         var childMC:Loader = evt.getLoader();
         NewAngelParkView.alertClassRef = childMC.contentLoaderInfo.applicationDomain.getDefinition("UI_NewAngelAlert") as Class;
         NewAngelParkView.instance.ed.addEventListener(NewAngelParkView.NEW_ANGEL_PARK_MAP_INIT_OVER,this.newAngelParkInitOver);
         NewAngelParkView.instance.setView(childMC.content as MovieClip);
      }
      
      private function onLoadHomeComplete(evt:MCLoadEvent) : void
      {
         PeopleManager.isHideMount = false;
         var childMC:* = evt.getLoader();
         GV.onlineSocket.addEventListener("allHomeGoodsLoaded",this.homeGoodsOver);
         HomeView.getInstance().setValue(childMC,this.objEvent);
      }
      
      private function onLoadHouseComplete(evt:MCLoadEvent) : void
      {
         PeopleManager.isHideMount = false;
         var childMC:* = evt.getLoader();
         GV.onlineSocket.addEventListener("allGoodsLoaded",this.roomGoodsOver);
         newHouseView.getInstance().setValue(childMC,this.objEvent);
      }
      
      private function onLoadMapFail(evt:MCLoadEvent) : void
      {
      }
      
      private function farmGoodsOver(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("allFarmGoodsLoaded",this.farmGoodsOver);
         this._mapLogic.initFindPath();
         this.mapLevel.depthLevel.mouseChildren = this.mapLevel.depthLevel.mouseEnabled = true;
      }
      
      private function homeGoodsOver(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("allHomeGoodsLoaded",this.homeGoodsOver);
         this._mapLogic.initFindPath();
         this.mapLevel.depthLevel.mouseChildren = this.mapLevel.depthLevel.mouseEnabled = true;
      }
      
      private function restaurantGoodsOver(evt:EventTaomee) : void
      {
         this._mapLogic.initFindPath();
         this.mapLevel.depthLevel.mouseChildren = this.mapLevel.depthLevel.mouseEnabled = true;
      }
      
      private function AngelParkMapInitOK(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(AngelParkView.MapInitOk,this.AngelParkMapInitOK);
         this._mapLogic.initFindPath();
      }
      
      private function newAngelParkInitOver(evt:Event) : void
      {
         NewAngelParkView.instance.ed.removeEventListener(NewAngelParkView.NEW_ANGEL_PARK_MAP_INIT_OVER,this.newAngelParkInitOver);
         this._mapLogic.initFindPath();
      }
      
      private function roomGoodsOver(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("allGoodsLoaded",this.roomGoodsOver);
         this._mapLogic.initFindPath();
         this.mapLevel.depthLevel.mouseChildren = this.mapLevel.depthLevel.mouseEnabled = true;
      }
      
      private function onPeopleOver(evt:*) : void
      {
         var tmpMapID:uint = 0;
         var tmpMapType:uint = 0;
         dispatchEvent(new Event(Event.INIT));
         if(Boolean(this._mapControl))
         {
            this._mapControl.init();
            LocalUserInfo.setIsHideOtherMole(ToolSystemMenu._isHideOtherMole);
            if(this._isTaskChangeMap)
            {
               TaskManager.checkEnterMap(MapManager.curMapID);
               this._isTaskChangeMap = false;
            }
         }
         else
         {
            tmpMapID = MapManager.curMapID;
            tmpMapType = MapManager.curMapType;
            if(tmpMapID == LocalUserInfo.getUserID() && tmpMapType == 0)
            {
               TaskManager.checkEnterMap(50002);
            }
            else if(tmpMapID == LocalUserInfo.getUserID() + GV.TwentyBillion)
            {
               TaskManager.checkEnterMap(50001);
            }
            else if(tmpMapID == LocalUserInfo.getUserID() && tmpMapType == 300)
            {
               TaskManager.checkEnterMap(50003);
            }
            else if(tmpMapID == LocalUserInfo.getUserID() && tmpMapType == 37)
            {
               TaskManager.checkEnterMap(50004);
            }
         }
      }
      
      public function initFindPath() : void
      {
         this._mapLogic.initFindPath();
      }
      
      public function get MapManage() : MapManageLogic
      {
         return this._mapLogic;
      }
      
      public function get mapLevel() : MapLevel
      {
         return this._mapLogic.mapModel.mapLevel;
      }
      
      public function get mapFrame() : MovieClip
      {
         return this._mapLogic.mapModel.mapLevel.map_mc;
      }
      
      public function get mapControl() : MapControl
      {
         return this._mapControl;
      }
      
      public function gotoRestaurant() : void
      {
         if(LocalUserInfo.getMapType() == 31 && GV.MyInfo_userID == LocalUserInfo.getMapID())
         {
            Alert.smileAlart("    你已經在自己的餐廳了！");
            return;
         }
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
            GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.haveCertificate);
            checkItem.checkItemHandler(190658);
         }
      }
      
      private function haveCertificate(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.haveCertificate);
         var msg:String = "";
         if(evt.EventObj.num == 1)
         {
            this.joinMap = 143;
            msg = "　　你還沒有開設餐廳呢，去建設署找湯米看看吧。";
         }
         else
         {
            this.joinMap = 149;
            msg = "　　沒有領取摩摩土地卡就不能開設餐廳哦，快去摩摩商會找伊蓮吧。";
         }
         this.alertObj = GF.showAlert(LevelManager.topLevel,msg,"",100,"go,notgo",true,false,"E");
         this.alertObj.addEventListener("CLICK" + 1,this.onGoMap);
      }
      
      private function onGoMap(evt:Event) : void
      {
         this.alertObj.removeEventListener("CLICK" + 1,this.onGoMap);
         MapManager.enterMap(this.joinMap);
      }
      
      public function initMySite(mcContainer:MovieClip, eventOwer:Object, leaveHandler:Function) : void
      {
         BC.addEvent(eventOwer,mcContainer.mapBtn,MouseEvent.CLICK,this.openMap);
         BC.addEvent(eventOwer,mcContainer.homeBtn,MouseEvent.CLICK,this.gotoHome);
         BC.addEvent(eventOwer,mcContainer.farmBtn,MouseEvent.CLICK,this.gotoFarm);
         BC.addEvent(eventOwer,mcContainer.pigHouseBtn,MouseEvent.CLICK,this.gotoPigHouse);
         BC.addEvent(eventOwer,mcContainer.leaveBtn,MouseEvent.CLICK,leaveHandler);
         BC.addEvent(eventOwer,mcContainer.angelBtn,MouseEvent.CLICK,this.gotoAngel);
         BC.addEvent(eventOwer,mcContainer.restaurantBtn,MouseEvent.CLICK,this.gotoRestaurantHandler);
         BC.addEvent(eventOwer,mcContainer.seaBtn,MouseEvent.CLICK,this.gotoSeaHouse);
         tip.tipTailDisPlayObject(mcContainer.mapBtn,"我的樂園");
         tip.tipTailDisPlayObject(mcContainer.homeBtn,"家園");
         tip.tipTailDisPlayObject(mcContainer.farmBtn,"牧場");
         tip.tipTailDisPlayObject(mcContainer.pigHouseBtn,"肥肥館");
         tip.tipTailDisPlayObject(mcContainer.leaveBtn,"離開");
         tip.tipTailDisPlayObject(mcContainer.angelBtn,"天使園");
         tip.tipTailDisPlayObject(mcContainer.restaurantBtn,"我的餐廳");
         tip.tipTailDisPlayObject(mcContainer.seaBtn,"海洋館");
      }
      
      private function openMap(evt:MouseEvent) : void
      {
         ModuleManager.openPanel("HomeMapPanel",null,"正在加載...",LevelManager.topLevel);
      }
      
      private function gotoHome(evt:MouseEvent) : void
      {
         MapManager.enterMap(0,1);
      }
      
      private function gotoFarm(evt:MouseEvent) : void
      {
         GF.switchMap(LocalUserInfo.getUserID(),false,2);
      }
      
      private function gotoPigHouse(evt:MouseEvent) : void
      {
         GF.switchToPigHouse(LocalUserInfo.getUserID());
      }
      
      private function gotoAngel(evt:MouseEvent) : void
      {
         GF.switchMap(LocalUserInfo.getUserID(),false,37);
      }
      
      private function gotoRestaurantHandler(evt:MouseEvent) : void
      {
         this.gotoRestaurant();
      }
      
      private function gotoSeaHouse(event:MouseEvent) : void
      {
         TaskDiceCurse.inst.openSystem();
      }
   }
}

