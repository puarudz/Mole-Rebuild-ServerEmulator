package com.mole.app.manager
{
   import com.mole.app.task.Task;
   import com.mole.app.task.TaskManager;
   
   public class MissionNewCheck
   {
      
      private static var taskNewID:uint = 300;
      
      private static var taskMissionID:uint = 382;
      
      public function MissionNewCheck()
      {
         super();
      }
      
      public static function checkUp() : Boolean
      {
         var taskNew:Task = TaskManager.getTask(taskNewID);
         var taskMission:Task = TaskManager.getTask(taskMissionID);
         if(taskNew.state == 1 || taskMission.state == 1)
         {
            return true;
         }
         return false;
      }
   }
}

