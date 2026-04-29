package com.common.util
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class Tick
   {
      
      private static var _instance:Tick;
      
      private var _disObj:Sprite;
      
      private var _running:Boolean;
      
      private var _nextTime:Number;
      
      private var _prevTime:Number;
      
      private var _map:Dictionary = new Dictionary();
      
      public function Tick()
      {
         super();
         this._disObj = new Sprite();
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
      
      public function destroy() : void
      {
         this.stop();
         this._map = null;
      }
      
      public function get running() : Boolean
      {
         return this._running;
      }
      
      public function start() : void
      {
         if(!this._running)
         {
            this._disObj.addEventListener(Event.ENTER_FRAME,this.onTick);
            this._running = true;
         }
      }
      
      public function stop() : void
      {
         if(this._running)
         {
            this._disObj.removeEventListener(Event.ENTER_FRAME,this.onTick);
            this._running = false;
         }
      }
      
      public function addCallback(fun:Function) : void
      {
         this._map[fun] = true;
      }
      
      public function removeCallback(fun:Function) : void
      {
         if(fun in this._map)
         {
            delete this._map[fun];
         }
      }
      
      public function hasCallback(fun:Function) : Boolean
      {
         return fun in this._map;
      }
      
      private function onTick(e:Event) : void
      {
         var fun:* = undefined;
         this._nextTime = new Date().time;
         var disTime:Number = this._nextTime - this._prevTime;
         if(this._prevTime > 0)
         {
            for(fun in this._map)
            {
               fun(disTime);
            }
         }
         this._prevTime = this._nextTime;
      }
   }
}

