package com.mole.app.task.action
{
   import com.mole.app.manager.BufferManager;
   import com.mole.app.task.trigger.TaskTriggerBase;
   
   public class TaskFrontBuffAction extends TaskActionBase
   {
      
      private var _bufferID:uint;
      
      private var _bufferStep:uint;
      
      public function TaskFrontBuffAction(actionXml:XML, parent:TaskTriggerBase)
      {
         super(actionXml,parent);
         this._bufferID = actionXml.@BufferID;
         this._bufferStep = uint(actionXml.@BufferStep);
      }
      
      override public function execute() : void
      {
         BufferManager.setBuffer(this._bufferID,this._bufferStep);
         nextAction();
      }
   }
}

