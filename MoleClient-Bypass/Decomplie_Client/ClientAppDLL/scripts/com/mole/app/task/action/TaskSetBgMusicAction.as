package com.mole.app.task.action
{
   import com.mole.app.task.trigger.TaskTriggerBase;
   import com.view.mapView.activity.Task83.SoundManager;
   
   public class TaskSetBgMusicAction extends TaskActionBase
   {
      
      private var _mute:Boolean;
      
      public function TaskSetBgMusicAction(actionXml:XML, parent:TaskTriggerBase)
      {
         super(actionXml,parent);
         this._mute = uint(actionXml.@Mute) == 1;
      }
      
      override public function execute() : void
      {
         SoundManager.mute = this._mute;
         nextAction();
      }
   }
}

