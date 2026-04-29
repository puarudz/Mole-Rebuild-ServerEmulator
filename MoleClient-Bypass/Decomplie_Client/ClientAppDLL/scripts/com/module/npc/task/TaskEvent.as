package com.module.npc.task
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class TaskEvent extends EventTaomee
   {
      
      public static var UP_DATA:String = "up_data";
      
      private static var dispatchObj:EventDispatcher = new EventDispatcher();
      
      public static var dispatchEvent:Function = dispatchObj.dispatchEvent;
      
      public static var addEventListener:Function = dispatchObj.addEventListener;
      
      public static var removeEventListener:Function = dispatchObj.removeEventListener;
      
      private var _taskInfo:TaskInfo;
      
      public function TaskEvent(type:String, taskInfo:TaskInfo, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,data,bubbles,cancelable);
         this._taskInfo = taskInfo;
      }
      
      public function get taskInfo() : TaskInfo
      {
         return this._taskInfo;
      }
   }
}

