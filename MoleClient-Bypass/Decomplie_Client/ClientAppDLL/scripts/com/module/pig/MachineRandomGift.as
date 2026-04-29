package com.module.pig
{
   import com.common.data.HashMap;
   import com.event.EventTaomee;
   import com.logic.socket.pig.PigSocket;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class MachineRandomGift
   {
      
      private static var _instance:MachineRandomGift;
      
      private var timer:Timer;
      
      private var ronglu:HashMap;
      
      private var jichuang:HashMap;
      
      public function MachineRandomGift()
      {
         super();
      }
      
      public static function get instance() : MachineRandomGift
      {
         if(_instance == null)
         {
            _instance = new MachineRandomGift();
         }
         return _instance;
      }
      
      public function Init() : void
      {
         BC.addEvent(this,PigEvent.instance,PigEvent.HAS_WORK_MACHINE,this.onAddWorker);
         BC.addEvent(this,PigEvent.instance,PigEvent.WORK_MACHINE_OVER,this.onRemoveWorker);
         this.ronglu = new HashMap();
         this.jichuang = new HashMap();
         this.timer = new Timer(30000);
         BC.addEvent(this,this.timer,TimerEvent.TIMER,this.onTimer);
      }
      
      private function onAddWorker(event:EventTaomee) : void
      {
         if(event.EventObj.type == 1)
         {
            this.ronglu.add(event.EventObj.index,event.EventObj.index);
         }
         else
         {
            this.jichuang.add(event.EventObj.index,event.EventObj.index);
         }
         if(!this.timer.running)
         {
            this.timer.reset();
            this.timer.start();
         }
      }
      
      private function onRemoveWorker(event:EventTaomee) : void
      {
         if(event.EventObj.type == 1)
         {
            this.ronglu.remove(event.EventObj.index);
         }
         else
         {
            this.jichuang.remove(event.EventObj.index);
         }
         if(Boolean(this.timer))
         {
            this.timer.stop();
            this.timer.reset();
         }
      }
      
      private function onTimer(event:TimerEvent) : void
      {
         PigSocket.MachineRandomGoods(MachinistSquareEntrance.instance.userId);
      }
      
      public function destroy() : void
      {
         BC.removeEvent(this);
         if(Boolean(this.timer))
         {
            this.timer.stop();
            this.timer = null;
         }
         this.ronglu = null;
         this.jichuang = null;
         _instance = null;
      }
   }
}

