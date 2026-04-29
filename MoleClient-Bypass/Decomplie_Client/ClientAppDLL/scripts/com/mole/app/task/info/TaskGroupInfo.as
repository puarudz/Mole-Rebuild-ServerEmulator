package com.mole.app.task.info
{
   import com.common.data.HashMap;
   import com.mole.app.manager.SystemTimeController;
   import com.mole.app.task.Task;
   
   public class TaskGroupInfo
   {
      
      private var _groupName:String;
      
      private var _frameLabel:String;
      
      private var _isOpen:Boolean;
      
      private var _taskInfoMap:HashMap;
      
      public function TaskGroupInfo(groupXml:XML)
      {
         var task:Task = null;
         var taskInfoXml:XML = null;
         super();
         this._groupName = groupXml.@Name;
         this._frameLabel = groupXml.@FrameLabel;
         this._isOpen = Boolean(groupXml.@IsOpen);
         this._taskInfoMap = new HashMap();
         for each(taskInfoXml in groupXml.children())
         {
            task = new Task(taskInfoXml);
            if(task.taskInfo.off == false && SystemTimeController.instance.checkSysTimeAchieve(task.id + 10000))
            {
               this._taskInfoMap.add(task.id,task);
            }
         }
      }
      
      public function getTaskInfo(taskID:uint) : Task
      {
         return this._taskInfoMap.getValue(taskID);
      }
      
      public function get taskList() : Array
      {
         return this._taskInfoMap.values;
      }
      
      public function get groupName() : String
      {
         return this._groupName;
      }
      
      public function get frameLabel() : String
      {
         return this._frameLabel;
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
   }
}

