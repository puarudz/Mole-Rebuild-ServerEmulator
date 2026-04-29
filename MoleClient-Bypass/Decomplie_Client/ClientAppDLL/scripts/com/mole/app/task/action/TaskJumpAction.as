package com.mole.app.task.action
{
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.module.AppModuleControl;
   import com.mole.app.module.ModuleEvent;
   import com.mole.app.task.trigger.TaskTriggerBase;
   import com.mole.app.type.ModuleType;
   
   public class TaskJumpAction extends TaskActionBase
   {
      
      private var _panel:AppModuleControl;
      
      public function TaskJumpAction(actionXml:XML, parent:TaskTriggerBase)
      {
         super(actionXml,parent);
      }
      
      override public function execute() : void
      {
         this._panel = ModuleManager.openPanel(ModuleType.TASK_JUMP_PANEL,_param);
         this._panel.addEventListener(ModuleEvent.DESTROY,this.onCloseModule);
      }
      
      private function onCloseModule(e:ModuleEvent) : void
      {
         var appControl:AppModuleControl = e.currentTarget as AppModuleControl;
         appControl.removeEventListener(ModuleEvent.DESTROY,this.onCloseModule);
         nextAction();
      }
   }
}

