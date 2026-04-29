package com.logic.GameframeLogic
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.common.util.DisplayUtil;
   import com.core.MainManager;
   import com.core.dragon.dragonInfo.DragonInfo;
   import com.core.gameSimulator.SEI;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerInfo;
   import com.core.info.ServerUpTime;
   import com.core.loading.Loading;
   import com.core.manager.LevelManager;
   import com.core.music.TopicMusicManager;
   import com.core.newloader.BaseMCLoader;
   import com.core.newloader.LoaderList;
   import com.core.newloader.MCLoader;
   import com.core.socketlogic.ClientOnLineSerSocket;
   import com.core.socketlogic.servermsg.ServerMsg;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.links.Links;
   import com.global.staticData.CommandID;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.JoinGameLogic.JoinGameLogic;
   import com.logic.MapManageLogic.MapManageLogic;
   import com.logic.mapEvent.MapEvent;
   import com.logic.socket.PKsocket.GameKingSocket;
   import com.logic.socket.SendGameSocreRegistSocket;
   import com.logic.socket.singleGamdLogic.singleJoinOtherRes;
   import com.logic.socket.singleGame.SingleGameReq;
   import com.logic.socket.superlamuParty.superlamuPartySocket;
   import com.module.MagicBall.MagicBallManager;
   import com.module.PK.PKHePanel;
   import com.module.PK.PKResult;
   import com.module.findBlackCatGame.FindBlackCatGameManager;
   import com.module.monoplayGame.MonoPlayGameManage;
   import com.module.singleGame.singleGame;
   import com.module.snakeGame.SnakeGameManager;
   import com.mole.app.info.GameLoaderConfigInfo;
   import com.mole.app.manager.ActivityTmpDataManager;
   import com.mole.app.manager.BufferManager;
   import com.mole.app.manager.GameLoaderConfigManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.module.AppModuleControl;
   import com.mole.app.module.ModuleEvent;
   import com.mole.app.type.GameType;
   import com.view.MapManageView.MapManageView;
   import com.view.PeopleView.ClothAction;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.SharedObject;
   import flash.utils.setTimeout;
   
   public class GameframeLogic
   {
      
      public static var singleGameMC:MovieClip;
      
      public static var loadObj:MCLoader;
      
      public static var tempObj:*;
      
      public static var myAlert:*;
      
      public static var gameAlert:*;
      
      public static var ResultObj:Object;
      
      public static var gameFraction:*;
      
      public static var SendGameSocre:*;
      
      public static var gameServerInfo:Object;
      
      public static var playGameType:*;
      
      public static var singleGameID:Number;
      
      public static var itemMovie:MovieClip;
      
      public static var dragonInfo:DragonInfo;
      
      public static var cardGameType:int = 0;
      
      private static var isFraction:Boolean = false;
      
      private static var isGetList:Boolean = false;
      
      public static var policeSoundEvent:String = "POLICESOUND_EVENT";
      
      public static var isBeginOfDicegame:Boolean = false;
      
      public function GameframeLogic()
      {
         super();
      }
      
      public static function loadGame(id:int, gameType:int) : void
      {
         var o:GameLoaderConfigInfo;
         var gameURL:String = null;
         var appControl:AppModuleControl = null;
         GV.onlineSocket.dispatchEvent(new ModuleEvent(ModuleEvent.LOAD_COMPLETE,"game_" + String(id) + "_" + String(gameType)));
         LocalUserInfo.setLevel(GF.leve(LocalUserInfo.getExp()));
         singleGameMC = new MovieClip();
         singleGameMC.name = "singleGameMC";
         playGameType = gameType;
         LevelManager.gameLevel.addChild(singleGameMC);
         o = GameLoaderConfigManager.getInfo(gameType);
         if(Boolean(o))
         {
            gameURL = o.url;
         }
         else
         {
            switch(gameType)
            {
               case 1:
                  gameURL = "module/game/ddp.swf";
                  break;
               case 9:
                  gameURL = "module/game/tthinice.swf";
                  break;
               case 2:
                  gameURL = "module/game/skee.swf";
                  break;
               case 3:
                  MoveTo.CanMove = false;
                  gameURL = "module/game/FiveChess.swf";
                  break;
               case 4:
                  gameURL = "";
                  break;
               case 5:
                  gameURL = "module/game/momoKart.swf";
                  break;
               case 10:
                  gameURL = "module/singleGame/singleGame.swf";
                  break;
               case 11:
                  gameURL = "module/game/ChineseChess.swf";
                  break;
               case 13:
                  gameURL = "module/game/ppl.swf";
                  break;
               case 12:
                  gameURL = "module/game/Robot.swf";
                  break;
               case 14:
                  gameURL = "module/game/Travelmanor.swf";
                  break;
               case 15:
                  gameURL = "module/game/CullFruit.swf";
                  break;
               case 16:
                  gameURL = "module/game/fireBug.swf";
                  break;
               case 17:
                  gameURL = "module/game/piaoliu.swf";
                  break;
               case 18:
                  gameURL = "module/game/ShotGame.swf";
                  break;
               case 21:
                  gameURL = "module/game/FishGame.swf";
                  break;
               case 23:
                  gameURL = "module/game/MuscoviteSquare.swf";
                  break;
               case 24:
                  gameURL = "module/game/Flying.swf";
                  break;
               case 25:
                  gameURL = "module/game/dowork.swf";
                  break;
               case 26:
                  gameURL = "module/game/PianoTaomee.swf";
                  break;
               case 27:
                  gameURL = "module/game/cardGames.swf";
                  break;
               case 28:
                  gameURL = "module/game/TreasureHunt.swf";
                  break;
               case 29:
                  gameURL = "module/game/Dropbehind.swf";
                  break;
               case 30:
                  gameURL = "module/game/ICStore.swf";
                  break;
               case 31:
                  gameURL = "module/game/Firemen.swf";
                  break;
               case 32:
                  gameURL = "module/game/FlyingChess.swf";
                  break;
               case 33:
                  gameURL = "module/game/Convey.swf";
                  break;
               case 34:
                  gameURL = "module/game/SaveLamu.swf";
                  break;
               case 35:
                  gameURL = "module/game/BeatsMain.swf";
                  break;
               case 36:
                  gameURL = "module/game/trimmingLawn.swf";
                  break;
               case 37:
                  gameURL = "module/game/Answer.swf";
                  break;
               case 38:
                  gameURL = "module/game/CardGame.swf";
                  break;
               case 39:
                  gameURL = "module/game/SingleCardGame.swf?bossType=" + cardGameType;
                  dragonInfo = PeopleManageView(GV.MAN_PEOPLE).dragon_Info;
                  break;
               case 40:
                  gameURL = "module/game/NewSingleCardGame.swf?bossType=" + cardGameType;
                  break;
               case GameType.GAME_TYPE_41:
                  gameURL = "module/game/LamuEvolution.swf";
                  break;
               case GameType.GAME_TYPE_42:
                  gameURL = "module/game/MathGame/MathGame.swf";
                  break;
               case GameType.GAME_TYPE_43:
                  gameURL = "module/game/SimuClassRoom.swf";
                  break;
               case GameType.GAME_TYPE_44:
                  gameURL = "module/game/MusicTest.swf";
                  break;
               case GameType.GAME_TYPE_94:
                  gameURL = "module/game/SixChessGameMain.swf";
                  break;
               case GameType.GAME_TYPE_96:
                  gameURL = "module/game/BlowCandleGameMain.swf";
                  break;
               case GameType.PIAO_LIU_2:
                  gameURL = "module/game/piaoliu2.swf";
                  break;
               case GameType.SKEE_2:
                  gameURL = "module/game/skee2.swf";
                  break;
               case GameType.SKEE_3:
                  gameURL = "module/game/skee3.swf";
                  break;
               case 114:
                  gameURL = "module/game/SnakeGameTwoPeoplePanel.swf";
                  break;
               case 115:
                  gameURL = "module/game/MonopolyPanel.swf";
                  break;
               case 116:
                  gameURL = "module/game/FindBlackCatGamePanel.swf";
                  break;
               case 117:
                  gameURL = "module/game/MagicBallGamePanel.swf";
            }
         }
         if(Boolean(o) && o.newLoad == 1)
         {
            appControl = ModuleManager.openGame(o.url,null,"正在加載遊戲素材，請耐心等待...",false);
            appControl.addEventListener(ModuleEvent.LOAD_COMPLETE,function():void
            {
               GV.isSitDown = true;
               GV.onlineSocket.addEventListener("getGameFraction",sendGameFraction);
               GV.onlineSocket.addEventListener("showGameScoreList",showGameListHandle);
               MapManager.clearMap();
            });
         }
         else
         {
            loadObj = new MCLoader(gameURL,singleGameMC,Loading.TITLE_AND_PERCENT,"正在進入遊戲中......");
            loadObj.getLoadingStyle().setIsShowCloseBtn(true);
            loadObj.addEventListener(MCLoadEvent.ON_SUCCESS,gameLoadOverHandler);
            LoaderList.getInstance().addItem(loadObj,null,LoaderList.HIGH);
         }
      }
      
      public static function gameLoadOverHandler(evt:MCLoadEvent) : void
      {
         loadObj.removeEventListener(MCLoadEvent.ON_SUCCESS,gameLoadOverHandler);
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:Loader = evt.getLoader();
         stopMousicHandler();
         var o:GameLoaderConfigInfo = GameLoaderConfigManager.getInfo(playGameType);
         if(Boolean(o))
         {
            GV.onlineSocket.addEventListener("getGameFraction",sendGameFraction);
            GV.onlineSocket.addEventListener("showGameScoreList",showGameListHandle);
            mainMC.addChild(childMC);
            if(o.clearBg)
            {
               MapManager.clearMap();
            }
         }
         else
         {
            switch(playGameType)
            {
               case 1:
               case 30:
               case 9:
               case 15:
               case 16:
               case 18:
                  GV.onlineSocket.addEventListener("getGameFraction",sendGameFraction);
                  GV.onlineSocket.addEventListener("showGameScoreList",showGameListHandle);
                  mainMC.addChild(childMC);
                  break;
               case 2:
               case 3:
               case 5:
               case 32:
               case 37:
               case 11:
               case GameType.GAME_TYPE_94:
               case GameType.GAME_TYPE_96:
               case 13:
               case 23:
               case 27:
               case 38:
               case 39:
               case 40:
               case 29:
               case GameType.PIAO_LIU_2:
               case GameType.SKEE_2:
               case GameType.SKEE_3:
               case 114:
               case 115:
               case 116:
               case 117:
               case 17:
                  GV.onlineSocket.dispatchEvent(new EventTaomee("netGameOver"));
                  break;
               case 10:
                  GV.onlineSocket.addEventListener("getGameFraction",sendGameFraction);
                  GV.onlineSocket.dispatchEvent(new EventTaomee("netGameOver"));
                  GV.onlineSocket.dispatchEvent(new EventTaomee("JOIN_GAME_SOUNDEVENT"));
                  break;
               case 12:
               case 14:
               case 21:
               case 24:
               case 25:
               case 26:
               case 28:
               case 31:
               case 33:
               case 34:
               case 35:
               case 36:
               case GameType.GAME_TYPE_41:
               case GameType.GAME_TYPE_42:
               case GameType.GAME_TYPE_43:
               case GameType.GAME_TYPE_44:
                  MapManager.clearMap();
                  GV.onlineSocket.addEventListener("getGameFraction",sendGameFraction);
                  GV.onlineSocket.addEventListener("showGameScoreList",showGameListHandle);
                  mainMC.addChild(childMC);
            }
         }
      }
      
      public static function readyGame(infoArr:Array = null) : void
      {
         MoveTo.CanMove = false;
         var mainMC:DisplayObjectContainer = loadObj.parentContainer;
         var childMC:Loader = loadObj.loader;
         tempObj = {};
         tempObj.infoArr = infoArr;
         tempObj.childMC = childMC;
         childMC.addEventListener(Event.ADDED_TO_STAGE,onLoaded);
         mainMC.addChild(childMC);
         loadObj.clear();
      }
      
      public static function onLoaded(E:*) : void
      {
         var o:GameLoaderConfigInfo;
         var childMC:* = undefined;
         var ClassReference:Class = null;
         var skeeClass:Class = null;
         var instance:Object = null;
         var contentMC:MovieClip = null;
         var singleGameClass:singleGame = null;
         var tempMC:* = undefined;
         var cardGameClass:Class = null;
         var obj:Object = null;
         childMC = tempObj.childMC;
         childMC.removeEventListener(Event.ADDED_TO_STAGE,onLoaded);
         GV.onlineSocket.dispatchEvent(new EventTaomee("gameReadyEvent"));
         o = GameLoaderConfigManager.getInfo(playGameType);
         if(Boolean(o))
         {
            if(o.clearBg)
            {
               GV.isSitDown = true;
               MapManager.clearMap();
            }
         }
         else
         {
            switch(playGameType)
            {
               case 2:
                  GV.isSitDown = true;
                  MapManager.clearMap();
                  skeeClass = childMC.contentLoaderInfo.applicationDomain.getDefinition("com.taomee.skee.skeeGame") as Class;
                  new skeeClass(childMC,gameServerInfo);
                  break;
               case 3:
                  GV.isSitDown = true;
                  childMC.content["initGame"](childMC,gameServerInfo);
                  break;
               case 5:
                  GV.isSitDown = true;
                  MapManager.clearMap();
                  GC.setGTimeout(function():void
                  {
                     ClassReference = childMC.contentLoaderInfo.applicationDomain.getDefinition("kart::momoKartManage") as Class;
                     instance = new ClassReference(childMC,gameServerInfo);
                  },500);
                  break;
               case 10:
                  GV.isSitDown = true;
                  MapManager.clearMap();
                  contentMC = childMC.content.root as MovieClip;
                  singleGameClass = new singleGame(contentMC,tempObj.infoArr,singleGameID);
                  break;
               case 11:
                  GV.isSitDown = true;
                  childMC.content["initGame"](childMC,gameServerInfo);
                  break;
               case 13:
                  GV.isSitDown = true;
                  MapManager.clearMap();
                  tempMC = childMC.content.root["start_mc"];
                  tempMC.childMC = childMC;
                  tempMC.gameServerInfo = gameServerInfo;
                  tempMC.gotoAndStop(2);
                  break;
               case GameType.SKEE_2:
                  GV.isSitDown = true;
                  MapManager.clearMap();
                  skeeClass = childMC.contentLoaderInfo.applicationDomain.getDefinition("skeeGame") as Class;
                  new skeeClass(childMC,gameServerInfo);
                  break;
               case GameType.SKEE_3:
                  GV.isSitDown = true;
                  MapManager.clearMap();
                  skeeClass = childMC.contentLoaderInfo.applicationDomain.getDefinition("skeeGame") as Class;
                  new skeeClass(childMC,gameServerInfo);
                  break;
               case 114:
                  GV.isSitDown = true;
                  MapManager.clearMap();
                  new SnakeGameManager(childMC,gameServerInfo);
                  break;
               case 115:
                  GV.isSitDown = true;
                  MapManager.clearMap();
                  MonoPlayGameManage.getInstance().initserver(childMC,gameServerInfo);
                  break;
               case 116:
                  GV.isSitDown = true;
                  MapManager.clearMap();
                  new FindBlackCatGameManager(childMC,gameServerInfo);
                  break;
               case 117:
                  GV.isSitDown = true;
                  MapManager.clearMap();
                  MagicBallManager.getInstance().initserver(childMC,gameServerInfo);
                  break;
               case GameType.PIAO_LIU_2:
               case 17:
                  GV.isSitDown = true;
                  MapManager.clearMap();
                  ClassReference = childMC.contentLoaderInfo.applicationDomain.getDefinition("com.taomee.piaoliu.piaoliuGame") as Class;
                  instance = new ClassReference(childMC,gameServerInfo);
                  break;
               case 23:
                  GV.isSitDown = true;
                  MapManager.clearMap();
                  ClassReference = childMC.contentLoaderInfo.applicationDomain.getDefinition("MuscoviteSquareManage") as Class;
                  instance = new ClassReference(childMC,gameServerInfo);
                  break;
               case 27:
                  GV.isSitDown = true;
                  MapManager.clearMap();
                  cardGameClass = childMC.contentLoaderInfo.applicationDomain.getDefinition("PVPcardManage") as Class;
                  new cardGameClass(childMC,gameServerInfo);
                  break;
               case 29:
                  GV.isSitDown = true;
                  MapManager.clearMap();
                  skeeClass = childMC.contentLoaderInfo.applicationDomain.getDefinition("PPQManage") as Class;
                  new skeeClass(childMC,gameServerInfo);
                  break;
               case 32:
                  GV.isSitDown = true;
                  MapManager.clearMap();
                  SEI.SessionObj = gameServerInfo;
                  SEI.getSEI().openGame(gameServerInfo.GameID);
                  break;
               case 37:
                  GV.isSitDown = true;
                  MapManager.clearMap();
                  GC.setGTimeout(function():void
                  {
                     var ClassReference:Class = childMC.contentLoaderInfo.applicationDomain.getDefinition("com.taomee.moleClass.PPQManage") as Class;
                     var instance:Object = new ClassReference(childMC,gameServerInfo);
                  },500);
                  break;
               case 38:
               case 39:
                  GV.isSitDown = true;
                  MapManager.clearMap();
                  if(playGameType == 38)
                  {
                     cardGameClass = childMC.contentLoaderInfo.applicationDomain.getDefinition("cardgame.socket.PVPcardManage") as Class;
                  }
                  else
                  {
                     cardGameClass = childMC.contentLoaderInfo.applicationDomain.getDefinition("cardgame.socket.SPVPcardManage") as Class;
                  }
                  new cardGameClass(childMC,gameServerInfo);
                  break;
               case 40:
                  GV.isSitDown = true;
                  if(playGameType == 38)
                  {
                     cardGameClass = childMC.contentLoaderInfo.applicationDomain.getDefinition("cardgame.socket.PVPcardManage") as Class;
                  }
                  else
                  {
                     cardGameClass = childMC.contentLoaderInfo.applicationDomain.getDefinition("cardgame.socket.SPVPcardManage") as Class;
                  }
                  new cardGameClass(childMC,gameServerInfo);
                  break;
               case GameType.GAME_TYPE_94:
               case GameType.GAME_TYPE_96:
                  GV.isSitDown = true;
                  MapManager.clearMap();
                  obj = childMC.contentLoaderInfo.content;
                  obj.InitGame(gameServerInfo);
            }
         }
         tempObj.infoArr = null;
         tempObj.childMC = null;
      }
      
      public static function singleEvent(singlegameID:Number) : void
      {
         singleGameID = singlegameID;
         GV.onlineSocket.addEventListener(singleJoinOtherRes.SINGLEOTHER_INFO,getOtherSingleInfo);
      }
      
      public static function getOtherSingleInfo(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(singleJoinOtherRes.SINGLEOTHER_INFO,getOtherSingleInfo);
         var infoArr:Array = evt.EventObj.arr;
         readyGame(infoArr);
      }
      
      public static function sendGameFraction(evt:*) : void
      {
         JoinGameLogic.reset();
         GV.map_ManagerChange.refreshMap();
         itemMovie = null;
         GV.onlineSocket.dispatchEvent(new EventTaomee("gameOverMapAction"));
         GV.isSitDown = false;
         GV.isGameShowTip = false;
         GV.onlineSocket.addEventListener(ServerMsg.GAMESOCRE_SUBMISSION,getSingleResult);
         var singlegameReq:SingleGameReq = new SingleGameReq();
         if(evt.EventObj.mc != null)
         {
            itemMovie = evt.EventObj.mc;
         }
         trace("evt.EventObj.mc",evt.EventObj.mc);
         var _day:Date = ServerUpTime.getInstance().date;
         singlegameReq.singlegame(evt.EventObj.Ratio,evt.EventObj.fraction,int(int(evt.EventObj.fraction) * int(evt.EventObj.fraction) + _day.date * _day.date));
         LevelManager.mapLevel.mouseChildren = true;
         if(playGameType == 14)
         {
            ActivityTmpDataManager.getTransferItem(6);
         }
      }
      
      public static function addBallScoreListener() : void
      {
         GV.onlineSocket.addEventListener(ServerMsg.GAMESOCRE_SUBMISSION,getSingleResult);
      }
      
      public static function getSingleResult(evt:*) : void
      {
         var gameTip:MovieClip = null;
         GV.onlineSocket.removeEventListener(ServerMsg.GAMESOCRE_SUBMISSION,getSingleResult);
         LocalUserInfo.countIQ(Number(evt.EventObj.IQ));
         LocalUserInfo.countExp(Number(evt.EventObj.Exp));
         LocalUserInfo.countYXQ(Number(evt.EventObj.gameRMB));
         LocalUserInfo.countCharm(Number(evt.EventObj.Lovely));
         LocalUserInfo.countStrong(Number(evt.EventObj.Strong));
         ResultObj = new Object();
         ResultObj.Score = evt.EventObj.Score;
         ResultObj.GameID = evt.EventObj.GameID;
         ResultObj.Session = evt.EventObj.Session;
         ResultObj.Exp = evt.EventObj.Exp;
         ResultObj.IQ = evt.EventObj.IQ;
         ResultObj.Lovely = evt.EventObj.Lovely;
         ResultObj.Strong = evt.EventObj.Strong;
         ResultObj.gameRMB = evt.EventObj.gameRMB;
         ResultObj.MC = evt.EventObj.MC;
         ResultObj.itemArr = evt.EventObj.itemArr;
         switch(playGameType)
         {
            case 33:
               checkGameScore(uint(evt.EventObj.Score),33);
               if(evt.EventObj.Score > 40)
               {
                  GV.onlineSocket.dispatchEvent(new EventTaomee("invitation_gameover",1));
               }
               else
               {
                  Alert.smileAlart("      小摩爾繼續加油");
               }
               break;
            case 15:
               checkGameScore(uint(evt.EventObj.Score),1);
               break;
            case 10:
               if(ResultObj.GameID == 49)
               {
                  checkGameScore(uint(evt.EventObj.Score),2);
               }
               else if(ResultObj.GameID == 36)
               {
                  checkGameScore(uint(evt.EventObj.Score),6);
               }
               else if(ResultObj.GameID == 25)
               {
                  checkGameScore(uint(evt.EventObj.Score),7);
               }
               else if(ResultObj.GameID == 8)
               {
                  checkGameScore(uint(evt.EventObj.Score),8);
               }
               else if(ResultObj.GameID == 14)
               {
                  checkGameScore(uint(evt.EventObj.Score),10);
               }
               else if(ResultObj.GameID == 41)
               {
                  kfcAct(uint(evt.EventObj.Score));
               }
               break;
            case 16:
               checkGameScore(uint(evt.EventObj.Score),3);
               break;
            case 30:
               checkGameScore(uint(evt.EventObj.Score),4);
               break;
            case 18:
               checkGameScore(uint(evt.EventObj.Score),5);
               break;
            case 23:
               checkGameScore(uint(evt.EventObj.Score),9);
               break;
            case 25:
               if(evt.EventObj.Score > 40)
               {
                  GV.onlineSocket.dispatchEvent(new EventTaomee("invitation_gameover",3));
               }
               else
               {
                  Alert.smileAlart("      小摩爾繼續加油");
               }
               break;
            case 35:
               if(evt.EventObj.Score > 40)
               {
                  GV.onlineSocket.dispatchEvent(new EventTaomee("invitation_gameover",5));
               }
               else
               {
                  Alert.smileAlart("      小摩爾繼續加油");
               }
               break;
            case 44:
               kfcMusic(uint(evt.EventObj.Score));
         }
         if(Boolean(evt.EventObj) && Boolean(evt.EventObj.itemArr) && evt.EventObj.itemArr.length == 1)
         {
            if(evt.EventObj.itemArr[0] == 200)
            {
               GV.onlineSocket.dispatchEvent(new EventTaomee("getCandy_bygame",{"itemID":200}));
            }
            ResultObj.ItemID = evt.EventObj.itemArr[0];
         }
         else
         {
            ResultObj.ItemID = 0;
         }
         if(!MainManager.getGameLevel().getChildByName("GameTip"))
         {
            if(isBeginOfDicegame)
            {
               isBeginOfDicegame = false;
               return;
            }
            gameTip = new MovieClip();
            gameTip.name = "GameTip";
            gameTip.myAlert = myAlert;
            MainManager.getGameLevel().addChild(gameTip);
            myAlert = Alert.showAlert(gameTip,"gameTip,正在打開遊戲積分面板......","module/gameUI/gameUI.swf",Alert.CUSTOM_ALERT);
            myAlert.addEventListener(Event.ADDED,addedMC);
         }
         else
         {
            addedMC();
         }
      }
      
      private static function kfcAct(score:uint) : void
      {
         if(score >= 5000)
         {
            BufferManager.setBuffer(BufferManager.KFC_TEACHERDAY_ACT,1);
         }
      }
      
      private static function kfcMusic(score:uint) : void
      {
         Alert.smileAlart("現在去找奇奇幫忙找下音符吧！",function():void
         {
            MapManager.enterMap(203);
         });
         BufferManager.setBuffer(BufferManager.KFC_TEACHERDAY_ACT,2);
      }
      
      private static function checkGameScore(score:uint, id:uint) : void
      {
         if(MapManager.curMapID == 355)
         {
            if(id == 33)
            {
               GV.onlineSocket.addEventListener("read_" + CommandID.TreasureBowl,getPrizeOver);
               superlamuPartySocket.treasurebowl(getIndexByScore(score));
            }
         }
      }
      
      private static function getIndexByScore(score:uint) : uint
      {
         var index:uint = 184;
         if(score > 99)
         {
            index = score / 100 + index;
         }
         if(index > 188)
         {
            index = 188;
         }
         return index;
      }
      
      private static function getPrizeOver(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + CommandID.TreasureBowl,getPrizeOver);
         var obj:Object = e.EventObj;
         if(obj.itemId == 0)
         {
            return;
         }
         var name:String = GoodsInfo.getItemNameByID(obj.itemId);
         Alert.smileAlart("　　恭喜你獲得" + obj.count + "個" + name + "！");
      }
      
      private static function onChangeMap(e:*) : void
      {
         MapManageView.inst.MapManage.removeEventListener(MapManageLogic.people_OVER,onChangeMap);
         GV.onlineSocket.addEventListener("removeMapEvent",onShowMole);
      }
      
      private static function onShowMole(e:*) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",onShowMole);
         var p:PeopleManageView = GF.getPeopleByID(LocalUserInfo.getUserID());
         p.visible = true;
      }
      
      public static function addedMC(evt:* = null) : void
      {
         var i:int = 0;
         var ItemID:int = 0;
         myAlert.removeEventListener(Event.ADDED,addedMC);
         var arr:Array = ResultObj.itemArr;
         if(Boolean(arr))
         {
            arr = arr.concat();
            for(i = 0; i < arr.length; i++)
            {
               ItemID = int(arr[i].itemID);
               if(ItemID > 100 && ItemID < 104)
               {
                  arr.splice(i,1);
               }
               else if(ItemID > 1290000 && ItemID < 1290021)
               {
                  arr.splice(i,1);
               }
               else if(ItemID == 190028)
               {
                  arr.splice(i,1);
               }
               else if(ResultObj.MC != null)
               {
                  arr.splice(i,1);
               }
            }
         }
         if(arr == null || arr.length == 0)
         {
            myAlert.TARGET.gotoAndStop(1);
         }
         else
         {
            myAlert.TARGET.gotoAndStop(2);
         }
         setTimeout(setMC,100);
      }
      
      private static function setMC() : void
      {
         var i:int = 0;
         var ItemID:int = 0;
         if(LocalUserInfo.getMapID() == 60)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee(MapEvent.MOUSE_DOWN));
         }
         myAlert.TARGET.info_txt_1.text = ResultObj.gameRMB;
         myAlert.TARGET.info_txt_2.text = ResultObj.Exp;
         myAlert.TARGET.tip_infor_txt.text = "";
         if(ResultObj.Strong > 0)
         {
            myAlert.TARGET.info_txt_3.text = ResultObj.Strong;
            myAlert.TARGET.attrMC.gotoAndStop(1);
         }
         if(ResultObj.IQ > 0)
         {
            myAlert.TARGET.info_txt_3.text = ResultObj.IQ;
            myAlert.TARGET.attrMC.gotoAndStop(2);
         }
         if(ResultObj.Lovely > 0)
         {
            myAlert.TARGET.info_txt_3.text = ResultObj.Lovely;
            myAlert.TARGET.attrMC.gotoAndStop(3);
         }
         myAlert.TARGET.score_txt.text = ResultObj.Score;
         myAlert.TARGET.button1.addEventListener(MouseEvent.CLICK,enterEventHandler);
         myAlert.TARGET.button2.addEventListener(MouseEvent.CLICK,sendSeverFraction);
         myAlert.TARGET.button3.addEventListener(MouseEvent.CLICK,gameListHandler);
         isFraction = false;
         isGetList = false;
         if(ResultObj.Session == null)
         {
            myAlert.TARGET.button2.mouseEnabled = false;
         }
         if(ResultObj.GameID == 10000)
         {
            myAlert.TARGET.button2.mouseEnabled = false;
            myAlert.TARGET.button3.mouseEnabled = false;
         }
         var arr:Array = ResultObj.itemArr;
         if(Boolean(arr) && arr.length != 0)
         {
            for(i = 0; i < arr.length; i++)
            {
               ItemID = int(arr[i].itemID);
               if(ItemID > 100 && ItemID < 104)
               {
                  GF.showMadel(ItemID);
                  arr.splice(i,1);
               }
               else if(ItemID > 1290000 && ItemID < 1290021)
               {
                  GF.showMadel(ItemID);
                  arr.splice(i,1);
               }
               else if(ItemID == 190028)
               {
                  GF.showMadel(ItemID);
                  arr.splice(i,1);
               }
               else if(ResultObj.MC != null)
               {
                  ResultObj.MC.play();
                  myAlert.TARGET.addChild(ResultObj.MC);
                  arr.splice(i,1);
               }
            }
            if(arr.length != 0)
            {
               myAlert.TARGET.itemBG.gotoAndStop(arr.length);
               setTimeout(setItemico,100);
            }
            else if(myAlert.TARGET.currentFrame != 1)
            {
               myAlert.TARGET.gotoAndStop(1);
               setTimeout(setMC,100);
            }
         }
      }
      
      private static function setItemico() : void
      {
         var arr:Array = ResultObj.itemArr;
         for(var i:int = 0; i < arr.length; i++)
         {
            loadItem(myAlert.TARGET.itemBG["item" + i],arr[i].itemID);
            myAlert.TARGET.itemBG.num.text = arr[i].itemCount == 0 ? "" : arr[i].itemCount.toString();
         }
      }
      
      private static function loadItem(mc:MovieClip, itemID:int) : void
      {
         var str:String = GoodsInfo.getItemPathByID(itemID);
         if(str.indexOf("resource/farm/") != -1)
         {
            str = "resource/farm/icon/" + itemID + ".swf";
         }
         else
         {
            str += "/" + itemID + ".swf";
         }
         mc["icoName"] = GoodsInfo.getItemNameByID(itemID);
         var loader:BaseMCLoader = new BaseMCLoader(str,mc);
         loader.addEventListener(MCLoadEvent.ON_SUCCESS,icoComplete);
         loader.addEventListener(MCLoadEvent.ERROR,ioError);
         loader.doLoad();
      }
      
      private static function icoComplete(e:MCLoadEvent) : void
      {
         var loaderinfo:BaseMCLoader = e.currentTarget as BaseMCLoader;
         var mc:MovieClip = MovieClip(e.getParent());
         var id:int = int(mc.name.slice(-1));
         tip.tipTailDisPlayObject(mc,mc["icoName"]);
         mc.addChild(loaderinfo.loader);
         loaderinfo.clear();
         loaderinfo.removeEventListener(MCLoadEvent.ERROR,ioError);
         loaderinfo.removeEventListener(MCLoadEvent.ON_SUCCESS,icoComplete);
      }
      
      private static function ioError(e:MCLoadEvent) : void
      {
         trace("加載出錯");
         var loaderinfo:BaseMCLoader = e.currentTarget as BaseMCLoader;
         loaderinfo.clear();
         loaderinfo.removeEventListener(MCLoadEvent.ERROR,ioError);
         loaderinfo.removeEventListener(MCLoadEvent.ON_SUCCESS,icoComplete);
      }
      
      public static function enterEventHandler(evt:* = null) : void
      {
         myAlert.TARGET.button1.removeEventListener(MouseEvent.CLICK,enterEventHandler);
         myAlert.TARGET.button2.removeEventListener(MouseEvent.CLICK,sendSeverFraction);
         myAlert.TARGET.button3.removeEventListener(MouseEvent.CLICK,gameListHandler);
         GV.isSitDown = false;
         if(ResultObj.GameID == PKHePanel.PKGID)
         {
            PKResult.getInstance().showResult(ResultObj.Score,ResultObj.GameID);
         }
         ClothAction.clearEvents();
         MoveTo.CanMove = true;
         if(playGameType != 40)
         {
            GC.clearAllChildren(MainManager.getGameLevel());
         }
         if(GV.MapInfo_mapID != 38)
         {
            GV.onlineClass.addEventListener(ClientOnLineSerSocket.GET_BASIC_MESSAGE,getAllUserInfo);
            MoveTo.removeMouseEventToStage();
            GF.clearPeoples();
            GV.onlineClass.getUserListReq();
            GF.checklever(GV.MAN_PEOPLE,LocalUserInfo.getExp());
         }
      }
      
      public static function sendSeverFraction(evt:MouseEvent) : void
      {
         if(isFraction)
         {
            return;
         }
         isFraction = true;
         myAlert.TARGET.button2.removeEventListener(MouseEvent.CLICK,sendSeverFraction);
         var ip:String = ServerInfo.getGameInfo(ServerInfo.IP);
         var port:int = ServerInfo.getGameInfo(ServerInfo.PORT);
         var obj:Object = {
            "ip":ip,
            "port":port,
            "gameID":ResultObj.GameID,
            "score":ResultObj.Score,
            "session":ResultObj.Session,
            "type":0
         };
         SendGameSocre = new SendGameSocreRegistSocket(obj);
         SendGameSocre.addEventListener(SendGameSocreRegistSocket.SEND_GAME_SOCRE,getResultMsg);
      }
      
      public static function getResultMsg(evt:*) : void
      {
         SendGameSocre.removeEventListener(SendGameSocreRegistSocket.SEND_GAME_SOCRE,getResultMsg);
         setTimeout(SendGameSocre.closeSendGame,200);
         var tempObj:* = Alert.showAlert(MainManager.getGameLevel(),evt.EventObj.msg,"",6,"E");
      }
      
      public static function showGameListHandle(evt:*) : void
      {
         var gameMC:MovieClip = null;
         ResultObj = evt.EventObj;
         if(!MainManager.getGameLevel().getChildByName("GameList"))
         {
            gameMC = new MovieClip();
            gameMC.name = "GameList";
            MainManager.getGameLevel().addChild(gameMC);
            gameAlert = Alert.showAlert(gameMC,"Listmc,正在打開遊戲排行榜.....",Links.getUrl("module/gameUI/gameCompositor.swf"),Alert.CUSTOM_ALERT);
            gameAlert.addEventListener(Event.ADDED,addedGameListMC);
         }
      }
      
      public static function addedGameListMC(evt:Event) : void
      {
         gameAlert.removeEventListener(Event.ADDED,addedListMC);
         var ip:String = ServerInfo.getGameInfo(ServerInfo.IP);
         var port:int = ServerInfo.getGameInfo(ServerInfo.PORT);
         var obj:Object = {
            "ip":ip,
            "port":port,
            "gameID":ResultObj.GameID,
            "type":1
         };
         SendGameSocre = new SendGameSocreRegistSocket(obj);
         SendGameSocre.addEventListener(SendGameSocreRegistSocket.LIST_SEQUENCE,getResultGameList);
      }
      
      public static function gameListHandler(evt:MouseEvent) : void
      {
         var gameMC:MovieClip = null;
         if(isGetList)
         {
            return;
         }
         isGetList = true;
         myAlert.TARGET.button3.removeEventListener(MouseEvent.CLICK,gameListHandler);
         if(!MainManager.getGameLevel().getChildByName("GameList"))
         {
            gameMC = new MovieClip();
            gameMC.name = "GameList";
            MainManager.getGameLevel().addChild(gameMC);
            gameAlert = Alert.showAlert(gameMC,"Listmc,正在打開遊戲積分面板..",Links.getUrl("module/gameUI/gameCompositor.swf"),Alert.CUSTOM_ALERT);
            gameAlert.addEventListener(Event.ADDED,addedListMC);
         }
      }
      
      public static function addedListMC(evt:Event) : void
      {
         gameAlert.removeEventListener(Event.ADDED,addedListMC);
         var ip:String = ServerInfo.getGameInfo(ServerInfo.IP);
         var port:int = ServerInfo.getGameInfo(ServerInfo.PORT);
         var obj:Object = {
            "ip":ip,
            "port":port,
            "gameID":ResultObj.GameID,
            "type":1
         };
         gameAlert.TARGET.enterBtn.addEventListener(MouseEvent.CLICK,gameMCRemove);
         SendGameSocre = new SendGameSocreRegistSocket(obj);
         SendGameSocre.addEventListener(SendGameSocreRegistSocket.LIST_SEQUENCE,getResultGameList);
      }
      
      public static function getResultGameList(evt:*) : void
      {
         SendGameSocre.removeEventListener(SendGameSocreRegistSocket.LIST_SEQUENCE,getResultGameList);
         setTimeout(SendGameSocre.closeSendGame,200);
         gameAlert.TARGET.enterBtn.addEventListener(MouseEvent.CLICK,gameMCRemove);
         GV.onlineSocket.addEventListener("read_" + 1461,friendGameScore);
         GameKingSocket.friendgamelist(ResultObj.GameID);
         for(var n:int = 1; n <= 10; n++)
         {
            gameAlert.TARGET["list_" + n].visible = false;
         }
         var tempArray:Array = evt.EventObj.listArr;
         for(var i:int = 1; i <= tempArray.length; i++)
         {
            gameAlert.TARGET["list_" + i].visible = true;
            gameAlert.TARGET["list_" + i].id = tempArray[i - 1].UserID;
            gameAlert.TARGET["list_" + i].num_txt.text = i;
            gameAlert.TARGET["list_" + i].nickName_txt.text = tempArray[i - 1].Nick;
            gameAlert.TARGET["list_" + i].point_txt.text = tempArray[i - 1].Score;
         }
      }
      
      public static function friendGameScore(e:EventTaomee) : void
      {
         var j:uint = 0;
         var ii:uint = 0;
         GV.onlineSocket.removeEventListener("read_" + 1461,friendGameScore);
         var arr:Array = e.EventObj.arr;
         var so:SharedObject = MainManager.getGlobalObject();
         var friendsList:Array = so.data.FriendsList;
         if(arr.length > 10)
         {
            arr = arr.slice(0,10);
         }
         if(Boolean(friendsList))
         {
            for(j = 0; j < arr.length; j++)
            {
               for(ii = 0; ii < friendsList.length; ii++)
               {
                  if(friendsList[ii].UserID == arr[j].UserID)
                  {
                     arr[j].Nick = friendsList[ii].Nick;
                     break;
                  }
               }
            }
         }
         for(var n:int = 1; n <= 10; n++)
         {
            gameAlert.TARGET["flist_" + n].visible = false;
         }
         for(var i:int = 1; i <= arr.length; i++)
         {
            gameAlert.TARGET["flist_" + i].visible = true;
            gameAlert.TARGET["flist_" + i].id = arr[i - 1].UserID;
            gameAlert.TARGET["flist_" + i].num_txt.text = i;
            gameAlert.TARGET["flist_" + i].nickName_txt.text = Boolean(arr[i - 1].Nick) ? arr[i - 1].Nick : arr[i - 1].UserID;
            gameAlert.TARGET["flist_" + i].point_txt.text = arr[i - 1].GameScore;
         }
      }
      
      public static function gameMCRemove(evt:MouseEvent) : void
      {
         var gameList:DisplayObject = MainManager.getGameLevel().getChildByName("GameList");
         DisplayUtil.removeForParent(gameList);
         if(Boolean(myAlert))
         {
            myAlert.TARGET.button3.addEventListener(MouseEvent.CLICK,gameListHandler);
         }
         isGetList = false;
      }
      
      public static function getAllUserInfo(evt:*) : void
      {
         GV.onlineClass.removeEventListener(ClientOnLineSerSocket.GET_BASIC_MESSAGE,getAllUserInfo);
         var userArray:Array = evt.EventObj.arr;
         var userObj:Object = {
            "data":userArray,
            "type":1
         };
         ClothAction.getClearMapListener();
         GV.PeopleCount.changeOnlinePeople(userObj);
         setTimeout(doActionXY,300);
      }
      
      private static function doActionXY() : void
      {
         var tempX:int = 0;
         var tempY:int = 0;
         switch(LocalUserInfo.getMapID())
         {
            case 7:
               tempX = 130;
               tempY = 400;
               peopleMove(tempX,tempY);
               break;
            case 8:
               tempX = 770;
               tempY = 340;
               peopleMove(tempX,tempY);
               break;
            case 9:
               tempX = 820;
               tempY = 200;
               peopleMove(tempX,tempY);
               break;
            case 10:
               tempX = 400;
               tempY = 340;
               peopleMove(tempX,tempY);
               break;
            case 16:
               tempX = 530;
               tempY = 160;
               peopleMove(tempX,tempY);
               break;
            case 69:
               tempX = 450;
               tempY = 340;
               peopleMove(tempX,tempY);
         }
      }
      
      public static function peopleMove(X:int, Y:int) : void
      {
         MoveTo.AutoFind(X,Y,GV.MAN_PEOPLE);
      }
      
      public static function stopMousicHandler() : void
      {
         GV.onlineSocket.dispatchEvent(new Event(policeSoundEvent));
         TopicMusicManager.instance.stopSound();
      }
      
      public static function playMousicHandler() : void
      {
         var mapID:int = LocalUserInfo.getMapID();
         TopicMusicManager.instance.playSound(mapID);
      }
   }
}

