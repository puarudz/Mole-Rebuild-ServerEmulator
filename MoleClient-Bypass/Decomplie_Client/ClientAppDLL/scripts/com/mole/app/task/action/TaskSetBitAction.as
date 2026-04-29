package com.mole.app.task.action
{
   import com.mole.app.task.Task;
   import com.mole.app.task.trigger.TaskTriggerBase;
   
   public class TaskSetBitAction extends TaskActionBase
   {
      
      public function TaskSetBitAction(actionXml:XML, parent:TaskTriggerBase)
      {
         super(actionXml,parent);
      }
      
      override public function execute() : void
      {
         var task:Task = _parent.step.task;
         task.setBit(this.bit);
         nextAction();
      }
      
      private function get bit() : uint
      {
         return uint(_param);
      }
   }
}

