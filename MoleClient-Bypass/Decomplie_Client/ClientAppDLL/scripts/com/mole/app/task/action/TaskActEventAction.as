package com.mole.app.task.action
{
   import com.event.EventTaomee;
   import com.mole.app.task.trigger.TaskTriggerBase;
   
   public class TaskActEventAction extends TaskActionBase
   {
      
      public function TaskActEventAction(actionXml:XML, parent:TaskTriggerBase)
      {
         super(actionXml,parent);
      }
      
      override public function execute() : void
      {
         trace("任務中拋事件---------->" + _param);
         nextAction();
         GV.onlineSocket.dispatchEvent(new EventTaomee(_param,_data));
      }
   }
}

