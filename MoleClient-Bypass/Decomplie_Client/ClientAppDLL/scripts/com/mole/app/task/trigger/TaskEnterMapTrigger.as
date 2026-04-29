package com.mole.app.task.trigger
{
   import com.core.info.LocalUserInfo;
   import com.mole.app.task.TaskStep;
   import com.view.mapView.activity.Task83.SoundManager;
   
   public class TaskEnterMapTrigger extends TaskTriggerBase
   {
      
      private var _isStopSound:Boolean;
      
      public function TaskEnterMapTrigger(triggerXml:XML, step:TaskStep)
      {
         super(triggerXml,step);
         _mapID = uint(triggerXml.@MapID);
         this._isStopSound = uint(triggerXml.@IsStopSound) == 1;
      }
      
      override public function check(data:Object) : Object
      {
         var actionFlag:Boolean = false;
         var curMapID:uint = data as uint;
         if(curMapID == LocalUserInfo.getUserID())
         {
            curMapID = 50004;
         }
         if(_mapID == curMapID && isBit && isNoBit && !isComplete)
         {
            startAction();
            actionFlag = true;
         }
         if(this._isStopSound)
         {
            SoundManager.stopAll();
         }
         return actionFlag;
      }
   }
}

