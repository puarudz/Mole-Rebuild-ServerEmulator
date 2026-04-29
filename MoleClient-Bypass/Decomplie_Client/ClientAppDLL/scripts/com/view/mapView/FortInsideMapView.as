package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.loading.Loading;
   import com.core.music.TopicMusicManager;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.staticData.CommandID;
   import com.logic.socket.card.CardNumReq;
   import com.logic.socket.card.CardNumRes;
   import com.logic.socket.initPlayerCard.InitPlayerReq;
   import com.logic.socket.initPlayerCard.InitPlayerRes;
   import com.logic.socket.superlamuParty.superlamuPartySocket;
   import com.module.activityModule.checkItem;
   import com.module.query.QueryImpl;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.ActivityTmpDataManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.map.MapManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.media.Sound;
   
   public class FortInsideMapView extends MapBase
   {
      
      public static var explain:String = "你沒有任何騎士卡牌無法開始對戰，馬上去石桌上領取騎士卡牌冊吧！";
      
      public static var url:String = "module/gameUI/icon/002.swf";
      
      public static var isGetBook:Boolean = false;
      
      private var target_mc:MovieClip;
      
      private var depth_mc:MovieClip;
      
      private var gameTipMC:MovieClip;
      
      private var gameResultMC:MovieClip;
      
      private var rule1MC:MovieClip;
      
      private var rule2MC:MovieClip;
      
      private var helpMC:MovieClip;
      
      private var clothBook:MovieClip;
      
      private var loginGame:*;
      
      private var danceMusic:Sound;
      
      private var levelArr:Array = [100,250,500,1000,2000,3000,4000,5000,7000];
      
      public function FortInsideMapView()
      {
         super();
      }
      
      private function hSelectSay(e:SystemEvent) : void
      {
         var num:int = 0;
         if(!ActivityTmpDataManager.curTaskId)
         {
            num = int(Math.random() * 100);
            ActivityTmpDataManager.currentMap = num > 50 ? 392 : 393;
            MapManager.enterMap(ActivityTmpDataManager.currentMap);
         }
         else if(ActivityTmpDataManager.curTaskId != 3)
         {
            MapManager.enterMap(ActivityTmpDataManager.currentMap);
         }
         else
         {
            mapSay(100);
         }
      }
      
      private function hLetterTaskOver(e:SystemEvent) : void
      {
         superlamuPartySocket.treasurebowl(229);
         ActivityTmpDataManager.curTaskId = 0;
      }
      
      private function initSound() : void
      {
         BC.addEvent(this,this.target_mc.clothBook,MouseEvent.CLICK,this.loadClothBook);
         if(TopicMusicManager.instance.isOpen() == false)
         {
            this.target_mc.soundMC.gotoAndStop(2);
         }
      }
      
      private function loadClothBook(evt:MouseEvent) : void
      {
         var tempMC:MCLoader = null;
         if(!MainManager.getGameLevel().getChildByName("clothBook"))
         {
            this.clothBook = new MovieClip();
            this.clothBook.name = "clothBook";
            MainManager.getGameLevel().addChild(this.clothBook);
            tempMC = new MCLoader("resource/besmearBook/glory.swf",this.clothBook,Loading.TITLE_AND_PERCENT,"正在打開摩爾騎士");
            tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadBookOverHandler);
            tempMC.doLoad();
         }
      }
      
      private function loadBookOverHandler(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:* = evt.getLoader();
         mainMC.addChild(childMC);
         var mcloader:MCLoader = evt.target as MCLoader;
         mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.loadBookOverHandler);
         mcloader.clear();
         GV.onlineSocket.addEventListener("monthlyCloseEvent",this.removeMC);
      }
      
      public function removeMC(event:Event) : void
      {
         GV.onlineSocket.removeEventListener("monthlyCloseEvent",this.removeMC);
         GC.clearAll(this.clothBook);
         this.clothBook = null;
      }
      
      private function sundHandler(evt:MouseEvent) : void
      {
         var mapID:int = 0;
         if(this.target_mc.soundMC.currentFrame == 1)
         {
            this.target_mc.soundMC.gotoAndStop(2);
            TopicMusicManager.instance.stopSound();
            TopicMusicManager.instance.close();
         }
         else
         {
            this.target_mc.soundMC.gotoAndStop(1);
            TopicMusicManager.instance.open();
            mapID = LocalUserInfo.getMapID();
            TopicMusicManager.instance.playSound(mapID);
         }
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.checkGoods();
         this.initSound();
         BC.addEvent(this,this.target_mc.getBookBtn,MouseEvent.CLICK,this.getBookHandler);
         BC.addEvent(this,this.target_mc.rule1,MouseEvent.CLICK,this.rule1Handler);
         BC.addEvent(this,this.target_mc.rule2,MouseEvent.CLICK,this.rule2Handler);
         BC.addEvent(this,this.target_mc.helpBtn,MouseEvent.CLICK,this.helpMCHandler);
         BC.addEvent(this,this.target_mc.soundMC,MouseEvent.CLICK,this.sundHandler);
         SystemEventManager.addEventListener("frank_checkSayWhat",this.checkSayWhatFun);
         SystemEventManager.addEventListener("frank_joinGame",this.dealFun);
         SystemEventManager.addEventListener("frank_lookMark",this.dealFun);
         SystemEventManager.addEventListener("frank_challenge",this.dealFun);
         SystemEventManager.addEventListener("frank_jumpMap",this.onGo152);
         SystemEventManager.addEventListener("selectSay",this.hSelectSay);
         SystemEventManager.addEventListener("letterTaskOver",this.hLetterTaskOver);
         BC.addEvent(this,GV.onlineSocket,"read_" + CommandID.TreasureBowl,this.back1242);
      }
      
      private function back1242(e:EventTaomee) : void
      {
         var msg:String = null;
         BC.removeEvent(this,GV.onlineSocket,"read_" + CommandID.TreasureBowl,this.back1242);
         var infoObj:Object = e.EventObj;
         if(infoObj.type == 229)
         {
            msg = GoodsInfo.getItemNameByID(infoObj.itemId) + "x" + infoObj.count;
            Alert.smileAlart("恭喜你獲得" + msg + "。");
         }
      }
      
      private function onGo152(e:Event) : void
      {
         MapManager.enterMap(152);
      }
      
      private function checkSayWhatFun(evt:Event) : void
      {
         QueryImpl.getInstance().QueryItem([12364],this.setPropNumFun);
      }
      
      private function setPropNumFun(arr:Array) : void
      {
         if(arr[0].count > 0)
         {
            mapSay(2);
         }
         else
         {
            mapSay(3);
         }
      }
      
      private function dealFun(evt:Event) : void
      {
         if(!isGetBook)
         {
            Alert.showAlert(MainManager.getGameLevel(),url,explain,Alert.CHANG_ALERT,"ok",true,false,"EMP_BUY");
            return;
         }
         switch(evt.type)
         {
            case "frank_joinGame":
               this.joinGame(1);
               break;
            case "frank_challenge":
               this.joinGame(2);
               break;
            case "frank_lookMark":
               this.showResultHandler();
         }
      }
      
      private function helpMCHandler(event:MouseEvent) : void
      {
         var tempMC:Class = null;
         if(!MainManager.getAppLevel().getChildByName("helpMC"))
         {
            tempMC = GV.Lib_Map.getClass("helpMC") as Class;
            this.helpMC = new tempMC() as MovieClip;
            this.helpMC.name = "helpMC";
            MainManager.getAppLevel().addChild(this.helpMC);
            this.helpMC.x = (MainManager.getStageWidth() - this.helpMC.width) / 2;
            this.helpMC.y = (MainManager.getStageHeight() - this.helpMC.height) / 2;
            this.helpMC.close_btn.addEventListener(MouseEvent.CLICK,this.helpcloseHandler);
         }
      }
      
      private function helpcloseHandler(evt:MouseEvent = null) : void
      {
         this.helpMC.close_btn.removeEventListener(MouseEvent.CLICK,this.helpcloseHandler);
         GC.stopAllMC(this.helpMC);
         GC.clearChildren(this.helpMC);
         MainManager.getAppLevel().removeChild(this.helpMC);
         this.helpMC = null;
      }
      
      private function rule1Handler(event:MouseEvent) : void
      {
         var tempMC:Class = null;
         if(!MainManager.getAppLevel().getChildByName("rule1MC"))
         {
            tempMC = GV.Lib_Map.getClass("RULE1") as Class;
            this.rule1MC = new tempMC() as MovieClip;
            this.rule1MC.name = "rule1MC";
            MainManager.getAppLevel().addChild(this.rule1MC);
            this.rule1MC.x = (MainManager.getStageWidth() - this.rule1MC.width) / 2;
            this.rule1MC.y = (MainManager.getStageHeight() - this.rule1MC.height) / 2;
            this.rule1MC.close_btn.addEventListener(MouseEvent.CLICK,this.rule1CloseHandler);
         }
      }
      
      private function rule1CloseHandler(event:MouseEvent) : void
      {
         this.rule1MC.close_btn.removeEventListener(MouseEvent.CLICK,this.rule1CloseHandler);
         GC.stopAllMC(this.rule1MC);
         GC.clearChildren(this.rule1MC);
         MainManager.getAppLevel().removeChild(this.rule1MC);
         this.rule1MC = null;
      }
      
      private function rule2Handler(event:MouseEvent) : void
      {
         var tempMC:Class = null;
         if(!MainManager.getAppLevel().getChildByName("rule2MC"))
         {
            tempMC = GV.Lib_Map.getClass("RULE2") as Class;
            this.rule2MC = new tempMC() as MovieClip;
            this.rule2MC.name = "rule2MC";
            MainManager.getAppLevel().addChild(this.rule2MC);
            this.rule2MC.x = (MainManager.getStageWidth() - this.rule2MC.width) / 2;
            this.rule2MC.y = (MainManager.getStageHeight() - this.rule2MC.height) / 2;
            this.rule2MC.close_btn.addEventListener(MouseEvent.CLICK,this.rule2CloseHandler);
         }
      }
      
      private function rule2CloseHandler(event:MouseEvent) : void
      {
         this.rule2MC.close_btn.removeEventListener(MouseEvent.CLICK,this.rule2CloseHandler);
         GC.stopAllMC(this.rule2MC);
         GC.clearChildren(this.rule2MC);
         MainManager.getAppLevel().removeChild(this.rule2MC);
         this.rule2MC = null;
      }
      
      private function getGameSuc(evt:Event) : void
      {
         var tempMC:Class = null;
         var i:int = 0;
         if(!isGetBook)
         {
            Alert.showAlert(MainManager.getGameLevel(),url,explain,Alert.CHANG_ALERT,"ok",true,false,"EMP_BUY");
            return;
         }
         if(!MainManager.getAppLevel().getChildByName("gameTipMC"))
         {
            tempMC = GV.Lib_Map.getClass("gameTipMC");
            this.gameTipMC = new tempMC();
            MainManager.getAppLevel().addChild(this.gameTipMC);
            this.gameTipMC.x = (MainManager.getStageWidth() - this.gameTipMC.width) / 2;
            this.gameTipMC.y = (MainManager.getStageHeight() - this.gameTipMC.height) / 2;
            this.gameTipMC.closeBtn.addEventListener(MouseEvent.CLICK,this.gameCloseHandler);
            for(i = 1; i <= 3; i++)
            {
               this.gameTipMC["btn_" + i].addEventListener(MouseEvent.CLICK,this.gameClickHandler);
            }
         }
      }
      
      private function gameClickHandler(evt:MouseEvent) : void
      {
         var str:String = evt.currentTarget.name;
         var num:int = int(str.substr(4));
         switch(num)
         {
            case 1:
            case 2:
               this.joinGame(num);
               break;
            case 3:
               this.showResultHandler();
         }
      }
      
      private function joinGame(num:int) : void
      {
         this.loginGame = GF.loginGame(5,8 + num,27);
         this.loginGame.addEventForCard();
         this.loginGame.beforehandLoadGame();
         this.closeHandler();
      }
      
      private function showResultHandler() : void
      {
         GV.onlineSocket.addEventListener(CardNumRes.GET_CARD_NUM_SUCC,this.getCardSuc);
         CardNumReq.getCardNum(LocalUserInfo.getUserID());
      }
      
      private function getCardSuc(evt:EventTaomee) : void
      {
         var winNum:int = 0;
         var tempMC:Class = null;
         winNum = int(evt.EventObj.win);
         var lostNum:int = int(evt.EventObj.lost);
         var flag:int = int(evt.EventObj.Flag);
         GV.onlineSocket.removeEventListener(CardNumRes.GET_CARD_NUM_SUCC,this.getCardSuc);
         if(!MainManager.getAppLevel().getChildByName("gameResultMC"))
         {
            tempMC = GV.Lib_Map.getClass("gameResult");
            this.gameResultMC = new tempMC();
            MainManager.getAppLevel().addChild(this.gameResultMC);
            this.gameResultMC.x = (MainManager.getStageWidth() - this.gameResultMC.width) / 2;
            this.gameResultMC.y = (MainManager.getStageHeight() - this.gameResultMC.height) / 2;
            this.gameResultMC.closeBtn.addEventListener(MouseEvent.CLICK,this.closeRuslutMC);
            this.gameResultMC.enterBtn.addEventListener(MouseEvent.CLICK,this.closeRuslutMC);
            this.gameResultMC.win_txt.text = winNum;
            this.gameResultMC.lost_txt.text = lostNum;
            this.initLevel(winNum,lostNum,flag);
         }
      }
      
      private function initLevel(winNum:int, lostNum:Number, flag:int) : void
      {
         var nextLevelNum:int = 0;
         var levelNum:int = winNum * 50 + lostNum * 10;
         for(var i:int = 0; i < this.levelArr.length; i++)
         {
            if(levelNum < this.levelArr[i])
            {
               nextLevelNum = int(this.levelArr[i]);
               this.gameResultMC.clothMC.gotoAndStop(i + 1);
               break;
            }
         }
         if(levelNum >= 7000)
         {
            levelNum = 7000;
            nextLevelNum = 7000;
            this.gameResultMC.clothMC.gotoAndStop(10);
         }
         else
         {
            this.gameResultMC.Exp_txt.text = levelNum + "/" + nextLevelNum;
            this.gameResultMC.exp_mc.width = levelNum / nextLevelNum * 177;
         }
         if(flag == 1)
         {
            this.gameResultMC.clothMC.gotoAndStop(100);
         }
      }
      
      private function closeRuslutMC(evt:MouseEvent = null) : void
      {
         this.gameResultMC.closeBtn.removeEventListener(MouseEvent.CLICK,this.closeRuslutMC);
         this.gameResultMC.enterBtn.removeEventListener(MouseEvent.CLICK,this.closeRuslutMC);
         GC.stopAllMC(this.gameResultMC);
         GC.clearChildren(this.gameResultMC);
         this.gameResultMC.parent.removeChild(this.gameResultMC);
         this.gameResultMC = null;
      }
      
      private function gameCloseHandler(evt:MouseEvent = null) : void
      {
         this.closeHandler();
         this.peopleMove();
      }
      
      private function closeHandler() : void
      {
      }
      
      private function peopleMove() : void
      {
         var tempX:int = 320;
         var tempY:int = 310;
      }
      
      private function getBookHandler(evt:MouseEvent) : void
      {
         var msg:String = null;
         if(isGetBook)
         {
            msg = "你已經拿過騎士卡牌冊，不要太貪心囉！";
            GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
            return;
         }
         GV.onlineSocket.addEventListener(InitPlayerRes.INITPLAYER,this.getBookSuc);
         InitPlayerReq.initPlay();
      }
      
      private function getBookSuc(evt:Event) : void
      {
         isGetBook = true;
         GV.onlineSocket.removeEventListener(InitPlayerRes.INITPLAYER,this.getBookSuc);
         var str:String = "  騎士卡牌冊已經放入你的小屋倉庫中\n   另外你還能獲得一件普通訓練服哦！";
         var tempURL:String = "module/gameUI/icon/003.swf";
         Alert.showAlert(MainManager.getGameLevel(),tempURL,str,Alert.CHANG_ALERT,"ok",true,false,"EMP_BUY");
      }
      
      private function checkGoods() : void
      {
         GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.chekItemHandler);
         checkItem.checkItemHandler(160191);
      }
      
      private function chekItemHandler(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.chekItemHandler);
         if(evt.EventObj.num == 1)
         {
            isGetBook = true;
         }
      }
      
      override public function destroy() : void
      {
         if(this.helpMC != null)
         {
            this.helpcloseHandler();
         }
         if(this.gameResultMC != null)
         {
            this.closeRuslutMC();
         }
         if(this.gameTipMC != null)
         {
            this.closeHandler();
         }
         this.danceMusic = null;
         GV.onlineSocket.removeEventListener(InitPlayerRes.INITPLAYER,this.getBookSuc);
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
         SystemEventManager.removeEventListener("frank_checkSayWhat",this.checkSayWhatFun);
         SystemEventManager.removeEventListener("frank_joinGame",this.dealFun);
         SystemEventManager.removeEventListener("frank_lookMark",this.dealFun);
         SystemEventManager.removeEventListener("frank_challenge",this.dealFun);
         SystemEventManager.removeEventListener("frank_jumpMap",this.onGo152);
         SystemEventManager.removeEventListener("selectSay",this.hSelectSay);
         SystemEventManager.removeEventListener("letterTaskOver",this.hLetterTaskOver);
         super.destroy();
      }
   }
}

