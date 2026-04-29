package com.view.mapView.activity.map16
{
   import com.common.util.DisplayUtil;
   import com.core.info.ServerUpTime;
   import com.global.staticData.CommandID;
   import com.mole.app.manager.NewStatisticsManager;
   import com.mole.app.utils.PlayMovie;
   import com.mole.app.utils.Tool;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.ui.Mouse;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import org.taomee.net.SocketEvent;
   
   public class SixYearTollyActivity
   {
      
      private static var _inst:SixYearTollyActivity;
      
      private var _firstFlag:Boolean;
      
      private var _secondFlag:Boolean;
      
      private var _panel:MovieClip;
      
      private var _cakeMc:MovieClip;
      
      private var _timer:Timer;
      
      private var _movie:PlayMovie;
      
      private var _randomMovie:PlayMovie;
      
      private var _mouse:MovieClip;
      
      private var _count:int = 60;
      
      private var _tempMc:MovieClip;
      
      private var _backMc:MovieClip;
      
      private var _arrowBtn:MovieClip;
      
      private var _sendFlag:uint;
      
      private var _candle:uint;
      
      public function SixYearTollyActivity(mc:MovieClip)
      {
         super();
         this._panel = mc;
         this._cakeMc = this._panel["cake_mc"];
         this._cakeMc.visible = false;
         this._mouse = this._cakeMc["match_mc"];
         this._backMc = this._panel["back_mc"];
         this._arrowBtn = this._panel["arrow_btn"];
         this._arrowBtn.visible = false;
         this._backMc.mouseChildren = this._backMc.mouseEnabled = false;
         this._mouse.mouseChildren = this._mouse.mouseEnabled = false;
         this._backMc.visible = false;
         this._mouse.visible = false;
         this.tollyStep(this._cakeMc,6,true);
         GV.onlineSocket.addCmdListener(CommandID.GODDESS_OVER_TASK,this.onQueryInfo);
         GV.onlineSocket.addCmdListener(CommandID.SIX_YEAR_TOLLY_SEND,this.onSendState);
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.onTick);
         GF.sendSocket(CommandID.GODDESS_OVER_TASK,130);
      }
      
      private function onQueryInfo(e:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.GODDESS_OVER_TASK,this.onQueryInfo);
         var recData:ByteArray = e.data as ByteArray;
         recData.position = 0;
         var one:uint = recData.readUnsignedInt();
         var two:uint = recData.readUnsignedInt();
         this._firstFlag = Boolean(one);
         this._secondFlag = Boolean(two);
         this.init();
      }
      
      public function init() : void
      {
         var hour:int = ServerUpTime.getInstance().getMoleHours % 24;
         if(hour == 19)
         {
            this._timer.start();
            this._cakeMc.visible = true;
            this._arrowBtn.visible = true;
            if(!this._secondFlag)
            {
               if(!this._firstFlag)
               {
                  NewStatisticsManager.send(148);
                  this._movie = PlayMovie.play("resource/movie/sixYearTollyInScence.swf",null,null,this.playOver0);
               }
               this.tollyStep(this._cakeMc,6,false);
            }
            else
            {
               this._cakeMc.visible = false;
               this._arrowBtn.visible = false;
               DisplayUtil.removeForParent(this._backMc);
            }
         }
         else
         {
            DisplayUtil.removeForParent(this._backMc);
         }
      }
      
      private function playOver0() : void
      {
         this._sendFlag = 1;
         GF.sendSocket(CommandID.SIX_YEAR_TOLLY_SEND,1);
         this._movie.destroy();
         this._movie = null;
      }
      
      private function onSendState(e:SocketEvent) : void
      {
         var recData:ByteArray = null;
         var flag:uint = 0;
         var index:uint = uint(Math.random() * 3);
         recData = e.data as ByteArray;
         if(recData != null)
         {
            recData.position = 0;
            flag = recData.readUnsignedInt();
            if(flag == 0)
            {
               if(this._sendFlag == 2)
               {
                  GV.onlineSocket.removeCmdListener(CommandID.SIX_YEAR_TOLLY_SEND,this.onSendState);
                  this._backMc.visible = false;
                  this._randomMovie = this._movie = PlayMovie.play("resource/movie/sixYearRandom_" + index.toString() + ".swf",null,null,function():void
                  {
                     var count:* = recData.readUnsignedInt();
                     var id:* = recData.readUnsignedInt();
                     var num:* = recData.readUnsignedInt();
                     _randomMovie.destroy();
                     _randomMovie = null;
                     _cakeMc.visible = false;
                     _arrowBtn.visible = false;
                     Tool.alert(id,num);
                     NewStatisticsManager.send(150);
                  });
                  DisplayUtil.removeForParent(this._backMc);
               }
            }
         }
      }
      
      private function tollyStep(container:MovieClip, count:uint, flag:Boolean) : void
      {
         var mc:MovieClip = null;
         this._candle = count;
         for(var i:uint = 0; i < count; i++)
         {
            mc = container["mc_" + i.toString()];
            if(flag)
            {
               mc.gotoAndStop(2);
            }
            else
            {
               mc.gotoAndStop(1);
               mc.addEventListener(MouseEvent.CLICK,this.onClick);
               mc.addEventListener(MouseEvent.MOUSE_OUT,this.onOut);
               mc.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
            }
         }
      }
      
      private function onClick(e:MouseEvent) : void
      {
         var mc:MovieClip = e.target as MovieClip;
         mc.mouseEnabled = false;
         mc.mouseChildren = false;
         mc.gotoAndStop(2);
         this._tempMc = null;
         this._mouse.visible = false;
         Mouse.show();
         --this._candle;
         if(this._candle == 0)
         {
            NewStatisticsManager.send(149);
            this._sendFlag = 2;
            GF.sendSocket(CommandID.SIX_YEAR_TOLLY_SEND,2);
         }
      }
      
      private function onMouseOver(e:MouseEvent) : void
      {
         this._tempMc = e.target as MovieClip;
         Mouse.hide();
         this._mouse.visible = true;
         this._mouse.x = this._tempMc.x;
         this._mouse.y = this._tempMc.y;
      }
      
      private function onOut(e:MouseEvent) : void
      {
         this._tempMc = null;
         this._mouse.visible = false;
         Mouse.show();
      }
      
      private function onTick(e:TimerEvent) : void
      {
         var hour:int = ServerUpTime.getInstance().getMoleHours % 24;
         --this._count;
         if(this._count <= 0)
         {
            if(hour != 19)
            {
               this._cakeMc.visible = false;
               this._arrowBtn.visible = false;
               this._timer.stop();
            }
            this._count = 60;
         }
         if(this._tempMc != null)
         {
            this._mouse.x = this._tempMc.x;
            this._mouse.y = this._tempMc.y;
         }
      }
      
      public function destroy() : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.SIX_YEAR_TOLLY_SEND,this.onSendState);
         this._mouse = null;
         this._sendFlag = 0;
         if(this._timer.running)
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.onTick);
            this._timer.stop();
            this._timer = null;
         }
      }
   }
}

