package com.logic.CarGameLogic
{
   import com.event.EventTaomee;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class CarGameTimeCotrol
   {
      
      private static var instance:CarGameTimeCotrol;
      
      public static var CURRENTCOUNT:String = "currentCount";
      
      private var timer:Timer;
      
      private var timerCount:uint = 0;
      
      public function CarGameTimeCotrol()
      {
         super();
      }
      
      public static function getInstance() : CarGameTimeCotrol
      {
         if(instance == null)
         {
            instance = new CarGameTimeCotrol();
         }
         return instance;
      }
      
      public function startGameTime() : void
      {
         if(this.timer == null)
         {
            this.timer = new Timer(1000);
         }
         this.timer.addEventListener(TimerEvent.TIMER,this.timerHandler);
         this.timer.reset();
         this.timer.start();
      }
      
      private function timerHandler(event:TimerEvent) : void
      {
         this.timerCount = this.timer.currentCount;
         GV.onlineSocket.dispatchEvent(new EventTaomee(CURRENTCOUNT,{"timeNum":this.timerCount}));
      }
      
      public function pauseGameTime() : void
      {
         if(Boolean(this.timer))
         {
            this.timer.stop();
         }
      }
      
      public function keepGameTime() : void
      {
         if(Boolean(this.timer))
         {
            this.timer.start();
         }
      }
      
      public function getMyGameTime() : uint
      {
         return this.timerCount;
      }
      
      public function clearGameTime() : void
      {
         if(Boolean(this.timer))
         {
            this.timer.stop();
            this.timer.reset();
            this.timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
         }
      }
   }
}

