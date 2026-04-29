package com.mole.app.task.action
{
   import com.core.info.LocalUserInfo;
   import com.mole.app.task.trigger.TaskTriggerBase;
   
   public class TaskActionBase
   {
      
      protected var _parent:TaskTriggerBase;
      
      protected var _cmd:String;
      
      protected var _param:String;
      
      protected var _data:String;
      
      public function TaskActionBase(actionXml:XML, parent:TaskTriggerBase)
      {
         super();
         this._parent = parent;
         this._cmd = actionXml.@Cmd;
         this._param = actionXml.@Param;
         this._data = actionXml.@Data;
      }
      
      public function execute() : void
      {
      }
      
      public function nextAction() : void
      {
         if(!LocalUserInfo.getIsHideOtherMole())
         {
            LocalUserInfo.setIsHideOtherMole(true);
         }
         this._parent.nextAction();
      }
      
      public function destroy() : void
      {
         this._parent = null;
      }
   }
}

