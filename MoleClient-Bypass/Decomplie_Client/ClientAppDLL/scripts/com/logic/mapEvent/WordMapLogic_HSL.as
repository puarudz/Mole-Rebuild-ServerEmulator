package com.logic.mapEvent
{
   import com.common.Tween.TweenLite;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.info.MapInfo;
   import com.core.manager.ServerListManager;
   import com.event.EventTaomee;
   import com.global.staticData.MapsConfig;
   import com.global.staticData.XMLInfo;
   import com.logic.switchMapLogic.switchMapLogic;
   import com.module.house.homehotXML;
   import com.module.house.houseListView;
   import com.mole.app.map.MapManager;
   import com.view.toolView.toolView;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class WordMapLogic_HSL extends Sprite
   {
      
      public static var mapMC:MovieClip;
      
      public var houseListViews:houseListView;
      
      public var areaArr:Array;
      
      public var isHomeHot:Boolean = false;
      
      private var PlaceArr:Array;
      
      private var worldXML:XML;
      
      private var mapObjArr:Array;
      
      private var homeObj:MapObj;
      
      private var extdelay:int = 600;
      
      private var timeOutID:uint = 0;
      
      private var useSkillTimer:Timer;
      
      private var useSkillTimer1:Timer;
      
      private var cm:MovieClip;
      
      public function WordMapLogic_HSL(map:*)
      {
         super();
         this.houseListViews = new houseListView();
         mapMC = map.content.root;
         setTimeout(function():void
         {
            EventInit();
         },100);
         this.initMolePlace();
         this.initAreaArr();
         this.loadXML();
         this.initTips();
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.closeMap);
      }
      
      private function loadXML() : void
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
         this.worldXML = XMLInfo.WorldMapXML_HSL;
         this.mapObjArr = new Array();
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
            tempObj.init(tempID,tempName,0,tempActive,tempTipObj,tempImgArr,isLockMove);
            if(Boolean(mapMC.map_btn["btn_" + tempObj.id]))
            {
               tempObj.btn = mapMC.map_btn["btn_" + tempObj.id];
               tempObj.btn.buttonMode = true;
               BC.addEvent(this,tempObj,MapObj.MAP_Click,this.mapClickHandler);
               BC.addEvent(this,tempObj,MapObj.MAP_ROLL_OVER,this.mapOverHandler);
               BC.addEvent(this,tempObj,MapObj.MAP_ROLL_OUT,this.mapOutHandler);
            }
            this.mapObjArr.push(tempObj);
         }
         this.homeObj = new MapObj();
         this.homeObj.id = 1000;
         this.homeObj.name = "展示家園";
         tempDecObj = new MapDescriptionObj("絲姐姐的家就在這裡！",1);
         this.homeObj.tipObj.taskArr.push(tempDecObj);
         this.homeObj._btn = mapMC.map_btn.myHome;
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
         var placeNul:uint = LocalUserInfo.getMapID();
         if(placeNul > 1000 || placeNul == 82 || placeNul == 58)
         {
            mapInfo = MapInfo.currentMapInfo();
            mapMC.mole_mc.visible = true;
            if(mapInfo.name == "dining")
            {
               if(Boolean(mapMC) && Boolean(mapMC.map_btn) && Boolean(mapMC.map_btn["btn_142"]))
               {
                  mapMC.mole_mc.x = mapMC.map_btn["btn_142"].x + mapMC.map_btn.x;
                  mapMC.mole_mc.y = mapMC.map_btn["btn_142"].y + mapMC.map_btn.y;
               }
            }
            else if(Boolean(mapMC.map_btn.myHome))
            {
               mapMC.mole_mc.x = mapMC.map_btn.myHome.x + mapMC.map_btn.x;
               mapMC.mole_mc.y = mapMC.map_btn.myHome.y + mapMC.map_btn.y;
            }
            this.setColor();
            return;
         }
         if(placeNul == 241)
         {
            mapMC.mole_mc.x = 388;
            mapMC.mole_mc.y = 207;
         }
         else if(Boolean(mapMC.map_btn["btn_" + placeNul]))
         {
            mapMC.mole_mc.visible = true;
            mapMC.mole_mc.x = mapMC.map_btn["btn_" + placeNul].x + mapMC.map_btn.x;
            mapMC.mole_mc.y = mapMC.map_btn["btn_" + placeNul].y + mapMC.map_btn.y;
            this.setColor();
         }
         else
         {
            mapMC.mole_mc.visible = true;
            mapMC.mole_mc.x = mapMC.map_btn["btn_" + 124].x + mapMC.map_btn.x;
            mapMC.mole_mc.y = mapMC.map_btn["btn_" + 124].y + mapMC.map_btn.y;
         }
         mapMC.mole_mc.mouseChildren = false;
         mapMC.mole_mc.mouseEnabled = false;
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
      }
      
      private function EventInit() : void
      {
         var serID:* = GV.serverID;
         var serName:String = ServerListManager.getServerName(serID);
         mapMC.serAdd.text = "你所在的伺服器是:" + serID + "." + serName;
         BC.addEvent(this,mapMC.closeBtn,MouseEvent.CLICK,this.closeBtnClick);
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
         e.stopPropagation();
         var num:int = int(MapObj(e.target).id);
         if(LocalUserInfo.getMapID() != num && !MapObj(e.target)._isLockMove)
         {
            this.closeBtnClick();
            if(num == 61)
            {
               toolView.getInstance().goMapFunc(1);
            }
            else
            {
               MapManager.enterMap(num);
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
      
      private function showTips(CmapObj:MapObj) : void
      {
         var tempTxt:TextField = null;
         var firstMap:int = 0;
         mapMC.tips.alpha = 0;
         mapMC.tips.scaleY = 0.5;
         mapMC.tips.visible = true;
         mapMC.tips.x = CmapObj._btn.x + mapMC.map_btn.x - 20;
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
         var tempY:int = 5;
         var tempDistance:uint = 5;
         var tempTxtDistance:uint = 18;
         var tempTotalHeigth:uint = 30;
         var tempTaskHeight:uint = 2;
         var tempGameHeight:uint = 2;
         var tempShoppingHeight:uint = 2;
         var tempWorkingHeight:uint = 2;
         var textFormat:TextFormat = new TextFormat();
         textFormat.align = TextFormatAlign.LEFT;
         textFormat.size = 12;
         var i:uint = 0;
         var textX:int = 0;
         var textY:int = 0;
         if(CmapObj.tipObj.taskArr.length > 0)
         {
            textY = 0;
            mapMC.tips.task.y = tempY;
            mapMC.tips.task.visible = true;
            mapMC.tips.task.alpha = 0;
            TweenLite.to(mapMC.tips.task,0.5,{
               "alpha":1,
               "delay":0.1
            });
            for(i = 0; i < CmapObj.tipObj.taskArr.length; i++)
            {
               tempTxt = new TextField();
               tempTxt.width = 145;
               tempTxt.maxChars = 10;
               tempTxt.setTextFormat(textFormat);
               tempTxt.text = CmapObj.tipObj.taskArr[i].descrpiton;
               tempTxt.textColor = CmapObj.tipObj.taskArr[i].color;
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
         if(CmapObj.tipObj.gameArr.length > 0)
         {
            textY = 0;
            mapMC.tips.game.y = tempY;
            mapMC.tips.game.visible = true;
            mapMC.tips.game.alpha = 0;
            TweenLite.to(mapMC.tips.game,0.5,{
               "alpha":1,
               "delay":0.2
            });
            for(i = 0; i < CmapObj.tipObj.gameArr.length; i++)
            {
               tempTxt = new TextField();
               tempTxt.width = 145;
               tempTxt.maxChars = 10;
               tempTxt.setTextFormat(textFormat);
               tempTxt.text = CmapObj.tipObj.gameArr[i].descrpiton;
               tempTxt.textColor = CmapObj.tipObj.gameArr[i].color;
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
         if(CmapObj.tipObj.shoppingArr.length > 0)
         {
            textY = 0;
            mapMC.tips.shopping.y = tempY;
            mapMC.tips.shopping.visible = true;
            mapMC.tips.shopping.alpha = 0;
            TweenLite.to(mapMC.tips.shopping,0.5,{
               "alpha":1,
               "delay":0.3
            });
            for(i = 0; i < CmapObj.tipObj.shoppingArr.length; i++)
            {
               tempTxt = new TextField();
               tempTxt.width = 145;
               tempTxt.maxChars = 10;
               tempTxt.setTextFormat(textFormat);
               tempTxt.text = CmapObj.tipObj.shoppingArr[i].descrpiton;
               tempTxt.textColor = CmapObj.tipObj.shoppingArr[i].color;
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
         if(CmapObj.tipObj.workingArr.length > 0)
         {
            textY = 0;
            mapMC.tips.working.y = tempY;
            mapMC.tips.working.visible = true;
            mapMC.tips.working.alpha = 0;
            TweenLite.to(mapMC.tips.working,0.5,{
               "alpha":1,
               "delay":0.4
            });
            for(i = 0; i < CmapObj.tipObj.workingArr.length; i++)
            {
               tempTxt = new TextField();
               tempTxt.width = 145;
               tempTxt.maxChars = 10;
               tempTxt.setTextFormat(textFormat);
               tempTxt.text = CmapObj.tipObj.workingArr[i].descrpiton;
               tempTxt.textColor = CmapObj.tipObj.workingArr[i].color;
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
         mapMC.tips.dec_txt.y = tempY;
         var tempMap:int = LocalUserInfo.getMapID();
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

