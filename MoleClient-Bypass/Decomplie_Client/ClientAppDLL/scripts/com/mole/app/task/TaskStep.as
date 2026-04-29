package com.mole.app.task
{
   import com.mole.app.info.ModuleInfo;
   import com.mole.app.info.NPCDialogOptionInfo;
   import com.mole.app.task.trigger.TaskCollectTrigger;
   import com.mole.app.task.trigger.TaskEnterMapTrigger;
   import com.mole.app.task.trigger.TaskNowTrigger;
   import com.mole.app.task.trigger.TaskNpcTrigger;
   import com.mole.app.task.trigger.TaskSubmitScoreTrigger;
   import com.mole.app.task.trigger.TaskTriggerBase;
   
   public class TaskStep
   {
      
      private var _task:Task;
      
      private var _step:uint;
      
      private var _mapID:uint;
      
      private var _mapType:uint;
      
      private var _npcList:Array;
      
      private var _enterMapList:Array;
      
      private var _submitScoreList:Array;
      
      private var _collectList:Array;
      
      private var _nowList:Array;
      
      private var _curTrigger:TaskTriggerBase;
      
      private var _test:TaskStepTest;
      
      public function TaskStep(stepXml:XML, task:Task)
      {
         var npcTrigger:TaskNpcTrigger = null;
         var npcXml:XML = null;
         var enterMapTrigger:TaskEnterMapTrigger = null;
         var enterMapXml:XML = null;
         var submitScoreTrigger:TaskSubmitScoreTrigger = null;
         var submitScoreXml:XML = null;
         var collectTrigger:TaskCollectTrigger = null;
         var collectXml:XML = null;
         var nowTrigger:TaskNowTrigger = null;
         var nowXml:XML = null;
         super();
         this._task = task;
         this._step = uint(stepXml.@ID);
         this._mapID = uint(stepXml.@TarMapID);
         this._mapType = uint(stepXml.@TarMapType);
         this._npcList = new Array();
         for each(npcXml in stepXml.NPC)
         {
            npcTrigger = new TaskNpcTrigger(npcXml,this);
            this._npcList.push(npcTrigger);
         }
         this._enterMapList = new Array();
         for each(enterMapXml in stepXml.EnterMap)
         {
            enterMapTrigger = new TaskEnterMapTrigger(enterMapXml,this);
            this._enterMapList.push(enterMapTrigger);
         }
         this._submitScoreList = new Array();
         for each(submitScoreXml in stepXml.SubmitScore)
         {
            submitScoreTrigger = new TaskSubmitScoreTrigger(submitScoreXml,this);
            this._submitScoreList.push(submitScoreTrigger);
         }
         this._collectList = new Array();
         for each(collectXml in stepXml.Collect)
         {
            collectTrigger = new TaskCollectTrigger(collectXml,this);
            this._collectList.push(collectTrigger);
         }
         this._nowList = new Array();
         for each(nowXml in stepXml.NowTrigger)
         {
            nowTrigger = new TaskNowTrigger(nowXml,this);
            this._nowList.push(nowTrigger);
         }
         if(Boolean(stepXml.Test[0]))
         {
            this._test = new TaskStepTest(stepXml.Test[0],this);
         }
      }
      
      public function get task() : Task
      {
         return this._task;
      }
      
      public function clickNpc(npcID:uint) : NPCDialogOptionInfo
      {
         var dialogOptionInfo:NPCDialogOptionInfo = null;
         var npcTrigger:TaskNpcTrigger = null;
         for each(npcTrigger in this._npcList)
         {
            dialogOptionInfo = npcTrigger.check(npcID) as NPCDialogOptionInfo;
            if(Boolean(dialogOptionInfo))
            {
               return dialogOptionInfo;
            }
         }
         return null;
      }
      
      public function checkEnterMap(mapID:uint) : Boolean
      {
         var enterMapTrigger:TaskEnterMapTrigger = null;
         for each(enterMapTrigger in this._enterMapList)
         {
            if(Boolean(enterMapTrigger.check(mapID)))
            {
               return true;
            }
         }
         return false;
      }
      
      public function checkSubmitScore(moduleInfo:ModuleInfo) : void
      {
         var submitScoreTrigger:TaskSubmitScoreTrigger = null;
         for each(submitScoreTrigger in this._submitScoreList)
         {
            submitScoreTrigger.check(moduleInfo);
         }
      }
      
      public function checkCollectTask(mapID:uint) : Boolean
      {
         var collectTrigger:TaskCollectTrigger = null;
         for each(collectTrigger in this._collectList)
         {
            if(Boolean(collectTrigger.check(mapID)))
            {
               return true;
            }
         }
         return false;
      }
      
      public function nowTrigger() : void
      {
         var nowTrigger:TaskNowTrigger = null;
         for each(nowTrigger in this._nowList)
         {
            nowTrigger.check(null);
         }
      }
      
      public function test() : void
      {
         if(this._task.buffer.step == this._step && Boolean(this._test))
         {
            this._test.test();
         }
      }
      
      public function destroy() : void
      {
         var trigger:TaskTriggerBase = null;
         this._task = null;
         var tmpList:Array = this._npcList.concat(this._enterMapList);
         for each(trigger in tmpList)
         {
            trigger.destroy();
         }
         this._npcList = null;
         this._enterMapList = null;
      }
      
      public function get step() : uint
      {
         return this._step;
      }
      
      public function get mapID() : uint
      {
         return this._mapID;
      }
      
      public function get mapType() : uint
      {
         return this._mapType;
      }
      
      public function get npcList() : Array
      {
         return this._npcList;
      }
   }
}

