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
   import com.module.house.houseListView;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class WordMapLogic_MLD extends Sprite
   {
      
      public static var mapMC:MovieClip;
      
      public var houseListViews:houseListView;
      
      private var timeOutID:uint = 0;
      
      private var worldXML:XML;
      
      private var mapObjArr:Array;
      
      private var homeObj:MapObj;
      
      private var extdelay:int = 500;
      
      public function WordMapLogic_MLD(map:*)
      {
         super();
         this.houseListViews = new houseListView();
         mapMC = map.content.root;
         setTimeout(function():void
         {
            EventInit();
         },100);
         this.initMolePlace();
         this.loadXML();
         this.initTips();
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.closeMap);
      }
      
      private function closeMap(evt:EventTaomee) : void
      {
         this.closeBtnClick();
      }
      
      private function initTips() : void
      {
         mapMC.tips.visible = false;
         mapMC.tips.mouseChildren = false;
         mapMC.tips.mouseEnabled = false;
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
         this.worldXML = XMLInfo.WorldMapXML_MLD;
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
      
      private function mapClickHandler(e:Event) : void
      {
         var p:PeopleManageView = null;
         e.stopPropagation();
         var num:int = int(MapObj(e.target).id);
         if(LocalUserInfo.getMapID() != num && !MapObj(e.target)._isLockMove)
         {
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
               GF.switchMap(num,true);
            }
            else
            {
               GF.switchMap(num,true);
            }
            GV.onlineSocket.dispatchEvent(new EventTaomee("CAR_GAME_MAP"));
            this.closeBtnClick();
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
      
      private function reallyShow(CmapObj:MapObj) : void
      {
         clearTimeout(this.timeOutID);
         this.timeOutID = setTimeout(this.showTips,this.extdelay,CmapObj);
      }
      
      private function showTips(CmapObj:MapObj) : void
      {
         var tempTxt:TextField = null;
         var i:uint = 0;
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
         i = 0;
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
            firstMap = LocalUserInfo.getMapID();
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
      
      private function closeTips() : void
      {
         clearTimeout(this.timeOutID);
         if(Boolean(mapMC.tips))
         {
            mapMC.tips.visible = false;
         }
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
         if(Boolean(mapMC.map_btn["btn_" + placeNul]))
         {
            mapMC.mole_mc.visible = true;
            mapMC.mole_mc.x = mapMC.map_btn["btn_" + placeNul].x + mapMC.map_btn.x;
            mapMC.mole_mc.y = mapMC.map_btn["btn_" + placeNul].y + mapMC.map_btn.y;
            this.setColor();
         }
         else
         {
            mapMC.mole_mc.visible = true;
            mapMC.mole_mc.x = mapMC.map_btn["btn_" + 8].x + mapMC.map_btn.x;
            mapMC.mole_mc.y = mapMC.map_btn["btn_" + 8].y + mapMC.map_btn.y;
         }
         mapMC.mole_mc.mouseChildren = false;
         mapMC.mole_mc.mouseEnabled = false;
      }
      
      private function setColor() : void
      {
         var color:int = LocalUserInfo.getFamily();
         var myColor:Object = GF.getRGBColor(color);
         mapMC.mole_mc.mc.mc.transform.colorTransform = new ColorTransform(myColor.red / 256,myColor.green / 256,myColor.blue / 256,1);
      }
      
      private function EventInit() : void
      {
         var serID:* = GV.serverID;
         var serName:String = ServerListManager.getServerName(serID);
         mapMC.serAdd.text = "你所在的伺服器是:" + serID + "." + serName;
         BC.addEvent(this,mapMC.closeBtn,MouseEvent.CLICK,this.closeBtnClick);
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
   }
}

