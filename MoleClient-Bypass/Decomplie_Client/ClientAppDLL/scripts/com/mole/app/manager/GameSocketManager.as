package com.mole.app.manager
{
   import com.common.Alert.Alert;
   import com.common.data.HashMap;
   import com.core.info.LocalUserInfo;
   import com.core.manager.LevelManager;
   import com.global.staticData.CommandID;
   import com.logic.socket.enterGame.EnterGameReq;
   import com.logic.socket.enterGameServer.EnterGameServerRes;
   import com.logic.socket.leaveGame.LeaveGameReq;
   import com.mole.app.map.MapManager;
   import com.mole.app.module.AppModuleControl;
   import com.mole.app.module.ModuleEvent;
   import com.mole.app.type.ModuleType;
   import com.mole.net.SocketImpl;
   import com.mole.net.events.SocketEvent;
   import com.view.PeopleView.PeopleManageView;
   import flash.events.Event;
   import flash.utils.ByteArray;
   
   public class GameSocketManager
   {
      
      public static var GAME_INFO_LIST:HashMap;
      
      private static var _gameInfo:Object;
      
      private static var _gameIP:String;
      
      private static var _gamePort:uint;
      
      private static var _session:ByteArray;
      
      private static var _peopleList:Array;
      
      private static var _socket:SocketImpl;
      
      private static var _leaveFun:Function;
      
      private static var _matchPanel:AppModuleControl;
      
      private static var _gameModel:AppModuleControl;
      
      private static var _isLeave:Boolean;
      
      public function GameSocketManager()
      {
         super();
      }
      
      public static function enter(gameID:uint, leaveFun:Function) : void
      {
         GAME_INFO_LIST = new HashMap();
         GAME_INFO_LIST.add(7,{
            "gameID":100,
            "itemID":7,
            "matchPro":30628,
            "startPro":30625
         });
         GAME_INFO_LIST.add(10,{
            "gameID":111,
            "itemID":10,
            "matchPro":30628,
            "startPro":30625
         });
         GAME_INFO_LIST.add(11,{
            "gameID":112,
            "itemID":1,
            "matchPro":30643,
            "startPro":30625
         });
         _leaveFun = leaveFun;
         _gameInfo = GAME_INFO_LIST.getValue(gameID);
         _isLeave = false;
         new EnterGameReq().enterGame(_gameInfo.itemID);
         OnlineManager.addCmdListener(CommandID.ENTER_GAME_SER,onEnterGameSer);
         var peopleView:PeopleManageView = GV.MAN_PEOPLE;
         peopleView.addEventListener(PeopleManageView.ON_GO_START,onLeaveShark);
      }
      
      private static function onLeaveShark(e:Event) : void
      {
         leave();
         var peopleView:PeopleManageView = GV.MAN_PEOPLE;
         peopleView.removeEventListener(PeopleManageView.ON_GO_START,onLeaveShark);
      }
      
      private static function onEnterGameSer(e:SocketEvent) : void
      {
         OnlineManager.removeCmdListener(CommandID.ENTER_GAME_SER,onEnterGameSer);
         var gameSer:EnterGameServerRes = e.bodyInfo;
         _gameIP = gameSer.ip;
         _gamePort = gameSer.port;
         _session = gameSer.session;
         _peopleList = gameSer.peopleList;
         _socket = new SocketImpl(LocalUserInfo.getUserID());
         _socket.connect(_gameIP,_gamePort);
         _socket.addEventListener(Event.CONNECT,onConnectGameSer);
      }
      
      private static function onConnectGameSer(e:Event) : void
      {
         _socket.removeEventListener(Event.CONNECT,onConnectGameSer);
         _socket.send(CommandID.CHECK_GAME_SER,_session);
         _socket.addCmdListener(CommandID.CHECK_GAME_SER,onCheckGameSer);
      }
      
      private static function removeMatch(close:Boolean = false) : void
      {
         if(Boolean(_matchPanel))
         {
            _matchPanel.removeEventListener(ModuleEvent.DESTROY,onCloseMatchPanel);
            if(close)
            {
               _matchPanel.close();
            }
            _matchPanel = null;
         }
      }
      
      private static function onCheckGameSer(e:SocketEvent) : void
      {
         _socket.removeCmdListener(CommandID.CHECK_GAME_SER,onCheckGameSer);
         _socket.addCmdListener(_gameInfo.matchPro,onGameMatchSucc);
         _matchPanel = ModuleManager.openPanel(ModuleType.TWO_GAME_MATCHING_PANEL,_gameInfo.itemID,"",LevelManager.gameLevel);
         _matchPanel.addEventListener(ModuleEvent.DESTROY,onCloseMatchPanel);
      }
      
      private static function onCloseMatchPanel(e:Event) : void
      {
         if(_leaveFun != null)
         {
            _leaveFun.apply();
         }
         leave();
      }
      
      private static function removeGameModel() : void
      {
         if(Boolean(_gameModel))
         {
            _gameModel.removeEventListener(ModuleEvent.DESTROY,onSharkOver);
            _gameModel = null;
         }
      }
      
      private static function onGameMatchSucc(e:SocketEvent) : void
      {
         _socket.removeCmdListener(_gameInfo.matchPro,onGameMatchSucc);
         removeMatch(true);
         switch(_gameInfo.itemID)
         {
            case 7:
               _gameModel = ModuleManager.openPanel(ModuleType.SUGGESTIVE_SHARKS_PANEL,_socket,"",LevelManager.gameLevel);
               _gameModel.addEventListener(ModuleEvent.DESTROY,onSharkOver);
               break;
            case 10:
               MapManager.clearMap();
               _gameModel = ModuleManager.openPanel(ModuleType.STR_MAN_PANEL,_socket,"",LevelManager.gameLevel);
               _gameModel.addEventListener(ModuleEvent.DESTROY,onGameOver);
               break;
            case 1:
               MapManager.clearMap();
               _gameModel = ModuleManager.openPanel("KFCQuestGamePanel",_socket,"",LevelManager.gameLevel);
               _gameModel.addEventListener(ModuleEvent.DESTROY,onKFCGameOver);
         }
      }
      
      private static function onGameOver(e:ModuleEvent) : void
      {
         clear();
      }
      
      private static function onKFCGameOver(e:ModuleEvent) : void
      {
         _socket.send(CommandID.USERREQ_LEAVEA_GAME);
         clear();
      }
      
      private static function onSharkOver(e:ModuleEvent) : void
      {
         var obj:Object = e.data;
         switch(obj && obj.type)
         {
            case 100:
               if(Boolean(obj.isWin))
               {
                  Alert.smileAlart("　　哇，對方先被鯊魚咬到啦！恭喜你獲得10張海底樂園禮券。");
               }
               else
               {
                  Alert.smileAlart("　　本輪沒有中獎，請再接再厲哦！");
               }
         }
         clear();
      }
      
      public static function leave() : void
      {
         if(_isLeave == false)
         {
            _isLeave = true;
            if(Boolean(_matchPanel))
            {
               _matchPanel.close();
               clear();
            }
            LeaveGameReq.leaveGame(_gameInfo.itemID);
         }
      }
      
      public static function clear() : void
      {
         removeMatch();
         removeGameModel();
         var peopleView:PeopleManageView = GV.MAN_PEOPLE;
         peopleView.removeEventListener(PeopleManageView.ON_GO_START,onLeaveShark);
         OnlineManager.removeCmdListener(CommandID.ENTER_GAME_SER,onEnterGameSer);
         if(Boolean(_socket))
         {
            _socket.removeEventListener(Event.CONNECT,onConnectGameSer);
            _socket.removeCmdListener(CommandID.CHECK_GAME_SER,onCheckGameSer);
            _socket.removeCmdListener(_gameInfo.matchPro,onGameMatchSucc);
            _socket.destroy();
            _socket = null;
         }
         _session = null;
         _leaveFun = null;
      }
   }
}

