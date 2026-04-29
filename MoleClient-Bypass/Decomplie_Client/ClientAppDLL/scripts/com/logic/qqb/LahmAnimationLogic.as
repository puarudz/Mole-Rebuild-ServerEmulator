package com.logic.qqb
{
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   
   public class LahmAnimationLogic
   {
      
      private var lahmMC:MovieClip;
      
      private var isStart:Boolean = false;
      
      private var array:Array = ["left","right","left_b","right_b","tired","huang"];
      
      private var oldStatus:String;
      
      public function LahmAnimationLogic(mc:MovieClip)
      {
         super();
         this.lahmMC = mc;
      }
      
      public function stop() : void
      {
         this.lahmMC.gotoAndPlay("no_people");
         this.isStart = false;
      }
      
      public function clear() : void
      {
         this.lahmMC = null;
      }
      
      public function left() : void
      {
         if(this.oldStatus != "left")
         {
            this.lahmMC.gotoAndPlay("left");
            this.oldStatus = "left";
         }
      }
      
      public function right() : void
      {
         if(this.oldStatus != "right")
         {
            this.lahmMC.gotoAndPlay("right");
            this.oldStatus = "right";
         }
      }
      
      public function tired() : void
      {
         if(this.oldStatus != "tired")
         {
            this.lahmMC.gotoAndPlay("tired");
            this.oldStatus = "tired";
         }
      }
      
      private function timerHandler(event:TimerEvent) : void
      {
         var num:Number = Math.floor(Math.random() * this.array.length);
         this.lahmMC.gotoAndPlay(this.array[num]);
      }
      
      public function getIsStart() : Boolean
      {
         return this.isStart;
      }
   }
}

