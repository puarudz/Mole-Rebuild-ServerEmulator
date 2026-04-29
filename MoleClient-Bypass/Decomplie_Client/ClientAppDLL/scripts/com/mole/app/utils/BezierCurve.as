package com.mole.app.utils
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class BezierCurve
   {
      
      public function BezierCurve()
      {
         super();
      }
      
      public static function cubic_curve(mc:DisplayObject, pt0:Point, pt1:Point, pt2:Point, complete:Function = null, param:Array = null, step:Number = 0.03) : void
      {
         var pos_x:Number = NaN;
         var pos_y:Number = NaN;
         var i:Number = NaN;
         var tFunc:Function = null;
         mc.x = pt0.x;
         mc.y = pt0.y;
         i = 0;
         tFunc = function(e:Event):void
         {
            mc.x = Math.pow(1 - i,2) * pt0.x + 2 * i * (1 - i) * pt1.x + Math.pow(i,2) * pt2.x;
            mc.y = Math.pow(1 - i,2) * pt0.y + 2 * i * (1 - i) * pt1.y + Math.pow(i,2) * pt2.y;
            i += step;
            if(int(i) >= 1)
            {
               mc.removeEventListener(Event.ENTER_FRAME,tFunc);
               if(complete != null)
               {
                  complete.apply(null,param);
               }
            }
         };
         mc.addEventListener(Event.ENTER_FRAME,tFunc);
      }
   }
}

