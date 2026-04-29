package
{
   import com.common.util.DisplayUtil;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   
   public class GC
   {
      
      public function GC()
      {
         super();
      }
      
      public static function clear() : void
      {
      }
      
      public static function stopAllMC(mc:*) : void
      {
         DisplayUtil.stopAllMovieClip(mc as DisplayObjectContainer);
      }
      
      public static function clearChildren(mc:*) : void
      {
         DisplayUtil.removeAllChild(mc as DisplayObjectContainer);
      }
      
      public static function clearAllChildren(mc:*) : void
      {
         DisplayUtil.removeAllChild(mc as DisplayObjectContainer);
      }
      
      public static function clearAll(mc:*, allBool:Boolean = true) : void
      {
         DisplayUtil.removeForParent(mc as DisplayObject,allBool);
      }
      
      public static function setGTimeout(closure:Function, delay:Number, ... vars) : Timer
      {
         return getTimerInstance(closure,delay,1,vars);
      }
      
      public static function clearGTimeout(timer:Timer) : void
      {
         BC.removeEvent(timer);
         if(Boolean(timer))
         {
            timer.stop();
            timer = null;
         }
      }
      
      public static function setGInterval(closure:Function, delay:*, ... vars) : Timer
      {
         var num:uint = 0;
         var ta:Array = null;
         if(Boolean(delay as String) && delay.indexOf(":") > -1)
         {
            ta = delay.split(":");
            num = uint(int(ta[1]));
            delay = int(ta[0]);
         }
         else
         {
            num = 0;
         }
         return getTimerInstance(closure,delay,num,vars);
      }
      
      public static function clearGInterval(timer:Timer) : void
      {
         BC.removeEvent(timer);
         if(Boolean(timer))
         {
            timer.stop();
            timer = null;
         }
      }
      
      public static function clearAllTimer() : void
      {
         clearAllTimeout();
         clearAllInterval();
      }
      
      public static function clearAllTimeout() : void
      {
         var timeoutNum:uint = 0;
         timeoutNum = setTimeout(function():void
         {
            var i:*;
            timeoutNum = setTimeout(function():void
            {
            },0);
            for(i = 1; i <= timeoutNum; i++)
            {
               clearTimeout(i);
            }
         },0);
      }
      
      public static function clearAllInterval() : void
      {
         var timeoutNum:uint = 0;
         timeoutNum = setInterval(function():void
         {
            var i:*;
            timeoutNum = setInterval(function():void
            {
            },0);
            for(i = 1; i <= timeoutNum; i++)
            {
               clearInterval(i);
            }
         },0);
      }
      
      private static function getTimerInstance(closure:Function, delay:Number, repeatCount:uint, vars:Array) : Timer
      {
         var tempTimer:Timer = null;
         tempTimer = new Timer(delay,repeatCount);
         BC.addEvent(tempTimer,tempTimer,TimerEvent.TIMER,function(e:TimerEvent):void
         {
            if(repeatCount != 0 && tempTimer.currentCount == tempTimer.repeatCount)
            {
               clearGTimeout(tempTimer);
            }
            closure.apply(this,vars);
         });
         tempTimer.start();
         return tempTimer;
      }
   }
}

