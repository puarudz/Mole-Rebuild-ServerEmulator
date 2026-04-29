package com.view.mapView.activity.map066
{
   import com.common.Alert.Alert;
   import com.core.info.LocalUserInfo;
   import com.core.manager.LevelManager;
   import com.core.manager.UIManager;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.mapEvent.MapEvent;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.PeopleManager;
   import com.mole.app.manager.SystemEventManager;
   import com.view.MapManageView.MapManageView;
   import com.view.PeopleView.ChildPeople.simplePeople;
   import com.view.PeopleView.PeopleManageView;
   import com.view.player.PlayerActionConstant;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class LionDanceActivity extends EventDispatcher
   {
      
      private static var _inst:LionDanceActivity;
      
      private const _seatLeavePosiList:Array = [["520","340"],["450","400"],["540","330"],["610","400"]];
      
      private const _seatOnPosiList:Array = [["456","300"],["375","380"],["600","300"],["690","380"]];
      
      private const _iconPosiList:Array = [["456","220"],["375","300"],["600","220"],["690","300"]];
      
      private var _selfView:PeopleManageView;
      
      private var _seatStatusList:Array;
      
      private var _icon:MovieClip;
      
      private var _userArr:Array;
      
      private var _currentIndex:int = -1;
      
      private var _bg:Sprite;
      
      public function LionDanceActivity()
      {
         super();
      }
      
      private static function get inst() : LionDanceActivity
      {
         if(_inst == null)
         {
            _inst = new LionDanceActivity();
         }
         return _inst;
      }
      
      public static function init() : void
      {
         inst.init();
      }
      
      private function init() : void
      {
         this.addEvents();
      }
      
      private function addEvents() : void
      {
         BC.addEvent(this,GV.onlineSocket,MapEvent.CHANGE_MAP_COMPLETE,this.onEnterMap);
      }
      
      private function onEnterMap(e:EventTaomee) : void
      {
         BC.addEvent(this,GV.onlineSocket,MapEvent.READY_CHANGE_MAP,this.onLeaveMap);
         GV.onlineSocket.addCmdListener(CommandID.LION_DANCE_INTO_MAP,this.onBroadCast);
         GF.sendSocket(CommandID.LION_DANCE_INTO_MAP,66);
         SystemEventManager.addEventListener("joinLionDanceGame",this.onJoinGame);
         this._selfView = PeopleManager.getPeopleView(LocalUserInfo.getUserID());
      }
      
      private function onBroadCast(e:SocketEvent) : void
      {
         var statusObj:Object = null;
         var personList:Array = null;
         var userId:uint = 0;
         var playGame:Boolean = false;
         var tempUserId:uint = 0;
         var hasPerson:Boolean = false;
         var tempUserArr:Array = null;
         var recData:ByteArray = e.data as ByteArray;
         var len:uint = 4;
         if(Boolean(this._seatStatusList))
         {
            tempUserArr = this._seatStatusList.concat();
         }
         this._seatStatusList = [];
         playGame = false;
         statusObj = {};
         statusObj.status = recData.readUnsignedInt();
         statusObj.flag = recData.readUnsignedInt();
         personList = [];
         hasPerson = false;
         for(var j:uint = 0; j < len; j++)
         {
            userId = recData.readUnsignedInt();
            personList.push(userId);
            this.clearSeatStatus(j);
            if(userId == LocalUserInfo.getUserID())
            {
               this._currentIndex = j;
               playGame = true;
            }
            if(userId != 0)
            {
               hasPerson = true;
               this.showSeatStatus(j,statusObj.status);
            }
            if(Boolean(tempUserArr))
            {
               tempUserId = uint((tempUserArr[0] as Object).personList[j]);
            }
            if(Boolean(tempUserArr) && Boolean(tempUserId == LocalUserInfo.getUserID()) && userId != LocalUserInfo.getUserID())
            {
               this.leaveSeat(j);
            }
         }
         statusObj.personList = personList;
         this._seatStatusList.push(statusObj);
         if(playGame && statusObj.status == 1)
         {
            this.beginGame();
         }
      }
      
      private function onJoinGame(evt:SystemEvent) : void
      {
         var seatList:Array = (evt.data as String).split(",");
         if(this._currentIndex > -1)
         {
            return;
         }
         this.seat(1,seatList[0],seatList[1]);
         this._currentIndex = uint(seatList[0]) * 2 + uint(seatList[1]);
      }
      
      private function seat(action:uint, group:uint, index:uint) : void
      {
         GV.onlineSocket.addCmdListener(CommandID.LION_DANCE_HANDLE_SEAT,this.onOperationSeat);
         GF.sendSocket(CommandID.LION_DANCE_HANDLE_SEAT,0,group,index,action);
      }
      
      private function onOperationSeat(evt:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.LION_DANCE_HANDLE_SEAT,this.onOperationSeat);
         var recData:ByteArray = evt.data as ByteArray;
         var id:uint = recData.readUnsignedInt();
         var flag:uint = recData.readUnsignedInt();
         var status:uint = recData.readUnsignedInt();
         if(status == 0)
         {
            Alert.angryAlart("\t當前位置已有摩爾了，請選擇別的位置吧！");
            if(this._currentIndex > -1)
            {
               this.leaveSeatHandler(this._currentIndex);
            }
         }
         else if(status == 1)
         {
            if(flag != 0)
            {
               if(flag == 1)
               {
                  this.onSeat(this._currentIndex);
               }
            }
         }
         else if(status == 2)
         {
            Alert.angryAlart("\t所站位置不對。");
            if(this._currentIndex > -1)
            {
               this.leaveSeatHandler(this._currentIndex);
            }
         }
         else if(status == 3)
         {
            Alert.angryAlart("\t遊戲正在進行中!");
            if(this._currentIndex > -1)
            {
               this.leaveSeatHandler(this._currentIndex);
            }
         }
      }
      
      private function onLeaveSeat(e:Event) : void
      {
         Alert.showChooseAlart("遊戲正在等待中，確定退出遊戲嗎？",this.sureLeaveSeat);
      }
      
      private function sureLeaveSeat() : void
      {
         this.seat(0,Math.floor(this._currentIndex / 2),this._currentIndex % 2);
      }
      
      private function showSeatStatus(seatIndex:uint, status:uint) : void
      {
         this.clearSeatStatus(seatIndex);
         if(status == 0)
         {
            this._icon = UIManager.getMovieClip("UI_Waitting_Double_Game");
            this._icon.name = "waittingIcon" + seatIndex;
         }
         else
         {
            this._icon = UIManager.getMovieClip("UI_In_Double_Game");
            this._icon.name = "inGameIcon" + seatIndex;
         }
         MapManageView.inst.mapLevel.controlLevel.addChild(this._icon);
         this._icon.x = this._iconPosiList[seatIndex][0];
         this._icon.y = this._iconPosiList[seatIndex][1];
      }
      
      private function clearSeatStatus(seatIndex:uint) : void
      {
         var icon:MovieClip = null;
         icon = MapManageView.inst.mapLevel.controlLevel.getChildByName("waittingIcon" + seatIndex) as MovieClip;
         if(Boolean(icon))
         {
            MapManageView.inst.mapLevel.controlLevel.removeChild(icon);
         }
         icon = MapManageView.inst.mapLevel.controlLevel.getChildByName("inGameIcon" + seatIndex) as MovieClip;
         if(Boolean(icon))
         {
            MapManageView.inst.mapLevel.controlLevel.removeChild(icon);
         }
      }
      
      private function onSeat(index:uint) : void
      {
         MoveTo.CanMove = false;
         this.setMoleToPos(this._seatOnPosiList[index][0],this._seatOnPosiList[index][1]);
         simplePeople(this._selfView.avatarClass).DelRotation();
         if(this._bg == null)
         {
            this._bg = LevelManager.drawBG(0,0);
         }
         LevelManager.mapLevel.addChild(this._bg);
         this._bg.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
      }
      
      private function onMouseDownHandler(evt:MouseEvent) : void
      {
         this.onLeaveSeat(null);
      }
      
      private function leaveSeat(index:uint) : void
      {
         this._bg.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
         DisplayUtil.removeFromParent(this._bg);
         MoveTo.CanMove = true;
         simplePeople(this._selfView.avatarClass).addRotation();
         this.clearSeatStatus(index);
         this.leaveSeatHandler(index);
      }
      
      private function leaveSeatHandler(index:uint) : void
      {
         this.moleMoveTo(this._seatLeavePosiList[index][0],this._seatLeavePosiList[index][1]);
         this._currentIndex = -1;
      }
      
      private function beginGame() : void
      {
         MoveTo.CanMove = false;
         LevelManager.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
         ModuleManager.openPanel("LionDancePanel",this._seatStatusList[0].personList);
      }
      
      private function getFlipDataBack(evt:SocketEvent) : void
      {
      }
      
      private function setMoleToPos(x:uint, y:uint) : void
      {
         if(Boolean(this._selfView))
         {
            this._selfView.avatarClass.showActionWithId(PlayerActionConstant.ACTION_STAND,0);
            this._selfView.x = x;
            this._selfView.y = y;
         }
      }
      
      private function moleMoveTo(x:uint, y:uint) : void
      {
         PeopleManageView(GV.MAN_PEOPLE).moveTo(x,y);
      }
      
      private function onLeaveMap(e:EventTaomee) : void
      {
         this.destroy();
      }
      
      private function destroy() : void
      {
         BC.removeEvent(this);
         GV.onlineSocket.removeCmdListener(CommandID.LION_DANCE_INTO_MAP,this.onBroadCast);
         GV.onlineSocket.removeCmdListener(CommandID.LION_DANCE_HANDLE_SEAT,this.onOperationSeat);
         if(Boolean(this._bg))
         {
            this._bg.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
            DisplayUtil.removeFromParent(this._bg);
         }
         SystemEventManager.removeEventListener("joinLionDanceGame",this.onJoinGame);
      }
   }
}

