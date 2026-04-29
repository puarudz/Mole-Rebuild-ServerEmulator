package com.module.pig.view.pig
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class PigActionCtl
   {
      
      private var _actions:Array;
      
      private var _endFun:Function;
      
      private var _timer:Timer;
      
      public function PigActionCtl()
      {
         super();
         this._timer = new Timer(10 * 1000,1);
         this._actions = new Array();
      }
      
      public function set endFun(fun:Function) : void
      {
         this._endFun = fun;
      }
      
      public function get actionCount() : int
      {
         return this._actions.length;
      }
      
      public function AddAction(fun:Function, time:Number = -1) : void
      {
         this._actions.push({
            "fun":fun,
            "time":time
         });
      }
      
      public function RemoveAllAction() : void
      {
         this._actions = new Array();
         this.StopTimer();
      }
      
      private function StopTimer() : void
      {
         if(Boolean(this._timer))
         {
            BC.removeEvent(this,this._timer);
            this._timer.stop();
         }
      }
      
      public function Play(e:* = null) : void
      {
         var action:Object = null;
         if(this._actions.length > 0)
         {
            action = this._actions.shift();
            if(action.time > 0)
            {
               if(action.fun != null)
               {
                  action.fun();
               }
               this.StopTimer();
               this._timer.delay = action.time;
               this._timer.repeatCount = 1;
               BC.addEvent(this,this._timer,TimerEvent.TIMER_COMPLETE,this.Play);
               this._timer.start();
            }
            else if(action.time == 0)
            {
               if(action.fun != null)
               {
                  action.fun();
               }
               this.Play();
            }
            else if(action.fun != null)
            {
               action.fun();
            }
         }
         else
         {
            this.StopTimer();
            if(this._endFun != null)
            {
               this._endFun();
            }
         }
      }
      
      public function Clear() : void
      {
         this.RemoveAllAction();
         this._timer = null;
      }
   }
}

