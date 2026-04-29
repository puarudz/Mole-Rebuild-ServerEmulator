package com.common.localTimer
{
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class localTimer extends EventDispatcher
   {
      
      public var startTimer:int;
      
      public var currentCount:uint = 0;
      
      public var repeatCount:int = 0;
      
      public var timeCount:int;
      
      public var delay:uint = 1000;
      
      public var running:Boolean = false;
      
      public var TimerArray:Array;
      
      private var mydelay:uint = 10;
      
      private var myTimer:Timer;
      
      public function localTimer(checkTime:int = 10, StartTimer:int = 0)
      {
         super();
         this.timeCount = checkTime;
         this.TimerArray = new Array();
         if(StartTimer > 0)
         {
            this.startTimer = StartTimer;
         }
         else
         {
            this.startTimer = new Date().valueOf();
         }
      }
      
      public function start(delayNum:uint = 1000, repeatCountNum:uint = 0) : void
      {
         this.delay = delayNum;
         this.currentCount = 0;
         this.repeatCount = repeatCountNum;
         this.startTimer = new Date().valueOf();
         try
         {
            if(this.myTimer.running)
            {
               this.myTimer.stop();
            }
         }
         catch(E:*)
         {
         }
         this.myTimer = new Timer(this.mydelay);
         if(this.repeatCount != 0)
         {
            this.myTimer.addEventListener(TimerEvent.TIMER,this.myTimer1);
         }
         else
         {
            this.myTimer.addEventListener(TimerEvent.TIMER,this.myTimer2);
         }
         this.running = true;
         this.myTimer.start();
      }
      
      public function stop() : void
      {
         try
         {
            if(this.repeatCount != 0)
            {
               this.myTimer.removeEventListener(TimerEvent.TIMER,this.myTimer1);
            }
            else
            {
               this.myTimer.removeEventListener(TimerEvent.TIMER,this.myTimer2);
            }
            this.myTimer.stop();
         }
         catch(E:*)
         {
         }
      }
      
      private function myTimer1(E:TimerEvent) : void
      {
         var tempTimer:uint = uint(this.getTimer() / this.delay);
         if(tempTimer != this.currentCount)
         {
            dispatchEvent(new TimerEvent(TimerEvent.TIMER));
            this.currentCount = tempTimer;
            if(this.currentCount == this.repeatCount)
            {
               dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
               this.stop();
               this.running = false;
            }
         }
      }
      
      public function myTimer2(E:TimerEvent) : void
      {
         var tempTimer:int = int(this.getTimer() / this.delay);
         if(tempTimer != this.currentCount)
         {
            dispatchEvent(new TimerEvent(TimerEvent.TIMER));
            this.currentCount = tempTimer;
         }
      }
      
      public function getAverageTimer() : int
      {
         var tempNum:Number = NaN;
         var num:Number = NaN;
         if(this.TimerArray.length > 0)
         {
            tempNum = 0;
            for each(num in this.TimerArray)
            {
               tempNum += num;
            }
            return tempNum / this.TimerArray.length;
         }
         return 0;
      }
      
      public function push(TimerPiece:Number) : int
      {
         this.TimerArray.push(TimerPiece);
         if(this.TimerArray.length > this.timeCount)
         {
            this.TimerArray.shift();
         }
         return this.getAverageTimer();
      }
      
      public function getTimer() : int
      {
         return this.getTheTimer(this.startTimer,new Date().valueOf());
      }
      
      private function getTheTimer(s1:int, s2:int) : int
      {
         return s2 - s1;
      }
      
      public function getDate() : int
      {
         return new Date().valueOf();
      }
   }
}

