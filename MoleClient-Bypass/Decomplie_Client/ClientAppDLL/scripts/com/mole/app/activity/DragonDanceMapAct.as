package com.mole.app.activity
{
   import com.common.Alert.Alert;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.CSItems.exchange;
   import com.module.activityModule.Presented;
   import com.mole.app.event.PeopleEvent;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.PeopleManager;
   import com.mole.app.manager.QueryItemCntManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.utils.PlayMovie;
   import com.view.MapManageView.MapManageView;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   
   public class DragonDanceMapAct
   {
      
      private static var _inst:DragonDanceMapAct;
      
      private var _curSeat:uint;
      
      private var _playVec:Vector.<uint>;
      
      private var _isSelf:Boolean;
      
      private var _query:QueryItemCntManager;
      
      private var _wiatVec:Vector.<MovieClip>;
      
      public function DragonDanceMapAct()
      {
         super();
      }
      
      public static function getInst() : DragonDanceMapAct
      {
         if(!_inst)
         {
            _inst = new DragonDanceMapAct();
         }
         return _inst;
      }
      
      public function getIn() : void
      {
         var wait:MovieClip = null;
         this._playVec = new Vector.<uint>();
         this._query = new QueryItemCntManager();
         this._wiatVec = new Vector.<MovieClip>();
         for(var i:uint = 1; i < 8; i++)
         {
            wait = MapManageView.inst.mapLevel.controlLevel["wait" + i];
            wait.visible = false;
            this._wiatVec.push(wait);
         }
         SystemEventManager.addEventListener("Seat",this.onEnterSeat);
         GV.onlineSocket.addCmdListener(CommandID.DRAGON_DANCE_ENTER_LEAVE,this.enterLeaveHandle);
         GV.onlineSocket.addCmdListener(CommandID.DRAGON_DANCE_FULL_BROADCAST,this.fullBroadCastHandle);
         GV.onlineSocket.addCmdListener(CommandID.DRAGON_DANCE_PLAYER_INFO,this.playerInfoHandle);
         GF.sendSocket(CommandID.DRAGON_DANCE_PLAYER_INFO);
      }
      
      private function onEnterSeat(e:SystemEvent) : void
      {
         trace("收到了坐到位置上的事件");
         this._curSeat = uint(e.data) - 1;
         if(this._playVec[this._curSeat] == 0)
         {
            GV.onlineSocket.addEventListener(PeopleEvent.READY_MOVE,this.onLeaveSeat);
            GF.sendSocket(CommandID.DRAGON_DANCE_ENTER_LEAVE,1,this._curSeat);
         }
         else
         {
            Alert.angryAlart("  小摩爾,位置上有人哦,待會再來試試吧!");
            PeopleManager.getPeopleView(LocalUserInfo.getUserID()).moveTo(381,521);
         }
      }
      
      private function onLeaveSeat(e:*) : void
      {
         GV.onlineSocket.removeEventListener(PeopleEvent.READY_MOVE,this.onLeaveSeat);
         GF.sendSocket(CommandID.DRAGON_DANCE_ENTER_LEAVE,0,this._curSeat);
      }
      
      private function playerInfoHandle(e:SocketEvent) : void
      {
         var mimiID:uint = 0;
         var data:ByteArray = e.data as ByteArray;
         var cnt:uint = data.readUnsignedInt();
         for(var i:uint = 0; i < cnt; i++)
         {
            mimiID = data.readUnsignedInt();
            this._playVec[i] = mimiID;
            if(mimiID != 0)
            {
               this._wiatVec[i].visible = true;
            }
         }
      }
      
      private function enterLeaveHandle(e:SocketEvent) : void
      {
         var data:ByteArray = e.data as ByteArray;
         data.position = 0;
         var userID:uint = data.readUnsignedInt();
         var flag:uint = data.readUnsignedInt();
         var pos:uint = data.readUnsignedInt();
         if(flag == 1)
         {
            this._playVec[pos] = userID;
            this._wiatVec[pos].visible = true;
            if(userID == LocalUserInfo.getUserID())
            {
               this._isSelf = true;
            }
         }
         else if(flag == 0)
         {
            if(userID == LocalUserInfo.getUserID())
            {
               this._isSelf = false;
            }
            this._playVec[pos] = 0;
            this._wiatVec[pos].visible = false;
         }
      }
      
      private function fullBroadCastHandle(e:SocketEvent) : void
      {
         var people:PeopleManageView = null;
         var wait:MovieClip = null;
         var id:uint = 0;
         var movie:PlayMovie = null;
         GV.onlineSocket.removeEventListener(PeopleEvent.READY_MOVE,this.onLeaveSeat);
         trace("廣播的時候的位置上的用戶id" + this._playVec);
         for each(wait in this._wiatVec)
         {
            wait.visible = false;
         }
         for each(id in this._playVec)
         {
            if(id != 0)
            {
               people = PeopleManager.getPeopleView(id);
               people.visible = false;
               people.moveTo(381,521);
            }
         }
         if(this._isSelf)
         {
            people = PeopleManager.getPeopleView(LocalUserInfo.getUserID());
            people.visible = false;
            people.moveTo(381,521);
         }
         movie = PlayMovie.play("resource/map/activity/wuLong.swf",null,null,function():void
         {
            movie.destroy();
            for(var i:* = 0; i < _playVec.length; i++)
            {
               if(_playVec[i] != 0)
               {
                  try
                  {
                     people = PeopleManager.getPeopleView(_playVec[i]);
                     people.visible = true;
                     _playVec[i] = 0;
                  }
                  catch(error:Error)
                  {
                  }
               }
            }
            trace("動畫播放好以後的位置信息" + _playVec);
            PeopleManager.getPeopleView(LocalUserInfo.getUserID()).visible = true;
            getPrize();
         },null,null,false);
      }
      
      private function getPrize() : void
      {
         if(this._isSelf)
         {
            this._isSelf = false;
            this._query.addEventListener(QueryItemCntManager.DayTYPE_QUERY,this.dayTypeHandle);
            this._query.dayTypeQuery(31705);
         }
      }
      
      private function dayTypeHandle(e:EventTaomee) : void
      {
         var times:uint;
         this._query.removeEventListener(QueryItemCntManager.DayTYPE_QUERY,this.dayTypeHandle);
         times = uint(e.EventObj);
         if(times == 0)
         {
            Presented.getInstance().celebrate1225(3225);
            setTimeout(function():void
            {
               BC.addOnceEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,socksHandler);
               exchange.exchange_goods(3226,1,1);
            },1500);
         }
         else if(times < 5)
         {
            Presented.getInstance().celebrate1225(3225);
         }
         else if(times >= 5)
         {
            Alert.angryAlart("  小摩爾每天只能領取5次獎勵哦！");
         }
      }
      
      private function socksHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.socksHandler);
      }
      
      public function destroy() : void
      {
         if(Boolean(this._query))
         {
            this._query.removeEventListener(QueryItemCntManager.DayTYPE_QUERY,this.dayTypeHandle);
            this._query = null;
         }
         GV.onlineSocket.removeEventListener(PeopleEvent.READY_MOVE,this.onLeaveSeat);
         SystemEventManager.removeEventListener("Seat",this.onEnterSeat);
         GV.onlineSocket.removeCmdListener(CommandID.DRAGON_DANCE_ENTER_LEAVE,this.enterLeaveHandle);
         GV.onlineSocket.removeCmdListener(CommandID.DRAGON_DANCE_FULL_BROADCAST,this.fullBroadCastHandle);
         GV.onlineSocket.removeCmdListener(CommandID.DRAGON_DANCE_PLAYER_INFO,this.playerInfoHandle);
      }
   }
}

