package com.mole.app.activity
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.throwItem.ThrowItemReq;
   import com.logic.socket.throwItem.ThrowItemRes;
   import com.mole.app.task.Task;
   import com.mole.app.task.TaskManager;
   import com.mole.app.task.type.TaskStateType;
   import com.mole.app.utils.PlayMovie;
   import com.view.MapManageView.MapManageView;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.activity.Task83.SoundManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.ui.Mouse;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.Tick;
   
   public class RkVsActivity
   {
      
      private static var _inst:RkVsActivity;
      
      private var controlLevel:MovieClip;
      
      private var topLevel:MovieClip;
      
      private var _pen_mc:Sprite;
      
      private var throwItemReq:ThrowItemReq;
      
      private var _bloodBar_mc:MovieClip;
      
      private var _blood_mc:MovieClip;
      
      private var _pointer_mc:MovieClip;
      
      private var _zeroBlood_txt:TextField;
      
      private var _rkBlood_txt:TextField;
      
      private var _timeTip_mc:MovieClip;
      
      private var _time_txt:TextField;
      
      private var _sceneCartoon_mc:MovieClip;
      
      private var RKTipMovie:PlayMovie;
      
      private var zeroTipMovie:PlayMovie;
      
      private var restMovie:PlayMovie;
      
      private var RkWinMovie:PlayMovie;
      
      private var zeroWinMovie:PlayMovie;
      
      private var _hit_mc:MovieClip;
      
      private var _gameState:uint;
      
      private var _pointPos:uint;
      
      private var _leftTime:uint;
      
      private var _throwState:uint;
      
      private var pointARr:Array = [13,439,182,416];
      
      private var _preMin:Number;
      
      private var _timeSHow:Timer;
      
      private const POINTOFFSET:uint = 60;
      
      private var task574:Task;
      
      private var _isHit:Boolean;
      
      public function RkVsActivity()
      {
         super();
      }
      
      public static function get inst() : RkVsActivity
      {
         if(_inst == null)
         {
            _inst = new RkVsActivity();
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
         MapManageView.inst.removeEventListener(Event.INIT,this.initHandle);
         this._pen_mc = this.topLevel["pen_mc"];
         this._pen_mc.mouseChildren = false;
         this._pen_mc.mouseEnabled = false;
         this.throwItemReq = new ThrowItemReq();
         this._bloodBar_mc = this.controlLevel["bloodBar_mc"];
         this._blood_mc = this._bloodBar_mc["blood_mc"];
         this._pointer_mc = this._bloodBar_mc["pointer_mc"];
         this._timeTip_mc = this._bloodBar_mc["timeTip_mc"];
         this._time_txt = this._timeTip_mc["time_txt"];
         this._sceneCartoon_mc = this.controlLevel["sceneCartoon_mc"];
         this._hit_mc = this.topLevel["hit_mc"];
         this.task574Control();
      }
      
      private function task574Control() : void
      {
         this.task574 = TaskManager.getTask(574);
         if(Boolean(this.task574) && Boolean(this.task574.state == TaskStateType.OPEN) && (this.task574.buffer.step == 3 || this.task574.buffer.step == 4))
         {
            this.task574.addEventListener(Task.TASK_OVER,this.task574Over);
         }
         else
         {
            this.initEvent();
         }
      }
      
      private function initEvent() : void
      {
         GV.onlineSocket.addCmdListener(CommandID.RK_VS_ZERO_ENTERMAP,this.enterMap);
         GF.sendSocket(CommandID.RK_VS_ZERO_THROWWATER);
         GV.onlineSocket.addCmdListener(CommandID.RK_VS_ZERO_THROWWATER,this.throwWater);
         GV.onlineSocket.addCmdListener(CommandID.RK_VS_ZERO_PRIZE,this.prizeHandle);
         Mouse.show();
         Tick.instance.addRender(this.onMove);
         LevelManager.stage.addEventListener(MouseEvent.CLICK,this.onClickTarget);
         BC.addEvent(this,this._hit_mc,MouseEvent.MOUSE_OVER,this.onOverHit);
         BC.addEvent(this,this._hit_mc,MouseEvent.MOUSE_OUT,this.onOutHit);
         BC.addEvent(this,GV.onlineSocket,ThrowItemRes.THROW_ITEM,this.throwThingStart);
      }
      
      private function task574Over(evt:Event) : void
      {
         TaskManager.getTask(574).removeEventListener(Task.TASK_OVER,this.task574Over);
         this.initEvent();
      }
      
      private function onOverHit(e:MouseEvent) : void
      {
         this._isHit = true;
      }
      
      private function onOutHit(e:MouseEvent) : void
      {
         this._isHit = false;
      }
      
      public function throwThingStart(E:EventTaomee) : void
      {
         var tmpPeopleView:PeopleManageView = GF.getPeopleByID(E.EventObj.UserID);
         if(Boolean(tmpPeopleView))
         {
            tmpPeopleView.Throw_selected = E.EventObj.ItemID;
            if(E.EventObj.UserID == LocalUserInfo.getUserID() && tmpPeopleView.Throw_selected == 150001)
            {
               if(LevelManager.stage.mouseX < this.pointARr[0] || LevelManager.stage.mouseX > this.pointARr[1] || LevelManager.stage.mouseY < this.pointARr[2] || LevelManager.stage.mouseY > this.pointARr[3])
               {
                  trace("投擲了水彈，但是不在目標區域內");
               }
               else
               {
                  trace("此時給後台發送投擲了水彈的協議?");
               }
            }
         }
      }
      
      private function onClickTarget(e:Event) : void
      {
         if(this._isHit == false)
         {
            return;
         }
         if(LevelManager.stage.mouseX < this.pointARr[0] || LevelManager.stage.mouseX > this.pointARr[1] || LevelManager.stage.mouseY < this.pointARr[2] || LevelManager.stage.mouseY > this.pointARr[3])
         {
            trace("不在區域點擊");
         }
         else
         {
            trace("投水彈");
            if(this._gameState == 0)
            {
               Alert.angryAlart("　　 小摩爾,要在活動時間之內,才可以扔水彈!你現在還不能幫助RK!");
            }
            else if(this._gameState == 2)
            {
               Alert.angryAlart("　小摩爾,休息時間內不能投擲水彈哦!");
            }
            else
            {
               SoundManager.play("resource/map/cartoon/water.mp3");
               this.throwItemReq.throwItem(150001,LevelManager.stage.mouseX,LevelManager.stage.mouseY);
            }
         }
      }
      
      private function onMove(time:uint) : void
      {
         trace("mouseX" + LevelManager.stage.mouseX);
         trace("mouseY" + LevelManager.stage.mouseY);
         if(LevelManager.stage.mouseX < this.pointARr[0] || LevelManager.stage.mouseX > this.pointARr[1] || LevelManager.stage.mouseY < this.pointARr[2] || LevelManager.stage.mouseY > this.pointARr[3])
         {
            Mouse.show();
            this._pen_mc.visible = false;
         }
         else if(this._isHit == true)
         {
            Mouse.hide();
            this._pen_mc.visible = true;
            this._pen_mc.x = LevelManager.stage.mouseX;
            this._pen_mc.y = LevelManager.stage.mouseY;
            if(this.topLevel.getChildIndex(this._pen_mc) != this.topLevel.numChildren - 1)
            {
               this.topLevel.setChildIndex(this._pen_mc,this.topLevel.numChildren - 1);
            }
         }
      }
      
      private function throwWater(e:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.RK_VS_ZERO_THROWWATER,this.throwWater);
         var throwData:ByteArray = e.data as ByteArray;
         this._throwState = throwData.readUnsignedInt();
         if(this._throwState != 1)
         {
            trace("投擲水彈成功");
            GF.sendSocket(CommandID.RK_VS_ZERO_ENTERMAP);
         }
      }
      
      private function enterMap(e:SocketEvent) : void
      {
         var point:int;
         var ranNum:uint = 0;
         var _preDate:Date = null;
         var mapData:ByteArray = e.data as ByteArray;
         mapData.position = 0;
         this._gameState = mapData.readUnsignedInt();
         point = mapData.readInt();
         this._leftTime = mapData.readUnsignedInt();
         trace("_gameState" + this._gameState + "point" + point + "_leftTime" + this._leftTime);
         this._pointPos = point + this.POINTOFFSET;
         if(Boolean(this._timeSHow))
         {
            this._timeSHow.stop();
            this._timeSHow.removeEventListener(TimerEvent.TIMER,this.showTime);
         }
         switch(this._gameState)
         {
            case 0:
               if(Boolean(this.RKTipMovie))
               {
                  this.RKTipMovie.destroy();
               }
               if(Boolean(this.zeroTipMovie))
               {
                  this.zeroTipMovie.destroy();
               }
               if(Boolean(this.restMovie))
               {
                  this.restMovie.destroy();
               }
               if(Boolean(this.RkWinMovie))
               {
                  this.RkWinMovie.destroy();
               }
               if(Boolean(this.zeroWinMovie))
               {
                  this.zeroWinMovie.destroy();
               }
               this._bloodBar_mc.visible = false;
               this._sceneCartoon_mc.visible = true;
               this._sceneCartoon_mc.gotoAndPlay(1);
               break;
            case 1:
               if(Boolean(this.restMovie))
               {
                  this.restMovie.destroy();
               }
               if(Boolean(this.RkWinMovie))
               {
                  this.RkWinMovie.destroy();
               }
               if(Boolean(this.zeroWinMovie))
               {
                  this.zeroWinMovie.destroy();
               }
               this._sceneCartoon_mc.visible = true;
               this._sceneCartoon_mc.play();
               this._bloodBar_mc.visible = true;
               this._blood_mc.gotoAndStop(this._pointPos);
               this._pointer_mc.gotoAndStop(this._pointPos);
               this._timeTip_mc.gotoAndStop(1);
               this._time_txt.text = this._leftTime.toString();
               if(this._leftTime == 30)
               {
                  ranNum = Math.round(Math.random() * 2 + 1);
                  trace("ranNum" + ranNum);
                  if(ranNum == 2)
                  {
                     this.RKTipMovie = PlayMovie.play("resource/map/cartoon/map_123_RKTip.swf",null,null,function():void
                     {
                        RKTipMovie.destroy();
                     },null,this.topLevel,false);
                  }
                  else if(ranNum == 3)
                  {
                     this._sceneCartoon_mc.visible = false;
                     this.zeroTipMovie = PlayMovie.play("resource/map/cartoon/map_123_ZeroTip.swf",null,null,function():void
                     {
                        zeroTipMovie.destroy();
                        _sceneCartoon_mc.visible = true;
                     },null,this.topLevel,false);
                  }
               }
               break;
            case 2:
               if(Boolean(this.RKTipMovie))
               {
                  this.RKTipMovie.destroy();
               }
               if(Boolean(this.zeroTipMovie))
               {
                  this.zeroTipMovie.destroy();
               }
               if(Boolean(this.RkWinMovie))
               {
                  this.RkWinMovie.destroy();
               }
               if(Boolean(this.zeroWinMovie))
               {
                  this.zeroWinMovie.destroy();
               }
               this._sceneCartoon_mc.visible = false;
               this.restMovie = PlayMovie.play("resource/map/cartoon/map_123_rest.swf",null,null,function():void
               {
                  restMovie.destroy();
                  _sceneCartoon_mc.visible = true;
               },null,this.topLevel,false);
               _preDate = ServerUpTime.getInstance().chinaDate;
               this._preMin = Number(_preDate.time);
               this._bloodBar_mc.visible = true;
               this._blood_mc.gotoAndStop(60);
               this._pointer_mc.gotoAndStop(60);
               this._timeTip_mc.gotoAndStop(2);
               this._timeSHow = new Timer(1000);
               this._timeSHow.start();
               this._timeSHow.addEventListener(TimerEvent.TIMER,this.showTime);
               break;
            case 3:
               if(Boolean(this.RKTipMovie))
               {
                  this.RKTipMovie.destroy();
               }
               if(Boolean(this.zeroTipMovie))
               {
                  this.zeroTipMovie.destroy();
               }
               if(Boolean(this.restMovie))
               {
                  this.restMovie.destroy();
               }
               this._bloodBar_mc.visible = false;
               if(this._pointPos <= 60)
               {
                  trace("播放零勝利的動畫");
                  this._sceneCartoon_mc.visible = false;
                  this.RkWinMovie = PlayMovie.play("resource/map/cartoon/map_123_ZeroWin.swf",null,null,function():void
                  {
                     RkWinMovie.destroy();
                     _sceneCartoon_mc.visible = true;
                  },null,this.topLevel,true);
               }
               else if(this._pointPos > 60)
               {
                  trace("播放RK勝利的動畫");
                  this._sceneCartoon_mc.visible = false;
                  this._sceneCartoon_mc.gotoAndStop(1);
                  this.zeroWinMovie = PlayMovie.play("resource/map/cartoon/map_123_RKWin.swf",null,null,function():void
                  {
                     zeroWinMovie.destroy();
                     _sceneCartoon_mc.visible = true;
                  },null,this.topLevel,true);
               }
         }
      }
      
      private function showTime(e:*) : void
      {
         --this._leftTime;
         this._time_txt.text = this._leftTime.toString();
      }
      
      private function prizeHandle(e:SocketEvent) : void
      {
         var _itemVec:Vector.<Object> = null;
         var obj:Object = null;
         var prizeData:ByteArray = e.data as ByteArray;
         var _count:uint = prizeData.readUnsignedInt();
         _itemVec = new Vector.<Object>();
         for(var i:uint = 0; i < _count; i++)
         {
            obj = new Object();
            obj.itemID = prizeData.readUnsignedInt();
            obj.itemNum = prizeData.readUnsignedInt();
            _itemVec.push(obj);
         }
         var msg:String = "    恭喜你獲得";
         for(var j:uint = 0; j < _itemVec.length; j++)
         {
            msg += _itemVec[j].itemNum + "個" + GoodsInfo.getItemNameByID(_itemVec[j].itemID);
         }
         Alert.smileAlart(msg);
      }
      
      public function destroy() : void
      {
         if(Boolean(this._timeSHow))
         {
            this._timeSHow.stop();
            this._timeSHow.removeEventListener(TimerEvent.TIMER,this.showTime);
         }
         if(Boolean(this.RKTipMovie))
         {
            this.RKTipMovie.destroy();
         }
         if(Boolean(this.zeroTipMovie))
         {
            this.zeroTipMovie.destroy();
         }
         if(Boolean(this.restMovie))
         {
            this.restMovie.destroy();
         }
         if(Boolean(this.RkWinMovie))
         {
            this.RkWinMovie.destroy();
         }
         if(Boolean(this.zeroWinMovie))
         {
            this.zeroWinMovie.destroy();
         }
         this.task574.removeEventListener(Task.TASK_OVER,this.task574Over);
         BC.removeEvent(this,GV.onlineSocket,ThrowItemRes.THROW_ITEM,this.throwThingStart);
         Mouse.show();
         LevelManager.stage.removeEventListener(MouseEvent.CLICK,this.onClickTarget);
         Tick.instance.removeRender(this.onMove);
         MapManageView.inst.removeEventListener(Event.INIT,this.initHandle);
         GV.onlineSocket.removeCmdListener(CommandID.RK_VS_ZERO_PRIZE,this.prizeHandle);
         GV.onlineSocket.removeCmdListener(CommandID.RK_VS_ZERO_THROWWATER,this.throwWater);
         GV.onlineSocket.removeCmdListener(CommandID.RK_VS_ZERO_ENTERMAP,this.enterMap);
         BC.removeEvent(this);
         this.controlLevel = null;
         this.topLevel = null;
      }
   }
}

