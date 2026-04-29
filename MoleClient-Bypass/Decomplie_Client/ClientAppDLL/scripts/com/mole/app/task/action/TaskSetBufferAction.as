package com.mole.app.task.action
{
   import com.mole.app.task.Task;
   import com.mole.app.task.trigger.TaskTriggerBase;
   
   public class TaskSetBufferAction extends TaskActionBase
   {
      
      private var _panelID:uint;
      
      private var _stepID:uint;
      
      public function TaskSetBufferAction(actionXml:XML, parent:TaskTriggerBase)
      {
         super(actionXml,parent);
         this._panelID = uint(actionXml.@Panel);
         this._stepID = uint(actionXml.@Step);
      }
      
      override public function execute() : void
      {
         var task:Task = _parent.step.task;
         task.setStepAndPanel(this._stepID,this._panelID);
         nextAction();
      }
   }
}

