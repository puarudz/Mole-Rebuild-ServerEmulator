package com.mole.app.task.action
{
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.module.AppModuleControl;
   import com.mole.app.module.ModuleEvent;
   import com.mole.app.task.trigger.TaskTriggerBase;
   import flash.events.Event;
   
   public class TaskOpenGameAction extends TaskActionBase
   {
      
      public function TaskOpenGameAction(actionXml:XML, parent:TaskTriggerBase)
      {
         super(actionXml,parent);
      }
      
      override public function execute() : void
      {
         var appCtl:AppModuleControl = ModuleManager.openGame(this.panelName,_data);
         appCtl.addEventListener(ModuleEvent.DESTROY,this.onDestroyPanel);
      }
      
      private function onDestroyPanel(e:Event) : void
      {
         var appCtl:AppModuleControl = e.currentTarget as AppModuleControl;
         appCtl.removeEventListener(ModuleEvent.DESTROY,this.onDestroyPanel);
         nextAction();
      }
      
      private function get panelName() : String
      {
         return _param;
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
   }
}

