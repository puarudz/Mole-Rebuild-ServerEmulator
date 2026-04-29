package com.view.mapView.activity
{
   import com.common.util.MovieClipUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class AirBallView
   {
      
      private var setMC:MovieClip;
      
      private var ballMC:MovieClip;
      
      private var ox:int = 0;
      
      private var oy:int = 0;
      
      private var xy:uint = 0;
      
      private var bln:uint = 0;
      
      public function AirBallView(set:MovieClip, ball:MovieClip)
      {
         super();
         this.setMC = set;
         this.ballMC = ball;
         this.setMC.gotoAndStop(1);
         this.ballMC.gotoAndStop(1);
      }
      
      public function initView() : void
      {
         this.setMC.gotoAndStop(1);
         this.ballMC.gotoAndStop(1);
      }
      
      public function stopView(str:String) : void
      {
         this.setMC.gotoAndStop(this.setMC.totalFrames);
         this.ballMC.gotoAndStop(this.ballMC.totalFrames);
      }
      
      public function playView(str:String) : void
      {
         if(str == "开始" || str == "待机" || str == "结束" || str == "失败")
         {
            str = "待机";
            this.setMC.gotoAndPlay(str);
            this.ballMC.gotoAndPlay(str);
         }
         else if(str == "放飞")
         {
            this.setMC.gotoAndPlay(str);
            MovieClipUtil.playEndAndFunc(this.setMC,function():void
            {
               setMC.gotoAndStop(setMC.totalFrames);
               ballMC.gotoAndPlay(str);
               movingBall();
            });
         }
      }
      
      private function movingBall() : void
      {
         this.ox = this.ballMC.x;
         this.oy = this.ballMC.y;
         this.bln = uint(Math.random() * 2);
         BC.addEvent(this,this.ballMC.stage,Event.ENTER_FRAME,this.flyBallMC);
      }
      
      private function flyBallMC(e:Event) : void
      {
         var xp:Number = 2;
         var yp:Number = 5 + 0.1 * uint(Math.random() * 10) / 10;
         if(this.ballMC.x > this.ox + 100 && this.xy == 0)
         {
            this.xy = 1;
         }
         if(this.xy == 1)
         {
            if(this.bln == 0)
            {
               this.ballMC.x -= xp;
            }
            else
            {
               this.ballMC.x += xp;
            }
         }
         else if(this.xy == 0)
         {
            if(this.bln == 0)
            {
               this.ballMC.x += xp;
            }
            else
            {
               this.ballMC.x -= xp;
            }
         }
         this.ballMC.y -= yp;
         if(this.ballMC.y < 0)
         {
            BC.removeEvent(this,this.ballMC.stage,Event.ENTER_FRAME,this.flyBallMC);
         }
      }
      
      public function destroy() : void
      {
         BC.removeEvent(this);
         if(this.ox != 0)
         {
            this.ballMC.x = this.ox;
            this.ballMC.y = this.oy;
         }
      }
   }
}

