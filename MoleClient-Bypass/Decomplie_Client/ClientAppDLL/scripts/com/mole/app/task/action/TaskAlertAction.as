package com.mole.app.task.action
{
   import com.common.Alert.Alert;
   import com.mole.app.task.trigger.TaskTriggerBase;
   import flash.events.Event;
   
   public class TaskAlertAction extends TaskActionBase
   {
      
      private var _face:String;
      
      public function TaskAlertAction(actionXml:XML, parent:TaskTriggerBase)
      {
         super(actionXml,parent);
         this._face = actionXml.@Face;
      }
      
      override public function execute() : void
      {
         if(this._face == "" || this._face == "開心")
         {
            Alert.smileAlart(_param,function(e:Event):void
            {
               nextAction();
            });
         }
      }
   }
}

