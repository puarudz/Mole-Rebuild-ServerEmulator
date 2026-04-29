package com.mole.app.task.action
{
   import com.common.util.DisplayUtil;
   import com.core.manager.LevelManager;
   import com.mole.app.task.trigger.TaskTriggerBase;
   import flash.display.DisplayObject;
   
   public class TaskDeleteMovieAction extends TaskActionBase
   {
      
      public function TaskDeleteMovieAction(actionXml:XML, parent:TaskTriggerBase)
      {
         super(actionXml,parent);
      }
      
      override public function execute() : void
      {
         if(Boolean(this.res_mc))
         {
            DisplayUtil.removeForParent(this.res_mc);
         }
         nextAction();
      }
      
      private function get res_mc() : DisplayObject
      {
         var mc:DisplayObject = LevelManager.topLevel.getChildByName(this.resName);
         if(mc == null)
         {
            mc = LevelManager.mapMovieLevel.getChildByName(this.resName);
         }
         return mc;
      }
      
      private function get resName() : String
      {
         return "TaskMovie_" + _parent.step.task.id + "_" + _param;
      }
   }
}

