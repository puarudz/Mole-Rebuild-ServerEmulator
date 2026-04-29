package com.mole.app.task.trigger
{
   import com.common.Alert.Alert;
   import com.common.Alert.type.AlertType;
   import com.mole.app.info.ModuleInfo;
   import com.mole.app.info.MoleActionInfo;
   import com.mole.app.manager.MoleActionManager;
   import com.mole.app.task.TaskStep;
   import flash.events.Event;
   
   public class TaskSubmitScoreTrigger extends TaskTriggerBase
   {
      
      private var _moduleID:uint;
      
      private var _minScore:Number;
      
      private var _loseMsg:String;
      
      public function TaskSubmitScoreTrigger(triggerXml:XML, step:TaskStep)
      {
         super(triggerXml,step);
         this._moduleID = uint(triggerXml.@ModuleID);
         this._minScore = Number(triggerXml.@MinScore);
         this._loseMsg = triggerXml.@LoseMsg;
      }
      
      override public function check(data:Object) : Object
      {
         var moduleInfo:ModuleInfo = null;
         moduleInfo = data as ModuleInfo;
         if(this._moduleID == moduleInfo.id)
         {
            if(this._minScore <= moduleInfo.score)
            {
               startAction();
            }
            else if(Boolean(this._loseMsg))
            {
               Alert.angryAlart("　　" + this._loseMsg,function(e:Event):void
               {
                  var moleActionInfo:MoleActionInfo = new MoleActionInfo();
                  moleActionInfo.cmd = moduleInfo.moduleType;
                  moleActionInfo.param = moduleInfo.moduleName;
                  MoleActionManager.doAction(moleActionInfo);
               },AlertType.SURE + "," + AlertType.CANCEL);
            }
         }
         return null;
      }
   }
}

