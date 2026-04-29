package com.mole.app.task.trigger
{
   import com.mole.app.task.TaskStep;
   
   public class TaskNowTrigger extends TaskTriggerBase
   {
      
      public function TaskNowTrigger(triggerXml:XML, step:TaskStep, isTest:Boolean = true)
      {
         super(triggerXml,step,isTest);
      }
      
      override public function check(data:Object) : Object
      {
         startAction();
         return null;
      }
   }
}

