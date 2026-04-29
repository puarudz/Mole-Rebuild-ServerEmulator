package com.logic.MapManageLogic
{
   import com.common.util.DisplayUtil;
   import com.common.util.Tick;
   import com.core.info.LocalUserInfo;
   import com.core.socketlogic.ClientOnLineSerSocket;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.FindPathLogic;
   import com.logic.PeopleCountLogic.PeopleCountLogic;
   import com.logic.socket.angelPark.AngelParkSocket;
   import com.logic.socket.angelPark.valueObj.AngelParkVO;
   import com.logic.socket.classSystem.classSocket;
   import com.logic.socket.farm.farmSocket;
   import com.logic.socket.getRoomInfo.GetRoomInfoReq;
   import com.logic.socket.getRoomInfo.GetRoomInfoRes;
   import com.logic.socket.home.GetHomeInfoReq;
   import com.logic.socket.home.GetHomeInfoRes;
   import com.logic.socket.lahmClassRoomSocket.lahmClassRoomSocket;
   import com.logic.socket.oneBigStreetSocket.oneBigStreetSocket;
   import com.logic.switchMapLogic.switchMapLogic;
   import com.module.newAngel.NewAngelManager;
   import com.module.newHouse.HouseData;
   import com.mole.app.map.MapManager;
   import com.mole.debug.DebugManager;
   import com.view.PeopleView.ClothAction;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class MapManageLogic extends EventDispatcher
   {
      
      private static var bgBitMap:Bitmap;
      
      public static var data_OVER:String = "data_over";
      
      public static var room_OVER:String = "room_over";
      
      public static var home_OVER:String = "home_over";
      
      public static var class_OVER:String = "class_over";
      
      public static var farm_OVER:String = "farm_over";
      
      public static var people_OVER:String = "people_over";
      
      public static var restaurant_OVER:String = "restaurant_over";
      
      public static var lamuClassRoom_OVER:String = "lamuClassRoom_over";
      
      public static var AngelPark_OVER:String = "AngelPark_OVER";
      
      public static var PigHouse_OVER:String = "PigHouse_OVER";
      
      public static var BeautyHouse_OVER:String = "BeautyHouse_OVER";
      
      public static var MachinistSquare_OVER:String = "MachinistSquare_OVER";
      
      public static var NEW_ANGEL_PARK_OVER:String = "new_angel_park_over";
      
      public static var recordMapArray:Array = [{
         "mapID":1,
         "mapType":1
      }];
      
      private static var tmpBGMC:MovieClip = new MovieClip();
      
      private var _mapModel:MapModelLogic;
      
      public var userArray:Array;
      
      public var userObj:Object;
      
      private var _isRefresh:Boolean = true;
      
      private var _curRefreshCount:uint = 0;
      
      public function MapManageLogic()
      {
         super();
         this.userArray = new Array();
         GV.onlineClass.addEventListener(ClientOnLineSerSocket.GET_MAP_MESSAGE,this.getMapData);
         GV.onlineSocket.addEventListener("read_1279",this.getLahmClassInfo);
         GV.onlineSocket.addEventListener("read_1014",this.getRestaurantInfo);
         GV.onlineSocket.addEventListener("read_5002",this.getClassInfo);
         GV.onlineSocket.addEventListener("read_1361",this.getFarmInfo);
         GV.onlineSocket.addEventListener(GetRoomInfoRes.GET_ROOM_INFO,this.getRoomInfo);
         GV.onlineSocket.addEventListener(GetHomeInfoRes.GET_HOME_INFO,this.getHomeInfo);
      }
      
      public static function addBackgroud(bg_mc:MovieClip) : void
      {
         var bg:DisplayObject = null;
         var maptype:int = 0;
         var i:int = 0;
         removeBackgroud();
         if(bg_mc != null)
         {
            bg_mc.visible = true;
            bg_mc.alpha = 1;
            bgBitMap = vector2Bitmap(bg_mc);
            bgBitMap.name = "bgBitMap";
            if(bg_mc.name == "bg")
            {
               bg = GV.MC_mapFrame.getChildByName("bgBitMap");
               if(Boolean(bg) && Boolean(bg.parent))
               {
                  bg.parent.removeChild(bg);
               }
               if(Boolean(bg_mc.getChildByName("mc_1220438")))
               {
                  tmpBGMC = bg_mc.getChildByName("mc_1220438") as MovieClip;
               }
               GV.MC_mapFrame.addChildAt(bgBitMap,3);
               if(Boolean(tmpBGMC))
               {
                  GV.MC_mapFrame.addChild(tmpBGMC);
                  trace(tmpBGMC.x + "***********" + tmpBGMC.y);
               }
            }
            else
            {
               GV.MC_mapFrame.addChildAt(bgBitMap,bg_mc.parent.getChildIndex(bg_mc) + 1);
               maptype = int(MapManager.curMapType);
               for(i = 0; i < bg_mc.numChildren; i++)
               {
                  if(bg_mc.getChildAt(i) is MovieClip)
                  {
                     tmpBGMC = bg_mc.getChildAt(i) as MovieClip;
                     break;
                  }
               }
               if(Boolean(tmpBGMC) && tmpBGMC.name == "bg")
               {
                  tmpBGMC.mouseChildren = false;
                  tmpBGMC.mouseEnabled = false;
                  DisplayUtil.playAllMovieClip(tmpBGMC);
                  GV.MC_mapFrame.addChildAt(tmpBGMC,bg_mc.parent.getChildIndex(bgBitMap) + 1);
               }
               else
               {
                  tmpBGMC = null;
               }
            }
            DisplayUtil.removeForParent(bg_mc);
         }
      }
      
      public static function removeBackgroud() : void
      {
         if(Boolean(bgBitMap))
         {
            if(Boolean(bgBitMap) && Boolean(bgBitMap.bitmapData))
            {
               bgBitMap.bitmapData.dispose();
            }
            DisplayUtil.removeForParent(bgBitMap);
            bgBitMap = null;
         }
         if(Boolean(tmpBGMC))
         {
            DisplayUtil.removeForParent(tmpBGMC);
            tmpBGMC = null;
         }
      }
      
      public static function vector2Bitmap(mc:*) : Bitmap
      {
         var myBitmapData:BitmapData = new BitmapData(mc.width,mc.height);
         myBitmapData.draw(mc);
         return new Bitmap(myBitmapData);
      }
      
      private function getMapData(evt:*) : void
      {
         var tempObj:Object = evt.EventObj.obj;
         dispatchEvent(new EventTaomee(data_OVER,{"obj":tempObj}));
      }
      
      private function getFarmInfo(e:EventTaomee) : void
      {
         GV.MapInfo_mapID = e.EventObj.UserID;
         dispatchEvent(new EventTaomee(farm_OVER,e.EventObj));
      }
      
      private function getClassInfo(e:EventTaomee) : void
      {
         GV.MapInfo_mapID = e.EventObj.UserID;
         dispatchEvent(new EventTaomee(class_OVER,e.EventObj));
      }
      
      public function getHomeInfo(e:EventTaomee) : void
      {
         GV.MapInfo_mapID = e.EventObj.UserID + GV.TwentyBillion;
         dispatchEvent(new EventTaomee(home_OVER,e.EventObj));
      }
      
      private function getRestaurantInfo(e:EventTaomee) : void
      {
         GV.MapInfo_mapID = e.EventObj.UserID;
         dispatchEvent(new EventTaomee(restaurant_OVER,e.EventObj));
      }
      
      private function getLahmClassInfo(e:EventTaomee) : void
      {
         GV.MapInfo_mapID = e.EventObj.UserID;
         dispatchEvent(new EventTaomee(lamuClassRoom_OVER,e.EventObj));
      }
      
      private function GetAngelParkInfo(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + AngelParkSocket.GetParkInfoCmd,this.GetAngelParkInfo);
         GV.MapInfo_mapID = AngelParkVO(e.EventObj).userId;
         dispatchEvent(new EventTaomee(AngelPark_OVER,e.EventObj));
      }
      
      private function getRoomInfo(e:EventTaomee) : void
      {
         HouseData.isUpset = e.EventObj.isUpset;
         GV.MapInfo_mapID = e.EventObj.UserID;
         dispatchEvent(new EventTaomee(room_OVER,{"obj":e.EventObj}));
      }
      
      private function sendMapData(mapID:Number = 1, type:int = 0) : void
      {
         var tempRoomInfo:GetRoomInfoReq = null;
         GV.currentMapID = mapID;
         if(type == 1)
         {
            classSocket.class_enterMap(mapID);
         }
         else if(type == 2)
         {
            farmSocket.farm_info(mapID);
         }
         else if(type == 31)
         {
            oneBigStreetSocket.restaurantInfo(mapID,type);
         }
         else if(type == 32)
         {
            lahmClassRoomSocket.getClassRoomInfo(mapID);
         }
         else if(type >= 300 && type <= 399)
         {
            GV.onlineSocket.addEventListener("read_" + AngelParkSocket.GetParkInfoCmd,this.GetAngelParkInfo);
            AngelParkSocket.GetParkInfo(mapID,type);
         }
         else if(type == 34)
         {
            GV.MapInfo_mapID = mapID;
            LocalUserInfo.setMapType(34);
            dispatchEvent(new EventTaomee(PigHouse_OVER));
         }
         else if(type == 35)
         {
            GV.MapInfo_mapID = mapID;
            LocalUserInfo.setMapType(35);
            dispatchEvent(new EventTaomee(BeautyHouse_OVER));
         }
         else if(type == 36)
         {
            GV.MapInfo_mapID = mapID;
            LocalUserInfo.setMapType(36);
            dispatchEvent(new EventTaomee(MachinistSquare_OVER));
         }
         else if(type == 37)
         {
            GV.MapInfo_mapID = mapID;
            LocalUserInfo.setMapType(37);
            NewAngelManager.instance.addEventListener(NewAngelManager.NEW_ANGEL_ENTER_PARK,this.enterAngelParkHandler);
            NewAngelManager.instance.enterAngelPark(LocalUserInfo.getUserID());
         }
         else if(mapID < 10000)
         {
            GV.onlineClass.mapReq(mapID);
         }
         else if(mapID < 2000000000)
         {
            tempRoomInfo = new GetRoomInfoReq();
            tempRoomInfo.getRoomInfo(mapID);
         }
         else
         {
            GetHomeInfoReq.getHomeInfo(mapID - GV.TwentyBillion);
         }
      }
      
      public function refreshMap() : void
      {
         var tarMapId:uint = 0;
         var tarMapType:uint = 0;
         if(this._isRefresh)
         {
            this._isRefresh = false;
            MapManager.clearMap();
            trace("刷新本地圖");
            tarMapId = MapManager.curMapID;
            tarMapType = MapManager.curMapType;
            if(tarMapId < 1000)
            {
               dispatchEvent(new EventTaomee(data_OVER,null));
            }
            else if(tarMapId == LocalUserInfo.getUserID() && tarMapType == 300)
            {
               switchMapLogic.switchMapLogicHandler(LocalUserInfo.getUserID(),true,300);
            }
            else if(tarMapId == LocalUserInfo.getUserID() && tarMapType == 37)
            {
               switchMapLogic.switchMapLogicHandler(LocalUserInfo.getUserID(),true,37);
            }
            else
            {
               this.sendMapData(tarMapId,tarMapType);
            }
         }
         else
         {
            DebugManager.traceMsg("刷新太頻繁了，稍候在試下！",false);
         }
         this._curRefreshCount = 0;
         Tick.instance.addCallback(this.onResetRefresh);
      }
      
      private function onResetRefresh(delay:Number) : void
      {
         if(this._curRefreshCount++ > 30)
         {
            Tick.instance.removeCallback(this.onResetRefresh);
            this._isRefresh = true;
         }
      }
      
      public function changeMap(mapID:Number, type:int = 0) : void
      {
         this.sendMapData(mapID,type);
      }
      
      public function initFindPath(getUser:Boolean = true) : void
      {
         if(Boolean(this._mapModel))
         {
            this._mapModel.destroy();
            this._mapModel = null;
         }
         this._mapModel = new MapModelLogic(GV.MC_mapFrame);
         this._mapModel.makeMapArray();
         this.createFindPathLogic();
         recordMapArray.push({
            "mapID":LocalUserInfo.getMapID(),
            "mapType":LocalUserInfo.getMapType()
         });
         if(recordMapArray.length > 5)
         {
            recordMapArray.shift();
         }
         if(getUser)
         {
            this.getMapUser();
         }
      }
      
      public function getMapUser() : void
      {
         GV.PeopleCount = new PeopleCountLogic();
         GV.PeopleCount.addEventListener(PeopleCountLogic.onAddChildPeopleOver,this.getAllUserEvent);
         this.sendUserInfo();
      }
      
      private function createFindPathLogic() : void
      {
         MapDepthManageLogic.compositorMapDepth();
         if(GV.FindPath == null)
         {
            GV.FindPath = new FindPathLogic();
         }
         GV.FindPath.createMapModel(this._mapModel);
         var tempMC:MovieClip = GV.MC_mapFrame["bg_mc"];
         addBackgroud(tempMC);
         GV.MC_mapFrame.addEventListener(Event.REMOVED_FROM_STAGE,this.removeHandler);
      }
      
      private function sendUserInfo() : void
      {
         GV.onlineClass.addEventListener(ClientOnLineSerSocket.GET_BASIC_MESSAGE,this.getAllUserInfo);
         GV.onlineClass.getUserListReq();
      }
      
      public function getAllUserInfo(evt:*) : void
      {
         GV.onlineClass.removeEventListener(ClientOnLineSerSocket.GET_BASIC_MESSAGE,this.getAllUserInfo);
         try
         {
            ClothAction.getClearMapListener();
         }
         catch(err:Error)
         {
         }
         this.userArray = evt.EventObj.arr;
         this.userObj = {
            "data":this.userArray,
            "type":1
         };
         GV.PeopleCount.changeOnlinePeople(this.userObj);
      }
      
      private function getAllUserEvent(e:*) : void
      {
         trace("-------------------------------->人物生成完畢");
         GV.PeopleCount.removeEventListener(PeopleCountLogic.onAddChildPeopleOver,this.getAllUserEvent);
         dispatchEvent(new Event(people_OVER));
      }
      
      private function enterAngelParkHandler(evt:EventTaomee) : void
      {
         NewAngelManager.instance.removeEventListener(NewAngelManager.NEW_ANGEL_ENTER_PARK,this.enterAngelParkHandler);
         dispatchEvent(new Event(NEW_ANGEL_PARK_OVER));
      }
      
      private function removeHandler(evt:*) : void
      {
         evt.target.removeEventListener(Event.REMOVED_FROM_STAGE,this.removeHandler);
         removeBackgroud();
      }
      
      public function get mapModel() : MapModelLogic
      {
         return this._mapModel;
      }
   }
}

