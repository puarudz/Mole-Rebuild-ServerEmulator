package com.mole.app.task.action
{
   import com.mole.app.manager.StatisticsManager;
   import com.mole.app.task.trigger.TaskTriggerBase;
   import flash.utils.setTimeout;
   
   public class TaskSetStaticsAction extends TaskActionBase
   {
      
      private var _staticsID:uint;
      
      public function TaskSetStaticsAction(actionXml:XML, parent:TaskTriggerBase)
      {
         super(actionXml,parent);
         this._staticsID = uint(actionXml.@StaticsID);
      }
      
      override public function execute() : void
      {
         setTimeout(function():void
         {
            StatisticsManager.send(_staticsID);
         },1000);
         nextAction();
      }
   }
}

