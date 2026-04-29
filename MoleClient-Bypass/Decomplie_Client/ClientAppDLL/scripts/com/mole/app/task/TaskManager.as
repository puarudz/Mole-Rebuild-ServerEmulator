package com.mole.app.task
{
   import com.common.Alert.Alert;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.info.LocalUserInfo;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.smc.expandItem.RemoveLoopJobRes;
   import com.logic.socket.task.TaskChangeProtocol;
   import com.logic.socket.task.TaskGetBufferProtocol;
   import com.logic.socket.task.TaskGetListProtocol;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.OnlineManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.module.ModuleSubmitScoreEvent;
   import com.mole.app.task.info.TaskInfo;
   import com.mole.app.task.type.TaskStateType;
   import com.mole.app.type.ModuleType;
   import com.mole.app.utils.PlayMovie;
   import com.mole.debug.DebugManager;
   import com.mole.info.TaskBufferInfo;
   import com.mole.net.events.SocketEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class TaskManager
   {
      
      private static var _taskSummary:TaskSummary;
      
      private static var _taskStateList:Array;
      
      public static var hasEnterMapTask:Boolean;
      
      private static var _initTaskTotal:uint;
      
      private static var _initTaskCount:uint;
      
      private static var _eventDispatcher:EventDispatcher;
      
      public static const TASK_INIT_COMPLETE:String = "TaskManager_INIT_COMPLETE";
      
      public static const TASK_STATE_CHANGE:String = "TaskManager_StateChange";
      
      public static const TASK_SUMMARY_PATH:String = "resource/xml/task/TaskSummary.xml";
      
      public static const TASK_CONFIG_PATH:String = "resource/xml/task/";
      
      public function TaskManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         var taskResID:uint = DownLoadManager.add(TASK_SUMMARY_PATH,ResType.STRING,true,"正在加載任務總表");
         DownLoadManager.addEvent(taskResID,onTaskSummaryComplete);
         ModuleManager.addEventListener(ModuleSubmitScoreEvent.SUBMIT_SCORE,onCheckSubmitScore);
      }
      
      private static function onTaskSummaryComplete(e:DownLoadEvent) : void
      {
         var summaryXML:XML = null;
         try
         {
            summaryXML = XML(e.data);
            _taskSummary = new TaskSummary(summaryXML);
            OnlineManager.addCmdListener(CommandID.LISTITEM,onGetTaskList);
            TaskGetListProtocol.send(LocalUserInfo.getUserID());
            OnlineManager.addCmdListener(CommandID.LOOP_SMCJOB_GET,onGetTaskBuffer);
            OnlineManager.addCmdListener(CommandID.CHANGLIST_ITEM,onUpdateTaskState);
            OnlineManager.addCmdListener(CommandID.LOOP_SMCJOB_REMOVE,onRemoveTaskState);
         }
         catch(err:Error)
         {
            DebugManager.traceMsg("任務總表有錯，策劃改正後，才能正常進入！\n" + err.message,false);
         }
      }
      
      private static function onRemoveTaskState(e:SocketEvent) : void
      {
         var taskPro:RemoveLoopJobRes = e.bodyInfo;
         TaskChangeProtocol.send(taskPro.taskID,0);
      }
      
      private static function onGetTaskBuffer(e:SocketEvent) : void
      {
         var bufferInfo:TaskBufferInfo = null;
         var taskBufferProtocol:TaskGetBufferProtocol = e.bodyInfo;
         var task:Task = _taskSummary.getTask(taskBufferProtocol.taskID);
         if(Boolean(task))
         {
            task.buffer = taskBufferProtocol.taskBuffer;
            if(task.state == TaskStateType.OPEN)
            {
               bufferInfo = task.buffer;
               if(bufferInfo.panelId == 0 && bufferInfo.step == 0)
               {
                  bufferInfo.panelId = 1;
                  bufferInfo.step = 1;
               }
            }
         }
         if(_initTaskCount <= _initTaskTotal)
         {
            ++_initTaskCount;
            if(_initTaskCount == _initTaskTotal)
            {
               dispatchEvent(new Event(TASK_INIT_COMPLETE));
            }
         }
      }
      
      private static function onGetTaskList(e:SocketEvent) : void
      {
         var task:Task = null;
         _initTaskTotal = _initTaskCount = 0;
         var taskGetList:TaskGetListProtocol = e.bodyInfo;
         var tmpStateList:Array = taskGetList.taskList;
         var tmpTaskList:Array = _taskSummary.taskList;
         if(_taskStateList == null)
         {
            for each(task in tmpTaskList)
            {
               if(task.id < 2000)
               {
                  task.state = tmpStateList[task.id];
                  if(task.state == TaskStateType.OPEN)
                  {
                     ++_initTaskTotal;
                     TaskGetBufferProtocol.send(task.id);
                  }
               }
            }
            if(_initTaskTotal == 0)
            {
               dispatchEvent(new Event(TASK_INIT_COMPLETE));
            }
            _taskStateList = tmpStateList;
         }
         else
         {
            updateTaskList(tmpStateList);
         }
      }
      
      private static function onUpdateTaskState(e:SocketEvent) : void
      {
         var changePro:TaskChangeProtocol = e.bodyInfo;
         updateTaskList(changePro.taskStateList,false);
         var task:Task = getTask(changePro.taskID);
         if(Boolean(task))
         {
            task.state = changePro.taskStateList[changePro.taskID];
         }
         TaskManager.dispatchEvent(new EventTaomee(TASK_STATE_CHANGE,changePro.taskID));
         GV.onlineSocket.dispatchEvent(new EventTaomee("changList_over",changePro.oldObj));
      }
      
      private static function updateTaskList(stateList:Array, isUpdate:Boolean = true) : void
      {
         var task:Task = null;
         var i:uint = 0;
         if(isUpdate)
         {
            for(i = 0; i < 2000; i++)
            {
               task = TaskManager.getTask(i);
               if(Boolean(task))
               {
                  task.state = stateList[task.id];
               }
            }
         }
         _taskStateList = stateList;
      }
      
      public static function applyTask(taskID:uint) : Boolean
      {
         var task:Task = _taskSummary.getTask(taskID);
         if(Boolean(task))
         {
            if(task.state == TaskStateType.NO_OPEN)
            {
               PlayMovie.play("resource/ui/effects.swf",null,null,null,null,LevelManager.topLevel,false);
               return task.apply();
            }
            DebugManager.traceMsg("任務不能接！當前狀態為--> " + task.state);
         }
         else
         {
            DebugManager.traceMsg("任務列表中找不到任務:" + taskID);
         }
         return false;
      }
      
      public static function overTask(taskID:uint) : void
      {
         var task:Task = _taskSummary.getTask(taskID);
         if(Boolean(task))
         {
            if(task.state == TaskStateType.OPEN)
            {
               task.over();
            }
            else
            {
               DebugManager.traceMsg("任務不能交！當前狀態為--> " + task.state);
            }
         }
         else
         {
            DebugManager.traceMsg("任務列表中找不到任務:" + taskID);
         }
      }
      
      public static function getTask(taskID:uint) : Task
      {
         if(Boolean(_taskSummary))
         {
            return _taskSummary.getTask(taskID);
         }
         return null;
      }
      
      public static function getDefaultShowTaskId() : uint
      {
         return _taskSummary.defaultShowTaskId;
      }
      
      public static function getTaskInfo(taskID:uint) : TaskInfo
      {
         var task:Task = getTask(taskID);
         if(Boolean(task))
         {
            return task.taskInfo;
         }
         return null;
      }
      
      public static function getTaskState(taskID:uint) : uint
      {
         if(Boolean(_taskStateList))
         {
            return _taskStateList[taskID];
         }
         return 0;
      }
      
      public static function clickNpc(npcID:uint) : Array
      {
         return _taskSummary.clickNpc(npcID);
      }
      
      public static function checkEnterMap(mapID:uint) : void
      {
         if(Boolean(_taskSummary))
         {
            _taskSummary.checkMapTask(mapID);
         }
      }
      
      private static function onCheckSubmitScore(e:ModuleSubmitScoreEvent) : void
      {
         _taskSummary.checkSubmitScore(e.moduleInfo);
      }
      
      public static function get newTaskList() : Array
      {
         if(Boolean(_taskSummary))
         {
            return _taskSummary.newTaskList;
         }
         return [];
      }
      
      public static function get growUpTaskList() : Array
      {
         if(Boolean(_taskSummary))
         {
            return _taskSummary.growUpTaskList;
         }
         return [];
      }
      
      public static function get classicsTaskList() : Array
      {
         if(Boolean(_taskSummary))
         {
            return _taskSummary.classicsTaskList;
         }
         return [];
      }
      
      public static function get worldTaskList() : Array
      {
         if(Boolean(_taskSummary))
         {
            return _taskSummary.worldTaskList;
         }
         return [];
      }
      
      public static function get taskStateList() : Array
      {
         if(Boolean(_taskSummary))
         {
            return _taskStateList;
         }
         return [];
      }
      
      public static function runTask(id:uint) : void
      {
         var mapID:uint = 0;
         var mapType:uint = 0;
         var task:Task = TaskManager.getTask(id);
         if(Boolean(task))
         {
            if(task.state == TaskStateType.NO_OPEN)
            {
               if(applyTask(id))
               {
                  MapManager.enterMap(task.taskInfo.goMapID,task.taskInfo.goMapType);
               }
            }
            else if(task.state == TaskStateType.OPEN)
            {
               task.goStep();
            }
            else if(task.state == TaskStateType.FINISH)
            {
               ModuleManager.openPanel(ModuleType.TASK_FILES_PANEL,id);
            }
         }
         else
         {
            Alert.smileAlart("　　404！");
         }
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
   }
}

