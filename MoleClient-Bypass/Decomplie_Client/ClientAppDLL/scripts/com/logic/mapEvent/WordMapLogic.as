package com.logic.mapEvent
{
   import com.common.Alert.Alert;
   import com.common.Tween.TweenLite;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.info.MapInfo;
   import com.core.manager.ServerListManager;
   import com.event.EventTaomee;
   import com.global.staticData.MapsConfig;
   import com.global.staticData.XMLInfo;
   import com.logic.socket.getMapheat.getMapheatReq;
   import com.logic.socket.getMapheat.getMapheatRes;
   import com.logic.switchMapLogic.switchMapLogic;
   import com.module.house.homehotXML;
   import com.module.house.houseListView;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.type.ModuleType;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.activity.Task83.Anniversary;
   import com.view.mapView.activity.Task83.StatisticsClass;
   import com.view.toolView.toolView;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   
   public class WordMapLogic extends Sprite
   {
      
      public static var mapMC:MovieClip;
      
      public static var localIndex:int;
      
      public var mapHotReq:getMapheatReq;
      
      public var houseListViews:houseListView;
      
      public var areaArr:Array;
      
      public var isHomeHot:Boolean = false;
      
      private var PlaceArr:Array;
      
      private var worldXML:XML;
      
      private var mapObjArr:Array;
      
      private var homeObj:MapObj;
      
      private var extdelay:int = 100;
      
      private var timeOutID:uint = 0;
      
      private var useSkillTimer:Timer;
      
      private var useSkillTimer1:Timer;
      
      private var cm:MovieClip;
      
      private var app:ApplicationDomain;
      
      private var mapArr:Array;
      
      private var blurMapMC:Bitmap;
      
      private var blurMapMask:Sprite;
      
      private var index:int = -1;
      
      private var names:Array;
      
      private var blurTimer:Timer;
      
      private var blurColorMatrixFilter:ColorMatrixFilter;
      
      private var blurcount:int = 0;
      
      public function WordMapLogic(map:*)
      {
         var arr:Array;
         var i:int;
         var j:int;
         this.mapArr = [[1],[2],[3],[4],[5],[6]];
         this.names = ["bg","gameBtn1","shopBtn2","workBtn3","petBtn4","npcBtn5","allBtn9","closeBtn","serAdd","tips"];
         this.blurColorMatrixFilter = new ColorMatrixFilter();
         super();
         this.app = Loader(map).contentLoaderInfo.applicationDomain;
         this.houseListViews = new houseListView();
         mapMC = map.content.root;
         setTimeout(function():void
         {
            EventInit();
         },100);
         this.initMolePlace();
         this.initAreaArr();
         this.mapHotReq = new getMapheatReq();
         this.mapHotReq.mapSendReq();
         this.loadXML();
         this.initTips();
         BC.addEvent(this,GV.onlineSocket,getMapheatRes.GETMAP_HEAT,this.gethot);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.closeMap);
         arr = new Array();
         for(i = 0; i < mapMC.map_btn.numChildren; i++)
         {
            arr.push(mapMC.map_btn.getChildAt(i));
         }
         arr.sortOn("y",Array.NUMERIC);
         for(j = 0; j < arr.length; j++)
         {
            mapMC.map_btn.setChildIndex(arr[j],j);
         }
      }
      
      private function parseXML(mapObjArr:Array) : void
      {
         var tempObj:MapObj = null;
         var tempID:uint = 0;
         var tempName:String = null;
         var isLockMove:int = 0;
         var tempActive:Boolean = false;
         var tempTipObj:MapTipObj = null;
         var tempDecObj:MapDescriptionObj = null;
         var j:uint = 0;
         var tempImgArr:Array = null;
         var subList:XMLList = null;
         var tempList:XMLList = this.worldXML.scence;
         for(var i:uint = 0; i < tempList.length(); i++)
         {
            tempObj = new MapObj();
            tempID = uint(tempList[i].@id);
            tempName = tempList[i].@name;
            isLockMove = 0;
            tempActive = false;
            tempTipObj = new MapTipObj();
            j = 0;
            tempImgArr = new Array();
            isLockMove = int(tempList[i].@isLockMove);
            if(tempList[i].@isActive == 1)
            {
               tempActive = true;
            }
            else
            {
               tempActive = false;
            }
            subList = tempList[i].img.imgObj;
            for(j = 0; j < subList.length(); j++)
            {
               tempImgArr.push(subList[j].@url);
            }
            subList = tempList[i].tip.task.taskObj;
            if(subList.length() > 0)
            {
               tempDecObj = new MapDescriptionObj("任務",99);
               tempTipObj.taskArr.push(tempDecObj);
            }
            for(j = 0; j < subList.length(); j++)
            {
               tempDecObj = new MapDescriptionObj("* " + subList[j].@descrption,subList[j].@colorNum);
               tempTipObj.taskArr.push(tempDecObj);
            }
            subList = tempList[i].tip.game.gameObj;
            if(subList.length() > 0)
            {
               tempDecObj = new MapDescriptionObj("遊戲",99);
               tempTipObj.gameArr.push(tempDecObj);
            }
            for(j = 0; j < subList.length(); j++)
            {
               tempDecObj = new MapDescriptionObj("* " + subList[j].@descrption,subList[j].@colorNum);
               tempTipObj.gameArr.push(tempDecObj);
            }
            subList = tempList[i].tip.shopping.shoppingObj;
            if(subList.length() > 0)
            {
               tempDecObj = new MapDescriptionObj("購物",99);
               tempTipObj.shoppingArr.push(tempDecObj);
            }
            for(j = 0; j < subList.length(); j++)
            {
               tempDecObj = new MapDescriptionObj("* " + subList[j].@descrption,subList[j].@colorNum);
               tempTipObj.shoppingArr.push(tempDecObj);
            }
            subList = tempList[i].tip.working.workingObj;
            if(subList.length() > 0)
            {
               tempDecObj = new MapDescriptionObj("打工",99);
               tempTipObj.workingArr.push(tempDecObj);
            }
            for(j = 0; j < subList.length(); j++)
            {
               tempDecObj = new MapDescriptionObj("* " + subList[j].@descrption,subList[j].@colorNum);
               tempTipObj.workingArr.push(tempDecObj);
            }
            subList = tempList[i].singtonTip.task.taskObj;
            if(subList.length() > 0)
            {
               tempDecObj = new MapDescriptionObj("任務",99);
               tempTipObj.s_taskArr.push(tempDecObj);
            }
            for(j = 0; j < subList.length(); j++)
            {
               tempDecObj = new MapDescriptionObj("* " + subList[j].@descrption,subList[j].@colorNum);
               tempTipObj.s_taskArr.push(tempDecObj);
            }
            subList = tempList[i].singtonTip.game.gameObj;
            if(subList.length() > 0)
            {
               tempDecObj = new MapDescriptionObj("遊戲",99);
               tempTipObj.s_gameArr.push(tempDecObj);
            }
            for(j = 0; j < subList.length(); j++)
            {
               tempDecObj = new MapDescriptionObj("* " + subList[j].@descrption,subList[j].@colorNum);
               tempTipObj.s_gameArr.push(tempDecObj);
            }
            subList = tempList[i].singtonTip.shopping.shoppingObj;
            if(subList.length() > 0)
            {
               tempDecObj = new MapDescriptionObj("購物",99);
               tempTipObj.s_shoppingArr.push(tempDecObj);
            }
            for(j = 0; j < subList.length(); j++)
            {
               tempDecObj = new MapDescriptionObj("* " + subList[j].@descrption,subList[j].@colorNum);
               tempTipObj.s_shoppingArr.push(tempDecObj);
            }
            subList = tempList[i].singtonTip.working.workingObj;
            if(subList.length() > 0)
            {
               tempDecObj = new MapDescriptionObj("打工",99);
               tempTipObj.s_workingArr.push(tempDecObj);
            }
            for(j = 0; j < subList.length(); j++)
            {
               tempDecObj = new MapDescriptionObj("* " + subList[j].@descrption,subList[j].@colorNum);
               tempTipObj.s_workingArr.push(tempDecObj);
            }
            subList = tempList[i].singtonTip.npc.npcObj;
            if(subList.length() > 0)
            {
               tempDecObj = new MapDescriptionObj("莊園明星",99);
               tempTipObj.s_npcArr.push(tempDecObj);
            }
            for(j = 0; j < subList.length(); j++)
            {
               tempDecObj = new MapDescriptionObj("* " + subList[j].@descrption,subList[j].@colorNum);
               tempTipObj.s_npcArr.push(tempDecObj);
            }
            subList = tempList[i].singtonTip.pet.petObj;
            if(subList.length() > 0)
            {
               tempDecObj = new MapDescriptionObj("寵物",99);
               tempTipObj.s_petArr.push(tempDecObj);
            }
            for(j = 0; j < subList.length(); j++)
            {
               tempDecObj = new MapDescriptionObj("* " + subList[j].@descrption,subList[j].@colorNum);
               tempTipObj.s_petArr.push(tempDecObj);
            }
            tempObj.init(tempID,tempName,0,tempActive,tempTipObj,tempImgArr,isLockMove);
            if(Boolean(mapMC.map_btn["btn_" + tempObj.id]))
            {
               tempObj.btn = mapMC.map_btn["btn_" + tempObj.id];
               tempObj.btn.buttonMode = true;
               BC.addEvent(this,tempObj,MapObj.MAP_Click,this.mapClickHandler);
               BC.addEvent(this,tempObj,MapObj.MAP_ROLL_OVER,this.mapOverHandler);
               BC.addEvent(this,tempObj,MapObj.MAP_ROLL_OUT,this.mapOutHandler);
            }
            mapObjArr.push(tempObj);
         }
      }
      
      private function loadXML() : void
      {
         var j:int = 0;
         this.worldXML = XMLInfo.WorldMapXML;
         this.parseXML(this.mapObjArr = new Array());
         var tempList:XMLList = this.worldXML.sortMap;
         this.mapArr = [];
         this.mapArr[1] = [];
         for(j = 0; j < tempList[0].game[0].mapObj.length(); j++)
         {
            this.mapArr[1].push(int(tempList[0].game[0].mapObj[j].@id));
         }
         this.mapArr[2] = [];
         for(j = 0; j < tempList[0].shopping[0].mapObj.length(); j++)
         {
            this.mapArr[2].push(int(tempList[0].shopping[0].mapObj[j].@id));
         }
         this.mapArr[3] = [];
         for(j = 0; j < tempList[0].working[0].mapObj.length(); j++)
         {
            this.mapArr[3].push(int(tempList[0].working[0].mapObj[j].@id));
         }
         this.mapArr[4] = [];
         for(j = 0; j < tempList[0].pet[0].mapObj.length(); j++)
         {
            this.mapArr[4].push(int(tempList[0].pet[0].mapObj[j].@id));
         }
         this.mapArr[5] = [];
         for(j = 0; j < tempList[0].npc[0].mapObj.length(); j++)
         {
            this.mapArr[5].push(int(tempList[0].npc[0].mapObj[j].@id));
         }
         this.homeObj = new MapObj();
         this.homeObj.id = 1000;
         this.homeObj.name = "展示家園";
         var tempDecObj:MapDescriptionObj = new MapDescriptionObj("絲姐姐的家就在這裡！",1);
         this.homeObj.tipObj.taskArr.push(tempDecObj);
         this.homeObj._btn = mapMC.map_btn.myHome;
         BC.addEvent(this,mapMC.gameBtn1,MouseEvent.CLICK,this.btnClick);
         BC.addEvent(this,mapMC.shopBtn2,MouseEvent.CLICK,this.btnClick);
         BC.addEvent(this,mapMC.workBtn3,MouseEvent.CLICK,this.btnClick);
         BC.addEvent(this,mapMC.petBtn4,MouseEvent.CLICK,this.btnClick);
         BC.addEvent(this,mapMC.npcBtn5,MouseEvent.CLICK,this.btnClick);
         BC.addEvent(this,mapMC.allBtn9,MouseEvent.CLICK,this.btnClick);
         mapMC.gameBtn1.buttonMode = true;
         mapMC.shopBtn2.buttonMode = true;
         mapMC.workBtn3.buttonMode = true;
         mapMC.petBtn4.buttonMode = true;
         mapMC.npcBtn5.buttonMode = true;
         mapMC.allBtn9.buttonMode = true;
         this.playStop1(mapMC.gameBtn1 as MovieClip,null);
         this.playStop1(mapMC.shopBtn2 as MovieClip,null);
         this.playStop1(mapMC.workBtn3 as MovieClip,null);
         this.playStop1(mapMC.petBtn4 as MovieClip,null);
         this.playStop1(mapMC.npcBtn5 as MovieClip,null);
         this.playStop1(mapMC.allBtn9 as MovieClip,mapMC.allBtn9);
         if(localIndex != -1 && localIndex != 9)
         {
            switch(localIndex)
            {
               case 1:
                  mapMC.gameBtn1.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  break;
               case 2:
                  mapMC.shopBtn2.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  break;
               case 3:
                  mapMC.workBtn3.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  break;
               case 4:
                  mapMC.petBtn4.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  break;
               case 5:
                  mapMC.npcBtn5.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            }
         }
      }
      
      private function playStop1(mc:MovieClip, clickMC:MovieClip) : void
      {
         if(mc != clickMC)
         {
            mc.gotoAndStop(1);
         }
         else
         {
            mc.gotoAndStop(2);
         }
      }
      
      private function btnClick(e:MouseEvent = null) : void
      {
         var clickMC:MovieClip = null;
         if(e == null)
         {
            clickMC = mapMC.allBtn9;
         }
         else
         {
            clickMC = MovieClip(e.currentTarget);
         }
         this.playStop1(mapMC.gameBtn1 as MovieClip,clickMC);
         this.playStop1(mapMC.shopBtn2 as MovieClip,clickMC);
         this.playStop1(mapMC.workBtn3 as MovieClip,clickMC);
         this.playStop1(mapMC.petBtn4 as MovieClip,clickMC);
         this.playStop1(mapMC.npcBtn5 as MovieClip,clickMC);
         this.playStop1(mapMC.allBtn9 as MovieClip,clickMC);
         var id:int = int(clickMC.name.slice(-1));
         clickMC.gotoAndStop(2);
         if(id == 9)
         {
            this.blurcount = 0;
            this.clearBlur();
         }
         else
         {
            this.blur(this.mapArr[id],id);
         }
      }
      
      private function initTips() : void
      {
         mapMC.tips.visible = false;
         mapMC.tips.mouseChildren = false;
         mapMC.tips.mouseEnabled = false;
      }
      
      private function initMolePlace() : void
      {
         var mapInfo:MapInfo = null;
         BC.addEvent(this,mapMC.map_btn.gotoMapBtn,MouseEvent.CLICK,this.gotoMapHandler);
         var placeNul:uint = LocalUserInfo.getMapID();
         if(placeNul > 1000 || placeNul == 82 || placeNul == 58)
         {
            mapInfo = MapInfo.currentMapInfo();
            mapMC.mole_mc.visible = true;
            if(mapInfo.name == MapInfo.MAPTYPE_DINING)
            {
               mapMC.mole_mc.x = mapMC.map_btn["btn_142"].x + mapMC.map_btn.x;
               mapMC.mole_mc.y = mapMC.map_btn["btn_142"].y + mapMC.map_btn.y;
            }
            else if(mapInfo.name == MapInfo.MAPTYPE_CLASS)
            {
               mapMC.mole_mc.x = mapMC.map_btn["btn_142"].x + mapMC.map_btn.x;
               mapMC.mole_mc.y = mapMC.map_btn["btn_142"].y + mapMC.map_btn.y;
            }
            else
            {
               mapMC.mole_mc.x = mapMC.map_btn.myHome.x + mapMC.map_btn.x;
               mapMC.mole_mc.y = mapMC.map_btn.myHome.y + mapMC.map_btn.y;
            }
            this.setColor();
            return;
         }
         var firstMap:int = int(MapsConfig.MapsInfo[placeNul].firstMap);
         if(firstMap > 0)
         {
            mapMC.mole_mc.visible = true;
            mapMC.mole_mc.x = mapMC.map_btn["btn_" + firstMap].x + mapMC.map_btn.x;
            mapMC.mole_mc.y = mapMC.map_btn["btn_" + firstMap].y + mapMC.map_btn.y;
            this.setColor();
         }
         else
         {
            mapMC.mole_mc.visible = false;
         }
         mapMC.mole_mc.mouseChildren = false;
         mapMC.mole_mc.mouseEnabled = false;
      }
      
      private function gotoMapHandler(evt:MouseEvent) : void
      {
         this.closeBtnClick();
         Anniversary.getInstance().gotoMap();
      }
      
      private function gethot(e:EventTaomee) : void
      {
         var mapid:int = 0;
         var j:uint = 0;
         var mc:MovieClip = null;
         if(!mapMC.sunMC)
         {
            return;
         }
         var data:Object = e.EventObj;
         mapMC.sunMC.mouseChildren = false;
         mapMC.sunMC.mouseEnabled = false;
         for(var i:int = 0; i < data.length; i++)
         {
            mapid = int(this.getMapNO(data[i].mapID));
            mapMC.sunMC["area" + mapid].hot.text = Number(mapMC.sunMC["area" + mapid].hot.text) + data[i].mapUser;
            for(j = 0; j < this.mapObjArr.length; j++)
            {
               if(MapObj(this.mapObjArr[j]).id == mapid)
               {
                  MapObj(this.mapObjArr[j])._hotValue = MapObj(this.mapObjArr[j])._hotValue + data[i].mapUser;
               }
            }
         }
         for(var k:int = 0; k < mapMC.sunMC.numChildren; k++)
         {
            mc = mapMC.sunMC.getChildAt(k);
            this.sunGoto(mc);
         }
      }
      
      private function sunGoto(mc:MovieClip) : void
      {
         var num:Number = Number(mc.hot.text);
         if(num < 1)
         {
            mc.gotoAndStop(8);
         }
         else if(num > 0 && num < 6)
         {
            mc.gotoAndStop(1);
         }
         else if(num > 5 && num < 11)
         {
            mc.gotoAndStop(2);
         }
         else if(num > 10 && num < 21)
         {
            mc.gotoAndStop(3);
         }
         else if(num > 20 && num < 50)
         {
            mc.gotoAndStop(4);
         }
         else
         {
            mc.gotoAndStop(5);
         }
         mc.hot.visible = false;
      }
      
      private function getMapNO(mapid:*) : uint
      {
         var j:int = 0;
         for(var i:int = 0; i < this.areaArr.length; i++)
         {
            for(j = 0; j < this.areaArr[i].arr.length; j++)
            {
               if(mapid == this.areaArr[i].arr[j])
               {
                  return this.areaArr[i].showid;
               }
            }
         }
         return 1000;
      }
      
      private function initAreaArr() : void
      {
         this.areaArr = new Array();
         this.areaArr[0] = {
            "showid":7,
            "arr":[6,23,22,36]
         };
         this.areaArr[1] = {
            "showid":5,
            "arr":[5,37,34]
         };
         this.areaArr[2] = {
            "showid":2,
            "arr":[2,18,44,45,46]
         };
         this.areaArr[3] = {
            "showid":1,
            "arr":[1,15,16,17,14,32,33]
         };
         this.areaArr[4] = {
            "showid":3,
            "arr":[3,19,20,21,35]
         };
         this.areaArr[5] = {
            "showid":12,
            "arr":[12,13,29]
         };
         this.areaArr[6] = {
            "showid":8,
            "arr":[8,30,31]
         };
         this.areaArr[7] = {
            "showid":10,
            "arr":[10,27]
         };
         this.areaArr[8] = {
            "showid":1000,
            "arr":[]
         };
         this.areaArr[9] = {
            "showid":9,
            "arr":[9,25,26]
         };
         this.areaArr[10] = {
            "showid":38,
            "arr":[38]
         };
         this.areaArr[11] = {
            "showid":11,
            "arr":[11]
         };
         this.areaArr[12] = {
            "showid":12,
            "arr":[28,52,53]
         };
         this.areaArr[13] = {
            "showid":13,
            "arr":[40,41,42]
         };
         this.areaArr[14] = {
            "showid":14,
            "arr":[59,60]
         };
         this.areaArr[15] = {
            "showid":15,
            "arr":[61,62,63,64]
         };
         this.areaArr[16] = {
            "showid":16,
            "arr":[77,78]
         };
         this.areaArr[17] = {
            "showid":17,
            "arr":[7,24]
         };
         this.areaArr[18] = {
            "showid":18,
            "arr":[4,47]
         };
         this.areaArr[19] = {
            "showid":19,
            "arr":[68]
         };
         this.areaArr[20] = {
            "showid":20,
            "arr":[80]
         };
         this.areaArr[21] = {
            "showid":21,
            "arr":[83]
         };
         this.areaArr[22] = {
            "showid":142,
            "arr":[142]
         };
         this.areaArr[23] = {
            "showid":252,
            "arr":[252]
         };
      }
      
      private function EventInit() : void
      {
         var serID:* = GV.serverID;
         var serName:String = ServerListManager.getServerName(serID);
         mapMC.serAdd.text = "你所在的伺服器是:" + serID + "." + serName;
         BC.addEvent(this,mapMC.map_btn.myHome,MouseEvent.CLICK,this.myHomeClick);
         BC.addEvent(this,mapMC.map_btn.myHome,MouseEvent.ROLL_OVER,this.myHomeOver);
         BC.addEvent(this,mapMC.map_btn.myHome,MouseEvent.ROLL_OUT,this.myHomeOut);
         BC.addEvent(this,mapMC.closeBtn,MouseEvent.CLICK,this.closeBtnClick);
         if(GV.isSMC)
         {
            mapMC.map_btn.btn_31.visible = true;
         }
         else
         {
            mapMC.map_btn.btn_31.visible = false;
         }
      }
      
      private function spireClick(event:MouseEvent) : void
      {
         if(LocalUserInfo.getMapID() != 31)
         {
            BC.removeEvent(this,event.target,MouseEvent.CLICK,this.spireClick);
            GV.Room_DefaultRoomID = 0;
            LocalUserInfo.setMapID(0);
            switchMapLogic.switchMapLogicHandler(31);
         }
      }
      
      private function myHomeClick(event:MouseEvent) : void
      {
         var homehotXMLs:homehotXML = null;
         if(!this.isHomeHot)
         {
            this.isHomeHot = true;
            if(!homehotXML.IfOver)
            {
               homehotXMLs = new homehotXML();
               homehotXMLs.info();
               BC.addEvent(this,homehotXMLs,homehotXML.ALLDATE,this.hereOverFun);
            }
            else if(!MainManager.getAppLevel().getChildByName("homeListUI") && !GV.isChangeMap)
            {
               this.isHomeHot = false;
               BC.removeEvent(this,mapMC.map_btn.myHome,MouseEvent.CLICK,this.myHomeClick);
               this.houseListViews.info();
               this.closeBtnClick();
            }
         }
      }
      
      public function hereOverFun(e:*) : void
      {
         this.isHomeHot = false;
         BC.removeEvent(this,e.target,homehotXML.ALLDATE,this.hereOverFun);
         if(!MainManager.getAppLevel().getChildByName("homeListUI") && !GV.isChangeMap)
         {
            BC.removeEvent(this,mapMC.map_btn.myHome,MouseEvent.CLICK,this.myHomeClick);
            this.houseListViews.info();
            this.closeBtnClick();
         }
      }
      
      private function closeMap(evt:EventTaomee) : void
      {
         this.closeBtnClick();
      }
      
      private function closeBtnClick(event:MouseEvent = null) : void
      {
         clearTimeout(this.timeOutID);
         try
         {
            if(event.target.name == "closeBtn")
            {
               GV.JobViews.del("close_worldMapUI");
            }
         }
         catch(e:*)
         {
         }
         this.removeEventHandler();
         try
         {
            GC.clearAll(MainManager.getGameLevel().getChildByName("mapMC"));
         }
         catch(e:*)
         {
         }
      }
      
      private function removeEventHandler(evt:Event = null) : void
      {
         BC.removeEvent(this);
         var p:* = GV.JobLogics.findJobTaskStatus(24);
         if(p == 1)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("close_worldMapUI"));
         }
      }
      
      private function setColor() : void
      {
         var color:int = LocalUserInfo.getFamily();
         var myColor:Object = GF.getRGBColor(color);
         mapMC.mole_mc.mc.mc.transform.colorTransform = new ColorTransform(myColor.red / 256,myColor.green / 256,myColor.blue / 256,1);
      }
      
      private function mapClickHandler(e:Event) : void
      {
         var p:PeopleManageView = null;
         GV.onlineSocket.dispatchEvent(new EventTaomee("SNOW_GAME_MAP"));
         e.stopPropagation();
         var num:int = int(MapObj(e.target).id);
         if(LocalUserInfo.getMapID() != num && !MapObj(e.target)._isLockMove)
         {
            this.closeBtnClick();
            if(num == 120)
            {
               p = GV.MAN_PEOPLE as PeopleManageView;
               if(p.hasAnimal)
               {
                  Alert.smileAlart("    拉姆世界很危險，你要把動物送回家，才能進入拉姆世界哦！");
                  return;
               }
               if(p.hasCar)
               {
                  Alert.smileAlart("    拉姆世界很危險，你要把車開回家，才能進入拉姆世界哦！");
                  return;
               }
               toolView.getInstance().goMapFunc(2);
            }
            else if(num == 252)
            {
               ModuleManager.openPanel(ModuleType.SEABED_MAP_PANEL);
            }
            else if(num == 337)
            {
               toolView.getInstance().goMapFunc(16);
            }
            else
            {
               GF.switchMap(num,true);
            }
            GV.onlineSocket.dispatchEvent(new EventTaomee("CAR_GAME_MAP"));
         }
         else
         {
            mapMC.tips.dec_txt.scaleY = 1.2;
            TweenLite.to(mapMC.tips.dec_txt,0.3,{"scaleY":1});
         }
      }
      
      private function mapOverHandler(e:Event) : void
      {
         e.stopPropagation();
         this.reallyShow(MapObj(e.target));
      }
      
      private function mapOutHandler(e:Event) : void
      {
         e.stopPropagation();
         this.closeTips();
      }
      
      private function useBigMap(mc:MovieClip) : void
      {
         if(Boolean(mc.parent) && mc.name != "btn_33")
         {
            mc.parent.setChildIndex(mc,mc.parent.numChildren - 1);
         }
         if(Boolean(mc.useSkillTimer))
         {
            return;
         }
         mc.useSkillTimer = GC.setGInterval(function():*
         {
            mc.scaleX = mc.scaleY = mc.useSkillTimer.currentCount / 8 * 0.5 + 1;
         },"10:8");
      }
      
      private function delBigMap(mc:MovieClip) : void
      {
         GC.clearGInterval(mc.useSkillTimer);
         mc.useSkillTimer = GC.setGInterval(function():*
         {
            mc.scaleX = mc.scaleY = (1 - mc.useSkillTimer.currentCount / 4) * 0.5 + 1;
            if(mc.scaleX == 1)
            {
               mc.useSkillTimer = null;
            }
         },"10:4");
      }
      
      private function reallyShow(CmapObj:MapObj) : void
      {
         clearTimeout(this.timeOutID);
         this.timeOutID = setTimeout(this.showTips,this.extdelay,CmapObj);
      }
      
      private function checkindex(value:int, CmapObj:MapObj) : Boolean
      {
         if(this.index == -1)
         {
            switch(value)
            {
               case 0:
                  return CmapObj.tipObj.taskArr.length > 0;
               case 1:
                  return CmapObj.tipObj.gameArr.length > 0;
               case 2:
                  return CmapObj.tipObj.shoppingArr.length > 0;
               case 3:
                  return CmapObj.tipObj.workingArr.length > 0;
               case 4:
                  return CmapObj.tipObj.petArr.length > 0;
               case 5:
                  return CmapObj.tipObj.npcArr.length > 0;
               default:
                  return true;
            }
         }
         else
         {
            if(this.index != value)
            {
               return false;
            }
            switch(value)
            {
               case 0:
                  return CmapObj.tipObj.s_taskArr.length > 0;
               case 1:
                  return CmapObj.tipObj.s_gameArr.length > 0;
               case 2:
                  return CmapObj.tipObj.s_shoppingArr.length > 0;
               case 3:
                  return CmapObj.tipObj.s_workingArr.length > 0;
               case 4:
                  return CmapObj.tipObj.s_petArr.length > 0;
               case 5:
                  return CmapObj.tipObj.s_npcArr.length > 0;
               default:
                  return true;
            }
         }
      }
      
      private function showTips(CmapObj:MapObj) : void
      {
         var tempTxt:TextField = null;
         var arr:Array = null;
         var firstMap:int = 0;
         mapMC.tips.alpha = 0;
         mapMC.tips.scaleY = 0.5;
         mapMC.tips.visible = true;
         mapMC.tips.x = Math.max(180,CmapObj._btn.x + mapMC.map_btn.x - 20);
         mapMC.tips.y = CmapObj._btn.y + mapMC.map_btn.y - 20;
         if(CmapObj.name != "")
         {
            mapMC.tips.title.title_txt.text = CmapObj.name;
         }
         else
         {
            mapMC.tips.title.title_txt.text = MapsConfig.MapsInfo[CmapObj.id].note;
         }
         while(mapMC.tips.task.textHolder.numChildren > 0)
         {
            mapMC.tips.task.textHolder.removeChildAt(mapMC.tips.task.textHolder.numChildren - 1);
         }
         while(mapMC.tips.game.textHolder.numChildren > 0)
         {
            mapMC.tips.game.textHolder.removeChildAt(mapMC.tips.game.textHolder.numChildren - 1);
         }
         while(mapMC.tips.shopping.textHolder.numChildren > 0)
         {
            mapMC.tips.shopping.textHolder.removeChildAt(mapMC.tips.shopping.textHolder.numChildren - 1);
         }
         while(mapMC.tips.working.textHolder.numChildren > 0)
         {
            mapMC.tips.working.textHolder.removeChildAt(mapMC.tips.working.textHolder.numChildren - 1);
         }
         while(mapMC.tips.pet.textHolder.numChildren > 0)
         {
            mapMC.tips.pet.textHolder.removeChildAt(mapMC.tips.pet.textHolder.numChildren - 1);
         }
         while(mapMC.tips.npc.textHolder.numChildren > 0)
         {
            mapMC.tips.npc.textHolder.removeChildAt(mapMC.tips.npc.textHolder.numChildren - 1);
         }
         var tempY:int = 5;
         var tempDistance:uint = 5;
         var tempTxtDistance:uint = 18;
         var tempTotalHeigth:uint = 30;
         var tempTaskHeight:uint = 2;
         var tempGameHeight:uint = 2;
         var tempShoppingHeight:uint = 2;
         var tempWorkingHeight:uint = 2;
         var tempPetHeight:uint = 2;
         var tempNpcHeight:uint = 2;
         var textFormat:TextFormat = new TextFormat();
         textFormat.align = TextFormatAlign.LEFT;
         textFormat.size = 12;
         var i:uint = 0;
         var textX:int = 0;
         var textY:int = 0;
         if(this.checkindex(0,CmapObj))
         {
            textY = 0;
            mapMC.tips.task.y = tempY;
            mapMC.tips.task.visible = true;
            mapMC.tips.task.alpha = 0;
            TweenLite.to(mapMC.tips.task,0.5,{
               "alpha":1,
               "delay":0.1
            });
            if(this.index == -1)
            {
               arr = CmapObj.tipObj.taskArr;
            }
            else
            {
               arr = CmapObj.tipObj.s_taskArr;
            }
            for(i = 0; i < arr.length; i++)
            {
               tempTxt = new TextField();
               tempTxt.width = 145;
               tempTxt.maxChars = 10;
               tempTxt.setTextFormat(textFormat);
               tempTxt.text = arr[i].descrpiton;
               tempTxt.textColor = arr[i].color;
               tempTxt.x = textX;
               tempTxt.y = textY + i * tempTxtDistance;
               mapMC.tips.task.textHolder.addChild(tempTxt);
               tempTaskHeight += tempTxtDistance;
            }
            mapMC.tips.task.area.height = tempTaskHeight;
            tempY += tempTaskHeight + tempDistance;
         }
         else
         {
            mapMC.tips.task.visible = false;
         }
         if(this.checkindex(1,CmapObj))
         {
            textY = 0;
            mapMC.tips.game.y = tempY;
            mapMC.tips.game.visible = true;
            mapMC.tips.game.alpha = 0;
            TweenLite.to(mapMC.tips.game,0.5,{
               "alpha":1,
               "delay":0.2
            });
            if(this.index == -1)
            {
               arr = CmapObj.tipObj.gameArr;
            }
            else
            {
               arr = CmapObj.tipObj.s_gameArr;
            }
            for(i = 0; i < arr.length; i++)
            {
               tempTxt = new TextField();
               tempTxt.width = 145;
               tempTxt.maxChars = 10;
               tempTxt.setTextFormat(textFormat);
               tempTxt.text = arr[i].descrpiton;
               tempTxt.textColor = arr[i].color;
               tempTxt.x = textX;
               tempTxt.y = textY + i * tempTxtDistance;
               mapMC.tips.game.textHolder.addChild(tempTxt);
               tempGameHeight += tempTxtDistance;
            }
            mapMC.tips.game.area.height = tempGameHeight;
            tempY += tempGameHeight + tempDistance;
         }
         else
         {
            mapMC.tips.game.visible = false;
         }
         if(this.checkindex(2,CmapObj))
         {
            textY = 0;
            mapMC.tips.shopping.y = tempY;
            mapMC.tips.shopping.visible = true;
            mapMC.tips.shopping.alpha = 0;
            TweenLite.to(mapMC.tips.shopping,0.5,{
               "alpha":1,
               "delay":0.3
            });
            if(this.index == -1)
            {
               arr = CmapObj.tipObj.shoppingArr;
            }
            else
            {
               arr = CmapObj.tipObj.s_shoppingArr;
            }
            for(i = 0; i < arr.length; i++)
            {
               tempTxt = new TextField();
               tempTxt.width = 145;
               tempTxt.maxChars = 10;
               tempTxt.setTextFormat(textFormat);
               tempTxt.text = arr[i].descrpiton;
               tempTxt.textColor = arr[i].color;
               tempTxt.x = textX;
               tempTxt.y = textY + i * tempTxtDistance;
               mapMC.tips.shopping.textHolder.addChild(tempTxt);
               tempShoppingHeight += tempTxtDistance;
            }
            mapMC.tips.shopping.area.height = tempShoppingHeight;
            tempY += tempShoppingHeight + tempDistance;
         }
         else
         {
            mapMC.tips.shopping.visible = false;
         }
         if(this.checkindex(3,CmapObj))
         {
            textY = 0;
            mapMC.tips.working.y = tempY;
            mapMC.tips.working.visible = true;
            mapMC.tips.working.alpha = 0;
            TweenLite.to(mapMC.tips.working,0.5,{
               "alpha":1,
               "delay":0.4
            });
            if(this.index == -1)
            {
               arr = CmapObj.tipObj.workingArr;
            }
            else
            {
               arr = CmapObj.tipObj.s_workingArr;
            }
            for(i = 0; i < arr.length; i++)
            {
               tempTxt = new TextField();
               tempTxt.width = 145;
               tempTxt.maxChars = 10;
               tempTxt.setTextFormat(textFormat);
               tempTxt.text = arr[i].descrpiton;
               tempTxt.textColor = arr[i].color;
               tempTxt.x = textX;
               tempTxt.y = textY + i * tempTxtDistance;
               mapMC.tips.working.textHolder.addChild(tempTxt);
               tempWorkingHeight += tempTxtDistance;
            }
            mapMC.tips.working.area.height = tempWorkingHeight;
            tempY += tempWorkingHeight + tempDistance;
         }
         else
         {
            mapMC.tips.working.visible = false;
         }
         if(this.checkindex(4,CmapObj))
         {
            textY = 0;
            mapMC.tips.pet.y = tempY;
            mapMC.tips.pet.visible = true;
            mapMC.tips.pet.alpha = 0;
            TweenLite.to(mapMC.tips.pet,0.5,{
               "alpha":1,
               "delay":0.4
            });
            if(this.index == -1)
            {
               arr = CmapObj.tipObj.petArr;
            }
            else
            {
               arr = CmapObj.tipObj.s_petArr;
            }
            for(i = 0; i < arr.length; i++)
            {
               tempTxt = new TextField();
               tempTxt.width = 145;
               tempTxt.maxChars = 10;
               tempTxt.setTextFormat(textFormat);
               tempTxt.text = arr[i].descrpiton;
               tempTxt.textColor = arr[i].color;
               tempTxt.x = textX;
               tempTxt.y = textY + i * tempTxtDistance;
               mapMC.tips.pet.textHolder.addChild(tempTxt);
               tempPetHeight += tempTxtDistance;
            }
            mapMC.tips.pet.area.height = tempPetHeight;
            tempY += tempPetHeight + tempDistance;
         }
         else
         {
            mapMC.tips.pet.visible = false;
         }
         if(this.checkindex(5,CmapObj))
         {
            textY = 0;
            mapMC.tips.npc.y = tempY;
            mapMC.tips.npc.visible = true;
            mapMC.tips.npc.alpha = 0;
            TweenLite.to(mapMC.tips.npc,0.5,{
               "alpha":1,
               "delay":0.4
            });
            if(this.index == -1)
            {
               arr = CmapObj.tipObj.npcArr;
            }
            else
            {
               arr = CmapObj.tipObj.s_npcArr;
            }
            for(i = 0; i < arr.length; i++)
            {
               tempTxt = new TextField();
               tempTxt.width = 145;
               tempTxt.maxChars = 10;
               tempTxt.setTextFormat(textFormat);
               tempTxt.text = arr[i].descrpiton;
               tempTxt.textColor = arr[i].color;
               tempTxt.x = textX;
               tempTxt.y = textY + i * tempTxtDistance;
               mapMC.tips.npc.textHolder.addChild(tempTxt);
               tempNpcHeight += tempTxtDistance;
            }
            mapMC.tips.npc.area.height = tempNpcHeight;
            tempY += tempNpcHeight + tempDistance;
         }
         else
         {
            mapMC.tips.npc.visible = false;
         }
         mapMC.tips.dec_txt.y = tempY;
         var tempMap:Number = LocalUserInfo.getMapID();
         if(tempMap < 1000)
         {
            firstMap = int(MapsConfig.MapsInfo[LocalUserInfo.getMapID()].firstMap);
            if(firstMap == CmapObj.id)
            {
               mapMC.tips.dec_txt.text = "我在這裡";
               mapMC.tips.dec_txt.textColor = 26316;
            }
            else
            {
               mapMC.tips.dec_txt.text = "點擊前往";
               mapMC.tips.dec_txt.textColor = 6710886;
            }
         }
         else
         {
            mapMC.tips.dec_txt.text = "點擊前往";
            mapMC.tips.dec_txt.textColor = 6710886;
         }
         mapMC.tips.sun.y = tempY;
         this.showSun(CmapObj._hotValue);
         mapMC.tips.tipsbg.height = tempY + tempTotalHeigth + tempTxtDistance;
         this.resetPos();
         TweenLite.to(mapMC.tips,0.3,{
            "alpha":1,
            "scaleY":1
         });
      }
      
      private function blur(arr:Array, value:int) : void
      {
         var mc:* = undefined;
         if(this.index == value)
         {
            this.btnClick();
            return;
         }
         switch(value)
         {
            case 1:
               StatisticsClass.getInstance().init(67744881);
               break;
            case 2:
               StatisticsClass.getInstance().init(67744882);
               break;
            case 3:
               StatisticsClass.getInstance().init(67744883);
               break;
            case 4:
               StatisticsClass.getInstance().init(67744884);
               break;
            case 5:
               StatisticsClass.getInstance().init(67744885);
         }
         this.clearBlur();
         this.index = value;
         localIndex = this.index;
         this.createBlurMapMC();
         var ind:int = mapMC.getChildIndex(mapMC.getChildByName("map_btn"));
         mapMC.addChildAt(this.blurMapMC,ind);
         var ps:Array = [];
         for(var i:int = 0; i < arr.length; i++)
         {
            mc = mapMC.map_btn.getChildByName("btn_" + arr[i]);
            ps.push(mc);
         }
         this.setBlurMapMask(ps);
      }
      
      private function setBlurMapMask(ps:Array) : void
      {
         var mc:DisplayObject = null;
         for(var i:int = 0; i < mapMC.map_btn.numChildren; i++)
         {
            mc = mapMC.map_btn.getChildAt(i);
            if(ps.indexOf(mc) == -1)
            {
               mc.filters = null;
               mc.visible = false;
            }
            else
            {
               mc.filters = [new GlowFilter()];
               mc.visible = true;
            }
         }
      }
      
      private function drawBlurMapMask(ps:Array) : void
      {
         var i:int = 0;
         var cls:Class = null;
         var sb:DisplayObject = null;
         var mc:DisplayObject = null;
         for(i = this.blurMapMask.numChildren - 1; i >= 0; i--)
         {
            this.blurMapMask.removeChildAt(i);
         }
         var dis:int = 4;
         for(i = 0; i < ps.length; i++)
         {
            cls = this.app.getDefinition(getQualifiedClassName(ps[i])) as Class;
            sb = new cls();
            if(Boolean(sb as MovieClip))
            {
               MovieClip(sb).stop();
            }
            sb.x = ps[i].x;
            sb.y = ps[i].y;
            sb.scaleX = sb.scaleY = 1.1;
            this.blurMapMask.addChild(sb);
            mc = ps[i] as DisplayObject;
            mc.filters = [new GlowFilter()];
         }
      }
      
      private function clearBlur() : void
      {
         var i:int = 0;
         var mc:DisplayObject = null;
         localIndex = -1;
         if(this.blurMapMC == null || this.blurMapMC.parent == null)
         {
            return;
         }
         for(i = 0; i < mapMC.map_btn.numChildren; i++)
         {
            mapMC.map_btn.getChildAt(i).filters = null;
         }
         mapMC.removeChild(this.blurMapMC);
         this.index = -1;
         mapMC.getChildByName("map_btn").mask = null;
         for(i = 0; i < mapMC.map_btn.numChildren; i++)
         {
            mc = mapMC.map_btn.getChildAt(i);
            mc.filters = null;
            mc.visible = true;
         }
      }
      
      private function createBlurMapMC() : void
      {
         var i:int = 0;
         var d:DisplayObject = null;
         var n:Number = NaN;
         var nf:int = 0;
         var matrix:Array = null;
         this.blurMapMC = new Bitmap();
         var bmd:BitmapData = new BitmapData(mapMC.width,mapMC.height,true,0);
         var drawMC:Sprite = new Sprite();
         for(i = mapMC.numChildren - 1; i >= 0; i--)
         {
            d = mapMC.getChildAt(i);
            if(this.names.indexOf(d.name) == -1)
            {
               drawMC.addChildAt(d,0);
            }
         }
         bmd.draw(drawMC);
         for(i = drawMC.numChildren - 1; i >= 0; i--)
         {
            mapMC.addChildAt(drawMC.getChildAt(i),0);
         }
         this.blurMapMC.bitmapData = bmd;
         if(this.blurcount != 0)
         {
            n = 1 - this.blurcount * 0.05;
            nf = 255 * this.blurcount * 0.05;
            matrix = new Array();
            matrix = matrix.concat([n,0,0,0,nf]);
            matrix = matrix.concat([0,n,0,0,nf]);
            matrix = matrix.concat([0,0,n,0,nf]);
            matrix = matrix.concat([0,0,0,1,0]);
            this.blurColorMatrixFilter.matrix = matrix;
            this.blurMapMC.filters = [this.blurColorMatrixFilter];
         }
         else
         {
            this.tweenBlur();
         }
      }
      
      private function filterBlur() : void
      {
         ++this.blurcount;
         var n:Number = 1 - this.blurcount * 0.05;
         var nf:int = 255 * this.blurcount * 0.05;
         var matrix:Array = new Array();
         matrix = matrix.concat([n,0,0,0,nf]);
         matrix = matrix.concat([0,n,0,0,nf]);
         matrix = matrix.concat([0,0,n,0,nf]);
         matrix = matrix.concat([0,0,0,1,0]);
         this.blurColorMatrixFilter.matrix = matrix;
         this.blurMapMC.filters = [this.blurColorMatrixFilter];
         if(this.blurcount == 10)
         {
            GC.clearGInterval(this.blurTimer);
         }
      }
      
      private function tweenBlur() : void
      {
         if(Boolean(this.blurTimer))
         {
            GC.clearGInterval(this.blurTimer);
            this.blurTimer = null;
         }
         this.blurcount = 0;
         this.blurTimer = GC.setGInterval(this.filterBlur,50);
      }
      
      private function resetPos() : void
      {
         var tempTotalY:uint = mapMC.tips.tipsbg.height + mapMC.tips.y;
         if(tempTotalY > 500)
         {
            mapMC.tips.y -= tempTotalY - 500;
         }
      }
      
      private function showSun(Cvalue:int) : void
      {
         for(var i:uint = 1; i < 6; i++)
         {
            mapMC.tips.sun["sun" + i].visible = false;
            mapMC.tips.sun["sun" + i].alpha = 0;
         }
         var tempNum:uint = 0;
         if(Cvalue < 1)
         {
            return;
         }
         mapMC.tips.sun.sun1.visible = true;
         TweenLite.to(mapMC.tips.sun.sun1,0.5,{
            "alpha":1,
            "delay":0.1
         });
         if(Cvalue > 5)
         {
            mapMC.tips.sun.sun2.visible = true;
            TweenLite.to(mapMC.tips.sun.sun2,0.5,{
               "alpha":1,
               "delay":0.2
            });
         }
         if(Cvalue > 10)
         {
            mapMC.tips.sun.sun3.visible = true;
            TweenLite.to(mapMC.tips.sun.sun3,0.5,{
               "alpha":1,
               "delay":0.3
            });
         }
         if(Cvalue > 20)
         {
            mapMC.tips.sun.sun4.visible = true;
            TweenLite.to(mapMC.tips.sun.sun4,0.5,{
               "alpha":1,
               "delay":0.4
            });
         }
         if(Cvalue >= 50)
         {
            mapMC.tips.sun.sun5.visible = true;
            TweenLite.to(mapMC.tips.sun.sun5,0.5,{
               "alpha":1,
               "delay":0.5
            });
         }
      }
      
      private function myHomeOver(e:MouseEvent) : void
      {
         this.reallyShow(this.homeObj);
      }
      
      private function myHomeOut(e:MouseEvent) : void
      {
         this.closeTips();
      }
      
      private function closeTips() : void
      {
         clearTimeout(this.timeOutID);
         if(Boolean(mapMC.tips))
         {
            mapMC.tips.visible = false;
         }
      }
   }
}

