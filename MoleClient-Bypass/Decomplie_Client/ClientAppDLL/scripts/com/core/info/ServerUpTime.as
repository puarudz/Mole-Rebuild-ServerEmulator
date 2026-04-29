package com.core.info
{
   import com.common.util.ClassUtil;
   import com.common.util.Tick;
   import com.event.EventTaomee;
   import com.interfaces.IServerUpTime;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.getTimer;
   
   public class ServerUpTime implements IServerUpTime
   {
      
      private static var _inst:ServerUpTime;
      
      private static var _eventDispatcher:EventDispatcher;
      
      public static const COMPLETE:String = "ServerUpTime_Complete";
      
      public static const UPDATE:String = "ServerUpTime_Update";
      
      private var _offsetTime:Number = 0;
      
      private var _offsetTime2:Number = 0;
      
      private var _startTime:Number;
      
      private var _serverTimer:Number;
      
      public function ServerUpTime()
      {
         super();
         if(Boolean(_inst))
         {
            throw "該類為單例類.";
         }
      }
      
      public static function getInstance() : ServerUpTime
      {
         if(_inst == null)
         {
            _inst = new ServerUpTime();
         }
         return _inst;
      }
      
      private static function getEventDispathcer() : EventDispatcher
      {
         if(_eventDispatcher == null)
         {
            _eventDispatcher = new EventDispatcher();
         }
         return _eventDispatcher;
      }
      
      public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         getEventDispathcer().addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         getEventDispathcer().removeEventListener(type,listener,useCapture);
      }
      
      public static function dispatchEvent(event:Event) : void
      {
         getEventDispathcer().dispatchEvent(event);
      }
      
      public static function hasEventListener(type:String) : Boolean
      {
         return getEventDispathcer().hasEventListener(type);
      }
      
      public static function willTrigger(type:String) : Boolean
      {
         return getEventDispathcer().willTrigger(type);
      }
      
      public function init() : void
      {
         this._serverTimer = new Date().time;
         this._startTime = getTimer();
         var cl:* = ClassUtil.getClass("com.logic.socket.getServerTimer::getServerTimerReq") as Class;
         BC.addOnceEvent(this,GV.onlineSocket,"beforeGetServerTimer",this.onFirstTime);
         cl.getServerTimer(this,null);
         Tick.instance.addCallback(this.onReviseTime);
      }
      
      private function onFirstTime(e:EventTaomee) : void
      {
         this.onRepairTime(e);
         dispatchEvent(new Event(COMPLETE));
         BC.addEvent(this,GV.onlineSocket,"beforeGetServerTimer",this.onRepairTime);
      }
      
      private function onReviseTime(delay:Number) : void
      {
         var cl:* = undefined;
         var curTime:Number = getTimer();
         if(curTime - this._startTime > 30000)
         {
            this._startTime = curTime;
            cl = ClassUtil.getClass("com.logic.socket.getServerTimer::getServerTimerReq") as Class;
            cl.getServerTimer(this,null);
         }
      }
      
      private function onRepairTime(E:EventTaomee) : void
      {
         this._offsetTime = getTimer();
         this._serverTimer = E.EventObj.time;
         dispatchEvent(new EventTaomee(UPDATE,this.date));
      }
      
      public function get date() : Date
      {
         return this.valueDate;
      }
      
      public function get serverTime() : Number
      {
         return this._serverTimer + (getTimer() - this._offsetTime);
      }
      
      public function get getMoleHours() : int
      {
         return int(this.date.getUTCHours() + 8);
      }
      
      public function get chinaDate() : Date
      {
         return new Date(this.valueDate.fullYearUTC,this.valueDate.monthUTC,this.valueDate.dateUTC,this.valueDate.hoursUTC + 8,this.valueDate.minutesUTC,this.valueDate.secondsUTC,this.valueDate.millisecondsUTC);
      }
      
      public function get valueDate() : Date
      {
         return new Date(this.serverTime);
      }
      
      public function get offset() : int
      {
         return this._offsetTime2;
      }
      
      public function set offset(num:int) : void
      {
         this._offsetTime2 = num;
      }
      
      public function timeLimit(startT:Date, endT:Date) : Boolean
      {
         var servetTime:Date = this.valueDate;
         if(startT == null && endT == null)
         {
            return true;
         }
         if(startT == null && endT != null)
         {
            return endT >= servetTime;
         }
         if(endT == null && startT != null)
         {
            return startT <= servetTime;
         }
         if(startT <= servetTime && endT >= servetTime)
         {
            return true;
         }
         return false;
      }
      
      public function getDateInterval(year:uint, month:uint, day:uint) : uint
      {
         var date:Date = new Date(year,month - 1,day);
         var timeInterval:Number = Math.abs(this.serverTime - date.time);
         return uint(Math.ceil(timeInterval / (3600 * 24 * 1000)));
      }
   }
}

