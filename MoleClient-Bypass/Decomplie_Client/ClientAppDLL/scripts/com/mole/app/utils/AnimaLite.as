package com.mole.app.utils
{
   import com.common.Tween.TweenLite;
   import fl.motion.easing.Cubic;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   
   public class AnimaLite
   {
      
      public function AnimaLite()
      {
         super();
      }
      
      public static function FadeIn(dis:DisplayObject, duration:Number = 0.5, onComplete:Function = null, onStart:Function = null) : void
      {
         dis.alpha = 0;
         dis.visible = true;
         new TweenLite(dis,duration,{
            "alpha":1,
            "onComplete":onComplete,
            "onStart":onStart
         });
      }
      
      public static function FadeOut(dis:DisplayObject, duration:Number = 0.5, onComplete:Function = null, onCompleteParams:Array = null, onStart:Function = null, onStartParams:Array = null) : void
      {
         dis.alpha = 1;
         dis.visible = true;
         new TweenLite(dis,duration,{
            "alpha":0,
            "onComplete":onComplete,
            "onCompleteParams":onCompleteParams,
            "onStart":onStart,
            "onStartParams":onStartParams
         });
      }
      
      public static function PanelAppear(dis:DisplayObject, duration:Number = 0.5, scaleFrom:Number = 0.7, onComplete:Function = null, onCompleteParams:Array = null, onStart:Function = null, onStartParams:Array = null) : void
      {
         dis.scaleX = scaleFrom;
         dis.scaleY = scaleFrom;
         dis.alpha = 0;
         dis.visible = true;
         new TweenLite(dis,duration,{
            "alpha":1,
            "scaleX":1,
            "scaleY":1,
            "ease":Cubic.easeIn,
            "onComplete":onComplete,
            "onCompleteParams":onCompleteParams,
            "onStart":onStart,
            "onStartParams":onStartParams
         });
      }
      
      public static function autoBubble(mc:*, time:Number = 3, backMovie:Boolean = true, startTime:Number = 0.3) : void
      {
         var mc_txt:DisplayObject = null;
         var tFunc2:Function = null;
         var tFunc:Function = null;
         if(mc is DisplayObjectContainer)
         {
            mc.visible = true;
            mc.scaleX = 0;
            mc.scaleY = 0;
            mc_txt = mc.getChildAt(mc.numChildren - 1) as DisplayObject;
            mc_txt.visible = false;
            tFunc2 = function():void
            {
               if(backMovie)
               {
                  mc_txt.visible = false;
                  new TweenLite(mc,0.3,{
                     "scaleX":0,
                     "scaleY":0,
                     "ease":Cubic.easeIn
                  });
               }
               else
               {
                  mc.visible = false;
               }
            };
            tFunc = function():void
            {
               mc_txt.visible = true;
               new TweenLite(mc,time,{"onComplete":tFunc2});
            };
            new TweenLite(mc,startTime,{
               "scaleX":1,
               "scaleY":1,
               "ease":Cubic.easeIn,
               "onComplete":tFunc
            });
         }
      }
   }
}

