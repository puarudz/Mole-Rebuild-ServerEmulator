package com.mole.app.task.action
{
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.module.AppModuleControl;
   import com.mole.app.module.ModuleEvent;
   import com.mole.app.task.trigger.TaskTriggerBase;
   import com.mole.app.type.ModuleType;
   import flash.events.Event;
   
   public class TaskOpenTaskPanelAction extends TaskActionBase
   {
      
      public function TaskOpenTaskPanelAction(actionXml:XML, parent:TaskTriggerBase)
      {
         super(actionXml,parent);
      }
      
      override public function execute() : void
      {
         var appCtl:AppModuleControl = ModuleManager.openPanel(ModuleType.TASK_FILES_PANEL,_parent.step.task.id);
         appCtl.addEventListener(ModuleEvent.DESTROY,this.onDestroyPanel);
      }
      
      private function onDestroyPanel(e:Event) : void
      {
         var appCtl:AppModuleControl = e.currentTarget as AppModuleControl;
         appCtl.removeEventListener(ModuleEvent.DESTROY,this.onDestroyPanel);
         nextAction();
      }
   }
}

