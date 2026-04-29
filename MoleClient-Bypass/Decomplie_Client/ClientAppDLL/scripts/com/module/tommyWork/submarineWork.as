package com.module.tommyWork
{
   import com.common.Alert.Alert;
   import com.common.util.DisplayUtil;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.socket.CSItems.exchange;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class submarineWork
   {
      
      private static var _instance:submarineWork;
      
      private var working:Boolean = false;
      
      private var petTimer:Timer;
      
      private var kaddish_mc:MovieClip;
      
      public function submarineWork()
      {
         super();
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeMap);
      }
      
      public static function instance() : submarineWork
      {
         if(_instance == null)
         {
            _instance = new submarineWork();
         }
         return _instance;
      }
      
      public function InitWork() : void
      {
         Alert.smileAlart("    恭喜你戰勝了海盜，是否要將材料運輸到儲存箱去？",this.sureToWork,"traffic");
      }
      
      private function sureToWork(event:*) : void
      {
         MoveTo.CanMove2 = false;
         GV.MAN_PEOPLE.visible = false;
         this.work();
      }
      
      private function work() : void
      {
         if(!this.working)
         {
            LevelManager.mapLevel.mouseChildren = false;
            LevelManager.mapLevel.mouseEnabled = false;
            this.petTimer = new Timer(30000,1);
            BC.addEvent(this,this.petTimer,TimerEvent.TIMER,this.kaddishSuc);
            this.petTimer.reset();
            this.petTimer.start();
            this.loadMoleWorking();
         }
      }
      
      private function kaddishEndHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this,this.petTimer);
         this.working = false;
         this.clearKaddish_mc();
         this.petTimer.stop();
      }
      
      private function loadMoleWorking() : void
      {
         var tempMC:Class = null;
         if(!this.working)
         {
            this.working = true;
            tempMC = GV.Lib_Map.getClass("mole_working") as Class;
            this.kaddish_mc = new tempMC();
            this.kaddish_mc.name = "kaddish_mc";
            this.kaddish_mc.x = 444;
            this.kaddish_mc.y = 248;
            GV.MC_mapFrame["depth_mc"].addChild(this.kaddish_mc);
         }
      }
      
      private function kaddishSuc(evt:TimerEvent) : void
      {
         this.clearKaddish_mc();
         this.working = false;
         MoveTo.CanMove2 = true;
         GV.MAN_PEOPLE.visible = true;
         LevelManager.mapLevel.mouseChildren = true;
         LevelManager.mapLevel.mouseEnabled = true;
         BC.addEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.onGetAwards);
         exchange.exchange_goods(1488);
      }
      
      private function onGetAwards(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.onGetAwards);
         Alert.smileAlart("    恭喜你完成運輸，趕快去製造潛艇零件吧！");
      }
      
      private function clearKaddish_mc() : void
      {
         if(Boolean(this.petTimer))
         {
            this.petTimer.stop();
         }
         BC.removeEvent(this,this.petTimer);
         GC.stopAllMC(this.kaddish_mc);
         GC.clearChildren(this.kaddish_mc);
         DisplayUtil.removeForParent(this.kaddish_mc);
         this.kaddish_mc = null;
      }
      
      private function removeMap(event:Event) : void
      {
         BC.removeEvent(this);
         this.clearKaddish_mc();
         this.working = false;
         if(Boolean(this.petTimer))
         {
            this.petTimer.stop();
         }
         this.petTimer = null;
         LevelManager.mapLevel.mouseChildren = true;
         LevelManager.mapLevel.mouseEnabled = true;
         _instance = null;
      }
   }
}

