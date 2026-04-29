package com.view.mapView.activity.Task83
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.GameframeLogic.GameframeLogic;
   import com.logic.socket.AngelFight.AngelFightExtenalSocket;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.module.angelFight.AngelFightAlert;
   import com.module.angelFight.AngelFightMain;
   import com.module.angelFight.data.AngelFightUserData;
   import com.module.coin.CoinBuyNewModle;
   import com.mole.app.map.MapManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.net.URLLoader;
   
   public class TestAngelFight
   {
      
      private static var _instance:TestAngelFight;
      
      public static var state:Boolean = false;
      
      public var target_mc:*;
      
      public var isRemoveStage:Boolean = false;
      
      public var gameType:int = 0;
      
      public var tollgateId1:int = 0;
      
      public var tollgateId2:int = 0;
      
      public var nickName:String = "";
      
      public var isShowAwardPanel:Boolean = true;
      
      public var userColor:int = -1;
      
      private var bossXML:XML;
      
      private var challengeType:int;
      
      private var bossID:int;
      
      private var needGoodsID:int;
      
      private var mapID:int;
      
      private var normalCount:int;
      
      private var maxNormal:int = 10;
      
      private var vipCount:int;
      
      private var maxVip:int = 10;
      
      private var limitCount:int;
      
      private var maxLimit:int = 10;
      
      private var activityCount:int = 0;
      
      private var maxActivity:int = 10;
      
      private var data:*;
      
      private var _coinBuyNewModle:CoinBuyNewModle;
      
      private var gift_MC:MovieClip;
      
      private var childMC:Loader;
      
      public var momoType:int = 1;
      
      public function TestAngelFight()
      {
         super();
      }
      
      public static function getInstance() : TestAngelFight
      {
         if(_instance == null)
         {
            _instance = new TestAngelFight();
         }
         return _instance;
      }
      
      public function onJoinGame(type:int, mapID:int, nick:String = "", userID:int = 0, userColor:int = -1, isShowAwardPanel:Boolean = true, isRemove:Boolean = true) : void
      {
         if(AngelFightUserData.instance.angels.length <= 0)
         {
            AngelFightAlert.WrongAlert("你還沒有裝備天使！");
            AngelFightMain.instance.reOpenType = 0;
            return;
         }
         if(state)
         {
            return;
         }
         this.isRemoveStage = isRemove;
         state = true;
         this.gameType = type;
         if(this.gameType == 0)
         {
            this.gameType = 1;
         }
         else if(this.gameType == 1)
         {
            this.gameType = 0;
         }
         this.tollgateId1 = mapID;
         this.tollgateId2 = userID;
         this.nickName = nick;
         this.userColor = userColor;
         this.isShowAwardPanel = isShowAwardPanel;
         var url:String = "module/game/FoolPeopleGameMain.swf";
         BC.addEvent(this,GV.onlineSocket,"FoolPeopleGameOverEvent",this.clearHandler);
         GameframeLogic.stopMousicHandler();
         GV.onlineSocket.dispatchEvent(new Event("onCheckJoinAngelFightGameSuc"));
         this.onLoadPanel(url);
      }
      
      public function onJoinGameByOtherPanel(type:int, mapID:int, nick:String = "", userID:int = 0, userColor:int = -1, isShowAwardPanel:Boolean = true, isRemove:Boolean = true) : void
      {
         this.onJoinGame(type,mapID,nick,userID,userColor,isShowAwardPanel,isRemove);
      }
      
      public function onJoinPVPGame(type:int = 7, isShowAwardPanel:Boolean = true, isRemove:Boolean = true) : void
      {
         if(AngelFightUserData.instance.angels.length <= 0)
         {
            AngelFightAlert.WrongAlert("你還沒有裝備天使！");
            AngelFightMain.instance.reOpenType = 0;
            return;
         }
         if(state)
         {
            return;
         }
         this.isRemoveStage = isRemove;
         state = true;
         this.gameType = type;
         this.isShowAwardPanel = isShowAwardPanel;
         var url:String = "module/game/FoolPeopleGameMain.swf";
         BC.addEvent(this,GV.onlineSocket,"FoolPeopleGameOverEvent",this.clearHandler);
         GameframeLogic.stopMousicHandler();
         GV.onlineSocket.dispatchEvent(new Event("onCheckJoinAngelFightGameSuc"));
         this.onLoadPanel(url);
      }
      
      public function onLoaderBossPanel() : void
      {
         BC.addEvent(this,GV.onlineSocket,"onJoinBossGameEvent",this.onJoinBossGame);
         BC.addEvent(this,GV.onlineSocket,"onCancelJoinBossGameEvent",this.onCancelJoinBossGame);
         this.onLoadPanel("module/game/FoolPeopleBossMain.swf",true);
      }
      
      private function onJoinBossGame(e:EventTaomee) : void
      {
         this.bossID = e.EventObj.bossID;
         this.loaderXML();
      }
      
      public function onJoinBossGameInMap(bossID:int) : void
      {
         this.bossID = bossID;
         this.loaderXML();
      }
      
      private function loaderXML() : void
      {
         var xmlLoader:URLLoader = new URLLoader();
         BC.addEvent(this,xmlLoader,Event.COMPLETE,this.onLoaderBossXMLSuc);
         xmlLoader.load(VL.getURLRequest("resource/game/FoolPeopleGame/Xml/BossXML.xml"));
      }
      
      private function onLoaderBossXMLSuc(e:Event) : void
      {
         BC.removeEvent(this,e.currentTarget,Event.COMPLETE,this.onLoaderBossXMLSuc);
         this.bossXML = XML(e.currentTarget.data);
         this.data = this.bossXML.Boss.(@bossID == bossID);
         this.challengeType = int(this.data.@challengeType);
         this.getBossChallengeCount();
      }
      
      private function onCheckToBoss() : void
      {
         var hour:int = 0;
         var msg:String = null;
         if(this.challengeType == 0)
         {
            if(this.normalCount >= this.maxNormal)
            {
               AngelFightAlert.WrongAlert("你今天的挑戰次數已達上限！");
               AngelFightMain.instance.reOpenType = 0;
               return;
            }
            this.onCheckJoinBossGame();
         }
         else if(this.challengeType == 1)
         {
            hour = ServerUpTime.getInstance().getMoleHours;
            if(!(hour >= this.data.@startTimer && hour < this.data.@endTimer))
            {
               msg = "還沒到挑戰時間！挑戰時間為：" + String(this.data.@startTimer) + ":00 — " + String(this.data.@endTimer) + ":00！";
               AngelFightAlert.WrongAlert(msg);
               AngelFightMain.instance.reOpenType = 0;
               return;
            }
            if(this.limitCount >= this.maxLimit)
            {
               AngelFightAlert.WrongAlert("你今天的挑戰次數已達上限！");
               AngelFightMain.instance.reOpenType = 0;
               return;
            }
            this.onCheckJoinBossGame();
         }
         else if(this.challengeType == 2)
         {
            if(!LocalUserInfo.isVIP())
            {
               Alert.SLAlart("    只有擁有神奇力量的超級拉姆才能挑戰哦！");
               AngelFightMain.instance.reOpenType = 0;
               return;
            }
            if(this.vipCount >= this.maxVip)
            {
               AngelFightAlert.WrongAlert("你今天的挑戰次數已達上限！");
               AngelFightMain.instance.reOpenType = 0;
               return;
            }
            this.onCheckJoinBossGame();
         }
         else if(this.challengeType == 3)
         {
            if(AngelFightUserData.instance.level < this.data.@lvl)
            {
               AngelFightAlert.WrongAlert("你的等級不足！");
               AngelFightMain.instance.reOpenType = 0;
               return;
            }
            this.needGoodsID = this.data.@goodsID;
            BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getItemCountSuc);
            GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),this.needGoodsID,0);
         }
         else if(this.challengeType == 4)
         {
            if(this.activityCount >= this.maxActivity)
            {
               AngelFightAlert.WrongAlert("你今天的挑戰次數已達上限！");
               AngelFightMain.instance.reOpenType = 0;
               return;
            }
            this.onCheckJoinBossGame();
         }
      }
      
      private function getBossChallengeCount() : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + AngelFightExtenalSocket.getChallengeCountCmd,this.onGetChallengeCountSuc);
         AngelFightExtenalSocket.getChallengeCount();
      }
      
      private function onGetChallengeCountSuc(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + AngelFightExtenalSocket.getChallengeCountCmd,this.onGetChallengeCountSuc);
         this.normalCount = e.EventObj.normal;
         this.vipCount = e.EventObj.vip;
         this.limitCount = e.EventObj.limit;
         this.activityCount = e.EventObj.activity;
         this.onCheckToBoss();
      }
      
      private function getItemCountSuc(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getItemCountSuc);
         if(e.EventObj.obj.Count > 0)
         {
            if(e.EventObj.obj.arr[0].ID == this.needGoodsID)
            {
               this.onCheckJoinBossGame();
            }
         }
         else
         {
            BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getItemCountSuc2);
            GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),1301027,0);
         }
      }
      
      private function getItemCountSuc2(e:EventTaomee) : void
      {
         var msg:String = null;
         var myAle:* = undefined;
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getItemCountSuc2);
         if(e.EventObj.obj.Count > 0)
         {
            if(e.EventObj.obj.arr[0].ID == 1301027)
            {
               this.onCheckJoinBossGame();
            }
         }
         else
         {
            msg = "    挑戰" + this.data.@name + "需要摩摩挑戰卡，你確認購買嗎？";
            myAle = Alert.smileAlart(msg,null,"sure,cancel");
            myAle.addEventListener(Alert.CLICK_ + "1",this.onSureToBuy);
         }
      }
      
      private function onSureToBuy(e:*) : void
      {
         this._coinBuyNewModle = new CoinBuyNewModle();
         BC.addEvent(this,GV.onlineSocket,CoinBuyNewModle.Buy_Item_Success_Event,this.BuyOkHandler);
         this._coinBuyNewModle.BuyModle(101009,1,"個",MainManager.getGameLevel());
      }
      
      private function BuyOkHandler(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,CoinBuyNewModle.Buy_Item_Success_Event,this.BuyOkHandler);
      }
      
      private function onCheckJoinBossGame() : void
      {
         var m:* = undefined;
         if(AngelFightUserData.instance.level < this.data.@lvl)
         {
            AngelFightAlert.WrongAlert("你的等級不足！");
            AngelFightMain.instance.reOpenType = 0;
            return;
         }
         for each(m in this.data.items)
         {
            if(AngelFightUserData.instance.level >= m.@startLevel && AngelFightUserData.instance.level <= m.@endLevel)
            {
               this.mapID = m.@mapID;
               break;
            }
         }
         this.onCancelJoinBossGame();
         this.onJoinGame(0,this.mapID,"");
      }
      
      private function onCancelJoinBossGame(e:Event = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"onJoinBossGameEvent",this.onJoinBossGame);
         BC.removeEvent(this,GV.onlineSocket,"onCancelJoinBossGameEvent",this.onCancelJoinBossGame);
         this.clearMC();
      }
      
      private function clearMC(e:* = null) : void
      {
         if(this.gift_MC != null)
         {
            GC.stopAllMC(this.gift_MC);
            GC.clearAll(this.gift_MC);
            this.gift_MC = null;
         }
         if(this.childMC != null)
         {
            GC.stopAllMC(this.childMC);
            GC.clearAll(this.childMC);
            this.childMC = null;
         }
         state = false;
      }
      
      private function onLoadPanel(url:String, appBl:Boolean = false) : void
      {
         this.gift_MC = new MovieClip();
         this.gift_MC.name = "gift_MC";
         if(appBl)
         {
            MainManager.getAppLevel().addChild(this.gift_MC);
         }
         else
         {
            MainManager.getGameLevel().addChild(this.gift_MC);
         }
         var tempMC:MCLoader = new MCLoader(url,this.gift_MC,1,"請耐心等待......");
         tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadCallBoardHandler);
         tempMC.doLoad();
      }
      
      private function loadCallBoardHandler(e:*) : void
      {
         if(this.isRemoveStage)
         {
            this.removeStage();
         }
         var mainMC:DisplayObjectContainer = e.getParent();
         this.childMC = e.getLoader();
         mainMC.addChild(this.childMC);
         var mcloader:MCLoader = e.target as MCLoader;
         mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.loadCallBoardHandler);
         mcloader.clear();
      }
      
      public function clearHandler(e:* = null) : void
      {
         GV["map_ManagerChange"].refreshMap();
         this.clearMC();
         this.isRemoveStage = false;
         GameframeLogic.playMousicHandler();
         GV.onlineSocket.dispatchEvent(new Event("FoolPeopleGameOverByRefreshMapSuc"));
      }
      
      public function removeStage() : void
      {
         MapManager.clearMap();
      }
      
      public function loaderMomoMonsterBuy() : void
      {
         if(state)
         {
            return;
         }
         StatisticsClass.getInstance().init(67744866);
         state = true;
         BC.addEvent(this,GV.onlineSocket,"MomoMansterPanelClose",this.clearMC);
         this.onLoadPanel("module/game/MomoMonsterBuyMain.swf",true);
      }
   }
}

