package com.module.restaurant
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.manager.AssetsManage;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.logic.socket.oneBigStreetSocket.oneBigStreetSocket;
   import com.module.activityModule.checkItem;
   import com.module.loadExtentPanel.LoadGame;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.info.NPCDialogInfo;
   import com.mole.app.info.NPCDialogOptionInfo;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.NPCDialogManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.type.ActionType;
   import com.mole.app.type.ModuleType;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   
   public class RestaurantUI
   {
      
      private static var instance:RestaurantUI;
      
      private static var canotNew:Boolean = true;
      
      private var restaurantBeen:RestaurantBeen;
      
      private var UI:MovieClip;
      
      private var control_mc:MovieClip;
      
      private var createShopAssets:AssetsManage;
      
      private var hasPushfoodPan:Boolean = false;
      
      private var loader:Loader;
      
      private var joinObj:Object;
      
      private var joinMap:int;
      
      public function RestaurantUI()
      {
         super();
         if(canotNew)
         {
            throw new Error("RestaurantUI不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : RestaurantUI
      {
         if(!instance)
         {
            canotNew = false;
            instance = new RestaurantUI();
            canotNew = true;
         }
         return instance;
      }
      
      public function init() : void
      {
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         this.restaurantBeen = RestaurantBeen.getInstance();
         this.UI = this.restaurantBeen.getRestaurantMC().UI;
         this.control_mc = this.restaurantBeen.getRestaurantMC().control_mc;
         this.initLevelUI();
         this.initFunBtn();
      }
      
      private function initLevelUI() : void
      {
         var levelUI:MovieClip = this.UI.houseLevel;
         var favorUI:MovieClip = this.UI.houseFavor;
         this.levelUIFun();
         this.favorUIFun();
         BC.addEvent(this,levelUI.showLevelMc,MouseEvent.MOUSE_OVER,this.onShowLevelMc);
         BC.addEvent(this,levelUI.showLevelMc,MouseEvent.MOUSE_OUT,this.onShowLevelMc);
         BC.addEvent(this,levelUI.showLevelMc,MouseEvent.CLICK,this.onShowLevelMc);
         BC.addEvent(this,this.UI.moneyMc,MouseEvent.MOUSE_OVER,this.onMoneyMc);
         BC.addEvent(this,this.UI.moneyMc,MouseEvent.MOUSE_OUT,this.onMoneyMc);
         BC.addEvent(this,this.UI.moneyMc,MouseEvent.CLICK,this.onMoneyMc);
         BC.addEvent(this,favorUI,MouseEvent.MOUSE_OVER,this.onFavorUI);
         BC.addEvent(this,favorUI,MouseEvent.MOUSE_OUT,this.onFavorUI);
         BC.addEvent(this,favorUI,MouseEvent.CLICK,this.onFavorUI);
      }
      
      private function onFavorUI(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = null;
         if(evt.type == MouseEvent.MOUSE_OVER)
         {
            evt.currentTarget.scaleX = evt.currentTarget.scaleY = 1;
            evt.currentTarget.houseFavorTips.visible = true;
         }
         else if(evt.type == MouseEvent.MOUSE_OUT)
         {
            evt.currentTarget.scaleX = evt.currentTarget.scaleY = 1;
            evt.currentTarget.houseFavorTips.visible = false;
         }
         else if(evt.type == MouseEvent.CLICK)
         {
            loadGame = new LoadGame("module/external/restaurantFavor.swf","正在加載好評面板",MainManager.getGameLevel());
            loadGame = null;
         }
      }
      
      private function onMoneyMc(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = null;
         if(evt.type == MouseEvent.MOUSE_OVER)
         {
            evt.currentTarget.moneyMcTips.visible = true;
            evt.currentTarget.scaleX = evt.currentTarget.scaleY = 1;
         }
         else if(evt.type == MouseEvent.MOUSE_OUT)
         {
            evt.currentTarget.scaleX = evt.currentTarget.scaleY = 1;
            evt.currentTarget.moneyMcTips.visible = false;
         }
         else if(evt.type == MouseEvent.CLICK)
         {
            loadGame = new LoadGame("module/external/restaurantMoneyMain.swf","正在加載收益面板",MainManager.getGameLevel());
            loadGame = null;
         }
      }
      
      private function onShowLevelMc(evt:MouseEvent) : void
      {
         var houseLevelNum:int = 0;
         var houseExp:int = 0;
         var levelToExp:int = 0;
         var maxHouseLevelNum:int = 0;
         var loadGame:LoadGame = null;
         if(evt.type == MouseEvent.MOUSE_OVER)
         {
            houseLevelNum = int(this.restaurantBeen.getRestaurantInfo().houseInfo.houseLevel);
            houseExp = int(this.restaurantBeen.getRestaurantInfo().houseInfo.houseExp);
            levelToExp = int(XMLInfo.RestaurantUIObj.level[houseLevelNum]);
            maxHouseLevelNum = int(XMLInfo.RestaurantUIObj.maxLevel);
            evt.currentTarget.scaleX = evt.currentTarget.scaleY = 1;
            if(houseLevelNum >= maxHouseLevelNum)
            {
               evt.currentTarget.parent.levelNumMcTips.gotoAndStop(2);
            }
            else
            {
               evt.currentTarget.parent.levelNumMcTips.tipsTxt.text = "需要" + (levelToExp - houseExp) + "經驗值升到" + (houseLevelNum + 1) + "級";
            }
            evt.currentTarget.parent.levelNumMcTips.visible = true;
         }
         else if(evt.type == MouseEvent.MOUSE_OUT)
         {
            evt.currentTarget.scaleX = evt.currentTarget.scaleY = 1;
            evt.currentTarget.parent.levelNumMcTips.visible = false;
         }
         else if(evt.type == MouseEvent.CLICK)
         {
            loadGame = new LoadGame("module/external/restaurantLevelMain.swf","正在加載等級面板",MainManager.getGameLevel());
            loadGame = null;
         }
      }
      
      public function levelUIFun(tempHouseInfoEvt:Object = null) : void
      {
         var houseLevelNum:int;
         var houseExp:int;
         var levelToExp:int;
         var showLevelBarTotalFrames:int;
         var speedShowLevelBar:int;
         var houseMoney:int;
         var levelUI:MovieClip = null;
         var houseInfo:Object = null;
         var tempHouseInfo:Object = null;
         levelUI = this.UI.houseLevel;
         if(tempHouseInfoEvt != null)
         {
            houseInfo = this.restaurantBeen.getRestaurantInfo().houseInfo;
            tempHouseInfo = EventTaomee(tempHouseInfoEvt).EventObj;
            if(tempHouseInfo.houseLevel > houseInfo.houseLevel && this.restaurantBeen.isMyRestaurant())
            {
               this.popGoUpPanel(tempHouseInfo.houseLevel,tempHouseInfo.houseExp);
            }
            if(tempHouseInfo.houseExp != houseInfo.houseExp)
            {
               levelUI.showLevelMc.scaleX = levelUI.showLevelMc.scaleY = 1.1;
               setTimeout(function():void
               {
                  levelUI.showLevelMc.scaleX = levelUI.showLevelMc.scaleY = 1;
               },300);
            }
            if(tempHouseInfo.houseMoney != houseInfo.houseMoney)
            {
               this.UI.moneyMc.scaleX = this.UI.moneyMc.scaleY = 1.1;
               setTimeout(function():void
               {
                  UI.moneyMc.scaleX = UI.moneyMc.scaleY = 1;
               },300);
            }
            houseInfo.houseLevel = tempHouseInfo.houseLevel;
            houseInfo.houseExp = tempHouseInfo.houseExp;
            houseInfo.houseMoney = tempHouseInfo.houseMoney;
         }
         houseLevelNum = int(this.restaurantBeen.getRestaurantInfo().houseInfo.houseLevel);
         houseExp = int(this.restaurantBeen.getRestaurantInfo().houseInfo.houseExp);
         levelUI.levelMc.gotoAndStop(houseLevelNum);
         levelUI.showLevelMc.levelNumTxt.text = houseExp.toString();
         levelToExp = int(XMLInfo.RestaurantUIObj.level[houseLevelNum]);
         showLevelBarTotalFrames = int(levelUI.showLevelMc.showLevelBar.totalFrames);
         speedShowLevelBar = showLevelBarTotalFrames / (levelToExp / houseExp);
         levelUI.showLevelMc.showLevelBar.gotoAndStop(speedShowLevelBar);
         houseMoney = int(this.restaurantBeen.getRestaurantInfo().houseInfo.houseMoney);
         this.UI.moneyMc.moneyTxt.text = houseMoney.toString();
      }
      
      private function popGoUpPanel(houseLevel:int, houseExp:int) : void
      {
         var levelToExp:int = int(XMLInfo.RestaurantUIObj.level[houseLevel]);
         this.UI.goUpPanel.x = this.UI.stage.stageWidth / 2;
         this.UI.goUpPanel.y = this.UI.stage.stageHeight / 2;
         if(houseLevel < XMLInfo.RestaurantUIObj.maxLevel)
         {
            this.UI.goUpPanel.goUpTxt.text = "    在你的辛勤努力之下，你的餐廳等級有所提高，現在達到了第" + houseLevel + "級啦。\n" + "    再獲取" + (levelToExp - houseExp) + "點經驗就可以升到下一級了，好好努力哦。";
            this.UI.goUpPanel.levelNoteTxt.text = XMLInfo.RestaurantUIObj.levelMessage[houseLevel];
         }
         else
         {
            this.UI.goUpPanel.goUpTxt.text = "    更高的等級,更多的食譜,更華麗的裝潢,盡請期待摩摩餐廳後續發展。";
            this.UI.goUpPanel.levelNoteTxt.text = "    更高的等級,更多的食譜,更華麗的裝潢,盡請期待摩摩餐廳後續發展。";
         }
         BC.addEvent(this,this.UI.goUpPanel.closeBtn,MouseEvent.CLICK,function(e:MouseEvent):void
         {
            UI.goUpPanel.x *= 3;
            UI.goUpPanel.y *= 3;
         });
         BC.addEvent(this,this.UI.goUpPanel.okBtn,MouseEvent.CLICK,function(e:MouseEvent):void
         {
            UI.goUpPanel.x *= 3;
            UI.goUpPanel.y *= 3;
         });
      }
      
      public function favorUIFun(type:int = 0) : void
      {
         var houseFavor:Number;
         var houseFavorBarTotalFrames:int;
         var speedHouseFavorBar:int;
         var favorUI:MovieClip = null;
         favorUI = this.UI.houseFavor;
         favorUI.scaleX = favorUI.scaleY = 1.1;
         setTimeout(function():void
         {
            if(type == 1)
            {
               favorUI.faceMc.gotoAndPlay(2);
            }
            favorUI.scaleX = favorUI.scaleY = 1;
         },300);
         houseFavor = this.restaurantBeen.getRestaurantInfo().houseInfo.houseFavor / 10;
         houseFavorBarTotalFrames = int(favorUI.houseFavorBar.totalFrames);
         speedHouseFavorBar = Math.round(houseFavorBarTotalFrames / (100 / houseFavor));
         favorUI.houseFavorTxt.text = houseFavor.toString();
         favorUI.houseFavorBar.gotoAndStop(speedHouseFavorBar);
      }
      
      private function initFunBtn() : void
      {
         if(this.restaurantBeen.isMyRestaurant())
         {
            this.UI.otherMenu.visible = false;
            BC.addEvent(this,this.UI.myMenu.cmdBtn,MouseEvent.MOUSE_OVER,this.onCmdBtn);
            BC.addEvent(this,this.UI.myMenu.empPhone,MouseEvent.MOUSE_OVER,this.onCmdBtn);
            BC.addEvent(this,this.UI.myMenu.empPhone,MouseEvent.MOUSE_OUT,this.onEmpPhone);
            BC.addEvent(this,this.UI.myMenu.empPhone.empBtn,MouseEvent.CLICK,this.onEmpBtn);
            BC.addEvent(this,this.UI.myMenu.empPhone.phoneBtn,MouseEvent.CLICK,this.onPhoneBtn);
            BC.addEvent(this,this.UI.myMenu.empPhone.infoBtn,MouseEvent.CLICK,this.onInfoBtn);
            BC.addEvent(this,this.UI.myMenu.menuBtn,MouseEvent.CLICK,this.onMenuBtn);
            BC.addEvent(this,this.UI.myMenu.goBtn,MouseEvent.CLICK,this.onGoBtn);
            BC.addEvent(this,this.UI.myMenu.bookBtn,MouseEvent.CLICK,this.onBookBtn);
            BC.addEvent(this,this.UI.myMenu.activeBtn,MouseEvent.CLICK,this.onActiveBtn);
            this.control_mc.myNameMc.buttonMode = true;
            BC.addEvent(this,this.control_mc.myNameMc,MouseEvent.CLICK,this.onMyNameMc);
            BC.addEvent(this,this.control_mc.myNameMc,MouseEvent.MOUSE_OVER,this.onMyNameMc);
            BC.addEvent(this,this.control_mc.myNameMc,MouseEvent.MOUSE_OUT,this.onMyNameMc);
         }
         else
         {
            this.UI.otherMenu.x = this.UI.myMenu.x;
            this.UI.myMenu.visible = false;
            BC.addEvent(this,this.UI.otherMenu.empBtn,MouseEvent.CLICK,this.onEmpBtn);
            BC.addEvent(this,this.UI.otherMenu.infoBtn,MouseEvent.CLICK,this.onOterInfoBtn);
            BC.addEvent(this,this.UI.otherMenu.myBtn,MouseEvent.CLICK,this.onMyBtn);
            BC.addEvent(this,this.UI.otherMenu.goBtn,MouseEvent.CLICK,this.onGoBtn);
         }
      }
      
      private function onCmdBtn(evt:MouseEvent) : void
      {
         this.UI.myMenu.empPhone.visible = true;
      }
      
      private function onEmpPhone(evt:MouseEvent) : void
      {
         this.UI.myMenu.empPhone.visible = false;
      }
      
      private function onActiveBtn(e:MouseEvent) : void
      {
         ModuleManager.openPanel(ModuleType.RESTAURANT_ACTIVE_PANEL);
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
         this.createShopAssets.IncludeLib("createShop_Lib","module/external/BooksUI/petShopBook.swf","正在打開...",true);
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
      
      private function onEmpBtn(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("module/external/restaurantEmployePanelMain.swf","正在加載僱傭面板",MainManager.getGameLevel());
         loadGame = null;
      }
      
      private function onPhoneBtn(evt:MouseEvent) : void
      {
         var npcOptionInfo:NPCDialogOptionInfo = null;
         var sayList:Array = new Array();
         npcOptionInfo = new NPCDialogOptionInfo("我想裝修店鋪",ActionType.TASK_FUNCTION,this.onTommyS2,false);
         sayList.push(npcOptionInfo);
         npcOptionInfo = new NPCDialogOptionInfo("沒什麼事",ActionType.NONE);
         sayList.push(npcOptionInfo);
         var npcDialogInfo:NPCDialogInfo = new NPCDialogInfo(10063,"正常","你好，我是建設署署長湯米，請問有什麼事情我可以幫你？!",sayList);
         NPCDialogManager.say(npcDialogInfo);
      }
      
      private function onTommyS2() : void
      {
         var npcOptionInfo:NPCDialogOptionInfo = null;
         var sayList:Array = new Array();
         npcOptionInfo = new NPCDialogOptionInfo("好的",ActionType.SYSTEM_ACT,"tommy_changeRestaurant");
         sayList.push(npcOptionInfo);
         var npcDialogInfo:NPCDialogInfo = new NPCDialogInfo(10063,"正常","好的，我明白了，你挑選一套想要裝修的方案吧。",sayList);
         NPCDialogManager.say(npcDialogInfo);
         SystemEventManager.addEventListener("tommy_changeRestaurant",this.onChangeRestaurant);
      }
      
      private function onChangeRestaurant(e:SystemEvent) : void
      {
         new LoadGame("module/external/changeRestaurantMain.swf","正在加載改變房型",LevelManager.gameLevel);
      }
      
      private function onInfoBtn(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("module/external/restaurantStateMain.swf","正在加載餐廳狀態面板",MainManager.getGameLevel());
         loadGame = null;
      }
      
      private function onMenuBtn(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("module/external/restaurantMenuBtnMain.swf","正在加載食譜面板",MainManager.getGameLevel());
         loadGame = null;
      }
      
      private function onGoBtn(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("module/external/restaurantGoOtherMain.swf","正在加載逛逛面板",MainManager.getGameLevel());
         loadGame = null;
      }
      
      private function onOterInfoBtn(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("module/external/restaurantStateOtherMain.swf","正在加載餐廳狀態面板",MainManager.getGameLevel());
         loadGame = null;
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
         GV.Room_DefaultRoomID = 0;
         LocalUserInfo.setMapID(0);
         GF.switchMap(this.joinMap);
      }
      
      public function onMyNameMc(evt:MouseEvent) : void
      {
         var tipsS:String = null;
         if(evt.type == MouseEvent.MOUSE_OVER)
         {
            tipsS = "更改餐廳名稱";
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
      
      private function onSureBtn(evt:MouseEvent) : void
      {
         var houseNumber:int = 0;
         var myName:String = this.UI.changeName.nameTxt.text;
         var check:Boolean = this.checkMyName(myName);
         var myPattern:RegExp = / /g;
         var name:String = myName.replace(myPattern,"");
         if(name == "" || !check)
         {
            Alert.smileAlart("    你輸入的餐廳名字不合法！");
         }
         else if(this.restaurantBeen.getRestaurantInfo().houseInfo.houseName != myName)
         {
            houseNumber = int(this.restaurantBeen.getRestaurantInfo().houseInfo.houseNumber);
            BC.addEvent(this,GV.onlineSocket,"read_998",this.changeHouseName);
            oneBigStreetSocket.setHouseName(houseNumber,myName);
         }
      }
      
      private function changeHouseName(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_998",this.changeHouseName);
         this.restaurantBeen.getRestaurantInfo().houseInfo.houseName = evt.EventObj.name;
         RestaurantView.getInstance().initHouseName(evt.EventObj.name);
         this.UI.changeName.x *= 3;
         this.UI.changeName.y *= 3;
         GV.MC_AppLever.removeChild(this.UI.changeName);
      }
      
      private function onCancelBtn(evt:MouseEvent) : void
      {
         BC.removeEvent(this,this.UI.changeName.cancelBtn,MouseEvent.CLICK,this.onCancelBtn);
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
      
      public function honorFun(evt:EventTaomee) : void
      {
         var honorPath:String;
         var path:String;
         var honorid:int = int(evt.EventObj.honorId);
         this.UI.honorPanel.x = this.UI.stage.stageWidth / 2;
         this.UI.honorPanel.y = this.UI.stage.stageHeight / 2;
         this.UI.honorPanel.noteTxt.text = XMLInfo.RestaurantUIObj.honorNote[honorid - 1];
         this.UI.honorPanel.awardTxt.text = XMLInfo.RestaurantUIObj.honorAward[honorid - 1];
         honorPath = "resource/restaurant/honor/";
         path = honorPath + honorid + ".swf";
         this.loader = new Loader();
         this.loader.unload();
         this.loader.load(new URLRequest(path));
         GC.clearChildren(this.UI.honorPanel.icon);
         this.UI.honorPanel.icon.addChild(this.loader);
         BC.addEvent(this,this.UI.honorPanel.closeBtn,MouseEvent.CLICK,function(e:MouseEvent):void
         {
            UI.honorPanel.x *= 3;
            UI.honorPanel.y *= 3;
         });
         BC.addEvent(this,this.UI.honorPanel.okBtn,MouseEvent.CLICK,function(e:MouseEvent):void
         {
            UI.honorPanel.x *= 3;
            UI.honorPanel.y *= 3;
         });
      }
      
      public function onFoodUpLevel(evt:EventTaomee) : void
      {
         var honorPath:String;
         var path:String;
         var itemID:int = int(evt.EventObj.itemId);
         var foodStar:int = int(evt.EventObj.level);
         var addexp:int = int(evt.EventObj.addexp);
         var addcount:int = int(evt.EventObj.addcount);
         this.UI.foodUpPanel.x = this.UI.stage.stageWidth / 2;
         this.UI.foodUpPanel.y = this.UI.stage.stageHeight / 2;
         this.UI.foodUpPanel.msgTxt.text = "    恭喜你的廚藝又有提高了，你現在" + GoodsInfo.getItemNameByID(itemID) + "的製作水準已經達到" + foodStar + "星級的標準了。";
         this.UI.foodUpPanel.awardTxt.text = "    獎勵你" + addcount + "份" + GoodsInfo.getItemNameByID(itemID) + "和" + addexp + "點餐廳經驗值。";
         honorPath = "resource/restaurant/meunicon/";
         path = honorPath + itemID + ".swf";
         this.loader = new Loader();
         this.loader.unload();
         this.loader.load(new URLRequest(path));
         GC.clearChildren(this.UI.foodUpPanel.icon);
         this.UI.foodUpPanel.icon.addChild(this.loader);
         BC.addEvent(this,this.UI.foodUpPanel.closeBtn,MouseEvent.CLICK,function(e:MouseEvent):void
         {
            UI.foodUpPanel.x *= 3;
            UI.foodUpPanel.y *= 3;
         });
         BC.addEvent(this,this.UI.foodUpPanel.okBtn,MouseEvent.CLICK,function(e:MouseEvent):void
         {
            UI.foodUpPanel.x *= 3;
            UI.foodUpPanel.y *= 3;
         });
      }
      
      private function removeEventHandler(evt:Event) : void
      {
         if(this.joinObj != null)
         {
            this.joinObj.removeEventListener("CLICK" + 1,this.doActionHandler);
         }
         BC.removeEvent(this);
         SystemEventManager.removeEventListener("tommy_s2",this.onTommyS2);
         SystemEventManager.removeEventListener("tommy_changeRestaurant",this.onChangeRestaurant);
      }
   }
}

