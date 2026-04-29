package com.mole.app.task.trigger
{
   import com.mole.app.map.MapManager;
   import com.mole.app.task.Task;
   import com.mole.app.task.TaskManager;
   import com.mole.app.task.TaskStep;
   import com.mole.app.task.action.TaskActEventAction;
   import com.mole.app.task.action.TaskActionBase;
   import com.mole.app.task.action.TaskAddEventAction;
   import com.mole.app.task.action.TaskAlertAction;
   import com.mole.app.task.action.TaskCollectionAction;
   import com.mole.app.task.action.TaskDeleteMovieAction;
   import com.mole.app.task.action.TaskFrontBuffAction;
   import com.mole.app.task.action.TaskGoMapAction;
   import com.mole.app.task.action.TaskJumpAction;
   import com.mole.app.task.action.TaskJumpLoveAction;
   import com.mole.app.task.action.TaskOpenGameAction;
   import com.mole.app.task.action.TaskOpenPanelAction;
   import com.mole.app.task.action.TaskOpenTaskPanelAction;
   import com.mole.app.task.action.TaskOverAction;
   import com.mole.app.task.action.TaskPlayMovieAction;
   import com.mole.app.task.action.TaskSayAction;
   import com.mole.app.task.action.TaskSetAttributeAction;
   import com.mole.app.task.action.TaskSetBgMusicAction;
   import com.mole.app.task.action.TaskSetBitAction;
   import com.mole.app.task.action.TaskSetBufferAction;
   import com.mole.app.task.action.TaskSetDynamicNpcAction;
   import com.mole.app.task.action.TaskSetStaticsAction;
   import com.mole.app.task.action.TaskShowSelfAction;
   import com.mole.app.task.type.TaskActionType;
   import com.mole.app.task.type.TaskStateType;
   import com.mole.debug.DebugManager;
   import flash.media.Sound;
   
   public class TaskTriggerBase
   {
      
      protected var isComplete:Boolean;
      
      protected var _mapID:uint;
      
      protected var _actionList:Array;
      
      protected var _step:TaskStep;
      
      protected var _bit:uint;
      
      protected var _noBit:uint;
      
      private var _curAction:TaskActionBase;
      
      private var _actionIdx:uint;
      
      private var _isTest:Boolean;
      
      private var _triggerXml:XML;
      
      public function TaskTriggerBase(triggerXml:XML, step:TaskStep, isTest:Boolean = true)
      {
         var action:TaskActionBase = null;
         var actionXml:XML = null;
         super();
         this._triggerXml = triggerXml;
         this._bit = uint(triggerXml.@Bit);
         this._noBit = uint(triggerXml.@NoBit);
         this._actionList = new Array();
         this._step = step;
         this._isTest = isTest;
         for each(actionXml in triggerXml.Action)
         {
            action = this.createAction(actionXml);
            if(Boolean(action))
            {
               this._actionList.push(action);
            }
         }
      }
      
      public function startAction(value:* = null) : void
      {
         if(this is TaskEnterMapTrigger)
         {
            TaskManager.hasEnterMapTask = true;
         }
         else
         {
            TaskManager.hasEnterMapTask = false;
         }
         this.applyTask();
         this._actionIdx = 0;
         this.nextAction();
      }
      
      private function createAction(actionXml:XML) : TaskActionBase
      {
         var action:TaskActionBase = null;
         var s:Sound = new Sound();
         var actionType:String = actionXml.@Cmd;
         switch(actionType)
         {
            case TaskActionType.SEND_STATICS:
               action = new TaskSetStaticsAction(actionXml,this);
               break;
            case TaskActionType.FRONT_BUFF_SET:
               action = new TaskFrontBuffAction(actionXml,this);
               break;
            case TaskActionType.JUMP_TASK_UI:
               action = new TaskJumpAction(actionXml,this);
               break;
            case TaskActionType.JUMP_LOVE_TASK_UI:
               action = new TaskJumpLoveAction(actionXml,this);
               break;
            case TaskActionType.SAY:
               action = new TaskSayAction(actionXml,this);
               break;
            case TaskActionType.SET_BUFFER:
               action = new TaskSetBufferAction(actionXml,this);
               break;
            case TaskActionType.SET_BIT:
               action = new TaskSetBitAction(actionXml,this);
               break;
            case TaskActionType.OPEN_PANEL:
               action = new TaskOpenPanelAction(actionXml,this);
               break;
            case TaskActionType.OPEN_GAME:
               action = new TaskOpenGameAction(actionXml,this);
               break;
            case TaskActionType.PLAY_MOVIE:
               action = new TaskPlayMovieAction(actionXml,this);
               break;
            case TaskActionType.DELETE_MOVIE:
               action = new TaskDeleteMovieAction(actionXml,this);
               break;
            case TaskActionType.OVER:
               action = new TaskOverAction(actionXml,this);
               break;
            case TaskActionType.GO_MAP:
               action = new TaskGoMapAction(actionXml,this);
               break;
            case TaskActionType.SET_ATTRIBUTE:
               action = new TaskSetAttributeAction(actionXml,this);
               break;
            case TaskActionType.ACT_EVENT:
               action = new TaskActEventAction(actionXml,this);
               break;
            case TaskActionType.ADD_EVENT:
               action = new TaskAddEventAction(actionXml,this);
               break;
            case TaskActionType.ALERT:
               action = new TaskAlertAction(actionXml,this);
               break;
            case TaskActionType.OPEN_TASK_PANEL:
               action = new TaskOpenTaskPanelAction(actionXml,this);
               break;
            case TaskActionType.COLLECTION_ITEM:
               action = new TaskCollectionAction(actionXml,this);
               break;
            case TaskActionType.SET_BG_MUSIC:
               action = new TaskSetBgMusicAction(actionXml,this);
               break;
            case TaskActionType.SET_DYNAMIC_NPC:
               action = new TaskSetDynamicNpcAction(actionXml,this);
            case TaskActionType.TASK_SHOW_SELF:
               action = new TaskShowSelfAction(actionXml,this);
         }
         if(action == null)
         {
            DebugManager.traceMsg("沒有找到與行動:" + actionType + "對應的類!");
         }
         return action;
      }
      
      public function nextAction() : void
      {
         if(this._actionList.length > 0)
         {
            if(this._actionIdx == this._actionList.length)
            {
               this.isComplete = true;
               if(this._isTest)
               {
                  this._step.test();
               }
            }
            else
            {
               this._curAction = this._actionList[this._actionIdx++];
               this._curAction.execute();
            }
         }
         else
         {
            this.isComplete = true;
            if(this._isTest)
            {
               this._step.test();
            }
         }
      }
      
      public function check(data:Object) : Object
      {
         return null;
      }
      
      protected function get isBit() : Boolean
      {
         return this._bit == 0 || this._step.task.buffer.stateBit.getBitAt(this._bit - 1) == false;
      }
      
      protected function get isNoBit() : Boolean
      {
         return this._noBit == 0 || this._step.task.buffer.stateBit.getBitAt(this._bit - 1);
      }
      
      public function destroy() : void
      {
         var taskAction:TaskActionBase = null;
         for each(taskAction in this._actionList)
         {
            taskAction.destroy();
         }
         this._actionList = null;
         this._step = null;
      }
      
      public function get step() : TaskStep
      {
         return this._step;
      }
      
      protected function applyTask() : void
      {
         var task:Task = this._step.task;
         if(task.state == TaskStateType.NO_OPEN)
         {
            TaskManager.applyTask(task.id);
         }
      }
      
      public function addTaskFlag() : void
      {
         if(this._mapID > 0 && this._mapID != MapManager.curMapID)
         {
            return;
         }
      }
      
      public function get triggerXML() : XML
      {
         return this._triggerXml;
      }
   }
}

