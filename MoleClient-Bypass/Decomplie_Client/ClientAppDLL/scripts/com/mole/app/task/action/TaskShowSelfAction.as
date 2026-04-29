package com.mole.app.task.action
{
   import com.mole.app.task.trigger.TaskTriggerBase;
   import com.view.PeopleView.PeopleManageView;
   
   public class TaskShowSelfAction extends TaskActionBase
   {
      
      private var _hide:Boolean;
      
      public function TaskShowSelfAction(actionXml:XML, parent:TaskTriggerBase)
      {
         super(actionXml,parent);
         this._hide = uint(actionXml.@Hide) == 1;
      }
      
      override public function execute() : void
      {
         var peopleView:PeopleManageView = GV.MAN_PEOPLE;
         if(Boolean(peopleView))
         {
            peopleView.visible = !this._hide;
         }
         nextAction();
      }
   }
}

