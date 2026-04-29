package com.mole.app.manager
{
   import com.common.Alert.Alert;
   import com.event.EventTaomee;
   import com.mole.app.event.TimeEvent;
   import com.mole.app.info.SystemTimeInfo;
   import com.mole.app.info.SystemTimeXMLInfo;
   import flash.events.EventDispatcher;
   import org.taomee.ds.HashMap;
   
   public class SystemTimeController
   {
      
      private static var _instance:SystemTimeController;
      
      public static const SYSTEMTIME_ACHIEVE:String = "SYSTEMTIME0";
      
      public static const SYSTEMTIME_UNACHIEVE:String = "SYSTEMTIME1";
      
      private var evtDisp:EventDispatcher;
      
      private var curTimes:HashMap;
      
      private var curTimesListener:HashMap;
      
      public function SystemTimeController(sysOnly:SystemTimeControllerOnly)
      {
         super();
         this.evtDisp = new EventDispatcher();
         this.curTimes = new HashMap();
         this.curTimesListener = new HashMap();
         TimerManager.ed.addEventListener(TimeEvent.TIMER_EVERY_MINUTE,this.timerCheckTime);
      }
      
      public static function get instance() : SystemTimeController
      {
         if(!_instance)
         {
            _instance = new SystemTimeController(new SystemTimeControllerOnly());
         }
         return _instance;
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, userWeakReferenece:Boolean = false) : void
      {
         var count:int = 0;
         this.evtDisp.addEventListener(type,listener,useCapture,priority,userWeakReferenece);
         var timeId:uint = uint(type.split("-")[1]);
         var sysTimeInfo:SystemTimeInfo = SystemTimeXMLInfo.getSystemTimeInfoById(timeId);
         if(!sysTimeInfo)
         {
            return;
         }
         if(this.curTimes.containsKey(timeId))
         {
            count = this.curTimesListener.getValue(timeId);
            this.curTimesListener.remove(timeId);
            this.curTimesListener.add(timeId,count + 1);
         }
         else
         {
            this.curTimesListener.add(timeId,1);
            this.curTimes.add(timeId,sysTimeInfo);
         }
         this.timerCheckTime();
      }
      
      private function timerCheckTime(evt:TimeEvent = null) : void
      {
         var sysTimeInfo:SystemTimeInfo = null;
         for each(sysTimeInfo in this.curTimes.getValues())
         {
            if(sysTimeInfo.checkTime())
            {
               this.evtDisp.dispatchEvent(new EventTaomee(SYSTEMTIME_ACHIEVE + "-" + sysTimeInfo.id,null));
            }
            else
            {
               this.evtDisp.dispatchEvent(new EventTaomee(SYSTEMTIME_UNACHIEVE + "-" + sysTimeInfo.id,null));
            }
         }
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         this.evtDisp.removeEventListener(type,listener,useCapture);
         var timeId:uint = uint(type.split("-")[1]);
         var count:int = this.curTimesListener.getValue(timeId);
         this.curTimesListener.remove(timeId);
         this.curTimesListener.add(timeId,count - 1);
         if(count <= 1)
         {
            this.curTimesListener.remove(timeId);
            this.curTimes.remove(timeId);
         }
      }
      
      public function checkSysTimeAchieve(sysTimeId:uint) : Boolean
      {
         var sysTimeInfo:SystemTimeInfo = SystemTimeXMLInfo.getSystemTimeInfoById(sysTimeId);
         if(Boolean(sysTimeInfo))
         {
            return sysTimeInfo.checkTime();
         }
         return true;
      }
      
      public function showOutTimeAlert(id:int) : void
      {
         Alert.angryAlart(this.getActivityOutTimeMsg(id));
      }
      
      public function getActivityOutTimeMsg(sysTimeId:uint) : String
      {
         var msgStr:String = "";
         var sysTimeInfo:SystemTimeInfo = SystemTimeXMLInfo.getSystemTimeInfoById(sysTimeId);
         if(Boolean(sysTimeInfo))
         {
            msgStr = sysTimeInfo.outTimeMsg;
         }
         return msgStr;
      }
   }
}

class SystemTimeControllerOnly
{
   
   public function SystemTimeControllerOnly()
   {
      super();
   }
}
