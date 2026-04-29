package com.mole.app.task
{
   import com.mole.app.info.ModuleInfo;
   import com.mole.app.info.NPCDialogOptionInfo;
   import com.mole.app.task.info.TaskGroupInfo;
   import com.mole.app.task.type.TaskStateType;
   import org.taomee.ds.HashMap;
   
   public class TaskSummary
   {
      
      private var _newTaskList:Array;
      
      private var _growUpTaskList:Array;
      
      private var _classicsTaskList:Array;
      
      private var _worldTaskList:Array;
      
      private var _exceptionTaskList:Array;
      
      private var _hash:HashMap;
      
      public var defaultShowTaskId:uint;
      
      public function TaskSummary(summaryXml:XML)
      {
         var newTaskGroupInfo:TaskGroupInfo = null;
         var newTaskGroupXml:XML = null;
         var growUpGroupXmlList:XMLList = null;
         var growUpGroupInfo:TaskGroupInfo = null;
         var growUpGroupXml:XML = null;
         var classicsGroupXmlList:XMLList = null;
         var classicsGroupInfo:TaskGroupInfo = null;
         var classicsGroupXml:XML = null;
         var exceptionGroupXmlList:XMLList = null;
         var exceptionGroupInfo:TaskGroupInfo = null;
         var exceptionGroupXml:XML = null;
         var worldGroupXmlList:XMLList = null;
         var worldGroupInfo:TaskGroupInfo = null;
         var worldGroupXml:XML = null;
         super();
         this._newTaskList = new Array();
         this.defaultShowTaskId = uint(summaryXml.NewTask.@defaultShowTaskId);
         var newTaskGroupXmlList:XMLList = summaryXml.NewTask.children();
         for each(newTaskGroupXml in newTaskGroupXmlList)
         {
            newTaskGroupInfo = new TaskGroupInfo(newTaskGroupXml);
            this._newTaskList.push(newTaskGroupInfo);
         }
         this._growUpTaskList = new Array();
         growUpGroupXmlList = summaryXml.GrowUpTask.children();
         for each(growUpGroupXml in growUpGroupXmlList)
         {
            growUpGroupInfo = new TaskGroupInfo(growUpGroupXml);
            this._growUpTaskList.push(growUpGroupInfo);
         }
         this._classicsTaskList = new Array();
         classicsGroupXmlList = summaryXml.ClassicsTask.children();
         for each(classicsGroupXml in classicsGroupXmlList)
         {
            classicsGroupInfo = new TaskGroupInfo(classicsGroupXml);
            this._classicsTaskList.push(classicsGroupInfo);
         }
         this._exceptionTaskList = new Array();
         exceptionGroupXmlList = summaryXml.ExceptionTask.children();
         for each(exceptionGroupXml in exceptionGroupXmlList)
         {
            exceptionGroupInfo = new TaskGroupInfo(exceptionGroupXml);
            this._exceptionTaskList.push(exceptionGroupInfo);
         }
         this._worldTaskList = new Array();
         worldGroupXmlList = summaryXml.WorldTask.children();
         for each(worldGroupXml in worldGroupXmlList)
         {
            worldGroupInfo = new TaskGroupInfo(worldGroupXml);
            this._worldTaskList.push(worldGroupInfo);
         }
      }
      
      public function getTask(taskID:uint) : Task
      {
         var task:Task = null;
         var groupInfo:TaskGroupInfo = null;
         var groupList:Array = this._newTaskList.concat(this._growUpTaskList).concat(this._classicsTaskList).concat(this._exceptionTaskList).concat(this._worldTaskList);
         for each(groupInfo in groupList)
         {
            task = groupInfo.getTaskInfo(taskID);
            if(Boolean(task))
            {
               break;
            }
         }
         return task;
      }
      
      public function clickNpc(npcID:uint) : Array
      {
         var optionInfo:NPCDialogOptionInfo = null;
         var task:Task = null;
         var optionList:Array = new Array();
         for each(task in this.taskList)
         {
            optionInfo = task.clickNpc(npcID);
            if(Boolean(optionInfo))
            {
               optionList.push(optionInfo);
            }
         }
         return optionList;
      }
      
      public function checkMapTask(mapID:uint) : void
      {
         var task:Task = null;
         if(this.checkEnterMap(mapID))
         {
            return;
         }
         this.checkCollectTask(mapID);
         for each(task in this.taskList)
         {
            task.checkMapTaskForNPC(mapID);
         }
      }
      
      public function checkEnterMap(mapID:uint) : Boolean
      {
         var task:Task = null;
         for each(task in this.taskList)
         {
            if(task.state == TaskStateType.OPEN)
            {
               if(task.checkEnterMap(mapID))
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function checkSubmitScore(moduleInfo:ModuleInfo) : void
      {
         var task:Task = null;
         for each(task in this.taskList)
         {
            if(task.state == TaskStateType.OPEN)
            {
               task.checkSubmitScore(moduleInfo);
            }
         }
      }
      
      public function checkCollectTask(mapID:uint) : void
      {
         var task:Task = null;
         for each(task in this.taskList)
         {
            if(task.state == TaskStateType.OPEN)
            {
               task.checkCollectTask(mapID);
            }
         }
      }
      
      public function get taskList() : Array
      {
         var task:Task = null;
         var tmpList:Array = null;
         var groupInfo:TaskGroupInfo = null;
         var groupList:Array = this._newTaskList.concat(this._growUpTaskList).concat(this._classicsTaskList).concat(this._exceptionTaskList).concat(this._worldTaskList);
         var tmpTaskList:Array = new Array();
         for each(groupInfo in groupList)
         {
            tmpList = groupInfo.taskList;
            tmpTaskList = tmpTaskList.concat(tmpList);
         }
         return tmpTaskList;
      }
      
      public function get newTaskList() : Array
      {
         return this._newTaskList;
      }
      
      public function get growUpTaskList() : Array
      {
         return this._growUpTaskList;
      }
      
      public function get classicsTaskList() : Array
      {
         return this._classicsTaskList;
      }
      
      public function get worldTaskList() : Array
      {
         return this._worldTaskList;
      }
   }
}

