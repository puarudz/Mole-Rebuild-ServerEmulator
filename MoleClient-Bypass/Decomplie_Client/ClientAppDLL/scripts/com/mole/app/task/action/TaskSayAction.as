package com.mole.app.task.action
{
   import com.mole.app.info.NPCDialogInfo;
   import com.mole.app.info.NPCDialogOptionInfo;
   import com.mole.app.manager.NPCDialogManager;
   import com.mole.app.task.trigger.TaskTriggerBase;
   import com.mole.app.type.ActionType;
   import com.mole.config.info.Config;
   
   public class TaskSayAction extends TaskActionBase
   {
      
      private var _dialogInfoList:Array;
      
      public function TaskSayAction(actionXml:XML, parent:TaskTriggerBase)
      {
         var dialogInfo:NPCDialogInfo = null;
         var dialogOptionInfo:NPCDialogOptionInfo = null;
         var optionStrList:Array = null;
         var optionOptionInfoLiat:Array = null;
         var optionStr:String = null;
         var optionParam:int = 0;
         var optionParamList:Array = null;
         var dialogXml:XML = null;
         var i:uint = 0;
         super(actionXml,parent);
         this._dialogInfoList = new Array();
         var optionList:Array = new Array();
         var optionIdx:uint = 0;
         for each(dialogXml in actionXml.children())
         {
            optionIdx++;
            optionOptionInfoLiat = new Array();
            optionParamList = String(dialogXml.@Param).split(Config.SEPARATOR);
            optionStrList = String(dialogXml.@Option).split(Config.SEPARATOR);
            for(i = 0; i < optionStrList.length; i++)
            {
               optionStr = optionStrList[i];
               optionParam = int(optionParamList[i]);
               if(optionStrList.length > 1)
               {
                  trace("a");
               }
               if(optionParam == 0)
               {
                  optionParam = int(optionIdx);
               }
               else
               {
                  optionParam--;
               }
               dialogOptionInfo = new NPCDialogOptionInfo(optionStr,ActionType.TASK_FUNCTION,this.nextSay,optionParam > 10000 || optionIdx == actionXml.children().length(),[optionParam]);
               optionOptionInfoLiat.push(dialogOptionInfo);
            }
            dialogInfo = new NPCDialogInfo(uint(dialogXml.@NpcID),dialogXml.@Face,dialogXml.@Msg,optionOptionInfoLiat,true,true);
            this._dialogInfoList.push(dialogInfo);
         }
      }
      
      private function nextSay(idx:uint) : void
      {
         if(idx == -1)
         {
            NPCDialogManager.destroyDialog();
         }
         else if(idx >= 10000)
         {
            _parent.step.task.checkEnterMap(idx + 1);
         }
         else if(idx == this._dialogInfoList.length)
         {
            NPCDialogManager.destroyDialog();
            nextAction();
         }
         else
         {
            NPCDialogManager.say(this._dialogInfoList[idx]);
         }
      }
      
      override public function execute() : void
      {
         this.nextSay(0);
      }
      
      override public function destroy() : void
      {
         this._dialogInfoList = null;
         super.destroy();
      }
   }
}

