package com.mole.app.manager
{
   import com.common.Alert.Alert;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.MapManageLogic.MapDepthManageLogic;
   import com.mole.app.event.PeopleEvent;
   import com.mole.app.event.SystemEvent;
   import com.view.PeopleView.PeopleManageView;
   import com.view.player.PlayerActionConstant;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class SceneChargeManager extends EventDispatcher
   {
      
      private var _seatInfoProtolID:uint;
      
      private var _activityStateID:uint;
      
      private var _setOffID:uint;
      
      private var _leaveX:uint;
      
      private var _leaveY:uint;
      
      private var _seatedNum:uint;
      
      private var _offedNum:uint;
      
      private var _stateList:Array;
      
      private var _goUserID:uint;
      
      private var _flag:uint;
      
      private var _isSelf:Boolean;
      
      private var _posID:uint;
      
      private var _broadUserID:uint;
      
      private var _broadUserInfo:uint;
      
      public function SceneChargeManager()
      {
         super();
      }
      
      public function enterMap() : void
      {
         GV.onlineSocket.addCmdListener(this._seatInfoProtolID,this.entermapHandle);
         GV.onlineSocket.addCmdListener(this._activityStateID,this.activityBroadHandle);
         GV.onlineSocket.addCmdListener(this._setOffID,this.setOffHandle);
         SystemEventManager.addEventListener("Seat",this.onEnterSeat);
      }
      
      private function onEnterSeat(e:SystemEvent) : void
      {
         this._posID = e.data;
         GF.sendSocket(this._seatInfoProtolID,this._seatedNum,this._posID);
      }
      
      private function entermapHandle(e:SocketEvent) : void
      {
         var userObj:Object = null;
         this._stateList = new Array();
         var mapInfo:ByteArray = e.data as ByteArray;
         var count:uint = mapInfo.readUnsignedInt();
         for(var i:uint = 0; i < count; i++)
         {
            userObj = new Object();
            userObj.userID = mapInfo.readUnsignedInt();
            trace("各個位置上的用戶ID" + userObj.userID);
            this._stateList.push(userObj);
         }
         if(this._stateList[this._posID - 1].userID == 0)
         {
            GF.sendSocket(this._setOffID,this._seatedNum,this._posID);
            GV.onlineSocket.addEventListener(PeopleEvent.READY_MOVE,this.onLeaveSeat);
         }
         else
         {
            this.setMolePos(new Point(this._leaveX,this._leaveY));
            Alert.smileAlart("　　位置上有小摩爾，請耐心等待!");
         }
      }
      
      private function onLeaveSeat(e:Event) : void
      {
         GF.sendSocket(this._setOffID,this._offedNum,this._posID);
         GV.onlineSocket.removeEventListener(PeopleEvent.READY_MOVE,this.onLeaveSeat);
      }
      
      private function activityBroadHandle(e:SocketEvent) : void
      {
         var broaddata:ByteArray = e.data as ByteArray;
         this._broadUserID = broaddata.readUnsignedInt();
         this._broadUserInfo = broaddata.readUnsignedInt();
         if(this._isSelf)
         {
            this.setMolePos(new Point(this._leaveX,this._leaveY));
            MoveTo.CanMove = true;
            this.gainPrize();
         }
      }
      
      private function gainPrize() : void
      {
      }
      
      private function setOffHandle(e:SocketEvent) : void
      {
         var setOffData:ByteArray = e.data as ByteArray;
         this._flag = setOffData.readUnsignedInt();
         this._goUserID = setOffData.readUnsignedInt();
         if(this._flag == 1)
         {
            if(this._goUserID == LocalUserInfo.getUserID())
            {
               this._isSelf = true;
               GV.onlineSocket.addEventListener("removeMapEvent",this.onChangeMap);
            }
            else
            {
               this._isSelf = false;
            }
         }
         else if(this._flag == 0)
         {
            if(this._goUserID == LocalUserInfo.getUserID())
            {
               trace("在玩遊戲的人離開了位置");
            }
            this._isSelf = false;
            trace("離開遊戲");
         }
      }
      
      private function onChangeMap(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",this.onChangeMap);
         GF.sendSocket(this._setOffID,0,this._posID);
      }
      
      private function setMolePos(pos:Point) : void
      {
         GV.onlineClass.walking(pos.x,pos.y,LocalUserInfo.getUserID());
         PeopleManageView(GV.MAN_PEOPLE).stopToHere();
         PeopleManageView(GV.MAN_PEOPLE).avatarClass.showActionWithId(PlayerActionConstant.ACTION_STAND,0);
         PeopleManageView(GV.MAN_PEOPLE).x = pos.x;
         PeopleManageView(GV.MAN_PEOPLE).y = pos.y;
         MapDepthManageLogic.setPeopleDepth(PeopleManageView(GV.MAN_PEOPLE));
      }
      
      public function destroy() : void
      {
         GV.onlineSocket.removeCmdListener(this._seatInfoProtolID,this.entermapHandle);
         GV.onlineSocket.removeCmdListener(this._activityStateID,this.activityBroadHandle);
         GV.onlineSocket.removeCmdListener(this._setOffID,this.setOffHandle);
         SystemEventManager.removeEventListener("Seat",this.onEnterSeat);
         GV.onlineSocket.removeEventListener("removeMapEvent",this.onChangeMap);
      }
      
      public function set seatInfoProtolID(value:uint) : void
      {
         this._seatInfoProtolID = value;
      }
      
      public function set activityStateID(value:uint) : void
      {
         this._activityStateID = value;
      }
      
      public function set setOddID(value:uint) : void
      {
         this._setOffID = value;
      }
      
      public function set leaveX(value:uint) : void
      {
         this._leaveX = value;
      }
      
      public function set leaveY(value:uint) : void
      {
         this._leaveY = value;
      }
      
      public function set seatedNum(value:uint) : void
      {
         this._seatedNum = value;
      }
      
      public function set offedNum(value:uint) : void
      {
         this._offedNum = value;
      }
   }
}

