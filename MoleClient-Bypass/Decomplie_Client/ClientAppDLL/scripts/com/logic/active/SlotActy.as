package com.logic.active
{
   import com.common.util.DisplayUtil;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.logic.mapEvent.MapEvent;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.utils.Tool;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class SlotActy
   {
      
      private static var _inst:SlotActy;
      
      private var mapArrX:Array = [[330,204,42,41,112,53,52,81,77,68],[28,65,1,15,16,32,33,109,229,110],[5,4,40,34,37,75,143,76,19,21],[20,142,149,60,150,147,203,3,178,50],[31,176,8,22,36,47,7,24,38,6]];
      
      private var mapArr:Array;
      
      private var type:int = 132;
      
      private var dayType:int = 30104;
      
      private var timer:uint;
      
      public function SlotActy()
      {
         super();
      }
      
      public static function get inst() : SlotActy
      {
         if(_inst == null)
         {
            _inst = new SlotActy();
         }
         return _inst;
      }
      
      public function init() : void
      {
         this.timer = setTimeout(this.tick,2000);
      }
      
      private function tick() : void
      {
         var dayIndex:int = 0;
         clearTimeout(this.timer);
         var day:int = ServerUpTime.getInstance().date.date;
         if(day >= 27)
         {
            dayIndex = day - 27;
         }
         else
         {
            dayIndex = (day - 2) % 5;
            if(day == 1)
            {
               dayIndex = 4;
            }
         }
         this.mapArr = this.mapArrX[dayIndex];
         BC.addEvent(this,GV.onlineSocket,MapEvent.CHANGE_MAP_COMPLETE,this.onChangeMapOver);
         BC.addEvent(this,GV.onlineSocket,MapEvent.READY_CHANGE_MAP,this.onLeaveMap);
      }
      
      private function onLeaveMap(e:EventTaomee) : void
      {
         this.destroy();
      }
      
      private function onChangeMapOver(e:EventTaomee) : void
      {
         var mapID:int = LocalUserInfo.getMapID();
         for(var i:int = 0; i < this.mapArr.length; i++)
         {
            if(mapID == this.mapArr[i])
            {
               Tool.finishSomething(this.dayType + i,this.getDoneTimesOver);
               break;
            }
         }
      }
      
      private function getDoneTimesOver(doneTimes:int) : void
      {
         var resID:int = 0;
         if(doneTimes == 0)
         {
            resID = int(DownLoadManager.add("module/external/exeModule/201309/tigerIcon.swf",ResType.DISPLAY_OBJECT));
            DownLoadManager.addEvent(resID,this.loadTigerOver);
         }
      }
      
      private function loadTigerOver(e:DownLoadEvent) : void
      {
         var tiger:SimpleButton = (e.data as MovieClip).getChildAt(0) as SimpleButton;
         LevelManager.mapLevel.addChild(tiger);
         tiger.x = GV.MAN_PEOPLE.x;
         tiger.y = GV.MAN_PEOPLE.y;
         BC.addEvent(this,tiger,MouseEvent.CLICK,this.openTigerPanel);
      }
      
      public function destroy() : void
      {
         clearTimeout(this.timer);
      }
      
      private function openTigerPanel(e:MouseEvent) : void
      {
         BC.removeEvent(this,e.currentTarget,MouseEvent.CLICK,this.openTigerPanel);
         DisplayUtil.removeForParent(e.currentTarget as SimpleButton);
         var mapID:int = LocalUserInfo.getMapID();
         for(var i:int = 0; i < this.mapArr.length; i++)
         {
            if(mapID == this.mapArr[i])
            {
               ModuleManager.openPanel("TigerPanel",this.type + i);
               break;
            }
         }
      }
   }
}

