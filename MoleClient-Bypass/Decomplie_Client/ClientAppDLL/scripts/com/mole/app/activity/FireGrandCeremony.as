package com.mole.app.activity
{
   import com.common.Alert.Alert;
   import com.common.Alert.type.AlertType;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.util.MovieClipUtil;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.MapManageLogic.MapDepthManageLogic;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.logic.socket.fireGrand.EnterLeaveFirePlaceProtocol;
   import com.logic.socket.fireGrand.QueryFireInfoProtocol;
   import com.logic.socket.fireGrand.SetOffFireProtocol;
   import com.module.LocusWork.NumSprite;
   import com.module.activityModule.Presented;
   import com.mole.app.event.PeopleEvent;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.OnlineManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.net.events.SocketEvent;
   import com.view.MapManageView.MapManageView;
   import com.view.PeopleView.PeopleManageView;
   import com.view.player.PlayerActionConstant;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.setTimeout;
   import org.taomee.utils.Tick;
   
   public class FireGrandCeremony
   {
      
      private static var _inst:FireGrandCeremony;
      
      private var controlLevel:MovieClip;
      
      private var topLevel:MovieClip;
      
      private var _wordInfo_mc:MovieClip;
      
      private var _fireShoot_mc:MovieClip;
      
      private var _fireWord_txt:TextField;
      
      private var _startFire_btn:SimpleButton;
      
      private var _num_mc:MovieClip;
      
      private var _fireEffectVec:Vector.<MovieClip>;
      
      private var typeVec:Vector.<uint>;
      
      private const LeaveX:uint = 763;
      
      private const leaveY:uint = 391;
      
      private var _numSpr:NumSprite;
      
      private var _seat_1:Sprite;
      
      private var _torchNum:uint;
      
      private var _strIndex:uint;
      
      private var _ranIndex:uint;
      
      private var _wordArr:Array = ["拉姆","摩爾","愛"];
      
      private var _defaultWordArr:Array = ["摩爾莊園，快樂童年！","我愛摩爾莊園！","拉姆是我們的好夥伴！","祝拉姆運動會圓滿落幕！"];
      
      private var _targetUserID:uint;
      
      private var _firedTimes:uint;
      
      private var _isSelf:Boolean;
      
      private var _flag:uint;
      
      private var _goUserID:uint;
      
      private var _preMin:Number;
      
      private var _sendStr:String;
      
      public function FireGrandCeremony()
      {
         super();
      }
      
      public static function get inst() : FireGrandCeremony
      {
         if(_inst == null)
         {
            _inst = new FireGrandCeremony();
         }
         return _inst;
      }
      
      public function init(controlLevel:MovieClip, topLevel:MovieClip) : void
      {
         this.controlLevel = controlLevel;
         this.topLevel = topLevel;
         MapManageView.inst.addEventListener(Event.INIT,this.initHandle);
      }
      
      private function initHandle(e:Event) : void
      {
         var fireEffect:MovieClip = null;
         MapManageView.inst.removeEventListener(Event.INIT,this.initHandle);
         this.typeVec = new Vector.<uint>();
         this.typeVec.push(2203,2204,2205,2206);
         this._wordInfo_mc = this.topLevel["wordInfo_mc"];
         this._fireShoot_mc = this.controlLevel["fireShoot_mc"];
         this._fireWord_txt = this._wordInfo_mc["fireWord_txt"];
         this._startFire_btn = this._wordInfo_mc["startFire_btn"];
         this._num_mc = this._wordInfo_mc["num_mc"];
         this._numSpr = new NumSprite(this._num_mc,0,false,true);
         this._seat_1 = this.controlLevel["seat_1"];
         this._wordInfo_mc.visible = false;
         this._fireEffectVec = new Vector.<MovieClip>();
         for(var i:uint = 1; i < 5; i++)
         {
            fireEffect = this.controlLevel["fireEffect" + i + "_mc"];
            fireEffect.visible = false;
            MapManageView.inst.mapLevel.topLevel.addChild(fireEffect);
            this._fireEffectVec.push(fireEffect);
         }
         BC.addEvent(this,this._startFire_btn,MouseEvent.CLICK,this.onClickStart);
         SystemEventManager.addEventListener("Seat",this.onEnterSeat);
         OnlineManager.addCmdListener(CommandID.FINISH_SOMETHING,this.onCheckSomething);
         finishSomethingReq.sendReq(31490);
         OnlineManager.addCmdListener(CommandID.FIREGRAND_QUERY_FIREINFO,this.queryFireInfo);
         OnlineManager.addCmdListener(CommandID.FIREGRAND_ENTER_LEAVE_FIRE_PLACE,this.startLeaveHandle);
         OnlineManager.addCmdListener(CommandID.FIREGRAND_SETOFF_FIRE,this.setOffHandle);
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.onCheckItemCount);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),1351473,2);
      }
      
      private function onCheckItemCount(e:*) : void
      {
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.onCheckItemCount);
         var arr:Array = e.EventObj.obj.arr;
         var len:int = int(arr.length);
         if(len == 0 || arr[0].Count == 0)
         {
            this._torchNum = 0;
         }
         else
         {
            this._torchNum = arr[0].Count;
         }
      }
      
      private function setOffHandle(e:SocketEvent) : void
      {
         var setOffInfo:SetOffFireProtocol;
         var setOffUserID:uint;
         var setOffIndex:uint = 0;
         var setOffStr:String = null;
         this._fireWord_txt.text = "";
         this._wordInfo_mc.visible = false;
         setOffInfo = e.bodyInfo;
         setOffUserID = setOffInfo.userID;
         setOffIndex = setOffInfo.num;
         setOffStr = setOffInfo.strInfo;
         trace("米米號" + setOffUserID + "燃放了編號多少" + setOffIndex + "燃放的文字" + setOffStr);
         this._fireShoot_mc.gotoAndPlay(2);
         MovieClipUtil.playEndAndFunc(this._fireShoot_mc,function():void
         {
            _fireEffectVec[setOffIndex - 1].visible = true;
            _fireEffectVec[setOffIndex - 1].gotoAndPlay(2);
            _fireEffectVec[setOffIndex - 1]["showWord_mc"]["showWord_txt"].text = setOffStr;
            trace(_fireEffectVec[setOffIndex - 1]["showWord_mc"]["showWord_txt"].text);
            MovieClipUtil.playEndAndFunc(_fireEffectVec[setOffIndex - 1],function():void
            {
               trace("放完了");
               _fireEffectVec[setOffIndex - 1]["showWord_mc"]["showWord_txt"].text == "";
               _fireEffectVec[setOffIndex - 1].visible = false;
               _sendStr = null;
               if(_isSelf)
               {
                  setMolePos(new Point(LeaveX,leaveY));
                  MoveTo.CanMove = true;
                  gainPrize();
               }
            });
         });
      }
      
      private function onClickStart(e:Event) : void
      {
         if(e.type == "keyDown")
         {
            if(KeyboardEvent(e).keyCode != 13)
            {
               return;
            }
         }
         if(this._sendStr == null || !this._sendStr)
         {
            this._sendStr = this._defaultWordArr[this._ranIndex - 1];
         }
         this._strIndex = 0;
         trace("玩家輸入的資訊" + this._sendStr + "是多少個字節" + this._sendStr.length);
         for(var i:uint = 0; i < 3; i++)
         {
            if(this._sendStr.indexOf(this._wordArr[i]) != -1)
            {
               this._strIndex = i + 1;
            }
         }
         if(this._strIndex == 0)
         {
            SetOffFireProtocol.send(4,this._sendStr);
         }
         else
         {
            SetOffFireProtocol.send(this._strIndex,this._sendStr);
         }
      }
      
      private function queryFireInfo(e:SocketEvent) : void
      {
         var queryFireInfo:QueryFireInfoProtocol = e.bodyInfo;
         this._targetUserID = queryFireInfo.userID;
         trace("進入場景時，在位置上的用戶ID" + this._targetUserID);
         if(this._targetUserID == 0)
         {
            if(this._firedTimes >= 8)
            {
               Alert.angryAlart("當天免費次數已經用完，是否要花費3個火炬!" + "再次點燃煙花？",function(e:Event):void
               {
                  if(_torchNum >= 3)
                  {
                     Presented.getInstance().celebrate1225(2215,1,1,"恭喜成功獲得點燃煙花機會","恭喜成功獲得點燃煙花機會");
                     EnterLeaveFirePlaceProtocol.send(1);
                     GV.onlineSocket.addEventListener(PeopleEvent.READY_MOVE,onLeaveSeat);
                     _torchNum -= 3;
                     _seat_1.mouseChildren = false;
                     _seat_1.mouseEnabled = false;
                  }
                  else
                  {
                     Alert.angryAlart("　　小摩爾" + GoodsInfo.getItemNameByID(1351473) + "數量不足哦！");
                  }
               },AlertType.SURE + "," + AlertType.CANCEL);
            }
            else
            {
               EnterLeaveFirePlaceProtocol.send(1);
               GV.onlineSocket.addEventListener(PeopleEvent.READY_MOVE,this.onLeaveSeat);
               this._seat_1.mouseChildren = false;
               this._seat_1.mouseEnabled = false;
            }
         }
         else
         {
            this.setMolePos(new Point(this.LeaveX,this.leaveY));
            Alert.smileAlart("　　位置上有小摩爾，請耐心等待!");
         }
      }
      
      private function onCheckSomething(evt:SocketEvent) : void
      {
         var somethingPro:finishSomethingRes = evt.bodyInfo;
         if(somethingPro.Type == 31490)
         {
            if(Boolean(somethingPro.Done))
            {
               this._firedTimes = somethingPro.Done;
            }
            else
            {
               this._firedTimes = 0;
            }
         }
      }
      
      private function onEnterSeat(e:SystemEvent) : void
      {
         QueryFireInfoProtocol.send();
      }
      
      private function startLeaveHandle(e:SocketEvent) : void
      {
         var _preData:Date = null;
         var startLeaveInfo:EnterLeaveFirePlaceProtocol = e.bodyInfo;
         this._flag = startLeaveInfo.flag;
         this._goUserID = startLeaveInfo.userID;
         if(this._flag == 1)
         {
            if(startLeaveInfo.userID == LocalUserInfo.getUserID())
            {
               this._isSelf = true;
               this._wordInfo_mc.visible = true;
               MoveTo.CanMove = false;
               this._fireWord_txt.text = "";
               this._fireWord_txt.maxChars = 10;
               this._ranIndex = 1 + 3 * Math.random();
               this._fireWord_txt.text = this._defaultWordArr[this._ranIndex - 1];
               this._fireWord_txt.setSelection(this._fireWord_txt.text.length,this._fireWord_txt.text.length);
               LevelManager.stage.focus = this._fireWord_txt;
               this._fireWord_txt.addEventListener(KeyboardEvent.KEY_UP,this.onSendTexthandle);
               BC.addEvent(this,LevelManager.stage,KeyboardEvent.KEY_DOWN,this.onClickStart);
               _preData = ServerUpTime.getInstance().chinaDate;
               this._preMin = Number(_preData.time);
               Tick.instance.addRender(this.onCallTime);
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
               this._wordInfo_mc.visible = false;
               MoveTo.CanMove = true;
            }
            this._isSelf = false;
            trace("離開遊戲");
         }
      }
      
      private function onChangeMap(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",this.onChangeMap);
         EnterLeaveFirePlaceProtocol.send(0);
      }
      
      private function gainPrize() : void
      {
         this._seat_1.mouseChildren = true;
         this._seat_1.mouseEnabled = true;
         this._isSelf = false;
         Presented.getInstance().celebrate1225(this.typeVec[0]);
         ++this._firedTimes;
         setTimeout(function():void
         {
            for(var i:uint = 1; i <= 3; i++)
            {
               if(_firedTimes == uint(2 * i - 1))
               {
                  Presented.getInstance().celebrate1225(typeVec[i]);
                  break;
               }
               trace("不是");
            }
         },1000);
      }
      
      private function onCallTime(delay:Number) : void
      {
         var _curDate:Date = ServerUpTime.getInstance().chinaDate;
         var _curMin:Number = Number(_curDate.time);
         var tarSecond:uint = 60 - (_curMin / 1000 - this._preMin / 1000);
         trace(_curDate.time / 1000);
         this._numSpr.value = tarSecond;
         trace("倒計時分鐘" + Math.floor(_curMin / 1000 - this._preMin / 1000));
         if(tarSecond == 0)
         {
            trace("倒計時ok了");
            Tick.instance.removeRender(this.onCallTime);
            this._wordInfo_mc.visible = false;
            this.setMolePos(new Point(this.LeaveX,this.leaveY));
         }
      }
      
      private function onSendTexthandle(e:KeyboardEvent) : void
      {
         var text:TextField = e.target as TextField;
         var count:int = 20 - text.length;
         if(count > 0)
         {
            this._sendStr = text.text;
         }
         else
         {
            text.text = "";
            text.text = this._sendStr;
            count = 0;
         }
         trace("還剩餘的輸入的文字數" + count);
      }
      
      private function onLeaveSeat(e:Event) : void
      {
         this._seat_1.mouseChildren = true;
         this._seat_1.mouseEnabled = true;
         Tick.instance.removeRender(this.onCallTime);
         this._wordInfo_mc.visible = false;
         EnterLeaveFirePlaceProtocol.send(0);
         GV.onlineSocket.removeEventListener(PeopleEvent.READY_MOVE,this.onLeaveSeat);
      }
      
      private function setMolePos(pos:Point) : void
      {
         Tick.instance.removeRender(this.onCallTime);
         GV.onlineClass.walking(pos.x,pos.y,LocalUserInfo.getUserID());
         PeopleManageView(GV.MAN_PEOPLE).stopToHere();
         PeopleManageView(GV.MAN_PEOPLE).avatarClass.showActionWithId(PlayerActionConstant.ACTION_STAND,0);
         PeopleManageView(GV.MAN_PEOPLE).x = pos.x;
         PeopleManageView(GV.MAN_PEOPLE).y = pos.y;
         MapDepthManageLogic.setPeopleDepth(PeopleManageView(GV.MAN_PEOPLE));
      }
      
      public function destroy() : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",this.onChangeMap);
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.onCheckItemCount);
         OnlineManager.removeCmdListener(CommandID.FIREGRAND_SETOFF_FIRE,this.setOffHandle);
         this._fireWord_txt.removeEventListener(KeyboardEvent.KEY_UP,this.onSendTexthandle);
         OnlineManager.removeCmdListener(CommandID.FINISH_SOMETHING,this.onCheckSomething);
         GV.onlineSocket.removeEventListener(PeopleEvent.READY_MOVE,this.onLeaveSeat);
         SystemEventManager.removeEventListener("Seat",this.onEnterSeat);
         MapManageView.inst.removeEventListener(Event.INIT,this.initHandle);
         OnlineManager.removeCmdListener(CommandID.FIREGRAND_QUERY_FIREINFO,this.queryFireInfo);
         Tick.instance.removeRender(this.onCallTime);
         BC.removeEvent(this);
      }
   }
}

