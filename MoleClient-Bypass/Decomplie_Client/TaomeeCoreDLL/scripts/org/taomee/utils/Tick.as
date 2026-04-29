package org.taomee.utils
{
   import flash.display.Shape;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class Tick
   {
      
      private static var _instance:Tick;
      
      public static var timeScaleAll:Number = 1;
      
      private static var _o:Shape = new Shape();
      
      public var timeScale:Number = 1;
      
      private var _running:Boolean;
      
      private var _nextTime:Number;
      
      private var _prevTime:Number;
      
      private var _valueTime:uint;
      
      private var _renderMap:Dictionary = new Dictionary();
      
      private var _timeoutMap:Dictionary = new Dictionary();
      
      private var _renderoutMap:Dictionary = new Dictionary();
      
      private var _renderLength:int;
      
      private var _timeoutLength:int;
      
      private var _renderoutLength:int;
      
      public function Tick()
      {
         super();
      }
      
      public static function get instance() : Tick
      {
         if(_instance == null)
         {
            _instance = new Tick();
            _instance.start();
         }
         return _instance;
      }
      
      public function dispose() : void
      {
         this.stop();
         this._renderMap = null;
         this._timeoutMap = null;
         this._renderoutMap = null;
      }
      
      public function start() : void
      {
         _o.addEventListener(Event.ENTER_FRAME,this.onEnter);
      }
      
      public function stop() : void
      {
         _o.removeEventListener(Event.ENTER_FRAME,this.onEnter);
      }
      
      public function addRender(fun:Function, interval:int = 0) : void
      {
         if(fun in this._renderMap == false)
         {
            this._renderMap[fun] = new TimeoutInfo(interval);
            ++this._renderLength;
         }
      }
      
      public function removeRender(fun:Function) : void
      {
         if(fun in this._renderMap)
         {
            delete this._renderMap[fun];
            --this._renderLength;
         }
      }
      
      public function hasRender(fun:Function) : Boolean
      {
         return fun in this._renderMap;
      }
      
      public function addRenderAndOut(duration:uint, fun:Function) : void
      {
         if(fun in this._renderoutMap == false)
         {
            this._renderoutMap[fun] = new TimeoutInfo(duration);
            ++this._renderoutLength;
         }
      }
      
      public function removeRenderAndOut(fun:Function) : void
      {
         if(fun in this._renderoutMap)
         {
            delete this._renderoutMap[fun];
            --this._renderoutLength;
         }
      }
      
      public function hasRenderAndOut(fun:Function) : Boolean
      {
         return fun in this._renderoutMap;
      }
      
      public function addTimeout(delay:uint, fun:Function) : void
      {
         if(fun in this._timeoutMap == false)
         {
            this._timeoutMap[fun] = new TimeoutInfo(delay);
            ++this._timeoutLength;
         }
      }
      
      public function removeTimeout(fun:Function) : void
      {
         if(fun in this._timeoutMap)
         {
            delete this._timeoutMap[fun];
            --this._timeoutLength;
         }
      }
      
      public function hasTimeout(fun:Function) : Boolean
      {
         return fun in this._timeoutMap;
      }
      
      private function onEnter(event:Event) : void
      {
         this._nextTime = new Date().time;
         if(this._prevTime > 0)
         {
            this._valueTime = (this._nextTime - this._prevTime) * this.timeScale * timeScaleAll;
            this.onRender();
            this.onTimeout();
            this.onRenderAndOut();
         }
         this._prevTime = this._nextTime;
      }
      
      private function onRender() : void
      {
         var info:TimeoutInfo = null;
         var fun:* = undefined;
         if(this._renderLength > 0)
         {
            for(fun in this._renderMap)
            {
               info = this._renderMap[fun];
               if(info.delay > 0)
               {
                  if(info.count >= info.delay)
                  {
                     fun(info.count);
                     info.count %= info.delay;
                  }
               }
               else
               {
                  fun(this._valueTime);
               }
               info.count += this._valueTime;
            }
         }
      }
      
      private function onTimeout() : void
      {
         var info:TimeoutInfo = null;
         var fun:* = undefined;
         if(this._timeoutLength > 0)
         {
            for(fun in this._timeoutMap)
            {
               info = this._timeoutMap[fun];
               if(info.count >= info.delay)
               {
                  delete this._timeoutMap[fun];
                  --this._timeoutLength;
                  fun();
               }
               else
               {
                  info.count += this._valueTime;
               }
            }
         }
      }
      
      private function onRenderAndOut() : void
      {
         var info:TimeoutInfo = null;
         var fun:* = undefined;
         if(this._renderoutLength > 0)
         {
            for(fun in this._renderoutMap)
            {
               info = this._renderoutMap[fun];
               if(info.count >= info.delay)
               {
                  delete this._renderoutMap[fun];
                  --this._renderoutLength;
                  fun(true);
               }
               else
               {
                  fun(false);
                  info.count += this._valueTime;
               }
            }
         }
      }
   }
}

class TimeoutInfo
{
   
   public var count:uint;
   
   public var delay:uint;
   
   public function TimeoutInfo(delay:uint)
   {
      super();
      this.delay = delay;
   }
}
