package com.logic.JoinGameLogic
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.socketlogic.ClientOnLineSerSocket;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.GameframeLogic.GameframeLogic;
   import com.logic.socket.ClientGameSerSocket;
   import com.logic.socket.action.ActionReq;
   import com.logic.socket.enterGame.EnterGameReq;
   import com.logic.socket.enterGame.EnterGameRes;
   import com.logic.socket.enterGameServer.EnterGameServerRes;
   import com.logic.socket.gameGroup.GameGroupRes;
   import com.logic.socket.leaveGame.LeaveGameReq;
   import com.module.pet.petDiveGameLogic;
   import com.module.pet.petFlyGameLogic;
   import com.mole.app.event.PeopleEvent;
   import com.mole.app.info.GameLoaderConfigInfo;
   import com.mole.app.manager.GameLoaderConfigManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.module.AppModuleControl;
   import com.mole.app.module.ModuleEvent;
   import com.mole.app.type.GameType;
   import com.mole.app.type.ModuleType;
   import com.view.mapView.FortInsideMapView;
   import com.view.mapView.TrainingForestView;
   import com.view.mapView.activity.Task83.SoundManager;
   import com.view.mapView.activity.Task83.StatisticsClass;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class JoinGameLogic
   {
      
      private static var chairID:*;
      
      private static var faceID:*;
      
      private static var EventType:*;
      
      private static var actionClass:*;
      
      private static var actionStr:String;
      
      private static var joinObj:*;
      
      private static var getDirNumber:*;
      
      private static var getAction:int;
      
      private static var explain:String;
      
      private static var PlayGameID:int;
      
      public static var singleGameID:Number;
      
      private static var petFlyLogic:petFlyGameLogic;
      
      private static var petDiveLogic:petDiveGameLogic;
      
      private static var _isStart:Boolean;
      
      private static var _waitApp:AppModuleControl;
      
      public static var isLook:Boolean = false;
      
      public static var no_Have_Pet:String = "noHavePet";
      
      private static var ALERT_UI_PATH:String = "module/gameUI/alert/";
      
      public function JoinGameLogic()
      {
         super();
      }
      
      public static function reset() : void
      {
         EventType = -1;
      }
      
      public static function getchairId() : *
      {
         return chairID;
      }
      
      public static function joinGameAction(faceNum:int, chairNum:int, type:int = 0, gameSingleid:Number = 0) : void
      {
         if(gameSingleid == 2)
         {
            StatisticsClass.getInstance().init(67748711);
         }
         singleGameID = gameSingleid;
         faceID = faceNum;
         chairID = chairNum;
         EventType = type;
      }
      
      public static function loginInit(obj:*, fun:*) : void
      {
         var str:String = null;
         var msg:String = null;
         var url:String = null;
         var gameURL:String = null;
         var tempurl:String = null;
         var petObj:Object = null;
         actionClass = obj;
         actionStr = fun;
         var o:GameLoaderConfigInfo = GameLoaderConfigManager.getInfo(EventType);
         if(Boolean(o))
         {
            if(o.needVip)
            {
               if(LocalUserInfo.isVIP())
               {
                  explain = o.explain;
                  joinGameOfSelect();
               }
               else
               {
                  Alert.SLAlart(String("    " + o.needVipMsg));
               }
            }
            else
            {
               explain = o.explain;
               joinGameOfSelect();
            }
         }
         else
         {
            switch(EventType)
            {
               case 0:
                  joinSitHandler();
                  break;
               case 1:
                  explain = "ddp.swf";
                  joinGameOfSelect();
                  break;
               case 9:
                  explain = "你敢去大戰冰上外星怪獸嗎?";
                  joinGameOfSelect();
                  break;
               case 2:
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  explain = "huaxue.swf";
                  joinNetGameOfSelect();
                  break;
               case 3:
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  if(chairID > 100)
                  {
                     explain = "您是否要觀看五子棋?";
                  }
                  else
                  {
                     explain = "wuziqi.swf";
                  }
                  joinNetGameOfSelect();
                  break;
               case 5:
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  explain = "momodasaiche.swf";
                  joinNetGameOfSelect();
                  break;
               case 10:
                  MoveTo.CanMove = false;
                  switch(singleGameID)
                  {
                     case 1:
                        explain = "diaoyu.swf";
                        break;
                     case 2:
                        explain = "minghua.swf";
                        break;
                     case 3:
                        explain = "xiaonongfu.swf";
                        break;
                     case 4:
                        explain = "你要參加豬豬快跑嗎?";
                        break;
                     case 5:
                        explain = "jumpwater.swf";
                        break;
                     case 6:
                        explain = "你要操作R4齒輪機器人嗎?";
                        break;
                     case 7:
                        explain = "wudilianliankan.swf";
                        break;
                     case 8:
                        explain = "momolaizhaocha.swf";
                        break;
                     case 9:
                        explain = "linhuaqian.swf";
                        break;
                     case 10:
                        explain = "kuaileplate.swf";
                        break;
                     case 11:
                        if(GV.MAN_PEOPLE.Petlevel < 1)
                        {
                           MoveTo.CanMove = true;
                           msg = "親愛的小摩爾:\n    這裡是豐收食神擂台賽現場，你想參加食神大賽嗎？呵呵，快帶著你的小拉姆來吧！";
                           url = "resource/allJob/AlertPic/teamMc1.swf";
                           Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
                           return;
                        }
                        explain = "eatbattle.swf";
                        break;
                     case 12:
                        explain = "nanguasaipao.swf";
                        joinNetGameOfSelect();
                        break;
                     case 13:
                        explain = "dazuozhan.swf";
                  }
                  if(singleGameID != 12)
                  {
                     joinNetGameOfSelect();
                  }
                  break;
               case 11:
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  if(chairID > 100)
                  {
                     explain = "您是否要觀看象棋?";
                  }
                  else
                  {
                     explain = "xiangqi.swf";
                  }
                  joinNetGameOfSelect();
                  break;
               case 12:
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  explain = "你要玩學習機的腦力測試嗎？";
                  joinGameOfSelect();
                  break;
               case 13:
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  explain = "paopaolong.swf";
                  joinNetGameOfSelect();
                  break;
               case 14:
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  explain = "zhunagyuan.swf";
                  joinGameOfSelect();
                  break;
               case 15:
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  explain = "zhaiguozi.swf";
                  joinGameOfSelect();
                  break;
               case 16:
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  explain = "yinghuochong.swf";
                  joinGameOfSelect();
                  break;
               case 17:
               case 100:
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  explain = "你敢來試一把漂流嗎?";
                  joinNetGameOfSelect();
                  break;
               case GameType.SKEE_2:
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  explain = "你敢來試一把沙漠出租嗎?";
                  joinNetGameOfSelect();
                  break;
               case GameType.SKEE_3:
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  explain = "麼麼公主的滑雪?";
                  joinNetGameOfSelect();
                  break;
               case 18:
                  MoveTo.CanMove = false;
                  explain = "sheji.swf";
                  joinGameOfSelect();
                  break;
               case 19:
                  if(petFlyLogic == null)
                  {
                     petFlyLogic = new petFlyGameLogic();
                  }
                  petFlyLogic.init();
                  break;
               case 20:
                  trace("-----------------潛水遊水");
                  if(petDiveLogic == null)
                  {
                     petDiveLogic = new petDiveGameLogic();
                  }
                  petDiveLogic.init();
                  break;
               case 21:
                  petObj = GF.getPeopleObj(GV.MyInfo_userID);
                  if(petObj != null && Boolean(petObj.PetID))
                  {
                     joinSitHandler();
                  }
                  else
                  {
                     GV.onlineSocket.dispatchEvent(new Event(no_Have_Pet));
                  }
                  break;
               case 23:
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  explain = "els.swf";
                  joinNetGameOfSelect();
                  break;
               case 24:
                  MoveTo.CanMove = false;
                  explain = "renzhi.swf";
                  joinGameOfSelect();
                  break;
               case 25:
                  MoveTo.CanMove = false;
                  joinSitHandler();
                  break;
               case 26:
                  MoveTo.CanMove = false;
                  joinSitHandler();
                  break;
               case 27:
                  if(!FortInsideMapView.isGetBook)
                  {
                     str = FortInsideMapView.explain;
                     tempurl = FortInsideMapView.url;
                     joinObj = Alert.showAlert(MainManager.getGameLevel(),tempurl,str,Alert.CHANG_ALERT,"ok",true,false,"EMP_BUY");
                     return;
                  }
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  explain = "    你想與其他小摩爾來場友誼賽嗎？";
                  gameURL = "module/gameUI/icon/001.swf";
                  joinNetGameOfSelect(true,gameURL);
                  break;
               case 28:
                  MoveTo.CanMove = false;
                  explain = "你想進入神秘湖底尋寶嗎？";
                  joinGameOfSelect();
                  break;
               case 29:
                  if(GV.MAN_PEOPLE.Petlevel < 1)
                  {
                     msg = "你要帶著你的拉姆才能玩拋拋球遊戲！";
                     GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
                     return;
                  }
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  explain = "您是否要進入拋拋球?";
                  joinNetGameOfSelect();
                  break;
               case 30:
                  explain = "ICStore.swf";
                  joinGameOfSelect();
                  break;
               case 31:
                  explain = "xiaofangyuan.swf";
                  joinGameOfSelect();
                  break;
               case 32:
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  explain = "FlyingChess.swf";
                  joinNetGameOfSelect();
                  break;
               case 33:
                  explain = "banyungong.swf";
                  joinGameOfSelect();
                  break;
               case 34:
                  explain = "saveLamu.swf";
                  joinGameOfSelect();
                  break;
               case 35:
                  explain = "beats.swf";
                  joinGameOfSelect();
                  break;
               case 36:
                  if(GV.MAN_PEOPLE.Petlevel < 1)
                  {
                     msg = "你要帶著你的拉姆才能修剪小草坪！";
                     GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
                     return;
                  }
                  explain = "現在就讓你的拉姆修剪小草坪嗎？";
                  joinGameOfSelect();
                  break;
               case 37:
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  explain = "你要進入摩爾大課堂比賽嗎?";
                  joinNetGameOfSelect();
                  break;
               case 38:
               case 39:
                  if(!TrainingForestView.isGetBook)
                  {
                     str = TrainingForestView.explain;
                     tempurl = TrainingForestView.url;
                     joinObj = Alert.showAlert(MainManager.getGameLevel(),tempurl,str,Alert.CHANG_ALERT,"ok",true,false,"EMP_BUY");
                     return;
                  }
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  explain = "    你想與其他小摩爾來場友誼賽嗎？";
                  gameURL = "module/gameUI/icon/001.swf";
                  joinNetGameOfSelect(true,gameURL);
                  break;
               case 40:
                  if(!TrainingForestView.isGetBook)
                  {
                     str = TrainingForestView.explain;
                     tempurl = TrainingForestView.url;
                     joinObj = Alert.showAlert(MainManager.getGameLevel(),tempurl,str,Alert.CHANG_ALERT,"ok",true,false,"EMP_BUY");
                     return;
                  }
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  GV.isGameShowTip = true;
                  beforehandLoadGame();
                  break;
               case GameType.GAME_TYPE_41:
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  explain = "lamuEvolution.swf";
                  joinGameOfSelect();
                  break;
               case GameType.GAME_TYPE_42:
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  explain = "MathGame.swf";
                  joinGameOfSelect();
                  break;
               case GameType.GAME_TYPE_43:
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  explain = "SimuClassRoom.swf";
                  joinGameOfSelect();
                  break;
               case GameType.GAME_TYPE_44:
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  explain = "MusicTest.swf";
                  joinGameOfSelect();
                  break;
               case GameType.GAME_TYPE_94:
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  explain = "sixChess.swf";
                  joinNetGameOfSelect();
                  break;
               case GameType.GAME_TYPE_96:
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  explain = "blowCandle.swf";
                  joinNetGameOfSelect();
                  break;
               case 114:
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  explain = "你想與其他小摩爾來場馴蛇伏摩遊戲嗎？";
                  joinNetGameOfSelect();
                  break;
               case 115:
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  explain = "你想與其他小摩爾來場大富翁遊戲嗎？";
                  joinNetGameOfSelect();
                  break;
               case 116:
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  explain = "你想與其他小摩爾來場找黑貓遊戲嗎？";
                  joinNetGameOfSelect();
                  break;
               case 117:
                  MoveTo.CanMove = false;
                  BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
                  explain = "你想與其他小摩爾來場魔法球遊戲嗎？";
                  joinNetGameOfSelect();
            }
         }
      }
      
      private static function loginOutHandler(evt:* = null, type:* = null) : void
      {
         var tempX:int = 0;
         var tempY:int = 0;
         BC.removeEvent(JoinGameLogic,joinObj,"CLICK" + 1,joinGameHandler);
         BC.removeEvent(JoinGameLogic,joinObj,"CLICK" + 2,loginOutHandler);
         BC.removeEvent(JoinGameLogic,joinObj,"CLICK" + 1,joinSitHandler);
         BC.removeEvent(JoinGameLogic,GV.onlineSocket,"netGameOver",joinSitHandler);
         BC.removeEvent(JoinGameLogic,GV.onlineSocket,EnterGameRes.ENTER_GAME,enterGameHandler);
         BC.removeEvent(JoinGameLogic,GV.onlineSocket,ClientOnLineSerSocket.ERROR_GAME,errorGameHandler);
         BC.removeEvent(JoinGameLogic,GV.onlineSocket,GameGroupRes.GAMEGROPU,showWaticMC);
         GV.isGameShowTip = false;
         MoveTo.CanMove = true;
         if(EventType != 0)
         {
            if(Boolean(type))
            {
               tempX = int(GV.MAN_PEOPLE.x);
               if(EventType == 2)
               {
                  tempY = GV.MAN_PEOPLE.y - 60;
               }
               else
               {
                  tempY = GV.MAN_PEOPLE.y + 80;
               }
               MoveTo.AutoFind(tempX,tempY,GV.MAN_PEOPLE);
            }
            else
            {
               if(EventType == 2)
               {
                  tempX = int(GV.MAN_PEOPLE.x);
                  tempY = GV.MAN_PEOPLE.y - 60;
               }
               else
               {
                  tempX = GV.MAN_PEOPLE.x - 30;
                  tempY = int(GV.MAN_PEOPLE.y);
               }
               MoveTo.AutoFind(tempX,tempY,GV.MAN_PEOPLE);
            }
         }
      }
      
      public static function openGame(id:int, type:int) : void
      {
         BC.addEvent(JoinGameLogic,GV.onlineSocket,"netGameOver",joinSitHandler);
         GameframeLogic.loadGame(id,type);
         GV.onlineSocket.addEventListener(EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
      }
      
      public static function joinSitHandler(evt:* = null) : void
      {
         BC.removeEvent(JoinGameLogic,GV.onlineSocket,"netGameOver",joinSitHandler);
         if(GV.isSitDown == false)
         {
            BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameRes.ENTER_GAME,enterGameHandler);
            BC.addEvent(JoinGameLogic,GV.onlineSocket,ClientOnLineSerSocket.ERROR_GAME,errorGameHandler);
            BC.addEvent(JoinGameLogic,GV.onlineSocket,GameGroupRes.GAMEGROPU,showWaticMC);
            GV.isSitDown = true;
            GV.onlineSocket.dispatchEvent(new Event("stopSoundMachine"));
            EnterGameReq.send(chairID);
         }
         else
         {
            LeaveGameReq.leaveGame(0);
            GV.isSitDown = false;
            if(EventType != 40)
            {
               loginOutHandler();
            }
            BC.removeEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
         }
      }
      
      private static function joinGameHandler(evt:* = null) : void
      {
         EnterGameReq.send(chairID);
      }
      
      private static function clearNpcMoveFun(evt:EventTaomee) : void
      {
         BC.removeEvent(JoinGameLogic,GV.onlineSocket,LeaveGameReq.LEAVEGAME_CLEATNPC,clearNpcMoveFun);
      }
      
      public static function enterGameHandler(evt:* = null) : void
      {
         var tempID:int;
         var userID:int;
         var ItemID:int;
         var action:int;
         var Direction:int;
         var Status:int;
         var o:GameLoaderConfigInfo = null;
         if(EventType == -1)
         {
            return;
         }
         tempID = LocalUserInfo.getMapID();
         if(tempID == 28)
         {
            return;
         }
         userID = int(evt.EventObj.UserID);
         ItemID = int(evt.EventObj.ItemID);
         action = int(evt.EventObj.Action);
         Direction = int(evt.EventObj.Direction);
         Status = int(evt.EventObj.Status);
         getDirNumber = Direction;
         getAction = action;
         if(LocalUserInfo.getUserID() == userID)
         {
            BC.addEvent(JoinGameLogic,GV.onlineSocket,ClientGameSerSocket.SEEGAME_LEAVE,seeLevenGameFun);
            BC.addEvent(JoinGameLogic,GV.onlineSocket,LeaveGameReq.LEAVEGAME_CLEATNPC,clearNpcMoveFun);
            PlayGameID = evt.EventObj.GameID;
            GV.GroupID = evt.EventObj.GroupID;
            isLook = Status == 1 ? false : true;
            o = GameLoaderConfigManager.getInfo(EventType);
            if(Boolean(o))
            {
               loginOutHandler();
               onLoadGameHandler(PlayGameID);
            }
            else
            {
               switch(EventType)
               {
                  case 0:
                     loginOutHandler();
                     actionClass[actionStr](userID);
                     break;
                  case 1:
                  case 30:
                  case 31:
                  case 34:
                  case 35:
                  case 36:
                     loginOutHandler();
                     onLoadGameHandler(PlayGameID);
                     break;
                  case 9:
                     loginOutHandler();
                     onLoadGameHandler(PlayGameID);
                     GC.stopAllMC(GV.MC_mapFrame);
                     GV.onlineSocket.dispatchEvent(new EventTaomee("mouseMoveRemove"));
                     break;
                  case 3:
                     if(!isLook)
                     {
                        actionClass[actionStr](userID);
                     }
                     break;
                  case 5:
                  case 32:
                  case 37:
                     actionClass[actionStr](userID);
                     break;
                  case 10:
                     GameframeLogic.singleEvent(singleGameID);
                     switch(singleGameID)
                     {
                        case 1:
                           GV.onlineSocket.dispatchEvent(new EventTaomee("mouseMoveRemove"));
                           actionClass[actionStr](userID);
                           break;
                        default:
                           try
                           {
                              actionClass[actionStr](userID);
                           }
                           catch(error:Error)
                           {
                              trace(error);
                           }
                     }
                     break;
                  case 11:
                  case GameType.GAME_TYPE_94:
                  case GameType.GAME_TYPE_96:
                     if(!isLook)
                     {
                        actionClass[actionStr](userID);
                     }
                     break;
                  case 13:
                  case 29:
                     actionClass[actionStr](userID);
                     break;
                  case 14:
                  case 12:
                  case GameType.GAME_TYPE_41:
                  case GameType.GAME_TYPE_42:
                  case GameType.GAME_TYPE_43:
                  case GameType.GAME_TYPE_44:
                  case 15:
                  case 16:
                  case 18:
                     loginOutHandler();
                     onLoadGameHandler(PlayGameID);
                     break;
                  case 17:
                  case GameType.PIAO_LIU_2:
                  case GameType.SKEE_2:
                  case 23:
                     actionClass[actionStr](userID);
                     break;
                  case 19:
                     loginOutHandler();
                     actionClass[actionStr](userID);
                     break;
                  case 21:
                  case 24:
                  case 25:
                  case 26:
                  case 28:
                  case 33:
                     loginOutHandler();
                     onLoadGameHandler(PlayGameID);
                     break;
                  case 27:
                  case 38:
                     if(Boolean(actionStr))
                     {
                        if(chairID < 9)
                        {
                           actionClass[actionStr](userID);
                        }
                     }
               }
            }
         }
      }
      
      private static function seeLevenGameFun(evt:*) : void
      {
         MoveTo.CanMove = true;
         GV.isSitDown = false;
         BC.removeEvent(JoinGameLogic,GV.onlineSocket,ClientGameSerSocket.SEEGAME_LEAVE,seeLevenGameFun);
      }
      
      private static function errorGameHandler(evt:*) : void
      {
         loginOutHandler();
         GV.isSitDown = false;
         if(chairID > 100)
         {
            joinObj = Alert.showAlert(MainManager.getAppLevel(),"遊戲沒有開始,請換一個桌子觀看","",6,"D");
         }
         else
         {
            joinObj = Alert.showAlert(MainManager.getAppLevel(),evt.EventObj.msg,"",6,"D");
         }
      }
      
      public static function doActionSitDown() : void
      {
         setTimeout(function():void
         {
            delayAction();
         },500);
      }
      
      public static function delayAction() : void
      {
         GV.MAN_PEOPLE.sitDown(getDirNumber);
         ActionReq.actions1(getAction,getDirNumber);
      }
      
      public static function onLoadGameHandler(gameID:int) : void
      {
         GameframeLogic.loadGame(gameID,EventType);
      }
      
      private static function joinGameOfSelect() : void
      {
         GV.isGameShowTip = true;
         if(explain.indexOf(".swf") != -1)
         {
            joinObj = Alert.showAlert(MainManager.getAppLevel(),"",ALERT_UI_PATH + explain,Alert.GAME_ALERT,"sure,cancel",true,false,"EMP_BUY");
         }
         else
         {
            joinObj = Alert.showAlert(MainManager.getAppLevel(),"",explain,Alert.SELECT_ALERT);
         }
         BC.addEvent(JoinGameLogic,joinObj,"CLICK" + 1,joinSitHandler);
         BC.addEvent(JoinGameLogic,joinObj,"CLICK" + 2,loginOutHandler);
      }
      
      private static function joinNetGameOfSelect(isPic:Boolean = false, url:String = "") : void
      {
         GV.isGameShowTip = true;
         if(explain.indexOf(".swf") != -1)
         {
            joinObj = Alert.showAlert(MainManager.getAppLevel(),"",ALERT_UI_PATH + explain,Alert.GAME_ALERT,"sure,cancel",true,false,"EMP_BUY");
         }
         else if(!isPic)
         {
            joinObj = Alert.showAlert(MainManager.getAppLevel(),"",explain,Alert.SELECT_ALERT);
         }
         else
         {
            joinObj = Alert.showAlert(MainManager.getGameLevel(),url,explain,Alert.CHANG_ALERT,"sure,cancel",true,false,"EMP_BUY");
         }
         BC.addEvent(JoinGameLogic,joinObj,"CLICK" + 1,beforehandLoadGame);
         BC.addEvent(JoinGameLogic,joinObj,"CLICK" + 2,loginOutHandler);
      }
      
      public static function getGameServerInfo(evt:*) : void
      {
         GV.onlineSocket.removeEventListener(EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
         BC.removeEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
         _isStart = true;
         getOtherPeoInfo(evt.EventObj.userArr);
         remveShowMC();
         GameframeLogic.gameServerInfo = new Object();
         GameframeLogic.gameServerInfo.GameID = PlayGameID;
         GameframeLogic.gameServerInfo.GroupID = GV.GroupID;
         GameframeLogic.gameServerInfo.UserID = LocalUserInfo.getUserID();
         GameframeLogic.gameServerInfo.ip = evt.EventObj.IP;
         GameframeLogic.gameServerInfo.port = evt.EventObj.Port;
         GameframeLogic.gameServerInfo.SessionID = evt.EventObj.SessionID;
         GameframeLogic.gameServerInfo.userArr = evt.EventObj.userArr;
         GameframeLogic.readyGame();
      }
      
      private static function showWaticMC(evt:*) : void
      {
         MoveTo.CanMove = true;
         _isStart = false;
         _waitApp = ModuleManager.openPanel(ModuleType.GAME_WAIT_PANEL,{
            "gameType":EventType,
            "playerObj":evt.EventObj
         });
         _waitApp.addEventListener(ModuleEvent.DESTROY,onCloseWaitApp);
         GV.onlineSocket.addEventListener(PeopleEvent.READY_MOVE,onReadyMove);
      }
      
      private static function onReadyMove(e:Event) : void
      {
         GV.onlineSocket.removeEventListener(PeopleEvent.READY_MOVE,onReadyMove);
         removeWaitApp();
      }
      
      private static function onCloseWaitApp(e:Event) : void
      {
         var tmpWaitApp:AppModuleControl = e.currentTarget as AppModuleControl;
         if(Boolean(tmpWaitApp))
         {
            tmpWaitApp.removeEventListener(ModuleEvent.DESTROY,onCloseWaitApp);
         }
         if(_isStart == false)
         {
            leaveGame();
         }
      }
      
      private static function removeWaitApp() : void
      {
         if(Boolean(_waitApp))
         {
            _waitApp.close();
            _waitApp = null;
         }
      }
      
      private static function leaveGame() : void
      {
         SoundManager.openAll();
         GV.isSitDown = false;
         MoveTo.CanMove = true;
         BC.removeEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
         remveShowMC(null,1);
         LeaveGameReq.leaveGame(0);
      }
      
      private static function remveShowMC(evt:MouseEvent = null, type:* = null) : void
      {
         GV.isSitDown = false;
         removeWaitApp();
         if(type == null)
         {
            loginOutHandler(null,0);
         }
         else
         {
            loginOutHandler(null,1);
         }
      }
      
      private static function checkID(id:*) : String
      {
         for(var i:int = 0; i < GV.OnLineArray.length; i++)
         {
            if(id == GV.OnLineArray[i].UserID)
            {
               return GV.OnLineArray[i].Nick;
            }
         }
         return "";
      }
      
      public static function beforehandLoadGame(evt:* = null) : void
      {
         openGame(0,EventType);
      }
      
      public static function addEventForCard() : void
      {
         BC.addEvent(JoinGameLogic,GV.onlineSocket,EnterGameServerRes.ENTER_GAMESER,getGameServerInfo);
      }
      
      public static function getOtherPeoInfo(arr:Array) : void
      {
         var peop:MovieClip = null;
         GV.otherPetArr = new Array();
         for(var i:int = 0; i < arr.length; i++)
         {
            if(arr[i].UserID != LocalUserInfo.getUserID())
            {
               peop = GF.getPeopleByID(arr[i].UserID);
               if(Boolean(peop))
               {
                  GV.otherPetObj = {
                     "Petlvel":peop.Petlevel,
                     "PetColor":GV["petColor_" + peop.PetColor],
                     "Penick":peop.nickName
                  };
                  GV.otherPetArr.push({
                     "Petlvel":peop.Petlevel,
                     "PetColor":GV["petColor_" + peop.PetColor],
                     "Penick":peop.nickName,
                     "UserID":peop.id,
                     "manColor":peop.Family,
                     "manNick":peop.nickName
                  });
               }
            }
         }
      }
   }
}

