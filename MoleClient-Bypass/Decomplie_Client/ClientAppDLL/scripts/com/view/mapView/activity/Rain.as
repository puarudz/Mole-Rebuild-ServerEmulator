package com.view.mapView.activity
{
   import com.core.manager.LevelManager;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   
   public class Rain extends MovieClip
   {
      
      private static var _inst:Rain;
      
      private var nXDif:Number;
      
      private var nYDif:Number;
      
      private var iRotDegrees:int;
      
      private var nRotRadians:Number;
      
      private var iRotVariance:int;
      
      private var iLen:int;
      
      private var iTime:int;
      
      private var iDrops:int;
      
      private var iDropLengthMin:int;
      
      private var iDropLengthRnd:int;
      
      private var iDropStroke:int;
      
      private var iDropColor:uint;
      
      private var iDropAlpha:int;
      
      private var iYOffSetStart:int;
      
      private var iYOffSetRnd:int;
      
      private var nSpeed:Number;
      
      private var nSpeedVariance:Number;
      
      private var __displayList:Array;
      
      private var tRainTimer:Timer;
      
      public function Rain()
      {
         super();
         this.attach();
      }
      
      public static function get inst() : Rain
      {
         return _inst;
      }
      
      private function initVars() : void
      {
         this.__displayList = new Array();
      }
      
      public function attach() : void
      {
         this.iRotDegrees = 100;
         this.nRotRadians = this.iRotDegrees * Math.PI / 180;
         this.iRotVariance = 10;
         this.iLen = 1400;
         this.iTime = 15;
         this.iDrops = 10;
         this.iDropLengthMin = 5;
         this.iDropLengthRnd = 50;
         this.iDropStroke = 1.5;
         this.iDropColor = 13421772;
         this.iDropAlpha = 1;
         this.iYOffSetStart = -50;
         this.iYOffSetRnd = 100;
         this.nSpeed = 5;
         this.nSpeedVariance = 1.5;
         this.tRainTimer = new Timer(this.iTime,0);
         this.tRainTimer.addEventListener(TimerEvent.TIMER,this.rainTimerHandler);
         this.tRainTimer.start();
      }
      
      private function rainDelayStart() : void
      {
         var nStartDelay:Number = Math.random() * 25000;
         var nDuration:Number = 5000 + Math.random() * 35000;
         setTimeout(function():void
         {
            tRainTimer.start();
         },nStartDelay);
         setTimeout(function():void
         {
            tRainTimer.stop();
            rainDelayStart();
         },nStartDelay + nDuration);
      }
      
      private function addRain() : void
      {
         var tRotDegrees:Number = NaN;
         tRotDegrees = this.iRotDegrees + Math.random() * this.iRotVariance - this.iRotVariance / 2;
         var tRotRadians:Number = tRotDegrees * Math.PI / 180;
         var sRain:Sprite = new Sprite();
         sRain.graphics.lineStyle(this.iDropStroke,this.iDropColor,this.iDropAlpha,false);
         sRain.graphics.moveTo(0,0);
         sRain.graphics.lineTo(this.iDropLengthMin + Math.random() * this.iDropLengthRnd,0);
         sRain.x = LevelManager.stage.stageWidth / 2 + (Math.random() * (LevelManager.stage.stageWidth * 2) - LevelManager.stage.stageWidth);
         sRain.y = this.iYOffSetStart + Math.random() * this.iYOffSetRnd;
         sRain.rotation = tRotDegrees;
         addChild(sRain);
         this.nXDif = this.iLen * Math.cos(tRotRadians);
         this.nYDif = this.iLen * Math.sin(tRotRadians);
         TweenLite.to(sRain,this.nSpeed + (Math.random() * this.nSpeedVariance - this.nSpeedVariance / 2),{
            "alpha":0,
            "x":sRain.x + this.nXDif,
            "y":sRain.y + this.nYDif,
            "ease":Linear.easeNone,
            "onCompleteParams":[sRain],
            "onComplete":function(_scope:Sprite):void
            {
               removeChild(_scope);
            }
         });
      }
      
      private function rainTimerHandler(e:TimerEvent) : void
      {
         for(var iDrop:int = 0; iDrop < this.iDrops; iDrop++)
         {
            this.addRain();
         }
      }
      
      public function kill() : void
      {
         this.tRainTimer.stop();
         this.tRainTimer.removeEventListener(TimerEvent.TIMER,this.rainTimerHandler);
      }
   }
}

