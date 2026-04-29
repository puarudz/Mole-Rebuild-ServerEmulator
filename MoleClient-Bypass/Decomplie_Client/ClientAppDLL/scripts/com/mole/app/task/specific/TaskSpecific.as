package com.mole.app.task.specific
{
   import com.mole.app.task.Task;
   import com.mole.app.task.TaskManager;
   
   public class TaskSpecific
   {
      
      protected var _id:uint;
      
      public function TaskSpecific(id:uint)
      {
         super();
         this._id = id;
      }
      
      public function get task() : Task
      {
         return TaskManager.getTask(this._id);
      }
   }
}

