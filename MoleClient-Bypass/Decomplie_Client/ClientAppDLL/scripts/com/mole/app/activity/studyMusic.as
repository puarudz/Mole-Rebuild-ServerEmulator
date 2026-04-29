package com.mole.app.activity
{
   import com.common.Alert.Alert;
   import com.common.util.MovieClipUtil;
   import com.core.info.LocalUserInfo;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.socket.throwItem.ThrowItemReq;
   import com.module.LocusWork.NumSprite;
   import com.module.activityModule.Presented;
   import com.mole.app.manager.QueryItemCntManager;
   import com.mole.app.manager.SceneActivityManager;
   import com.mole.app.utils.Tool;
   import com.view.MapManageView.MapManageView;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import org.taomee.net.SocketEvent;
   
   public class studyMusic
   {
      
      private static var _inself:studyMusic;
      
      private var _npc_mc:MovieClip;
      
      private var _mole_mc:MovieClip;
      
      private var sceneActivityManager:SceneActivityManager;
      
      private var _text:TextField;
      
      private var _isHit:Boolean;
      
      private var throwItemReq:ThrowItemReq;
      
      private var _timer:Timer = new Timer(1000);
      
      private var _time:uint = 0;
      
      private var _pos:uint;
      
      private var _flowerNum:uint;
      
      private var _userID:uint;
      
      private var _goodsIDArr:Array = new Array(2313,2312,2314);
      
      private var _hundredIDArr:Array = new Array(2316,2315,2317);
      
      private var _throwIDArr:Array = new Array(2319,2318,2320);
      
      private var _itemIDArr:Array = new Array(1351512,1351511,1351513);
      
      private var _item2IDArr:Array = new Array(31512,31511,31513);
      
      private var _item3IDArr:Array = new Array(31515,31514,31516);
      
      private var _oneItem:QueryItemCntManager;
      
      private var _numSpr:NumSprite;
      
      private var _numMC:MovieClip;
      
      public function studyMusic()
      {
         super();
         this.sceneActivityManager = new SceneActivityManager();
         this.throwItemReq = new ThrowItemReq();
         this._oneItem = new QueryItemCntManager();
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimesHandle);
      }
      
      public static function get init() : studyMusic
      {
         if(_inself == null)
         {
            _inself = new studyMusic();
         }
         return _inself;
      }
      
      public function begin(npc:MovieClip, mole:MovieClip, pos:uint) : void
      {
         this._npc_mc = npc;
         this._mole_mc = mole;
         this._pos = pos;
         this._npc_mc.gotoAndStop(1);
         this._numMC = this._mole_mc["num_mc"];
         this._mole_mc.gotoAndStop(1);
         GV.onlineSocket.addCmdListener(CommandID.SEAT_MUSIC,this.sceneBroadcast);
         GV.onlineSocket.addCmdListener(CommandID.REFER_SEAT_MUSIC,this.seatInfoHandle);
         GV.onlineSocket.addCmdListener(CommandID.SHOW__MUSIC,this.isSucceed);
         MapManageView.inst.addEventListener(Event.INIT,this.initHandle);
         this._mole_mc.addEventListener(MouseEvent.ROLL_OUT,this.onOutHit);
         this._mole_mc.addEventListener(MouseEvent.ROLL_OVER,this.onOverHit);
      }
      
      public function send(flag:uint, pos:uint) : void
      {
         if(this._userID == 0)
         {
            GF.sendSocket(CommandID.SEAT_MUSIC,flag,pos);
         }
      }
      
      public function sendReferInfo(pos:uint) : void
      {
         GF.sendSocket(CommandID.REFER_SEAT_MUSIC,pos);
      }
      
      private function initHandle(e:Event) : void
      {
         MapManageView.inst.removeEventListener(Event.INIT,this.initHandle);
         LevelManager.stage.addEventListener(MouseEvent.CLICK,this.onClickTarget);
         this.sendReferInfo(this._pos);
      }
      
      private function onOverHit(e:MouseEvent) : void
      {
         this._isHit = true;
      }
      
      private function onOutHit(e:MouseEvent) : void
      {
         this._isHit = false;
      }
      
      private function onClickTarget(e:Event) : void
      {
         if(this._isHit)
         {
            this.throwItemReq.throwItem(150018,LevelManager.stage.mouseX,LevelManager.stage.mouseY);
            GV.onlineSocket.addEventListener(Presented.EXCHANGE_COMPLETE,this.checkExchangeItem);
            Tool.finishSomething(this._item3IDArr[this._pos],this.throwFlower);
         }
      }
      
      private function throwFlower(count:uint) : void
      {
         var arr:Array = new Array("今日投鮮花獲得的吉他樂感度已滿，請明天再為其他小摩爾喝彩吧！","今日投鮮花獲得的架子鼓樂感度已滿，請明天再為其他小摩爾喝彩吧！","今日投鮮花獲得的電子琴樂感度已滿，請明天再為其他小摩爾喝彩吧！");
         if(count < 10)
         {
            Presented.getInstance().celebrate1225(this._throwIDArr[this._pos],1);
         }
         else
         {
            Alert.smileAlart(arr[this._pos]);
         }
      }
      
      private function seatInfoHandle(e:SocketEvent) : void
      {
         var recData:ByteArray = e.data as ByteArray;
         var id:uint = recData.readUnsignedInt();
         this._flowerNum = recData.readUnsignedInt();
         this._time = recData.readUnsignedInt();
         if(id == 0)
         {
            return;
         }
         this._userID = id;
         if(this._time < 30 && this._time > 0)
         {
            this.playMusicMovie(this._time,id);
         }
         else
         {
            trace("後台返回時間有誤");
         }
      }
      
      private function isSucceed(e:SocketEvent) : void
      {
         var recData:ByteArray = e.data as ByteArray;
         var userID:uint = recData.readUnsignedInt();
         var pos:uint = recData.readUnsignedInt();
         var flag:uint = recData.readUnsignedInt();
         this.gameOver(userID,flag);
      }
      
      private function gameOver(userID:uint, isSuc:uint) : void
      {
         var mc:MovieClip = null;
         var moleMc:PeopleManageView = null;
         var num:uint = 0;
         moleMc = GF.getPeopleByID(userID) as PeopleManageView;
         num = 5;
         if(Boolean(isSuc))
         {
            this._mole_mc.gotoAndStop(2);
            this._npc_mc.gotoAndStop(3);
            MovieClipUtil.playAppointFrameAndFunc(this._mole_mc,2,function():void
            {
               mc = _mole_mc["mc_2"];
               MovieClipUtil.playEndAndFunc(mc,function():void
               {
                  _mole_mc.visible = false;
                  _mole_mc.gotoAndStop(1);
                  _npc_mc.gotoAndStop(1);
                  moleMc.visible = true;
                  num = 5;
                  if(LocalUserInfo.getUserID() == userID)
                  {
                     if(_flowerNum < 5)
                     {
                        num = 10;
                     }
                     else
                     {
                        num = 15;
                     }
                     setMoleToPos(userID,new Point(470,280));
                     GF.sendSocket(CommandID.SEAT_MUSIC,0,_pos);
                     GV.onlineSocket.addEventListener(Presented.EXCHANGE_COMPLETE,checkExchangeItem);
                     Presented.getInstance().celebrate1225(_goodsIDArr[_pos],num);
                  }
               });
            });
         }
         else
         {
            this._mole_mc.gotoAndStop(3);
            this._npc_mc.gotoAndStop(4);
            MovieClipUtil.playAppointFrameAndFunc(this._mole_mc,3,function():void
            {
               mc = _mole_mc["mc_3"];
               MovieClipUtil.playEndAndFunc(mc,function():void
               {
                  _mole_mc.visible = false;
                  _mole_mc.gotoAndStop(1);
                  _npc_mc.gotoAndStop(1);
                  moleMc.visible = true;
                  if(LocalUserInfo.getUserID() == userID)
                  {
                     GF.sendSocket(CommandID.SEAT_MUSIC,0,_pos);
                     setMoleToPos(userID,new Point(470,280));
                     GV.onlineSocket.addEventListener(Presented.EXCHANGE_COMPLETE,checkExchangeItem);
                     Presented.getInstance().celebrate1225(_goodsIDArr[_pos],num);
                  }
               });
            });
         }
         if(LocalUserInfo.getUserID() == userID)
         {
         }
      }
      
      private function checkExchangeItem(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(Presented.EXCHANGE_COMPLETE,this.checkExchangeItem);
         this._oneItem.addEventListener(QueryItemCntManager.ONEITEM_QUERY,this.oneItemQuery);
         this._oneItem.oneItemQuery(this._itemIDArr[this._pos]);
      }
      
      private function oneItemQuery(e:EventTaomee) : void
      {
         this._oneItem.removeEventListener(QueryItemCntManager.ONEITEM_QUERY,this.oneItemQuery);
         var oneItemNum:uint = e.EventObj as uint;
         if(oneItemNum > 99)
         {
            Tool.finishSomething(this._item2IDArr[this._pos],this.getStar);
         }
      }
      
      private function getStar(count:uint) : void
      {
         if(count == 0)
         {
            Presented.getInstance().celebrate1225(this._hundredIDArr[this._pos],5);
         }
      }
      
      private function onTimesHandle(e:TimerEvent) : void
      {
         var ran:Boolean = false;
         var isSuc:uint = 0;
         ++this._time;
         if(this._time >= 30)
         {
            this._time = 0;
            this._timer.stop();
            if(LocalUserInfo.getUserID() == this._userID)
            {
               ran = Math.random() > 0.5 ? true : false;
               if(this._flowerNum < 5 && ran)
               {
                  isSuc = 0;
               }
               else
               {
                  isSuc = 1;
               }
               GF.sendSocket(CommandID.SHOW__MUSIC,isSuc);
            }
         }
      }
      
      private function sceneBroadcast(evt:SocketEvent) : void
      {
         var flag:uint = 0;
         var recData:ByteArray = evt.data as ByteArray;
         var userID:uint = recData.readUnsignedInt();
         flag = recData.readUnsignedInt();
         var pos:uint = recData.readUnsignedInt();
         var moleMc:PeopleManageView = GF.getPeopleByID(userID) as PeopleManageView;
         if(moleMc == null)
         {
            return;
         }
         this._userID = userID;
         moleMc.visible = false;
         if(Boolean(flag))
         {
            this._flowerNum = 0;
            this.playMusicMovie(1,userID);
         }
         else
         {
            moleMc.visible = true;
            MoveTo.CanMove = true;
            this._mole_mc.visible = false;
            this._mole_mc.gotoAndStop(1);
            this._npc_mc.gotoAndStop(1);
            this._userID = 0;
         }
         if(LocalUserInfo.getUserID() == userID)
         {
            this._mole_mc.mouseChildren = this._mole_mc.mouseEnabled = false;
         }
         else
         {
            this._mole_mc.mouseChildren = this._mole_mc.mouseEnabled = true;
         }
      }
      
      private function playMusicMovie(time:uint, userID:uint) : void
      {
         var frame:uint = 0;
         var moleMc:PeopleManageView = GF.getPeopleByID(userID) as PeopleManageView;
         moleMc.visible = false;
         this._mole_mc.visible = true;
         this._mole_mc.gotoAndStop(1);
         (this._mole_mc["mc_1"] as MovieClip).mouseEnabled = false;
         this._npc_mc.gotoAndStop(2);
         frame = this._time * 24;
         this._mole_mc["time_mc"].gotoAndPlay(frame);
         this._numMC.num0.gotoAndStop(int(this._flowerNum % 1000 / 100) + 1);
         this._numMC.num1.gotoAndStop(int(this._flowerNum % 100 / 10) + 1);
         this._numMC.num2.gotoAndStop(int(this._flowerNum % 10 / 1) + 1);
         this._timer.stop();
         this._timer.start();
      }
      
      private function setMoleToPos(userId:uint, pos:Point, isMove:Boolean = false) : void
      {
         var moleMc:PeopleManageView = GF.getPeopleByID(userId) as PeopleManageView;
         if(Boolean(moleMc))
         {
            MoveTo.CanMove = true;
            moleMc.visible = true;
            moleMc.moveTo(pos.x,pos.y);
         }
      }
      
      public function destroy() : void
      {
         this._timer.stop();
         MapManageView.inst.removeEventListener(Event.INIT,this.initHandle);
         GV.onlineSocket.removeCmdListener(CommandID.SEAT_MUSIC,this.sceneBroadcast);
         GV.onlineSocket.removeCmdListener(CommandID.REFER_SEAT_MUSIC,this.seatInfoHandle);
         this._oneItem.removeEventListener(QueryItemCntManager.ONEITEM_QUERY,this.oneItemQuery);
         GV.onlineSocket.removeEventListener(Presented.EXCHANGE_COMPLETE,this.checkExchangeItem);
         GV.onlineSocket.removeCmdListener(CommandID.SHOW__MUSIC,this.isSucceed);
         this._userID = 0;
         this._numSpr = null;
      }
   }
}

