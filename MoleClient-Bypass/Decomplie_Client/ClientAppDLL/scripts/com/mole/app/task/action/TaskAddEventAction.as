package com.mole.app.task.action
{
   import com.mole.app.task.trigger.TaskTriggerBase;
   import flash.events.Event;
   
   public class TaskAddEventAction extends TaskActionBase
   {
      
      public function TaskAddEventAction(actionXml:XML, parent:TaskTriggerBase)
      {
         super(actionXml,parent);
      }
      
      override public function execute() : void
      {
         GV.onlineSocket.addEventListener(_param,this.onNextAction);
      }
      
      private function onNextAction(e:Event) : void
      {
         GV.onlineSocket.removeEventListener(_param,this.onNextAction);
         nextAction();
      }
   }
}

