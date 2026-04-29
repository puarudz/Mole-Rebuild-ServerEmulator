package com.module.lahmClassRoom
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.scrollBar.ScrollBar;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.manager.AssetsManage;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.logic.socket.lahmClassRoomSocket.lahmClassRoomSocket;
   import com.module.loadExtentPanel.LoadGame;
   import com.view.toolView.toolView;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   
   public class lahmClassRoomUI
   {
      
      private static var instance:lahmClassRoomUI;
      
      private static var canotNew:Boolean = true;
      
      private var lahmclassroombeen:lahmClassRoomBeen;
      
      private var UI:MovieClip;
      
      private var control_mc:MovieClip;
      
      private var myalter:Object;
      
      private var goodsArr:Array;
      
      public const SHOWGOODS_MAX:int = 8;
      
      private var currentPage:int = 1;
      
      private var allPage:int;
      
      private var imgLoad:Loader;
      
      private var loader:Loader;
      
      public var toolGoodsArr:Array = new Array(190750,190751,190752,190753,190754);
      
      public var toolSpecialGoodsArr:Array = new Array(190756,190755,190757);
      
      public var unClassToolGoodsArr:Array = [190757];
      
      private var createShopAssets:AssetsManage;
      
      private var hasPushfoodPan:Boolean = false;
      
      private var acScrollBar:ScrollBar;
      
      private var mc_Class:Class;
      
      private var itemBtn:MovieClip;
      
      private var toHappyNum:int;
      
      private var toHappyLoader:Loader;
      
      public function lahmClassRoomUI()
      {
         super();
         if(canotNew)
         {
            throw new Error("lahmClassRoomUI不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : lahmClassRoomUI
      {
         if(!instance)
         {
            canotNew = false;
            instance = new lahmClassRoomUI();
            canotNew = true;
         }
         return instance;
      }
      
      public function init() : void
      {
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         this.lahmclassroombeen = lahmClassRoomBeen.getInstance();
         this.UI = this.lahmclassroombeen.getLahmClassRoomMC().UI;
         this.control_mc = this.lahmclassroombeen.getLahmClassRoomMC().control_mc;
         this.initMsgPanel();
         this.initFunBtn();
         if(this.lahmclassroombeen.isMyLahmClassRoom())
         {
            this.initTool();
         }
      }
      
      public function initMsgPanel() : void
      {
         var crLevelUI:MovieClip = this.UI.msgPanel.crLevel;
         var crEnergyUI:MovieClip = this.UI.msgPanel.crEnergy;
         var crLovelyUI:MovieClip = this.UI.msgPanel.crLovely;
         BC.removeEvent(this,this.UI.msgPanel.crState,MouseEvent.CLICK,this.onCrState);
         if(this.lahmclassroombeen.isMyLahmClassRoom())
         {
            if(this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 3)
            {
               this.UI.nowMsgPanel.visible = false;
               this.UI.msgPanel.visible = true;
               this.UI.msgPanel.crState.gotoAndStop(1);
            }
            else if(this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 0 || this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 1)
            {
               this.UI.nowMsgPanel.x = this.UI.msgPanel.x;
               this.UI.msgPanel.visible = false;
               this.UI.nowMsgPanel.visible = true;
               crLevelUI = this.UI.nowMsgPanel.crLevel;
               crEnergyUI = this.UI.nowMsgPanel.crEnergy;
               crLovelyUI = this.UI.nowMsgPanel.crLovely;
               lahmClassRoomState.getInstance().setupClassFlag1A2(this.lahmclassroombeen.getLahmClassRoomInfo().overClassTimer);
               lahmClassRoomStudent.getInstance().setupClassLahmMovie(this.lahmclassroombeen.getLahmClassRoomInfo().coursesId);
            }
            else if(this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 2)
            {
               this.UI.nowMsgPanel.visible = false;
               this.UI.msgPanel.visible = true;
               this.UI.msgPanel.crState.gotoAndStop(3);
            }
            else if(this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 4)
            {
               this.UI.nowMsgPanel.visible = false;
               this.UI.msgPanel.visible = true;
               this.UI.msgPanel.crState.buttonMode = true;
               this.UI.msgPanel.crState.gotoAndStop(4);
               BC.addEvent(this,this.UI.msgPanel.crState,MouseEvent.CLICK,this.onCrState);
            }
            else if(this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 5)
            {
               this.UI.nowMsgPanel.visible = false;
               this.UI.msgPanel.visible = true;
               this.UI.msgPanel.crState.buttonMode = true;
               this.UI.msgPanel.crState.gotoAndStop(5);
               lahmClassRoomStudent.getInstance().clearLahmMovie();
               lahmClassRoomStudent.getInstance().clearLahmName();
               lahmClassRoomStudentChat.getInstance().clearChatTimer();
               lahmClassRoomState.getInstance().clearTestTimer();
               lahmClassRoomState.getInstance().clearCourseTimer();
               lahmClassRoomEvent.getInstance().showPuti();
            }
         }
         else
         {
            this.UI.nowMsgPanel.visible = false;
            this.UI.msgPanel.visible = true;
            if(this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 3)
            {
               this.UI.msgPanel.crState.gotoAndStop(1);
            }
            else if(this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 0 || this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 1)
            {
               this.UI.msgPanel.crState.gotoAndStop(2);
            }
            else if(this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 2)
            {
               this.UI.msgPanel.crState.gotoAndStop(3);
            }
            else if(this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 4)
            {
               this.UI.msgPanel.crState.gotoAndStop(4);
            }
            else if(this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 5)
            {
               this.UI.msgPanel.crState.gotoAndStop(5);
            }
         }
         this.setMsgPanelData();
         BC.addEvent(this,crLevelUI,MouseEvent.MOUSE_OVER,this.onCrLevelUI);
         BC.addEvent(this,crLevelUI,MouseEvent.MOUSE_OUT,this.onCrLevelUI);
         BC.addEvent(this,crLevelUI,MouseEvent.CLICK,this.onCrLevelUI);
         BC.addEvent(this,crEnergyUI,MouseEvent.MOUSE_OVER,this.onCrEnergyUI);
         BC.addEvent(this,crEnergyUI,MouseEvent.MOUSE_OUT,this.onCrEnergyUI);
         BC.addEvent(this,crEnergyUI,MouseEvent.CLICK,this.onCrEnergyUI);
         BC.addEvent(this,crLovelyUI,MouseEvent.MOUSE_OVER,this.onCrLovelyUI);
         BC.addEvent(this,crLovelyUI,MouseEvent.MOUSE_OUT,this.onCrLovelyUI);
         BC.addEvent(this,crLovelyUI,MouseEvent.CLICK,this.onCrLovelyUI);
      }
      
      public function setMsgPanelData(tempMsgPanelData:Object = null) : void
      {
         var levelToExp:int;
         var showLevelBarTotalFrames:int;
         var speedShowLevelBar:int;
         var maxLevelNum:int;
         var energyS:String;
         var energyNum:int;
         var energyBar:int;
         var lovelyS:String;
         var lovelyNum:int;
         var lovelySBar:int;
         var theMsgPanel:MovieClip = null;
         var tempDataInfo:Object = null;
         theMsgPanel = this.UI.msgPanel;
         if(this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 0 || this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 1)
         {
            if(this.lahmclassroombeen.isMyLahmClassRoom())
            {
               theMsgPanel = this.UI.nowMsgPanel;
            }
         }
         if(tempMsgPanelData != null)
         {
            tempDataInfo = tempMsgPanelData;
            if(tempDataInfo.level > this.lahmclassroombeen.getLahmClassRoomInfo().level && this.lahmclassroombeen.isMyLahmClassRoom())
            {
               this.popGoUpPanel(tempDataInfo.level,tempDataInfo.exp);
            }
            if(tempDataInfo.exp != this.lahmclassroombeen.getLahmClassRoomInfo().exp)
            {
               theMsgPanel.crLevel.showLevelMc.scaleX = theMsgPanel.crLevel.showLevelMc.scaleY = 1.1;
               setTimeout(function():void
               {
                  theMsgPanel.crLevel.showLevelMc.scaleX = theMsgPanel.crLevel.showLevelMc.scaleY = 1;
               },300);
            }
            if(tempDataInfo.energy != this.lahmclassroombeen.getLahmClassRoomInfo().energy)
            {
               theMsgPanel.crEnergy.showEnergyMc.scaleX = theMsgPanel.crEnergy.showEnergyMc.scaleY = 1.1;
               setTimeout(function():void
               {
                  theMsgPanel.crEnergy.showEnergyMc.scaleX = theMsgPanel.crEnergy.showEnergyMc.scaleY = 1;
               },300);
            }
            if(tempDataInfo.lovely != this.lahmclassroombeen.getLahmClassRoomInfo().lovely)
            {
               theMsgPanel.crLovely.showLovelyMc.scaleX = theMsgPanel.crLovely.showLovelyMc.scaleY = 1.1;
               setTimeout(function():void
               {
                  theMsgPanel.crLovely.showLovelyMc.scaleX = theMsgPanel.crLovely.showLovelyMc.scaleY = 1;
               },300);
            }
            this.lahmclassroombeen.getLahmClassRoomInfo().level = tempDataInfo.level;
            this.lahmclassroombeen.getLahmClassRoomInfo().exp = tempDataInfo.exp;
            this.lahmclassroombeen.getLahmClassRoomInfo().energy = tempDataInfo.energy;
            this.lahmclassroombeen.getLahmClassRoomInfo().lovely = tempDataInfo.lovely;
         }
         theMsgPanel.crLevel.levelMc.gotoAndStop(this.lahmclassroombeen.getLahmClassRoomInfo().level);
         theMsgPanel.crLevel.showLevelMc.numTxt.text = this.lahmclassroombeen.getLahmClassRoomInfo().exp;
         levelToExp = int(XMLInfo.lahmClassRoom.level[this.lahmclassroombeen.getLahmClassRoomInfo().level]);
         showLevelBarTotalFrames = int(theMsgPanel.crLevel.showLevelMc.showBar.totalFrames);
         speedShowLevelBar = showLevelBarTotalFrames / (levelToExp / this.lahmclassroombeen.getLahmClassRoomInfo().exp);
         theMsgPanel.crLevel.showLevelMc.showBar.gotoAndStop(speedShowLevelBar);
         maxLevelNum = int(XMLInfo.lahmClassRoom.maxLevel);
         if(this.lahmclassroombeen.getLahmClassRoomInfo().level >= maxLevelNum)
         {
            theMsgPanel.crLevel.showLevelMc.showBar.gotoAndStop(showLevelBarTotalFrames);
         }
         energyS = Number(this.lahmclassroombeen.getLahmClassRoomInfo().energy / 10).toFixed(1);
         theMsgPanel.crEnergy.showEnergyMc.numTxt.text = energyS;
         energyNum = Math.ceil(Number(energyS));
         energyBar = Math.ceil(energyNum / 2);
         theMsgPanel.crEnergy.showEnergyMc.showBar.gotoAndStop(energyBar);
         lovelyS = Number(this.lahmclassroombeen.getLahmClassRoomInfo().lovely / 10).toFixed(1);
         theMsgPanel.crLovely.showLovelyMc.numTxt.text = lovelyS;
         lovelyNum = Math.ceil(Number(lovelyS));
         lovelySBar = Math.ceil(lovelyNum / 2);
         theMsgPanel.crLovely.showLovelyMc.showBar.gotoAndStop(lovelySBar);
      }
      
      private function popGoUpPanel(nowLevel:int, nowExp:int) : void
      {
         var frameNum:int;
         var name:String;
         this.UI.goUpPanel.x = this.UI.stage.stageWidth / 2;
         this.UI.goUpPanel.y = this.UI.stage.stageHeight / 2;
         frameNum = int(XMLInfo.lahmClassRoom.levelShowMc[nowLevel]);
         this.UI.goUpPanel.showMc.gotoAndStop(frameNum);
         this.UI.goUpPanel.levelTxt.text = nowLevel + "";
         name = XMLInfo.lahmClassRoom.levelTitle[nowLevel];
         this.UI.goUpPanel.nameTxt.text = name;
         if(nowLevel == XMLInfo.lahmClassRoom.maxLevel)
         {
            this.UI.goUpPanel.goUpTxt.text = XMLInfo.lahmClassRoom.levelMessage[nowLevel];
            this.UI.goUpPanel.levelNoteTxt.text = XMLInfo.lahmClassRoom.levelMessage[nowLevel];
         }
         else if(LocalUserInfo.isVIP())
         {
            this.UI.goUpPanel.goUpTxt.text = XMLInfo.lahmClassRoom.levelSLMessage[nowLevel];
            this.UI.goUpPanel.levelNoteTxt.text = XMLInfo.lahmClassRoom.nextLevelSLMessage[nowLevel + 1];
         }
         else
         {
            this.UI.goUpPanel.goUpTxt.text = XMLInfo.lahmClassRoom.levelMessage[nowLevel];
            this.UI.goUpPanel.levelNoteTxt.text = XMLInfo.lahmClassRoom.nextLevelMessage[nowLevel + 1];
         }
         BC.addEvent(this,this.UI.goUpPanel.closeBtn,MouseEvent.CLICK,function(e:MouseEvent):void
         {
            UI.goUpPanel.x *= 3;
            UI.goUpPanel.y *= 3;
         });
      }
      
      public function onCrState(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("module/external/SelectCoutseMain.swf","正在加載選課面板",MainManager.getGameLevel());
         loadGame = null;
      }
      
      private function onCrLevelUI(evt:MouseEvent) : void
      {
         var levelNum:int = 0;
         var exp:int = 0;
         var levelToExp:int = 0;
         var maxLevelNum:int = 0;
         var unExpToExp:int = 0;
         var loadGame:LoadGame = null;
         if(evt.type == MouseEvent.MOUSE_OVER)
         {
            levelNum = int(this.lahmclassroombeen.getLahmClassRoomInfo().level);
            exp = int(this.lahmclassroombeen.getLahmClassRoomInfo().exp);
            levelToExp = int(XMLInfo.lahmClassRoom.level[levelNum]);
            maxLevelNum = int(XMLInfo.lahmClassRoom.maxLevel);
            evt.currentTarget.scaleX = evt.currentTarget.scaleY = 1;
            unExpToExp = new lahmClassRoomTool().GetTeachingLvlUpNeedExpByNowExp(exp);
            if(levelNum >= maxLevelNum)
            {
               evt.currentTarget.levelNumMcTips.gotoAndStop(2);
            }
            else
            {
               evt.currentTarget.levelNumMcTips.tipsTxt.text = "需要" + unExpToExp + "經驗值升到" + (levelNum + 1) + "級";
            }
            evt.currentTarget.levelNumMcTips.visible = true;
         }
         else if(evt.type == MouseEvent.MOUSE_OUT)
         {
            evt.currentTarget.scaleX = evt.currentTarget.scaleY = 1;
            evt.currentTarget.levelNumMcTips.visible = false;
         }
         else if(evt.type == MouseEvent.CLICK)
         {
            loadGame = new LoadGame("module/external/lahmClassRoomLevelMain.swf","正在加載等級面板",MainManager.getGameLevel());
            loadGame = null;
         }
      }
      
      private function onCrEnergyUI(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = null;
         if(evt.type == MouseEvent.MOUSE_OVER)
         {
            evt.currentTarget.EnergyTips.visible = true;
            evt.currentTarget.scaleX = evt.currentTarget.scaleY = 1;
         }
         else if(evt.type == MouseEvent.MOUSE_OUT)
         {
            evt.currentTarget.scaleX = evt.currentTarget.scaleY = 1;
            evt.currentTarget.EnergyTips.visible = false;
         }
         else if(evt.type == MouseEvent.CLICK)
         {
            loadGame = new LoadGame("module/external/lahmClassRoomEnergy.swf","正在加載精力面板",MainManager.getGameLevel());
            loadGame = null;
         }
      }
      
      private function onCrLovelyUI(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = null;
         if(evt.type == MouseEvent.MOUSE_OVER)
         {
            evt.currentTarget.LovelyTips.visible = true;
            evt.currentTarget.scaleX = evt.currentTarget.scaleY = 1;
         }
         else if(evt.type == MouseEvent.MOUSE_OUT)
         {
            evt.currentTarget.scaleX = evt.currentTarget.scaleY = 1;
            evt.currentTarget.LovelyTips.visible = false;
         }
         else if(evt.type == MouseEvent.CLICK)
         {
            loadGame = new LoadGame("module/external/lahmClassRoomLovely.swf","正在加載親密度面板",MainManager.getGameLevel());
            loadGame = null;
         }
      }
      
      public function initFunBtn() : void
      {
         if(this.lahmclassroombeen.isMyLahmClassRoom())
         {
            this.UI.otherMenu.visible = false;
            if(this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag != 0 || this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag != 1)
            {
               this.UI.myMenu.planBtn.visible = true;
               this.UI.myMenu.phoneBtn.visible = true;
               BC.addEvent(this,this.UI.myMenu.planBtn,MouseEvent.CLICK,this.onPlanBtn);
               BC.addEvent(this,this.UI.myMenu.phoneBtn,MouseEvent.CLICK,this.onPhoneBtn);
            }
            if(this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 0 || this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 1 || this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 4)
            {
               this.UI.myMenu.planBtn.visible = false;
               this.UI.myMenu.phoneBtn.visible = false;
            }
            BC.addEvent(this,this.UI.myMenu.dataBtn,MouseEvent.CLICK,this.onDataBtn);
            BC.addEvent(this,this.UI.myMenu.beforeBtn,MouseEvent.CLICK,this.onBeforeBtn);
            BC.addEvent(this,this.UI.myMenu.goBtn,MouseEvent.CLICK,this.onGoBtn);
            this.control_mc.myNameMc.buttonMode = true;
            BC.addEvent(this,this.control_mc.myNameMc,MouseEvent.CLICK,this.onMyNameMc);
            BC.addEvent(this,this.control_mc.myNameMc,MouseEvent.MOUSE_OVER,this.onMyNameMc);
            BC.addEvent(this,this.control_mc.myNameMc,MouseEvent.MOUSE_OUT,this.onMyNameMc);
         }
         else
         {
            this.UI.otherMenu.x = this.UI.myMenu.x;
            this.UI.myMenu.visible = false;
            BC.addEvent(this,this.UI.otherMenu.dataBtn,MouseEvent.CLICK,this.onDataBtn);
            BC.addEvent(this,this.UI.otherMenu.beforeBtn,MouseEvent.CLICK,this.onBeforeBtn);
            BC.addEvent(this,this.UI.otherMenu.acBtn,MouseEvent.CLICK,this.onacBtnFun);
            BC.addEvent(this,this.UI.otherMenu.myBtn,MouseEvent.CLICK,this.onMyBtn);
            BC.addEvent(this,this.UI.otherMenu.goBtn,MouseEvent.CLICK,this.onGoBtn);
         }
         BC.addEvent(this,this.control_mc.bookBtn,MouseEvent.CLICK,this.onBookBtn);
      }
      
      private function onBookBtn(evt:MouseEvent) : void
      {
         this.createShop();
      }
      
      public function createShop() : void
      {
         if(!this.createShopAssets)
         {
            this.createShopAssets = new AssetsManage();
         }
         this.createShopAssets.IncludeLib("createShop_Lib","module/external/BooksUI/lahmClassRoomBook.swf","正在打開...",true);
         MainManager.getAppLevel().addChild(this.createShopAssets.getLoader());
         this.hasPushfoodPan = true;
         this.createShopAssets.getLoader().contentLoaderInfo.sharedEvents.addEventListener("close",this.closeFun);
      }
      
      private function closeFun(E:*) : void
      {
         this.createShopAssets.getLoader().contentLoaderInfo.sharedEvents.removeEventListener("close",this.closeFun);
         this.hasPushfoodPan = false;
         GC.clearAll(this.createShopAssets.getLoader());
         this.createShopAssets = null;
      }
      
      public function onMyNameMc(evt:MouseEvent) : void
      {
         var tipsS:String = null;
         if(evt.type == MouseEvent.MOUSE_OVER)
         {
            tipsS = "更改拉姆教室名稱";
            tip.tipTailDisPlayObject(evt.currentTarget,tipsS);
         }
         else if(evt.type == MouseEvent.MOUSE_OUT)
         {
            tip.hideTip();
         }
         else if(evt.type == MouseEvent.CLICK)
         {
            this.UI.changeName.x = this.UI.stage.stageWidth / 2;
            this.UI.changeName.y = this.UI.stage.stageHeight / 2;
            BC.addEvent(this,this.UI.changeName.sureBtn,MouseEvent.CLICK,this.onSureBtn);
            BC.addEvent(this,this.UI.changeName.cancelBtn,MouseEvent.CLICK,this.onCancelBtn);
            this.UI.changeName.nameTxt.text = "可以輸入5個漢字或者10個字符";
            BC.addEvent(this,this.UI.changeName.nameTxt,MouseEvent.CLICK,this.onNameTxt);
            GV.MC_AppLever.addChild(this.UI.changeName);
         }
      }
      
      private function onNameTxt(evt:MouseEvent) : void
      {
         BC.removeEvent(this,this.UI.changeName.onNameTxt,MouseEvent.CLICK,this.onNameTxt);
         this.UI.changeName.nameTxt.text = "";
      }
      
      private function onCancelBtn(evt:MouseEvent) : void
      {
         BC.removeEvent(this,this.UI.changeName.cancelBtn,MouseEvent.CLICK,this.onCancelBtn);
         this.UI.changeName.x *= 3;
         this.UI.changeName.y *= 3;
         GV.MC_AppLever.removeChild(this.UI.changeName);
      }
      
      private function onSureBtn(evt:MouseEvent) : void
      {
         var houseNumber:int = 0;
         var myName:String = this.UI.changeName.nameTxt.text;
         var check:Boolean = this.checkMyName(myName);
         var myPattern:RegExp = / /g;
         var name:String = myName.replace(myPattern,"");
         if(name == "" || !check)
         {
            Alert.smileAlart("    你輸入的教室名字不合法！");
         }
         else if(this.lahmclassroombeen.getLahmClassRoomInfo().classRoomName != myName)
         {
            houseNumber = int(this.lahmclassroombeen.getLahmClassRoomInfo().classRoomId);
            BC.addEvent(this,GV.onlineSocket,"read_1277",this.changeHouseName);
            lahmClassRoomSocket.setClassRoomName(houseNumber,myName);
         }
      }
      
      private function changeHouseName(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_1277",this.changeHouseName);
         this.lahmclassroombeen.getLahmClassRoomInfo().classRoomName = evt.EventObj.classRoomName;
         lahmClassRoomView.getInstance().initHouseName(evt.EventObj.classRoomName);
         this.UI.changeName.x *= 3;
         this.UI.changeName.y *= 3;
         GV.MC_AppLever.removeChild(this.UI.changeName);
      }
      
      private function checkMyName(name:String) : Boolean
      {
         var ret:Boolean = true;
         var t:ByteArray = new ByteArray();
         t.writeUTF(name);
         if(t.length > 17)
         {
            ret = false;
         }
         return ret;
      }
      
      private function onPlanBtn(evt:MouseEvent) : void
      {
         var msg:String = null;
         var url:String = null;
         var loadGame:LoadGame = null;
         if(lahmClassRoomBeen.getInstance().getLahmClassRoomInfo().studentCount < 1)
         {
            msg = "    你現在還沒有招收學生哦，快來拉姆學院教導處吧，我這裡有不少又聰明又聽話的小拉姆哦。";
            url = XMLInfo.lahmClassRoom.findStudentPeople;
            this.myalter = Alert.showAlert(MainManager.getGameLevel(),url,msg,Alert.CHANG_ALERT,"sure,cancel",true,false,"SMCUI");
            BC.addEvent(this,this.myalter,"CLICK" + 1,this.onSetStudent);
         }
         else if(this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 4)
         {
            Alert.smileAlart("    馬上就要考試了，快去選擇考試科目吧");
         }
         else
         {
            loadGame = new LoadGame("module/external/CoursesPlanMain.swf","正在加載教學安排面板",MainManager.getGameLevel());
            loadGame = null;
         }
      }
      
      private function onSetStudent(evt:*) : void
      {
         BC.removeEvent(this,this.myalter,"CLICK" + 1,this.onSetStudent);
         GV.Room_DefaultRoomID = 0;
         LocalUserInfo.setMapID(0);
         GF.switchMap(53);
      }
      
      private function onPhoneBtn(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("module/external/changeClassRoomMain.swf","正在加載更換內飾",MainManager.getGameLevel());
         loadGame = null;
      }
      
      private function onDataBtn(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("module/external/lamuClassroom/TeachingArchives.swf","正在加載教學檔案面板",MainManager.getGameLevel());
         loadGame = null;
      }
      
      private function onBeforeBtn(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("module/external/lamuClassroom/TeachingMemories.swf","正在加載教學檔案面板",MainManager.getGameLevel());
         loadGame = null;
      }
      
      private function onGoBtn(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("module/external/ClassRoomGoOtherMain.swf","正在加載逛逛面板",MainManager.getGameLevel());
         loadGame = null;
      }
      
      private function onMyBtn(evt:MouseEvent) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_1294",this.onRead1294);
         lahmClassRoomSocket.queryhaveClass(LocalUserInfo.getUserID());
      }
      
      private function onRead1294(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_1294",this.onRead1294);
         if(evt.EventObj.ishaveClass > 0)
         {
            GF.switchMap(evt.EventObj.userId,false,32);
         }
         else
         {
            GF.showAlert(MainManager.getGameLevel(),"這個小摩爾還沒有建立屬於自己的拉姆教室呢。","",100,"iknow",true,false,"E");
         }
      }
      
      private function initACData() : void
      {
         this.mc_Class = GV.Lib_Map.getClass("ItemBtn") as Class;
         for(var i:int = 0; i < 10; i++)
         {
            this.itemBtn = new this.mc_Class();
            this.itemBtn.nameTxt.text = i.toString();
            this.itemBtn.x = 2;
            this.itemBtn.y = i * 30;
            BC.addEvent(this,this.itemBtn,MouseEvent.CLICK,this.onItemBtn);
            this.UI.otherMenu.acmc.panel.itemList.addChild(this.itemBtn);
         }
         this.acScrollBar = new ScrollBar(null,this.UI.otherMenu.acmc.panel.itemList,{
            "length":150,
            "x":75,
            "y":this.UI.otherMenu.acmc.panel.itemList.y
         },ScrollBar.ENABLE_ABATE,ScrollBar.DIRECTION_VERTICAL,30,2);
      }
      
      private function onItemBtn(evt:MouseEvent) : void
      {
         this.UI.otherMenu.acmc.visible = false;
         trace(evt.currentTarget.nameTxt.text);
      }
      
      private function onAcBtn(evt:MouseEvent) : void
      {
         this.UI.otherMenu.acmc.visible = true;
      }
      
      private function onacBtnFun(evt:MouseEvent) : void
      {
         var userIdForTheClass:int = 0;
         this.UI.otherMenu.acmc.visible = false;
         if(this.lahmclassroombeen.getLahmClassRoomInfo().studentCount > 0)
         {
            userIdForTheClass = int(this.lahmclassroombeen.getLahmClassRoomInfo().classRoomUserId);
            BC.addEvent(this,GV.onlineSocket,"read_6002",this.onToHappy);
            lahmClassRoomSocket.toHappy(userIdForTheClass);
         }
         else
         {
            Alert.smileAlart("    這個小摩爾還沒有招收學生哦，去別人的教室看看吧。");
         }
      }
      
      private function onToHappy(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_6002",this.onToHappy);
         this.toHappyNum = evt.EventObj.toHappyId;
         this.toHappyMoviePlay();
      }
      
      private function toHappyMoviePlay() : void
      {
         BC.addEvent(this,GV.onlineSocket,"ToHappyMovieOver",this.onToHappyMovieOver);
         var path:String = XMLInfo.lahmClassRoom.classMoviePath + "3.swf";
         this.toHappyLoader = new Loader();
         this.toHappyLoader.load(VL.getURLRequest(path));
         this.UI.addChild(this.toHappyLoader);
      }
      
      private function onToHappyMovieOver(evt:Event) : void
      {
         var msg:String;
         var path:String;
         BC.removeEvent(this,GV.onlineSocket,"ToHappyMovieOver",this.onToHappyMovieOver);
         this.UI.removeChild(this.toHappyLoader);
         this.toHappyLoader = null;
         this.UI.happyPanel.x = this.UI.stage.stageWidth / 2;
         this.UI.happyPanel.y = this.UI.stage.stageHeight / 2;
         BC.addEvent(this,this.UI.happyPanel.closeBtn,MouseEvent.CLICK,function(e:MouseEvent):void
         {
            UI.happyPanel.x *= 3;
            UI.happyPanel.y *= 3;
         });
         msg = XMLInfo.lahmClassRoom.toHappy[this.toHappyNum];
         this.UI.happyPanel.noteTxt.text = msg;
         path = "resource/lahmClassRoom/happyMovie/" + this.toHappyNum + ".swf";
         this.toHappyLoader = new Loader();
         this.toHappyLoader.load(VL.getURLRequest(path));
         GC.clearChildren(this.UI.happyPanel.imageMc);
         this.UI.happyPanel.imageMc.addChild(this.toHappyLoader);
      }
      
      private function onacBtnFun1(evt:MouseEvent) : void
      {
         this.UI.otherMenu.acmc.visible = false;
      }
      
      private function initTool() : void
      {
         BC.addEvent(this,this.control_mc.tableBtn,MouseEvent.CLICK,this.onTableBtn);
         BC.addEvent(this,this.control_mc.tableBtn,MouseEvent.MOUSE_OVER,this.onTableBtn);
         BC.addEvent(this,this.control_mc.tableBtn,MouseEvent.MOUSE_OUT,this.onTableBtn);
      }
      
      private function onTableBtn(evt:MouseEvent) : void
      {
         var tipsS:String = null;
         if(evt.type == MouseEvent.CLICK)
         {
            toolView.getInstance().hide();
            this.UI.itemTool.y = 555;
            BC.addEvent(this,this.UI.itemTool.closeBtn,MouseEvent.CLICK,this.onItemTool);
            this.initItemData();
         }
         else if(evt.type == MouseEvent.MOUSE_OVER)
         {
            tipsS = "教學道具";
            tip.tipTailDisPlayObject(evt.currentTarget,tipsS);
         }
         else if(evt.type == MouseEvent.MOUSE_OUT)
         {
            tip.hideTip();
         }
      }
      
      private function initItemData() : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_1271",this.onQueryClassRoomGoods);
         lahmClassRoomSocket.queryClassRoomGoods();
      }
      
      private function onQueryClassRoomGoods(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_1271",this.onQueryClassRoomGoods);
         this.goodsArr = evt.EventObj.itenArr;
         this.initPageBtn();
         this.hideGoods();
         this.showGoods();
      }
      
      private function initPageBtn() : void
      {
         this.allPage = this.goodsArr.length;
         if(this.allPage <= this.SHOWGOODS_MAX)
         {
            this.UI.itemTool.upBtn.visible = false;
            this.UI.itemTool.nextBtn.visible = false;
         }
         else if(this.currentPage == 1)
         {
            this.UI.itemTool.upBtn.visible = false;
            this.UI.itemTool.nextBtn.visible = true;
         }
         else if(this.currentPage == this.allPage)
         {
            this.UI.itemTool.upBtn.visible = true;
            this.UI.itemTool.nextBtn.visible = false;
         }
         else
         {
            this.UI.itemTool.upBtn.visible = true;
            this.UI.itemTool.nextBtn.visible = true;
         }
         BC.addEvent(this,this.UI.itemTool.upBtn,MouseEvent.CLICK,this.onUpBtn);
         BC.addEvent(this,this.UI.itemTool.nextBtn,MouseEvent.CLICK,this.onNextBtn);
      }
      
      private function onUpBtn(evt:MouseEvent) : void
      {
         if(this.currentPage > 1)
         {
            --this.currentPage;
            this.initPageBtn();
            this.showGoods();
         }
      }
      
      private function onNextBtn(evt:MouseEvent) : void
      {
         if(this.currentPage < this.allPage)
         {
            ++this.currentPage;
            this.initPageBtn();
            this.showGoods();
         }
      }
      
      private function hideGoods() : void
      {
         for(var i:int = 0; i < this.SHOWGOODS_MAX; i++)
         {
            this.UI.itemTool["item" + i].numTxt.text = "";
            GC.clearChildren(this.UI.itemTool["item" + i].icon);
         }
      }
      
      private function showGoods() : void
      {
         var foodArrNum:int = 0;
         var honorArrSign:int = 0;
         var itemId:int = 0;
         var path:String = null;
         var beginArrNum:int = (this.currentPage - 1) * this.SHOWGOODS_MAX;
         var foodArrRound:int = beginArrNum;
         var endLength:int = this.currentPage * this.SHOWGOODS_MAX;
         if(endLength > this.goodsArr.length)
         {
            endLength = int(this.goodsArr.length);
         }
         while(foodArrRound < endLength)
         {
            foodArrNum = foodArrRound - beginArrNum;
            honorArrSign = (this.currentPage - 1) * this.SHOWGOODS_MAX + foodArrNum;
            this.UI.itemTool["item" + foodArrNum].numTxt.text = this.goodsArr[honorArrSign].itemCount + "";
            itemId = int(this.goodsArr[honorArrSign].itemId);
            this.UI.itemTool["item" + foodArrNum].itemId = itemId;
            path = "resource/allJob/icon/" + itemId + ".swf";
            this.imgLoad = new Loader();
            this.imgLoad.unload();
            this.imgLoad.load(VL.getURLRequest(path));
            GC.clearChildren(this.UI.itemTool["item" + foodArrNum].icon);
            this.UI.itemTool["item" + foodArrNum].icon.addChild(this.imgLoad);
            BC.addEvent(this,this.UI.itemTool["item" + foodArrNum],MouseEvent.MOUSE_OVER,this.onItemHandler);
            BC.addEvent(this,this.UI.itemTool["item" + foodArrNum],MouseEvent.MOUSE_OUT,this.onItemHandler);
            BC.addEvent(this,this.UI.itemTool["item" + foodArrNum],MouseEvent.CLICK,this.onItemHandler);
            foodArrRound++;
         }
      }
      
      private function onItemHandler(evt:MouseEvent) : void
      {
         var tipsS:String = null;
         var itemNum:int = int(String(evt.currentTarget.name).slice(4));
         var itemNumSign:int = (this.currentPage - 1) * this.SHOWGOODS_MAX + itemNum;
         var itemid:int = int(evt.currentTarget.itemId);
         if(evt.type == MouseEvent.MOUSE_OVER)
         {
            tipsS = XMLInfo.lahmClassRoomToolTips[itemid];
            tip.tipTailDisPlayObject(evt.currentTarget,tipsS);
            evt.currentTarget.gotoAndStop(2);
         }
         else if(evt.type == MouseEvent.MOUSE_OUT)
         {
            tip.hideTip();
            evt.currentTarget.gotoAndStop(1);
         }
         else if(evt.type == MouseEvent.CLICK)
         {
            if(this.lahmclassroombeen.getLahmClassRoomInfo().studentCount != 0)
            {
               lahmClassRoomToolEvent.getInstance().usingTool(itemid);
            }
            else
            {
               Alert.smileAlart("    你現在還沒有學生，剛快去招生吧！");
            }
         }
      }
      
      public function onItemTool(evt:MouseEvent = null) : void
      {
         this.currentPage = 1;
         this.allPage = 1;
         this.UI.itemTool.y = 678;
         toolView.getInstance().show();
      }
      
      public function toolGoodSEffect(itemId:int) : void
      {
         var farme:int = this.toolGoodsArr.indexOf(itemId);
         if(farme != -1)
         {
            this.UI.goodSEffect.x = this.UI.stage.stageWidth / 2;
            this.UI.goodSEffect.y = this.UI.stage.stageHeight / 2;
            this.UI.goodSEffect.gotoAndStop(farme + 1);
         }
      }
      
      public function openActionClass() : void
      {
         var UI:MovieClip = null;
         UI = lahmClassRoomBeen.getInstance().getLahmClassRoomMC().UI;
         UI.actionClassPanel.x = UI.stage.stageWidth / 2;
         UI.actionClassPanel.y = UI.stage.stageHeight / 2;
         BC.addEvent(this,UI.actionClassPanel.closeBtn,MouseEvent.CLICK,function(e:MouseEvent):void
         {
            UI.actionClassPanel.x *= 3;
            UI.actionClassPanel.y *= 3;
         });
      }
      
      private function removeEventHandler(evt:Event) : void
      {
         BC.removeEvent(this);
      }
      
      public function honorFun(evt:Object) : void
      {
         var honorPath:String;
         var path:String;
         var arrLength:int;
         var awardsArr:Array;
         var i:int;
         var honorid:int = int(evt.honorId);
         var honorInfo:Object = new lahmClassRoomTool().GetTeacherHonerByID(honorid);
         this.UI.honorPanel.x = this.UI.stage.stageWidth / 2;
         this.UI.honorPanel.y = this.UI.stage.stageHeight / 2;
         this.UI.honorPanel.noteTxt.text = honorInfo.description;
         honorPath = "resource/lahmClassRoom/honerMovie/";
         path = honorPath + honorid + ".swf";
         this.loader = new Loader();
         this.loader.unload();
         this.loader.load(new URLRequest(path));
         GC.clearChildren(this.UI.honorPanel.icon);
         this.UI.honorPanel.icon.addChild(this.loader);
         arrLength = int(honorInfo.awards.length);
         awardsArr = honorInfo.awards;
         for(i = 0; i < arrLength; i++)
         {
            if(awardsArr[i].id == 0)
            {
               LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + int(awardsArr[i].count));
            }
            path = new lahmClassRoomTool().getURLByItem(awardsArr[i].id);
            this.loader = new Loader();
            this.loader.unload();
            this.loader.load(new URLRequest(path));
            GC.clearChildren(this.UI.honorPanel["itemIcon" + i]);
            this.UI.honorPanel["itemIcon" + i].addChild(this.loader);
            this.UI.honorPanel["itemNum" + i].text = awardsArr[i].count + "";
            this.UI.honorPanel["itemName" + i].text = GoodsInfo.getItemNameByID(awardsArr[i].id);
         }
         BC.addEvent(this,this.UI.honorPanel.closeBtn,MouseEvent.CLICK,function(e:MouseEvent):void
         {
            UI.honorPanel.x *= 3;
            UI.honorPanel.y *= 3;
         });
      }
   }
}

