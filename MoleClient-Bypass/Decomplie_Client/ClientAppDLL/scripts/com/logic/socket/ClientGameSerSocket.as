package com.logic.socket
{
   import com.common.msgHead.MsgHead;
   import com.core.info.LocalUserInfo;
   import com.core.socketlogic.servermsg.ServerMsg;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.enterPlayerGame.*;
   import com.logic.socket.fiveChess.*;
   import com.logic.socket.gameLogic.*;
   import com.logic.socket.gameScore.GameSocreRes;
   import com.logic.socket.leaveGameSer.*;
   import com.logic.socket.looker.LookerRes;
   import com.logic.socket.newUserEnterGame.NewUserEnterGameRes;
   import com.logic.socket.noticeGameOver.NoticeGameOverRes;
   import com.logic.socket.noticeGameStart.NoticeGameStartRes;
   import com.logic.socket.noticeLooker.NoticeLookerRes;
   import com.logic.socket.noticePlayerFail.*;
   import com.logic.socket.playerReqEqual.*;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.Socket;
   import flash.system.Security;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class ClientGameSerSocket extends Sprite
   {
      
      public static var SOCKET_CONNECT:String = "socket_connect";
      
      public static var VAILDATE_FAIL:String = "vaildate_fail";
      
      public static var ENTER_GAME_SUCCESS:String = "enter_game_sucess";
      
      public static var SEND_DATA:String = "send_data";
      
      public static var SOCKET_SHUTDOWN:String = "socket_shutdown";
      
      public static var SOCKET_SUCCESS:String = "socket_success";
      
      public static var SOCKET_ERROR:String = "socket_error";
      
      public static var SOCKET_DATAS:String = "socket_datas";
      
      public static var DATA_NOT_ENOUGH:String = "data_not_enough";
      
      public static var DATA_TOO_BIG:String = "data_too_big";
      
      public static var REGIST_FAIL:String = "regist_fail";
      
      public static var SEEGAME_LEAVE:String = "seeGame_leave";
      
      public var socket:Socket;
      
      private var time:Timer;
      
      private var gameFaultObj:Object;
      
      private var gameId:int;
      
      private var onlineId:int;
      
      private var groupId:int;
      
      private var is_head:Boolean;
      
      private var obj:Object;
      
      private var SessionID:ByteArray;
      
      private var tempObj:Object;
      
      private var enterPlayerGameReq:EnterPlayerGameReq;
      
      private var mapLoadEndReq:MapLoadEndReq;
      
      public function ClientGameSerSocket(ip:String, port:int, sessionID:ByteArray)
      {
         super();
         this.enterPlayerGameReq = new EnterPlayerGameReq();
         this.mapLoadEndReq = new MapLoadEndReq();
         this.socket = new Socket();
         GV.GameSocket = this.socket;
         this.is_head = true;
         this.obj = new Object();
         GV.GameSocket = this.socket;
         this.gameFaultObj = new Object();
         this.SessionID = new ByteArray();
         this.SessionID = sessionID;
         Security.loadPolicyFile("xmlsocket://" + ip + ":" + port);
         this.configureListeners();
         this.socket.connect(ip,port);
      }
      
      private function configureListeners() : void
      {
         this.socket.addEventListener(Event.CLOSE,this.closeHandler);
         this.socket.addEventListener(Event.CONNECT,this.connectHandler);
         this.socket.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
         this.socket.addEventListener(ProgressEvent.SOCKET_DATA,this.socketDataHandler);
      }
      
      private function closeHandler(event:Event) : void
      {
         GV.GameSocket.dispatchEvent(new Event(SOCKET_SHUTDOWN));
         GV.onlineSocket.dispatchEvent(new Event(SEEGAME_LEAVE));
      }
      
      private function connectHandler(event:Event) : void
      {
         GV.GameSocket.dispatchEvent(new Event(SOCKET_CONNECT));
         this.sendDataGameSer();
      }
      
      private function ioErrorHandler(event:IOErrorEvent) : void
      {
         GV.GameSocket.dispatchEvent(new Event(SOCKET_ERROR));
      }
      
      private function securityErrorHandler(event:SecurityErrorEvent) : void
      {
      }
      
      private function socketDataHandler(event:ProgressEvent) : void
      {
         this.socketData();
      }
      
      private function sendDataGameSer() : void
      {
         this.enterPlayerGameReq.enterPlayerGame(this.SessionID);
      }
      
      public function socketData() : void
      {
         while(this.socket.bytesAvailable > 0)
         {
            if(this.is_head && this.socket.bytesAvailable < 4)
            {
               this.obj.msg = "data not enough";
               GV.GameSocket.dispatchEvent(new EventTaomee(DATA_NOT_ENOUGH,this.obj));
               return;
            }
            if(this.is_head)
            {
               MsgHead.PkgLen = this.socket.readUnsignedInt();
            }
            if(MsgHead.PkgLen < 0 || MsgHead.PkgLen > 8192)
            {
               trace("data too big   " + MsgHead.PkgLen);
               this.obj.msg = "data too big";
               GV.GameSocket.dispatchEvent(new EventTaomee(DATA_TOO_BIG,this.obj));
               this.socket.close();
               return;
            }
            if(this.socket.bytesAvailable < MsgHead.PkgLen - 4)
            {
               this.is_head = false;
               this.obj.msg = "data not enough";
               GV.GameSocket.dispatchEvent(new EventTaomee(DATA_NOT_ENOUGH,this.obj));
               return;
            }
            this.is_head = true;
            MsgHead.Version = this.socket.readUnsignedByte();
            MsgHead.Command = this.socket.readUnsignedInt();
            MsgHead.UserID = this.socket.readUnsignedInt();
            MsgHead.Result = this.socket.readUnsignedInt();
            if(MsgHead.Result == 0)
            {
               this.acceptData();
            }
            else
            {
               if(MsgHead.Result == -10001)
               {
                  this.gameFaultObj.login = "驗證失敗，用戶尚未登陸。";
               }
               else if(MsgHead.Result == -10007)
               {
                  this.gameFaultObj.game = " 驗證成功，但加入遊戲失敗。";
               }
               else
               {
                  if(MsgHead.Result == -10021)
                  {
                     ServerMsg.MsgForserver(MsgHead.Result);
                     return;
                  }
                  if(MsgHead.Result == 1)
                  {
                     this.gameFaultObj.result = 1;
                  }
               }
               GV.GameSocket.dispatchEvent(new EventTaomee(VAILDATE_FAIL,this.gameFaultObj));
            }
         }
      }
      
      public function acceptData() : void
      {
         var i:int = 0;
         var count:int = 0;
         var enterPlayerGameRes:EnterPlayerGameRes = null;
         var newUserEnterGameRes:NewUserEnterGameRes = null;
         var gameSocreRes:GameSocreRes = null;
         var noticeGameStartRes:NoticeGameStartRes = null;
         var noticeGameOverRes:NoticeGameOverRes = null;
         var gameLogicRes:GameLogicRes = null;
         var allMapEndRes:AllMapEndRes = null;
         var noticeClientStartGameObj:Object = null;
         var clientGameActionObj:Object = null;
         var playerReqEqualRes:PlayerReqEqualRes = null;
         var noticePlayerFailRes:NoticePlayerFailRes = null;
         var fiveChessRes:FiveChessRes = null;
         var fiveChessActionRes:FiveChessActionRes = null;
         var fiveChessSuccessRes:FiveChessSuccessRes = null;
         var noticeLookerRes:NoticeLookerRes = null;
         var lookerRes:LookerRes = null;
         var reserveObj:Object = null;
         var refreshObj:Object = null;
         var rarr:Array = null;
         var scoreObj:Object = null;
         var itemsObj:Object = null;
         var itemarr:Array = null;
         var count1:int = 0;
         var personObj:Object = null;
         var personArr:Array = null;
         var count2:int = 0;
         var layoutObj:Object = null;
         var layoutArray:Array = null;
         var resultCatObj:Object = null;
         var monoarr:Array = null;
         var count3:int = 0;
         var selectObj:Object = null;
         var pointObj:Object = null;
         var itarr:Array = null;
         var startObj:Object = null;
         var cardObj:Object = null;
         var tmpobj:Object = null;
         var tmpuid:int = 0;
         var tmparr:Array = null;
         var tmpcid:int = 0;
         var tmpcount:int = 0;
         var stateObj:Object = null;
         var positionObj:Object = null;
         var uidObj:Object = null;
         var positionAndThetaObj:Object = null;
         var j:int = 0;
         var k:int = 0;
         var layoutIndex:uint = 0;
         var l:int = 0;
         switch(MsgHead.Command)
         {
            case CommandID.USERREQ_ENTER_GAME:
               trace("##用戶加入遊戲");
               enterPlayerGameRes = new EnterPlayerGameRes();
               enterPlayerGameRes.enterPlayerGame();
               break;
            case CommandID.NOTICE_USER_NEWUSER_ENTERGAME:
               trace("##通知用戶有新用戶加入遊戲");
               newUserEnterGameRes = new NewUserEnterGameRes();
               newUserEnterGameRes.newUserEnterGame();
               break;
            case CommandID.USERREQ_LEAVEA_GAME:
               trace("##用戶請求離開遊戲" + LocalUserInfo.getUserID());
               this.tempObj = new Object();
               this.tempObj.UserID = this.socket.readUnsignedInt();
               this.tempObj.Reason = this.socket.readUnsignedByte();
               GV.GameSocket.dispatchEvent(new EventTaomee("leavegameser",this.tempObj));
               break;
            case CommandID.USER_GET_GAME_SCORE:
               gameSocreRes = new GameSocreRes();
               gameSocreRes.gameSocre();
               break;
            case CommandID.NOTICE_GAME_START:
               trace("##遊戲開始");
               noticeGameStartRes = new NoticeGameStartRes();
               noticeGameStartRes.noticeGameStart();
               break;
            case CommandID.NOTICE_GAME_OVER:
               trace("##遊戲結束");
               noticeGameOverRes = new NoticeGameOverRes();
               noticeGameOverRes.noticeGameOver();
               break;
            case CommandID.RANDMMAP:
               gameLogicRes = new GameLogicRes();
               gameLogicRes.gameLogic();
               break;
            case CommandID.SENDALLMAP:
               allMapEndRes = new AllMapEndRes();
               allMapEndRes.allMapEnd();
               break;
            case CommandID.FINISHMAP:
               break;
            case CommandID.CLENTBEGINGAME:
               trace("##CommandID.CLENTBEGINGAME",this.socket.bytesAvailable);
               noticeClientStartGameObj = {};
               noticeClientStartGameObj.time1 = this.socket.readUnsignedInt();
               noticeClientStartGameObj.time2 = this.socket.readUnsignedInt();
               GV.GameSocket.dispatchEvent(new EventTaomee("notice_start_game",noticeClientStartGameObj));
               break;
            case CommandID.CLENTACTION:
               clientGameActionObj = new Object();
               clientGameActionObj.UserID = GV.GameSocket.readUnsignedInt();
               clientGameActionObj.x = GV.GameSocket.readUnsignedInt();
               clientGameActionObj.y = GV.GameSocket.readUnsignedInt();
               clientGameActionObj.Action = GV.GameSocket.readUnsignedInt();
               clientGameActionObj.Speed = GV.GameSocket.readUnsignedInt();
               clientGameActionObj.Sec = GV.GameSocket.readUnsignedInt();
               clientGameActionObj.MicroSec = GV.GameSocket.readUnsignedInt();
               GV.GameSocket.dispatchEvent(new EventTaomee("client_game_action",clientGameActionObj));
               break;
            case CommandID.PLAY_FAIL:
               playerReqEqualRes = new PlayerReqEqualRes();
               playerReqEqualRes.playerReqEqual();
               break;
            case CommandID.NOTICE_PLAY_FAIL:
               noticePlayerFailRes = new NoticePlayerFailRes();
               noticePlayerFailRes.noticePlayerFail();
               break;
            case CommandID.FIVECHESS_GAMEBEGIN:
               fiveChessRes = new FiveChessRes();
               fiveChessRes.fiveChess();
               break;
            case CommandID.FIVECHESS_ACTION:
               fiveChessActionRes = new FiveChessActionRes();
               fiveChessActionRes.fiveChessAction();
               break;
            case CommandID.FIVECHESS_SUCCESS:
               fiveChessSuccessRes = new FiveChessSuccessRes();
               fiveChessSuccessRes.fiveChessSuccess(MsgHead.PkgLen);
               break;
            case CommandID.NOTICE_LOOKER:
               noticeLookerRes = new NoticeLookerRes();
               noticeLookerRes.noticeLooker();
               break;
            case CommandID.LOOKER:
               lookerRes = new LookerRes();
               lookerRes.looker();
               break;
            case CommandID.PROTO_SNAKE_RESERVE_NOTIFY:
               reserveObj = new Object();
               reserveObj.uid = GV.GameSocket.readUnsignedInt();
               reserveObj.pos = GV.GameSocket.readUnsignedInt();
               reserveObj.dir = GV.GameSocket.readUnsignedInt();
               GV.GameSocket.dispatchEvent(new EventTaomee("PROTO_SNAKE_RESERVE_NOTIFY",reserveObj));
               break;
            case CommandID.PROTO_SNAKE_FRESHEN_NOTIFY:
               refreshObj = {};
               rarr = [];
               refreshObj.uid = GV.GameSocket.readUnsignedInt();
               count = int(GV.GameSocket.readUnsignedInt());
               for(i = 0; i < count; i++)
               {
                  rarr.push({
                     "pos":GV.GameSocket.readUnsignedInt(),
                     "type":GV.GameSocket.readUnsignedInt(),
                     "flag":GV.GameSocket.readUnsignedInt()
                  });
               }
               refreshObj.arr = rarr;
               GV.GameSocket.dispatchEvent(new EventTaomee("PROTO_SNAKE_FRESHEN_NOTIFY",refreshObj));
               break;
            case CommandID.PROTO_SNAKE_SYNC_STATE:
               scoreObj = {};
               scoreObj.uid = GV.GameSocket.readUnsignedInt();
               scoreObj.value = GV.GameSocket.readUnsignedInt();
               scoreObj.type = GV.GameSocket.readUnsignedInt();
               GV.GameSocket.dispatchEvent(new EventTaomee("PROTO_SNAKE_SYNC_STATE",scoreObj));
               break;
            case CommandID.PROTO_SNAKE_SYNC_BEADS:
               itemsObj = {};
               itemarr = [];
               itemsObj.uid = GV.GameSocket.readUnsignedInt();
               count1 = int(GV.GameSocket.readUnsignedInt());
               for(j = 0; j < count1; j++)
               {
                  itemarr.push({
                     "pos":GV.GameSocket.readUnsignedInt(),
                     "type":GV.GameSocket.readUnsignedInt()
                  });
               }
               itemsObj.arr = itemarr;
               GV.GameSocket.dispatchEvent(new EventTaomee("PROTO_SNAKE_SYNC_BEADS",itemsObj));
               break;
            case CommandID.PROTO_SNAKE_SYNC_PERSON:
               personObj = new Object();
               personArr = [];
               personObj.uid = GV.GameSocket.readUnsignedInt();
               personObj.buff1 = GV.GameSocket.readUnsignedByte();
               personObj.buff2 = GV.GameSocket.readUnsignedByte();
               personObj.buff3 = GV.GameSocket.readUnsignedByte();
               personObj.buff4 = GV.GameSocket.readUnsignedByte();
               personObj.dir = GV.GameSocket.readUnsignedInt();
               count2 = int(GV.GameSocket.readUnsignedInt());
               for(k = 0; k < count2; k++)
               {
                  personArr.push({
                     "pos":GV.GameSocket.readUnsignedInt(),
                     "type":GV.GameSocket.readUnsignedInt()
                  });
               }
               personObj.arr = personArr;
               GV.GameSocket.dispatchEvent(new EventTaomee("PROTO_SNAKE_SYNC_PERSON",personObj));
               break;
            case CommandID.GAME_PROTO_FINDCAT_LAYOUT_NOTI:
               layoutObj = new Object();
               layoutObj.pos = GV.GameSocket.readUnsignedByte();
               layoutObj.userid = GV.GameSocket.readUnsignedInt();
               layoutArray = new Array();
               for(layoutIndex = 0; layoutIndex < 16; layoutIndex++)
               {
                  layoutArray.push(GV.GameSocket.readUnsignedByte());
               }
               layoutObj.layout = layoutArray;
               GV.GameSocket.dispatchEvent(new EventTaomee("GAME_PROTO_FINDCAT_LAYOUT_NOTI",layoutObj));
               break;
            case CommandID.GAME_PROTO_FINDCAT_SELECT:
               GV.GameSocket.dispatchEvent(new EventTaomee("GAME_PROTO_FINDCAT_SELECT"));
               break;
            case CommandID.GAME_PROTO_FINDCAT_RESULT_NOTI:
               resultCatObj = new Object();
               resultCatObj.result = GV.GameSocket.readUnsignedInt();
               GV.GameSocket.dispatchEvent(new EventTaomee("GAME_PROTO_FINDCAT_RESULT_NOTI",resultCatObj));
               break;
            case CommandID.PROTO_MONOPOLY_PALYER_SORT:
               monoarr = [];
               count3 = int(GV.GameSocket.readUnsignedInt());
               for(i = 0; i < count3; i++)
               {
                  monoarr.push(GV.GameSocket.readUnsignedInt());
               }
               GV.GameSocket.dispatchEvent(new EventTaomee("PROTO_MONOPOLY_PALYER_SORT",monoarr));
               break;
            case CommandID.PROTO_MONOPOLY_SELECT_START_CMD:
               selectObj = new Object();
               selectObj.point = GV.GameSocket.readUnsignedByte();
               selectObj.uid = GV.GameSocket.readUnsignedInt();
               GV.GameSocket.dispatchEvent(new EventTaomee("PROTO_MONOPOLY_SELECT_START_CMD",selectObj));
               break;
            case CommandID.PROTO_MONOPOLY_START_THROW_CMD:
               pointObj = new Object();
               itarr = [];
               pointObj.uid = GV.GameSocket.readUnsignedInt();
               pointObj.status = GV.GameSocket.readUnsignedByte();
               pointObj.p = GV.GameSocket.readUnsignedByte();
               count = int(GV.GameSocket.readUnsignedByte());
               pointObj.point = [];
               for(i = 0; i < count; i++)
               {
                  pointObj.point.push(GV.GameSocket.readUnsignedByte());
               }
               pointObj.cardid = GV.GameSocket.readUnsignedByte();
               pointObj.curpos = GV.GameSocket.readUnsignedByte();
               GV.GameSocket.dispatchEvent(new EventTaomee("PROTO_MONOPOLY_START_THROW_CMD",pointObj));
               break;
            case CommandID.PROTO_MONOPOLY_START_CMD:
               startObj = new Object();
               startObj.id = GV.GameSocket.readUnsignedInt();
               GV.GameSocket.dispatchEvent(new EventTaomee("PROTO_MONOPOLY_START_CMD",startObj));
               break;
            case CommandID.PROTO_MONOPOLY_USE_ANGEL_GHOST_CARD_CMD:
               cardObj = new Object();
               cardObj.uid = GV.GameSocket.readUnsignedInt();
               cardObj.cid = GV.GameSocket.readUnsignedByte();
               cardObj.sid = GV.GameSocket.readUnsignedInt();
               cardObj.step = new Dictionary();
               tmparr = [];
               tmpcount = int(GV.GameSocket.readUnsignedByte());
               for(i = 0; i < tmpcount; i++)
               {
                  tmpobj = new Object();
                  tmpobj.point = [];
                  tmpuid = int(GV.GameSocket.readUnsignedInt());
                  count = int(GV.GameSocket.readUnsignedByte());
                  for(l = 0; l < count; l++)
                  {
                     tmpobj.point.push(GV.GameSocket.readUnsignedByte());
                  }
                  tmpobj.cardid = GV.GameSocket.readUnsignedByte();
                  cardObj.step[tmpuid] = tmpobj;
               }
               GV.GameSocket.dispatchEvent(new EventTaomee("PROTO_MONOPOLY_USE_ANGEL_GHOST_CARD_CMD",cardObj));
               break;
            case CommandID.PROTO_MONOPOLY_SYS_STATE:
               stateObj = new Object();
               stateObj.value = GV.GameSocket.readUnsignedInt();
               stateObj.uid = GV.GameSocket.readUnsignedInt();
               GV.GameSocket.dispatchEvent(new EventTaomee("PROTO_MONOPOLY_SYS_STATE",stateObj));
               break;
            case CommandID.PROTO_MAGIC_BALL_PLAYER_POSITION:
               positionObj = new Object();
               positionObj.posX = GV.GameSocket.readUnsignedInt();
               positionObj.posY = GV.GameSocket.readUnsignedInt();
               if(!positionObj.posX && !positionObj.posY)
               {
                  break;
               }
               GV.GameSocket.dispatchEvent(new EventTaomee("PROTO_MAGIC_BALL_PLAYER_POSITION",positionObj));
               break;
            case CommandID.PROTO_MAGIC_BALL_SCORE:
               uidObj = new Object();
               uidObj.uid = GV.GameSocket.readUnsignedInt();
               GV.GameSocket.dispatchEvent(new EventTaomee("PROTO_MAGIC_BALL_SCORE",uidObj));
               break;
            case CommandID.PROTO_MAGIC_BALL_POSITON_AND_THETA:
               positionAndThetaObj = new Object();
               positionAndThetaObj.uid = GV.GameSocket.readUnsignedInt();
               positionAndThetaObj.posX = GV.GameSocket.readUnsignedInt();
               positionAndThetaObj.posY = GV.GameSocket.readUnsignedInt();
               positionAndThetaObj.angle = GV.GameSocket.readInt();
               GV.GameSocket.dispatchEvent(new EventTaomee("PROTO_MAGIC_BALL_POSITON_AND_THETA",positionAndThetaObj));
         }
      }
   }
}

