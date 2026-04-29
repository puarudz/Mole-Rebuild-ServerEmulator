package com.module.paopao.paopaoView
{
   import com.core.info.LocalUserInfo;
   import com.core.manager.IndexManager;
   import com.module.paopao.paopaoLogic.paopaoLogic;
   import fl.transitions.Tween;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class paopaoView extends Sprite
   {
      
      private var scaleNum:int = 0;
      
      private var PaoTimer:Timer;
      
      private var pao:MovieClip;
      
      private var paoarr:Array;
      
      private var time:Number;
      
      private var useID:*;
      
      private var falstr:String;
      
      public function paopaoView(arr:Array)
      {
         super();
         this.getServerData(arr);
      }
      
      public function getServerData(arr:Array) : void
      {
         var paopaoArray:Array = new Array();
         paopaoArray = arr;
         this.useID = paopaoArray[0];
         paopaoArray.shift();
         paopaoArray.shift();
         this.time = 200;
         this.show(paopaoArray,this.time);
      }
      
      private function show(obj:Array, t:Number) : void
      {
         var h:uint;
         var cuipaoTimer:Timer = null;
         var doover:Function = null;
         doover = function(e:TimerEvent):void
         {
            cuipaoTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,doover);
            pao = IndexManager.getInstance().getMovieClip("Pao");
            GV.MC_mapTop.addChild(pao);
            var i:uint = 0;
            fly(i);
         };
         this.paoarr = obj;
         for(h = 0; h < this.paoarr.length; h++)
         {
            if(h % 2 == 1)
            {
               this.paoarr[h] -= 36;
            }
         }
         cuipaoTimer = new Timer(t,1);
         cuipaoTimer.addEventListener(TimerEvent.TIMER_COMPLETE,doover);
         cuipaoTimer.start();
      }
      
      public function fly(i:uint) : void
      {
         var doover:Function = null;
         var mySx:Tween = null;
         var mySy:Tween = null;
         var myTweenxs:Tween = null;
         var myTweenys:Tween = null;
         var myTweenx:Tween = null;
         var myTweeny:Tween = null;
         doover = function(e:TimerEvent):void
         {
            var removePao:Function;
            if(i < paoarr.length - 4)
            {
               i += 2;
               fly(i);
            }
            else
            {
               removePao = function():void
               {
                  if(useID == LocalUserInfo.getUserID())
                  {
                     --paopaoLogic.myPaoNum;
                  }
                  GV.MC_mapTop.removeChild(pao);
                  pao = null;
               };
               pao.gotoAndStop(2);
               PaoTimer = new Timer(1000,1);
               PaoTimer.addEventListener(TimerEvent.TIMER_COMPLETE,removePao);
               PaoTimer.start();
            }
         };
         this.time = 2;
         this.PaoTimer = new Timer(this.time * 200,1);
         this.PaoTimer.addEventListener(TimerEvent.TIMER_COMPLETE,doover);
         this.PaoTimer.start();
         if(this.scaleNum < 2)
         {
            mySx = new Tween(this.pao,"scaleX",null,(60 + this.scaleNum * 10) / 100,(70 + this.scaleNum * 10) / 100,this.time * 200 / 1000,true);
            mySy = new Tween(this.pao,"scaleY",null,(60 + this.scaleNum * 10) / 100,(70 + this.scaleNum * 10) / 100,this.time * 200 / 1000,true);
            myTweenxs = new Tween(this.pao,"x",null,this.paoarr[i],this.paoarr[i + 2],this.time * 200 / 1000,true);
            myTweenys = new Tween(this.pao,"y",null,this.paoarr[1] - (this.paoarr[i + 1] - this.paoarr[1]),this.paoarr[1] - (this.paoarr[i + 3] - this.paoarr[1]),this.time * 200 / 1000,true);
         }
         else
         {
            myTweenx = new Tween(this.pao,"x",null,this.paoarr[i],this.paoarr[i + 2],this.time * 200 / 1000,true);
            myTweeny = new Tween(this.pao,"y",null,this.paoarr[1] - (this.paoarr[i + 1] - this.paoarr[1]),this.paoarr[1] - (this.paoarr[i + 3] - this.paoarr[1]),this.time * 200 / 1000,true);
         }
         this.scaleNum += 1;
      }
   }
}

