package com.logic.active
{
   import com.common.Tween.TweenLite;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.event.EventTaomee;
   import com.logic.MapManageLogic.MapDepthManageLogic;
   import com.logic.mapEvent.MapEvent;
   import com.mole.app.utils.Tool;
   import fl.motion.easing.Linear;
   import flash.display.MovieClip;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class FlowerVehicleActy
   {
      
      private static var _inst:FlowerVehicleActy;
      
      private var _flag:uint = 0;
      
      private var type:int = 3327;
      
      private var dayType:int = 31732;
      
      private var mapIndex:int = -1;
      
      private var gotPrize:Boolean = false;
      
      private var mapArr:Array = [1,3,2];
      
      private var nodeArr:Array = [[{
         "pt":{
            "x":820,
            "y":435
         },
         "frame":2
      },{
         "pt":{
            "x":484,
            "y":435
         },
         "frame":2
      },{
         "pt":{
            "x":153,
            "y":435
         },
         "frame":2
      }],[{
         "pt":{
            "x":769,
            "y":369
         },
         "frame":2
      },{
         "pt":{
            "x":489,
            "y":378
         },
         "frame":2
      },{
         "pt":{
            "x":262,
            "y":378
         },
         "frame":2
      }],[{
         "pt":{
            "x":820,
            "y":435
         },
         "frame":2
      },{
         "pt":{
            "x":484,
            "y":435
         },
         "frame":4
      },{
         "pt":{
            "x":291,
            "y":302
         },
         "frame":4
      }]];
      
      private var timer:uint;
      
      private var vehicleLoaded:Boolean = false;
      
      private var vehicle:MovieClip;
      
      public function FlowerVehicleActy()
      {
         super();
      }
      
      public static function get inst() : FlowerVehicleActy
      {
         if(_inst == null)
         {
            _inst = new FlowerVehicleActy();
         }
         return _inst;
      }
      
      public function init() : void
      {
         BC.addEvent(_inst,GV.onlineSocket,MapEvent.CHANGE_MAP_COMPLETE,this.onChangeMapOver);
         BC.addEvent(_inst,GV.onlineSocket,MapEvent.READY_CHANGE_MAP,this.onLeaveMap);
      }
      
      private function onChangeMapOver(e:EventTaomee) : void
      {
         var day:int = ServerUpTime.getInstance().date.date;
         var mapID:int = LocalUserInfo.getMapID();
         if(day == 28)
         {
            this.mapIndex = 0;
         }
         if(day == 29)
         {
            this.mapIndex = 1;
         }
         if(day == 30)
         {
            this.mapIndex = 2;
         }
         if(this.mapIndex > -1)
         {
            if(this.mapArr[this.mapIndex] == mapID)
            {
               this.timer = setInterval(this.tick,1000);
            }
         }
      }
      
      private function tick() : void
      {
         var min:int = 0;
         var i:uint = 0;
         var mapID:int = 0;
         var resID:int = 0;
         var mc:MovieClip = null;
         var xDis:Number = NaN;
         var yDis:Number = NaN;
         var hour:int = ServerUpTime.getInstance().getMoleHours % 24;
         min = ServerUpTime.getInstance().date.minutes;
         var sec:int = ServerUpTime.getInstance().date.seconds;
         if(hour == 13 || hour == 15 || hour == 18 || hour == 20)
         {
            if(min < 2)
            {
               i = uint(this.mapIndex);
               mapID = LocalUserInfo.getMapID();
               if(!this.vehicleLoaded)
               {
                  this.vehicleLoaded = true;
                  resID = int(DownLoadManager.add("module/external/exeModule/201309/vehicle.swf",ResType.DISPLAY_OBJECT));
                  DownLoadManager.addEvent(resID,this.loadVehicleOver);
               }
               else if(Boolean(this.vehicle))
               {
                  this.vehicle.visible = true;
                  mc = this.vehicle.getChildAt(0) as MovieClip;
                  if(sec <= 30 && min < 1)
                  {
                     xDis = (this.nodeArr[i][1].pt.x - this.nodeArr[i][0].pt.x) / 30;
                     yDis = (this.nodeArr[i][1].pt.y - this.nodeArr[i][0].pt.y) / 30;
                     this.vehicle.x = xDis * sec + this.nodeArr[i][0].pt.x;
                     this.vehicle.y = yDis * sec + this.nodeArr[i][0].pt.y;
                     this.vehicle.gotoAndStop(this.nodeArr[i][0].frame);
                     mc.gotoAndStop(1);
                  }
                  else if(sec > 30 && min < 1)
                  {
                     xDis = (this.nodeArr[i][2].pt.x - this.nodeArr[i][1].pt.x) / 30;
                     yDis = (this.nodeArr[i][2].pt.y - this.nodeArr[i][1].pt.y) / 30;
                     TweenLite.to(this.vehicle,1,{
                        "x":this.vehicle.x + xDis,
                        "y":this.vehicle.y + yDis,
                        "ease":Linear.easeNone
                     });
                     if(this.vehicle.x <= this.nodeArr[i][2].pt.x)
                     {
                        this.vehicle.visible = false;
                     }
                     this.vehicle.gotoAndStop(this.nodeArr[i][1].frame);
                     mc.gotoAndStop(1);
                  }
                  else
                  {
                     this.vehicle.x = this.nodeArr[i][1].pt.x;
                     this.vehicle.y = this.nodeArr[i][1].pt.y;
                     mc.gotoAndStop(2);
                     if(!this.gotPrize)
                     {
                        this.gotPrize = true;
                        Tool.finishSomething(this.dayType,this.getDoneTimesOver);
                     }
                  }
               }
            }
         }
      }
      
      private function getDoneTimesOver(doneTimes:int) : void
      {
         var hour:int = 0;
         if(doneTimes < 4)
         {
            hour = ServerUpTime.getInstance().getMoleHours % 24;
            Tool.exchangeGoods(this.type);
         }
         this.vehicle.visible = false;
      }
      
      private function loadVehicleOver(e:DownLoadEvent) : void
      {
         var mapID:int;
         var hour:int;
         var min:int;
         var sec:int;
         var fun:Function;
         var xDis:Number = NaN;
         var yDis:Number = NaN;
         var i:uint = uint(this.mapIndex);
         this.vehicle = (e.data as MovieClip).getChildAt(0) as MovieClip;
         mapID = LocalUserInfo.getMapID();
         hour = ServerUpTime.getInstance().getMoleHours % 24;
         min = ServerUpTime.getInstance().date.minutes;
         sec = ServerUpTime.getInstance().date.seconds;
         if(min < 1 && sec <= 30)
         {
            xDis = (this.nodeArr[i][1].pt.x - this.nodeArr[i][0].pt.x) / 30;
            yDis = (this.nodeArr[i][1].pt.y - this.nodeArr[i][0].pt.y) / 30;
            this.vehicle.x = xDis * sec + this.nodeArr[i][0].pt.x;
            this.vehicle.y = yDis * sec + this.nodeArr[i][0].pt.y;
         }
         else if(min < 1 && sec > 30)
         {
            xDis = (this.nodeArr[i][2].pt.x - this.nodeArr[i][1].pt.x) / 30;
            yDis = (this.nodeArr[i][2].pt.y - this.nodeArr[i][1].pt.y) / 30;
         }
         else
         {
            this.vehicle.x = this.nodeArr[i][1].pt.x;
            this.vehicle.y = this.nodeArr[i][1].pt.y;
         }
         GV.MC_mapFrame["depth_mc"].addChild(this.vehicle);
         fun = function(evt:*):void
         {
            var f:Function = evt.EventObj as Function;
            f([vehicle]);
         };
         BC.addEvent(this.vehicle,MapDepthManageLogic.owner,MapDepthManageLogic.ADD_ARRAY,fun);
      }
      
      private function onLeaveMap(e:EventTaomee) : void
      {
         this.destroy();
      }
      
      public function destroy() : void
      {
         if(Boolean(this.vehicle))
         {
            BC.removeEvent(this.vehicle);
         }
         this.gotPrize = false;
         clearInterval(this.timer);
         this.vehicleLoaded = false;
         this.vehicle = null;
      }
   }
}

