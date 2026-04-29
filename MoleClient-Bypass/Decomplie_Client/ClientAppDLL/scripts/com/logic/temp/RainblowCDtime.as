package com.logic.temp
{
   import com.common.Alert.Alert;
   import com.global.staticData.CommandID;
   import com.logic.socket.raimblowLoL.GetLollipopsProtocol;
   import com.mole.app.manager.OnlineManager;
   import com.mole.net.events.SocketEvent;
   import com.view.MapManageView.MapManageView;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class RainblowCDtime
   {
      
      private static var _inself:RainblowCDtime;
      
      private var _arr:Array = new Array(0,0,0,0,0,0,0);
      
      private var _timer:Timer = new Timer(1000);
      
      private var _isStart:Boolean;
      
      private var _sceneID:uint;
      
      public function RainblowCDtime()
      {
         super();
         OnlineManager.addCmdListener(CommandID.LOLLIPS_RAINBLOW_GET,this.ongetLolHandle);
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimesHandle);
      }
      
      public static function get init() : RainblowCDtime
      {
         if(_inself == null)
         {
            _inself = new RainblowCDtime();
         }
         return _inself;
      }
      
      private function ongetLolHandle(e:SocketEvent) : void
      {
         var itemPro:GetLollipopsProtocol = e.bodyInfo;
         var flag:uint = itemPro.flag;
         var index:uint = itemPro.index;
         var arr:Array = new Array("紅","橙","黃","綠","青","藍","紫");
         if(flag == 0)
         {
            this.beginCD(index - 1);
            Alert.smileAlart("  你獲得了一個" + arr[index - 1] + "色迷你波板糖！去漿果叢林交給小丑吧！");
         }
         if(flag == 1)
         {
            Alert.smileAlart("  這個顏色的糖你已經拿到上限25個了，去找找別的顏色吧！");
         }
      }
      
      private function onTimesHandle(e:TimerEvent) : void
      {
         var mc:MovieClip = MapManageView.inst.mapLevel.controlLevel["lollipops"];
         var count:uint = 0;
         if(Boolean(mc))
         {
            if(this._arr[this.getMapID()] > 0)
            {
               mc.visible = false;
               mc.mouseEnabled = mc.mouseChildren = false;
            }
            else
            {
               mc.mouseEnabled = mc.mouseChildren = true;
               mc.visible = true;
            }
         }
         for(var i:uint = 0; i < 7; i++)
         {
            if(this._arr[i] > 0)
            {
               --this._arr[i];
            }
            else
            {
               count++;
            }
         }
         if(count == 7)
         {
            this._timer.stop();
         }
      }
      
      private function getMapID() : uint
      {
         var arr:Array = new Array(2,10,9,112,28,8,204);
         var id:uint = 0;
         if(Boolean(MapManageView.inst.mapControl))
         {
            id = MapManageView.inst.mapControl.mapID;
         }
         this._sceneID = arr.indexOf(id);
         return this._sceneID;
      }
      
      public function beginCD(index:uint) : void
      {
         this._arr[index] = 60;
         this._timer.start();
      }
      
      public function get CDtimeInfo() : Array
      {
         return this._arr;
      }
   }
}

