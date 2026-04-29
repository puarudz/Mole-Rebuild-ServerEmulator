package com.module.throwThing
{
   import com.common.localTimer.localTimer;
   import com.event.EventTaomee;
   import fl.motion.BezierSegment;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   
   public class throwThingLogic extends EventDispatcher
   {
      
      public static var Throw_START:String = "throw_start";
      
      public static var Throw_TIMER:String = "throw_timer";
      
      public static var Throw_OVER:String = "throw_over";
      
      private var p2:Point = new Point();
      
      public var startPoint:Point = new Point();
      
      public var targetPoint:Point = new Point();
      
      private var bezier:BezierSegment;
      
      private var startpos:int = 0;
      
      private var time:Number = 100;
      
      private var degrees:Number = 0;
      
      public var MyID:localTimer;
      
      private var targetMC:*;
      
      public var D_time:int = 10;
      
      public var topSize:Number = 1;
      
      public function throwThingLogic()
      {
         super();
         this.MyID = new localTimer();
      }
      
      public function throwProp(mc:*, p1:Point, p3:Point) : void
      {
         var kuan:Number = NaN;
         this.targetPoint = p3;
         this.startPoint = p1;
         this.degrees = Math.atan2(p3.y - p1.y,p3.x - p1.x);
         this.time = 40 + Math.floor(Point.distance(p1,p3) / this.D_time / 3);
         this.time = int(this.time * 10) / 10;
         this.targetMC = mc;
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeHandler);
         this.MyID.addEventListener(TimerEvent.TIMER,this.doMotion);
         var dis:Number = Math.abs(p1.x - p3.x);
         this.p2.x = (p3.x + p1.x) / 2;
         var gao:Number = dis * 0.3 + 30 - Math.abs(p1.y - p3.y) / 400;
         gao /= this.topSize;
         if(p3.y < p1.y)
         {
            this.p2.y = p3.y - gao;
            kuan = (p1.y - p3.y) / 400 * Math.abs(p3.x - this.p2.x);
            if(p3.x < p1.x)
            {
               this.p2.x -= kuan;
            }
            else
            {
               this.p2.x += kuan;
            }
         }
         else
         {
            this.p2.y = p1.y - gao;
            kuan = (p3.y - p1.y) / 400 * Math.abs(p3.x - this.p2.x);
            if(p3.x < p1.x)
            {
               this.p2.x += kuan;
            }
            else
            {
               this.p2.x -= kuan;
            }
         }
         this.bezier = new BezierSegment(p1,this.p2,this.p2,p3);
         this.startpos = 0;
         this.domo();
      }
      
      public function removeHandler(e:Event) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeHandler);
         this.MyID.stop();
         this.MyID.removeEventListener(TimerEvent.TIMER,this.doMotion);
      }
      
      public function domo() : void
      {
         this.MyID.start(30);
         dispatchEvent(new EventTaomee(Throw_START,this.targetMC));
      }
      
      public function doMotion(e:Event) : void
      {
         var tt:Number = NaN;
         var bp:Point = null;
         var temp2Prop:MovieClip = null;
         if(this.startpos < this.time - 1)
         {
            ++this.startpos;
            tt = this.startpos / this.time;
            bp = this.bezier.getValue(tt);
            this.targetMC.x = bp.x;
            this.targetMC.y = bp.y;
            dispatchEvent(new EventTaomee(Throw_TIMER,{
               "targetMC":this.targetMC,
               "time":tt,
               "degrees":this.degrees
            }));
         }
         else
         {
            this.MyID.stop();
            try
            {
               temp2Prop = this.targetMC.getChildAt(0).getChildAt(0) as MovieClip;
               temp2Prop.gotoAndStop(3);
            }
            catch(E:*)
            {
            }
            this.startpos = 0;
            dispatchEvent(new EventTaomee(Throw_OVER,this.targetMC));
            GV.onlineSocket.dispatchEvent(new EventTaomee(Throw_OVER,this.targetMC));
            if(this.topSize == 1)
            {
               throwHitTest.throwObj.dispatchEvent(new EventTaomee("hitTest",{
                  "po":this.targetPoint,
                  "id":this.targetMC.Throw_selected,
                  "mc":this.targetMC,
                  "userID":this.targetMC.userID
               }));
            }
         }
      }
   }
}

