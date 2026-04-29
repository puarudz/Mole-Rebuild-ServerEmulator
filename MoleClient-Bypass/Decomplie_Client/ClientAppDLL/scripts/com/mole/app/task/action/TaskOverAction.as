package com.mole.app.task.action
{
   import com.mole.app.task.TaskManager;
   import com.mole.app.task.trigger.TaskTriggerBase;
   
   public class TaskOverAction extends TaskActionBase
   {
      
      private var _mapID:uint;
      
      private var _mapType:uint;
      
      public function TaskOverAction(actionXml:XML, parent:TaskTriggerBase)
      {
         super(actionXml,parent);
         this._mapID = actionXml.@MapID;
         this._mapType = actionXml.@MapType;
      }
      
      override public function execute() : void
      {
         TaskManager.hasEnterMapTask = false;
         _parent.step.task.over(this._mapID,this._mapType);
      }
   }
}

