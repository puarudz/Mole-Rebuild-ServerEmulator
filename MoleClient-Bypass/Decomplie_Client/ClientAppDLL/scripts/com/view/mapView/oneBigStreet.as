package com.view.mapView
{
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.socketlogic.ClientOnLineSerSocket;
   import com.event.EventTaomee;
   import com.logic.PeopleCountLogic.PeopleCountLogic;
   import com.logic.socket.oneBigStreetSocket.oneBigStreetSocket;
   import com.module.activityModule.checkItem;
   import com.module.helpPanel.HelpPanel;
   import com.module.loadExtentPanel.LoadGame;
   import com.mole.app.map.MapBase;
   import com.view.PeopleView.PeopleManageView;
   import com.view.userPanelView.userPanelView;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   
   public class oneBigStreet extends MapBase
   {
      
      private var target_mc:MovieClip;
      
      private var depth_mc:MovieClip;
      
      private var botton_mc:MovieClip;
      
      private var top_mc:MovieClip;
      
      private var bg_mc:MovieClip;
      
      private var userObj:Object;
      
      private var oldUserArray:Array;
      
      private var moveMapType:int;
      
      private var houseNormX:int = 150;
      
      private var houseNormY:int = 340;
      
      private var houseArr:Array;
      
      private var houseMcArr:Array;
      
      private var houseMcArrBak:Array;
      
      private var houseLoder:Loader;
      
      private var houseSourcePath:String = "resource/oneBigStree/swf/";
      
      private var notHouseStyle:int = 1330003;
      
      private var isStreetEnd:int;
      
      private var loadCount:int;
      
      private var moveTimer:Timer;
      
      private var joinRestaurantMC:MovieClip;
      
      private var firstGird:int;
      
      private var tmpMapID:int;
      
      private var joinObj:Object;
      
      private var joinMap:int;
      
      public function oneBigStreet()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         this.top_mc = GV.MC_mapFrame["top_mc"];
         this.bg_mc = GV.MC_mapFrame["bg_mc"];
         this.top_mc.mouseEnabled = false;
         this.top_mc.mouseChildren = false;
         this.initAStreetFun();
      }
      
      private function initAStreetFun() : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 1000,this.onRead1000);
         oneBigStreetSocket.queryGirdTotal();
      }
      
      private function onRead1000(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1000,this.onRead1000);
         this.firstGird = evt.EventObj.firstGird;
         var MapManageLogic:* = getDefinitionByName("com.logic.MapManageLogic.MapManageLogic");
         var mapObj:Object = MapManageLogic.recordMapArray[MapManageLogic.recordMapArray.length - 2];
         this.tmpMapID = mapObj.mapID;
         if(this.tmpMapID == 2)
         {
            LocalUserInfo.setMyInfo_Grid(evt.EventObj.girdTotal);
         }
         else if(this.tmpMapID != 150 && mapObj.mapType != 31)
         {
            if(evt.EventObj.myGird == 0)
            {
               LocalUserInfo.setMyInfo_Grid(this.randomGird(evt.EventObj.firstGird,evt.EventObj.girdTotal));
            }
            else
            {
               LocalUserInfo.setMyInfo_Grid(evt.EventObj.myGird);
            }
         }
         BC.addEvent(this,GV.onlineSocket,"read_" + 995,this.onRead995);
         oneBigStreetSocket.oneBigStreetHouse();
      }
      
      private function randomGird(firstGird:int, girdTotal:int) : int
      {
         var ret:int = girdTotal - firstGird;
         return int(Math.random() * ret + firstGird);
      }
      
      private function onRead995(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 995,this.onRead995);
         this.houseMcArr = new Array();
         this.houseArr = evt.EventObj.houseArr as Array;
         this.isStreetEnd = evt.EventObj.isStreetEnd;
         this.loadHouseUnit();
      }
      
      private function loadHouseUnit() : void
      {
         var path:String = null;
         if(this.houseArr.length != 0)
         {
            this.houseLoder = new Loader();
            this.houseLoder.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onHouseLoderOver);
            if(this.houseArr[0].houseStyle == 0)
            {
               this.houseArr[0].houseStyle = this.notHouseStyle;
            }
            path = this.houseSourcePath + this.houseArr[0].houseStyle + ".swf";
            this.houseLoder.load(VL.getURLRequest(path));
         }
      }
      
      private function onHouseLoderOver(evt:Event) : void
      {
         this.houseLoder.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onHouseLoderOver);
         var houseMc:MovieClip = evt.currentTarget.content as MovieClip;
         houseMc.theHouseData = this.houseArr[0];
         this.loadCount += 1;
         houseMc.theHouseData.loadCount = this.loadCount;
         this.houseMcArr.push(houseMc);
         if(this.moveMapType == 0)
         {
            houseMc.x = (houseMc.theHouseData.loadCount - 1) % 4 * 230 + this.houseNormX;
            setTimeout(this.initBtn,500);
         }
         else if(this.moveMapType == 1)
         {
            houseMc.x = (houseMc.theHouseData.loadCount - 1) % 4 * 230 + this.houseNormX - 960;
         }
         else if(this.moveMapType == 2)
         {
            houseMc.x = (houseMc.theHouseData.loadCount - 1) % 4 * 230 + this.houseNormX + 960;
         }
         houseMc.y = this.houseNormY;
         if(houseMc.theHouseData.houseType != 0)
         {
            houseMc.houseName.text = houseMc.theHouseData.houseDIYName;
            BC.addEvent(this,houseMc.userInfo,MouseEvent.CLICK,this.onUserInfo);
            houseMc.buttonMode = true;
            BC.addEvent(this,houseMc,MouseEvent.CLICK,this.onUserRestaurant);
            BC.addEvent(this,houseMc,MouseEvent.MOUSE_OVER,this.onUserRestaurant);
            BC.addEvent(this,houseMc,MouseEvent.MOUSE_OUT,this.onUserRestaurant);
         }
         this.target_mc.addChild(houseMc);
         var baseHouseMcNumber:int = (houseMc.theHouseData.loadCount - 1) % 4;
         this.target_mc["houseBox" + this.moveMapType]["h" + baseHouseMcNumber].visible = false;
         this.houseLoder.unload();
         this.houseLoder = null;
         this.houseArr.shift();
         this.loadHouseUnit();
      }
      
      private function onUserInfo(evt:MouseEvent) : void
      {
         var userID:int = int(evt.currentTarget.parent.theHouseData.houseUserId);
         userPanelView.showUserPanel(userID);
      }
      
      private function initBtn() : void
      {
         this.botton_mc.upStreet.buttonMode = true;
         BC.addEvent(this,this.botton_mc.upStreet,MouseEvent.MOUSE_MOVE,this.onUpStreetHandler);
         BC.addEvent(this,this.botton_mc.upStreet,MouseEvent.MOUSE_OUT,this.onUpStreetHandler);
         this.botton_mc.nextStreet.buttonMode = true;
         BC.addEvent(this,this.botton_mc.nextStreet,MouseEvent.MOUSE_MOVE,this.onNextStreetHandler);
         BC.addEvent(this,this.botton_mc.nextStreet,MouseEvent.MOUSE_OUT,this.onNextStreetHandler);
         BC.addEvent(this,this.botton_mc.myBtn,MouseEvent.CLICK,this.onMyBtn);
         BC.addEvent(this,this.botton_mc.goBtn,MouseEvent.CLICK,this.onGoBtn);
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.moveMap);
      }
      
      private function onMyBtn(evt:MouseEvent) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_1027",this.onRead1027);
         oneBigStreetSocket.queryHouseByUid(LocalUserInfo.getUserID(),31);
      }
      
      private function onRead1027(evt:EventTaomee) : void
      {
         if(evt.EventObj.count > 0)
         {
            BC.removeEvent(this,GV.onlineSocket,"read_1027",this.onRead1027);
            GF.switchMap(evt.EventObj.uid,false,evt.EventObj.type);
         }
         else
         {
            BC.addEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.haveCertificate);
            checkItem.checkItemHandler(190658);
         }
      }
      
      private function haveCertificate(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.haveCertificate);
         var msg:String = "";
         if(evt.EventObj.num == 1)
         {
            this.joinMap = 143;
            msg = "    你還沒有開設餐廳呢，去建設署找湯米看看吧。";
         }
         else
         {
            this.joinMap = 149;
            msg = "      沒有領取摩摩土地卡就不能開設餐廳哦，快去摩摩商會找伊蓮吧。";
         }
         this.joinObj = GF.showAlert(MainManager.getGameLevel(),msg,"",100,"go,notgo",true,false,"E");
         this.joinObj.addEventListener("CLICK" + 1,this.doActionHandler);
      }
      
      private function doActionHandler(evt:Event) : void
      {
         this.joinObj.removeEventListener("CLICK" + 1,this.doActionHandler);
         GF.switchMap(this.joinMap,true);
      }
      
      private function onTipsBtn(evt:MouseEvent) : void
      {
         if(Boolean(MainManager.getGameLevel().getChildByName("hleptips")))
         {
            return;
         }
         HelpPanel.getInstance().panelVisible("tips");
      }
      
      private function onGoBtn(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("module/external/restaurantGoOtherMain.swf","正在加載逛逛面板",MainManager.getGameLevel());
         loadGame = null;
      }
      
      private function onUpStreetHandler(evt:MouseEvent) : void
      {
         if(evt.type == MouseEvent.MOUSE_MOVE)
         {
            evt.currentTarget.aMsg.visible = true;
            evt.currentTarget.aMsg.txt.text = "逛逛上一條街";
            if(LocalUserInfo.getMyInfo_Grid() == this.firstGird)
            {
               evt.currentTarget.aMsg.txt.text = "進入米勒大道";
            }
         }
         else if(evt.type == MouseEvent.MOUSE_OUT)
         {
            evt.currentTarget.aMsg.visible = false;
         }
      }
      
      private function onNextStreetHandler(evt:MouseEvent) : void
      {
         if(evt.type == MouseEvent.MOUSE_MOVE)
         {
            evt.currentTarget.aMsg.visible = true;
            evt.currentTarget.aMsg.txt.text = "逛逛下一條街";
            if(this.isStreetEnd == 1)
            {
               evt.currentTarget.aMsg.txt.text = "愛心教堂";
            }
         }
         else if(evt.type == MouseEvent.MOUSE_OUT)
         {
            evt.currentTarget.aMsg.visible = false;
         }
      }
      
      private function moveMap(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"fireAction_select",this.moveMap);
         this.moveMapType = evt.EventObj.type;
         if(this.moveMapType == 2)
         {
            if(this.isStreetEnd == 1)
            {
               GF.switchMap(2,true);
               return;
            }
            GC.clearGInterval(this.moveTimer);
            this.moveTimer = GC.setGInterval(this.moveBG_Fun,60,-960);
            LocalUserInfo.setMyInfo_Grid(LocalUserInfo.getMyInfo_Grid() + 1);
         }
         else if(this.moveMapType == 1)
         {
            if(LocalUserInfo.getMyInfo_Grid() == this.firstGird)
            {
               GF.switchMap(142,true);
               return;
            }
            GC.clearGInterval(this.moveTimer);
            this.moveTimer = GC.setGInterval(this.moveBG_Fun,60,960);
            LocalUserInfo.setMyInfo_Grid(LocalUserInfo.getMyInfo_Grid() - 1);
         }
         this.showBaseHouse(this.moveMapType);
         this.peopleMove(true,this.moveMapType);
         this.loadCount = 0;
         this.houseMcArrBak = new Array();
         this.houseMcArrBak = this.houseMcArr;
         BC.addEvent(this,GV.onlineSocket,"read_" + 995,this.onRead995);
         oneBigStreetSocket.oneBigStreetHouse();
         var p:PeopleManageView = PeopleManageView(GV.MAN_PEOPLE);
         GV.onlineClass.walking(0,p.y,0,LocalUserInfo.getMyInfo_Grid());
         GV.onlineClass.addEventListener(ClientOnLineSerSocket.GET_BASIC_MESSAGE,this.getAllUserInfo);
         GV.onlineClass.getUserListReq(LocalUserInfo.getMyInfo_Grid());
      }
      
      private function moveBG_Fun(pos:int) : void
      {
         this.bg_mc.x += int(pos - this.bg_mc.x) * 0.5;
         this.depth_mc.x = this.bg_mc.x;
         this.target_mc.x = this.bg_mc.x;
         if(Math.abs(this.bg_mc.x - pos) < 1)
         {
            this.bg_mc.x = pos;
            this.depth_mc.x = pos;
            this.target_mc.x = pos;
            GC.clearGInterval(this.moveTimer);
            this.target_mcMoveOver(this.moveMapType);
            this.depth_mcMoveOver(this.moveMapType);
         }
      }
      
      public function getAllUserInfo(evt:*) : void
      {
         var item:* = undefined;
         var tempitem:* = undefined;
         GV.onlineClass.removeEventListener(ClientOnLineSerSocket.GET_BASIC_MESSAGE,this.getAllUserInfo);
         var userArray:Array = evt.EventObj.arr;
         this.userObj = {
            "data":userArray,
            "type":1
         };
         this.oldUserArray = PeopleCountLogic.peopleList.slice(0);
         if(Boolean(this.userObj))
         {
            GV.PeopleCount.changeOnlinePeople(this.userObj);
         }
         this.userObj = null;
         if(this.moveMapType == 2)
         {
            for each(tempitem in PeopleCountLogic.peopleList)
            {
               item = tempitem.Instance;
               if(item != GV.MAN_PEOPLE)
               {
                  item.x += 960;
               }
            }
         }
         else if(this.moveMapType == 1)
         {
            for each(tempitem in PeopleCountLogic.peopleList)
            {
               item = tempitem.Instance;
               if(item != GV.MAN_PEOPLE)
               {
                  item.x -= 960;
               }
            }
         }
      }
      
      private function depth_mcMoveOver(moveMapType:int) : void
      {
         var item:* = undefined;
         var tempitem:* = undefined;
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.moveMap);
         this.peopleMove(false,moveMapType);
         for each(tempitem in this.oldUserArray)
         {
            item = tempitem.Instance;
            if(item != GV.MAN_PEOPLE)
            {
               item["clearEvents"]();
               if(Boolean(item.parent))
               {
                  item.parent.removeChild(item);
               }
            }
         }
         if(moveMapType == 1)
         {
            for each(tempitem in PeopleCountLogic.peopleList)
            {
               item = tempitem.Instance;
               if(item != GV.MAN_PEOPLE)
               {
                  item.x += 960;
               }
            }
         }
         else if(moveMapType == 2)
         {
            for each(tempitem in PeopleCountLogic.peopleList)
            {
               item = tempitem.Instance;
               if(item != GV.MAN_PEOPLE)
               {
                  item.x -= 960;
               }
            }
         }
         this.depth_mc.x = 0;
      }
      
      private function delPeople(obj:*, index:int, arr:Array) : Boolean
      {
         var p:PeopleManageView = obj.Instance as PeopleManageView;
         if(p != GV.MAN_PEOPLE)
         {
            p.parent.removeChild(p);
            p.clearEvents();
         }
         return true;
      }
      
      private function target_mcMoveOver(moveMapType:int) : void
      {
         var len:int = int(this.houseMcArrBak.length);
         for(var i:int = 0; i < this.houseMcArrBak.length; i++)
         {
            this.target_mc.removeChild(this.houseMcArrBak[i]);
            if(moveMapType == 1)
            {
               this.houseMcArr[i].x += 960;
            }
            else if(moveMapType == 2)
            {
               this.houseMcArr[i].x -= 960;
            }
         }
         this.target_mc.x = 0;
         this.bg_mc.x = 0;
      }
      
      private function peopleMove(sign:Boolean, moveMapType:int) : void
      {
         var p:PeopleManageView = PeopleManageView(GV.MAN_PEOPLE);
         if(sign)
         {
            p.startX = p.x;
            p.startY = p.y;
            if(moveMapType == 2)
            {
               p.endX = 959;
               p.endY = p.y;
            }
            else if(moveMapType == 1)
            {
               p.endX = 0;
               p.endY = p.y;
            }
         }
         else
         {
            if(moveMapType == 2)
            {
               p.x = 0;
               p.startX = 0;
               p.startY = p.y;
               p.endX = 100;
               p.endY = p.y;
            }
            else if(moveMapType == 1)
            {
               p.x = 959;
               p.startX = 959;
               p.startY = p.y;
               p.endX = 860;
               p.endY = p.y;
            }
            GV.onlineClass.walking(p.endX,p.y,0,LocalUserInfo.getMyInfo_Grid());
         }
         p.gotoHere([-10,10],38);
      }
      
      private function showBaseHouse(moveMapType:int) : void
      {
         for(var i:int = 0; i < 4; i++)
         {
            this.target_mc["houseBox" + moveMapType]["h" + i].visible = true;
         }
      }
      
      private function onUserRestaurant(evt:MouseEvent) : void
      {
         var tipsS:String = null;
         BC.addEvent(this,GV.onlineSocket,"HOME_HIT",this.gotoRestaurant);
         if(evt.type == MouseEvent.MOUSE_OVER)
         {
            tipsS = "進入" + evt.currentTarget.theHouseData.houseUserId + "的餐廳";
            tip.tipTailDisPlayObject(evt.currentTarget.house,tipsS);
         }
         else if(evt.type == MouseEvent.MOUSE_OUT)
         {
            tip.hideTip();
         }
         else if(evt.type == MouseEvent.CLICK)
         {
            this.joinRestaurantMC = evt.currentTarget as MovieClip;
         }
      }
      
      private function gotoRestaurant(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"HOME_HIT",this.gotoRestaurant);
         var userId:int = int(this.joinRestaurantMC.theHouseData.houseUserId);
         GF.switchMap(userId,false,this.joinRestaurantMC.theHouseData.houseType);
      }
      
      override public function destroy() : void
      {
         if(this.joinObj != null)
         {
            this.joinObj.removeEventListener("CLICK" + 1,this.doActionHandler);
         }
         this.target_mc = null;
         this.depth_mc = null;
         this.botton_mc = null;
         super.destroy();
      }
   }
}

