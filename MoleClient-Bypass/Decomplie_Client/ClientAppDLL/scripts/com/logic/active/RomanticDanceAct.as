package com.logic.active
{
   import com.common.Alert.Alert;
   import com.common.util.DisplayUtil;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.manager.LevelManager;
   import com.mole.app.event.PeopleEvent;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.NewStatisticsManager;
   import com.mole.app.manager.PeopleManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.module.AppModuleControl;
   import com.mole.app.module.ModuleEvent;
   import com.mole.app.utils.PlayMovie;
   import com.view.MapManageView.MapManageView;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   
   public class RomanticDanceAct
   {
      
      private static var _inst:RomanticDanceAct;
      
      private const SEXMALE:uint = 1;
      
      private const SEXFEMALE:uint = 2;
      
      private var _wiatVec:Vector.<MovieClip>;
      
      private var _isSelf:Boolean;
      
      private var _playVec:Vector.<uint>;
      
      private var _sexVec:Vector.<uint>;
      
      private var _curSeat:int = -1;
      
      private var _groupID:uint;
      
      private var s:Sprite;
      
      private var selectSex:uint;
      
      private var appModule:AppModuleControl;
      
      private var joinModule:AppModuleControl;
      
      private var _peopleVec:Vector.<MovieClip>;
      
      private var _gamePlayer:*;
      
      public function RomanticDanceAct()
      {
         super();
      }
      
      public static function get inst() : RomanticDanceAct
      {
         if(_inst == null)
         {
            _inst = new RomanticDanceAct();
         }
         return _inst;
      }
      
      public function setUp() : void
      {
         MapManageView.inst.addEventListener(Event.INIT,this.initHandle);
      }
      
      private function initHandle(e:Event) : void
      {
         MapManageView.inst.removeEventListener(Event.INIT,this.initHandle);
         this.initUI();
         this.addEvents();
      }
      
      private function initUI() : void
      {
         var wait:MovieClip = null;
         this._gamePlayer = PeopleManager.getPeopleView(LocalUserInfo.getUserID());
         this._wiatVec = new Vector.<MovieClip>();
         for(var i:uint = 0; i < 6; i++)
         {
            wait = MapManageView.inst.mapLevel.controlLevel["wait" + i];
            wait.visible = false;
            this._wiatVec.push(wait);
         }
         this._playVec = new Vector.<uint>(6,true);
         this._sexVec = new Vector.<uint>(6,true);
         this._peopleVec = new Vector.<MovieClip>();
         for(var j:uint = 0; MapManageView.inst.mapLevel.controlLevel["people" + j] != null; j++)
         {
            this._peopleVec.push(MapManageView.inst.mapLevel.controlLevel["people" + j]);
            MapManageView.inst.mapLevel.controlLevel["people" + j].visible = false;
         }
      }
      
      private function addEvents() : void
      {
         SystemEventManager.addEventListener("seat",this.onEnterSeat);
         GV.onlineSocket.addCmdListener(9263,this.enterLeaveHandle);
         GV.onlineSocket.addEventListener("SocketEvent_error" + 9263,this.buyErrorHandler);
         GV.onlineSocket.addCmdListener(9264,this.playerInfoHandle);
         GF.sendSocket(9264);
         GV.onlineSocket.addCmdListener(9265,this.fullBroadCastHandle);
      }
      
      private function buyErrorHandler(e:*) : void
      {
         if(e.cmdID == 9263)
         {
            Alert.angryAlart("  選擇衣服性別相同，無法進行遊戲!");
            PeopleManager.getPeopleView(LocalUserInfo.getUserID()).moveTo(501,486);
         }
      }
      
      private function fullBroadCastHandle(e:*) : void
      {
         var steaID:uint;
         var people:PeopleManageView = null;
         var wait:MovieClip = null;
         var obj:Object = null;
         var movie:PlayMovie = null;
         var data:ByteArray = e.data as ByteArray;
         this._groupID = data.readUnsignedInt();
         GV.onlineSocket.removeEventListener(PeopleEvent.READY_MOVE,this.onLeaveSeat);
         trace("廣播的時候的位置上的用戶id" + this._playVec);
         steaID = data.readUnsignedInt();
         for each(wait in this._wiatVec)
         {
            wait.visible = false;
         }
         if(steaID == 0)
         {
            this._peopleVec[0].visible = false;
            this._peopleVec[1].visible = false;
         }
         else if(steaID == 2)
         {
            this._peopleVec[2].visible = false;
            this._peopleVec[3].visible = false;
         }
         else if(steaID == 4)
         {
            this._peopleVec[4].visible = false;
            this._peopleVec[5].visible = false;
         }
         if(this._isSelf)
         {
            people = PeopleManager.getPeopleView(LocalUserInfo.getUserID());
            people.moveTo(501,486);
            obj = new Object();
            obj.groupID = this._groupID;
            obj.seatID = this._curSeat;
            obj.playVec = this._playVec;
            this.removeBgEvents();
            this.removeBg();
            movie = PlayMovie.play("resource/map/activity/cartoon/readyDo.swf",null,null,function():void
            {
               movie.destroy();
               appModule = ModuleManager.openPanel("SixYearsDanceGamePanel",obj);
               appModule.addEventListener(ModuleEvent.DESTROY,moduleDestroyHandle);
               _isSelf = false;
               for(var i:* = 0; i < _playVec.length; i++)
               {
                  if(_playVec[i] != 0)
                  {
                     people = PeopleManager.getPeopleView(_playVec[i]);
                     people.visible = true;
                     people.moveTo(501,486);
                     _peopleVec[i].visible = false;
                  }
               }
            });
         }
      }
      
      private function moduleDestroyHandle(e:ModuleEvent) : void
      {
         for(var i:uint = 0; i < this._playVec.length; i++)
         {
            if(this._playVec[i] != 0)
            {
               this._playVec[i] = 0;
               this._sexVec[i] = 0;
            }
         }
      }
      
      private function playerInfoHandle(e:*) : void
      {
         var mimiID:uint = 0;
         var data:ByteArray = e.data as ByteArray;
         data.position = 0;
         var cnt:uint = data.readUnsignedInt();
         for(var i:uint = 0; i < cnt; i++)
         {
            mimiID = data.readUnsignedInt();
            this._playVec[i] = mimiID;
            this._sexVec[i] = data.readUnsignedInt();
            if(mimiID != 0)
            {
               this._wiatVec[i].visible = true;
               this._peopleVec[i].visible = true;
               this._peopleVec[i].gotoAndStop(this._sexVec[i]);
               PeopleManager.getPeopleView(mimiID).visible = false;
            }
         }
      }
      
      private function enterLeaveHandle(e:*) : void
      {
         var data:ByteArray = e.data as ByteArray;
         if(!data)
         {
            return;
         }
         data.position = 0;
         var userID:uint = data.readUnsignedInt();
         var tarSex:uint = data.readUnsignedInt();
         var flag:uint = data.readUnsignedInt();
         var pos:uint = data.readUnsignedInt();
         if(flag == 1)
         {
            this._playVec[pos] = userID;
            this._wiatVec[pos].visible = true;
            this._peopleVec[pos].visible = true;
            this._peopleVec[pos].gotoAndStop(tarSex);
            PeopleManager.getPeopleView(userID).visible = false;
            if(userID == LocalUserInfo.getUserID())
            {
               this._isSelf = true;
               this.s = this.addBg();
               this.s.buttonMode = true;
               BC.addEvent(this,this.s,MouseEvent.CLICK,this.leaveParty);
            }
         }
         else if(flag == 0)
         {
            if(userID == LocalUserInfo.getUserID())
            {
               this._isSelf = false;
               this._gamePlayer.visible = true;
            }
            this._playVec[pos] = 0;
            this._wiatVec[pos].visible = false;
            this._peopleVec[pos].visible = false;
            PeopleManager.getPeopleView(userID).visible = true;
         }
      }
      
      private function onEnterSeat(e:SystemEvent) : void
      {
         NewStatisticsManager.send(86);
         this._curSeat = int(e.data);
         trace("收到了坐到位置上的事件");
         if(this._wiatVec[this._curSeat].visible == false)
         {
            this.joinModule = ModuleManager.openPanel("SixYearsDanceJoinPanel");
            this.joinModule.addEventListener(ModuleEvent.DESTROY,this.sexJoinHandle);
         }
         else
         {
            Alert.angryAlart("  小摩爾,位置上有人哦,待會再來試試吧!");
            PeopleManager.getPeopleView(LocalUserInfo.getUserID()).moveTo(381,450);
         }
      }
      
      private function sexJoinHandle(e:ModuleEvent) : void
      {
         this.selectSex = uint(e.data);
         if(!this.selectSex)
         {
            return;
         }
         GF.sendSocket(9263,1,this._curSeat,this.selectSex);
      }
      
      private function addBg() : Sprite
      {
         var bg:Sprite = MainManager.getAppLevel().getChildByName("myBG") as Sprite;
         if(bg == null)
         {
            bg = LevelManager.drawBG(0,0);
            bg.name = "myBG";
            MainManager.getAppLevel().addChild(bg);
         }
         return bg;
      }
      
      private function removeBg() : void
      {
         DisplayUtil.removeForParent(this.s);
         var bg:Sprite = MainManager.getAppLevel().getChildByName("myBG") as Sprite;
         DisplayUtil.removeForParent(bg);
      }
      
      private function removeBgEvents() : void
      {
         var bg:Sprite = MainManager.getAppLevel().getChildByName("myBG") as Sprite;
         if(bg != null)
         {
            BC.removeEvent(this,bg,MouseEvent.CLICK,this.leaveParty);
         }
      }
      
      private function leaveParty(e:MouseEvent) : void
      {
         Alert.smileAlart("    小摩爾確定退出遊戲嗎？",this.onClickLeave,"sure,cancel");
      }
      
      protected function onClickLeave(e:*) : void
      {
         var people:* = PeopleManager.getPeopleView(LocalUserInfo.getUserID());
         people.moveTo(501,486);
         this.removeBgEvents();
         this.removeBg();
         GF.sendSocket(9263,0,this._curSeat,this.selectSex);
      }
      
      private function onLeaveSeat(e:*) : void
      {
         GV.onlineSocket.removeEventListener(PeopleEvent.READY_MOVE,this.onLeaveSeat);
         GF.sendSocket(9263,0,this._curSeat,this.selectSex);
      }
      
      public function destroy() : void
      {
         GV.onlineSocket.removeEventListener("SocketEvent_error" + 9263,this.buyErrorHandler);
         MapManageView.inst.removeEventListener(Event.INIT,this.initHandle);
         SystemEventManager.removeEventListener("seat",this.onEnterSeat);
         GV.onlineSocket.removeCmdListener(9263,this.enterLeaveHandle);
         GV.onlineSocket.removeCmdListener(9264,this.playerInfoHandle);
         GV.onlineSocket.removeCmdListener(9265,this.fullBroadCastHandle);
      }
   }
}

