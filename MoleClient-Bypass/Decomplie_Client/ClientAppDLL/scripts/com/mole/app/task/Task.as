package com.mole.app.task
{
   import com.common.Alert.Alert;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.JobLogic.JobLogic;
   import com.logic.socket.smc.expandItem.RemoveLoopJobReq;
   import com.logic.socket.task.TaskChangeProtocol;
   import com.logic.socket.task.TaskOverProtocol;
   import com.logic.socket.task.TaskSetBufferProtocol;
   import com.mole.app.info.ModuleInfo;
   import com.mole.app.info.NPCDialogOptionInfo;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.NPCDialogManager;
   import com.mole.app.manager.StatisticsManager;
   import com.mole.app.manager.TaskSpecialManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.task.info.TaskInfo;
   import com.mole.app.task.type.TaskStateType;
   import com.mole.app.type.ModuleType;
   import com.mole.debug.DebugManager;
   import com.mole.info.TaskBufferInfo;
   import com.view.MapManageView.MapManageView;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class Task extends EventDispatcher
   {
      
      public static const TASK_OPEN:String = "Task_Open";
      
      public static const TASK_OVER:String = "Task_Over";
      
      private var _taskInfo:TaskInfo;
      
      private var _buffer:TaskBufferInfo;
      
      private var _stepList:Array;
      
      private var lucas:uint = 0;
      
      private var _isChangeMapFlag:Boolean;
      
      private var _isLoadXML:Boolean = false;
      
      public function Task(taskXml:XML)
      {
         super();
         this._taskInfo = new TaskInfo();
         this._taskInfo.initXML(taskXml);
         this._buffer = new TaskBufferInfo();
         this._stepList = new Array();
      }
      
      public function set state(value:uint) : void
      {
         this._taskInfo.runningState = value;
         if(this._taskInfo.runningState == TaskStateType.LOAD_CONFIG)
         {
            this._taskInfo.runningState = TaskStateType.NO_OPEN;
            this.loadTaskConfig();
         }
         else if(this._taskInfo.runningState == TaskStateType.OPEN)
         {
            if(this._isLoadXML == false)
            {
               this.loadTaskConfig();
            }
            else
            {
               if(GV.isChangeMap == false && !TaskManager.hasEnterMapTask)
               {
                  this.checkTaskStepInMap();
               }
               dispatchEvent(new Event(TASK_OPEN));
            }
         }
         else if(this._taskInfo.runningState != TaskStateType.FINISH)
         {
            if(this._taskInfo.runningState == TaskStateType.NO_OPEN)
            {
            }
         }
      }
      
      private function loadTaskConfig() : void
      {
         var resID:uint = 0;
         if(this._isLoadXML == false)
         {
            this._isChangeMapFlag = false;
            resID = DownLoadManager.add(TaskManager.TASK_CONFIG_PATH + "Task" + this._taskInfo.id + ".xml",ResType.STRING,true);
            DownLoadManager.addEvent(resID,this.onLoadXmlComplete,null,null,this.onLoadXmlError);
            GV.onlineSocket.addEventListener(Event.INIT,this.onResetChangeMapFlag);
         }
      }
      
      public function get state() : uint
      {
         var tmpState:uint = 0;
         return this._taskInfo.runningState;
      }
      
      public function get isParentFinish() : Boolean
      {
         var parTask:Task = null;
         var parID:uint = 0;
         for each(parID in this._taskInfo.parTaskIDList)
         {
            parTask = TaskManager.getTask(parID);
            if(Boolean(parTask) && parTask.state != TaskStateType.FINISH)
            {
               return false;
            }
         }
         return true;
      }
      
      private function onResetChangeMapFlag(e:Event) : void
      {
         GV.onlineSocket.removeEventListener(Event.INIT,this.onResetChangeMapFlag);
         this._isChangeMapFlag = true;
      }
      
      public function get flag() : uint
      {
         if(this.isParentFinish)
         {
            return this.analysisState(this.state);
         }
         return 30;
      }
      
      private function analysisState(tmpState:uint) : uint
      {
         switch(tmpState)
         {
            case TaskStateType.NO_OPEN:
               if(this._taskInfo.timeState == 0)
               {
                  return 20;
               }
               return 25;
               break;
            case TaskStateType.OPEN:
               return 10;
            case TaskStateType.FINISH:
               return 40;
            default:
               return 5;
         }
      }
      
      private function onLoadXmlComplete(e:DownLoadEvent) : void
      {
         var taskXML:XML = null;
         var taskStep:TaskStep = null;
         var stepXml:XML = null;
         try
         {
            taskXML = XML(e.data);
            this._taskInfo.awardMsg = taskXML.@AwardMsg;
            this._taskInfo.awardBean = taskXML.@AwardBean;
            for each(stepXml in taskXML.children())
            {
               taskStep = new TaskStep(stepXml,this);
               this._stepList.push(taskStep);
            }
            if(this.state == TaskStateType.OPEN)
            {
               dispatchEvent(new Event(TASK_OPEN));
               if(this._isLoadXML == false && this._isChangeMapFlag && GV.isChangeMap == false && !TaskManager.hasEnterMapTask)
               {
                  this._isLoadXML = true;
                  this.checkTaskStepInMap();
               }
            }
            else
            {
               this._isLoadXML = true;
               this.checkMapTaskForNPC(MapManager.curMapID);
            }
         }
         catch(e:Error)
         {
            DebugManager.traceMsg("解析任務表失敗：ID--> " + id,false,e);
         }
      }
      
      private function onLoadXmlError(e:DownLoadEvent) : void
      {
         this._isLoadXML = true;
         if(this.state == TaskStateType.OPEN)
         {
            dispatchEvent(new Event(TASK_OPEN));
            if(this._isLoadXML == false && this._isChangeMapFlag && GV.isChangeMap == false && !TaskManager.hasEnterMapTask)
            {
               this._isLoadXML = true;
               this.checkTaskStepInMap();
            }
         }
         else
         {
            this._isLoadXML = true;
            this.checkMapTaskForNPC(MapManager.curMapID);
         }
      }
      
      public function clickNpc(npcID:uint) : NPCDialogOptionInfo
      {
         var dialogInfo:NPCDialogOptionInfo = null;
         var tarStep:TaskStep = this.getStep(this._buffer.step,false);
         if(Boolean(tarStep))
         {
            return tarStep.clickNpc(npcID);
         }
         return null;
      }
      
      public function checkMapTaskForNPC(mapID:uint) : void
      {
         var step:TaskStep = null;
         if(!this.isParentFinish)
         {
            return;
         }
         if(this.state == TaskStateType.OPEN)
         {
            step = this.getStep(this._buffer.step);
            this.setMapObjectTaskFlag(step,mapID);
         }
         else if(this.state == TaskStateType.NO_OPEN)
         {
            if(this.taskInfo.goMapID == mapID)
            {
               if(this._isLoadXML == false)
               {
                  this.state = TaskStateType.LOAD_CONFIG;
               }
               else
               {
                  step = this.getStep(this._buffer.step,false);
                  this.setMapObjectTaskFlag(step,mapID);
               }
            }
         }
      }
      
      private function setMapObjectTaskFlag(step:TaskStep, mapID:uint) : void
      {
         var i:int = 0;
         if(Boolean(step) && step.mapID == mapID)
         {
            for(i = 0; i < step.npcList.length; i++)
            {
               step.npcList[i].addTaskFlag();
            }
         }
      }
      
      private function checkTaskStepInMap() : void
      {
         if(!this.checkEnterMap(MapManager.curMapID))
         {
            this.checkCollectTask(MapManager.curMapID);
            this.checkMapTaskForNPC(MapManager.curMapID);
         }
      }
      
      public function checkEnterMap(mapID:uint) : Boolean
      {
         var tarStep:TaskStep = this.getStep(this._buffer.step);
         if(Boolean(tarStep))
         {
            return tarStep.checkEnterMap(mapID);
         }
         return false;
      }
      
      public function checkSubmitScore(moduleInfo:ModuleInfo) : void
      {
         var tarStep:TaskStep = this.getStep(this._buffer.step);
         if(Boolean(tarStep))
         {
            tarStep.checkSubmitScore(moduleInfo);
         }
      }
      
      public function checkCollectTask(mapID:uint) : Boolean
      {
         var tarStep:TaskStep = this.getStep(this._buffer.step);
         if(Boolean(tarStep))
         {
            return tarStep.checkCollectTask(mapID);
         }
         return false;
      }
      
      private function getStep(stepID:uint, needOpen:Boolean = true) : TaskStep
      {
         if(needOpen)
         {
            if(this.state == TaskStateType.OPEN)
            {
               return this.getStepByID(stepID);
            }
         }
         else if(this.state == TaskStateType.OPEN || this.state == TaskStateType.NO_OPEN)
         {
            return this.getStepByID(stepID);
         }
         return null;
      }
      
      private function getStepByID(stepID:uint) : TaskStep
      {
         var tarStep:TaskStep = null;
         var taskStep:TaskStep = null;
         for each(taskStep in this._stepList)
         {
            if(taskStep.step == this._buffer.step)
            {
               tarStep = taskStep;
               break;
            }
         }
         return tarStep;
      }
      
      public function nowTrigger() : void
      {
         var tarStep:TaskStep = this.getStep(this._buffer.step);
         if(Boolean(tarStep))
         {
            tarStep.nowTrigger();
         }
      }
      
      public function setStepAndPanel(stepID:uint = 0, panelID:uint = 0) : void
      {
         var isSend:Boolean = false;
         if(Boolean(stepID) && this._buffer.step != stepID)
         {
            this._buffer.step = stepID;
            isSend = true;
            this.checkTaskStepInMap();
            this.nowTrigger();
         }
         if(Boolean(panelID) && this._buffer.panelId != panelID)
         {
            this._buffer.panelId = panelID;
            isSend = true;
         }
         if(isSend)
         {
            TaskSetBufferProtocol.send(this.id,this._buffer.bufferData);
         }
      }
      
      public function setBit(bit:uint) : void
      {
         var isSend:Boolean = false;
         if(this._buffer.stateBit.getBitAt(bit - 1) == false)
         {
            this._buffer.stateBit.setBitAt(bit - 1,true);
            isSend = true;
         }
         if(isSend)
         {
            TaskSetBufferProtocol.send(this.id,this._buffer.bufferData);
         }
      }
      
      public function getBit(bit:uint) : Boolean
      {
         return this._buffer.stateBit.getBitAt(bit - 1);
      }
      
      public function get curStep() : TaskStep
      {
         var taskStep:TaskStep = null;
         for each(taskStep in this._stepList)
         {
            if(taskStep.step == this._buffer.step)
            {
               return taskStep;
            }
         }
         return null;
      }
      
      public function goStep() : void
      {
         var tmpStep:TaskStep = this.curStep;
         if(Boolean(tmpStep) && (Boolean(tmpStep.mapID) || Boolean(tmpStep.mapType)))
         {
            if(tmpStep.mapID == 50004)
            {
               MapManager.enterMap(37,3);
            }
            else
            {
               MapManager.enterMap(tmpStep.mapID,tmpStep.mapType);
            }
         }
         else
         {
            ModuleManager.openPanel(ModuleType.TASK_FILES_PANEL,this.id);
         }
      }
      
      public function apply(isSend:Boolean = true) : Boolean
      {
         var rr:uint = 0;
         var kk:uint = 0;
         var ix:int = 0;
         var iix:int = 0;
         var ki:int = 0;
         var kii:int = 0;
         var m:uint = 0;
         if(this.isParentFinish)
         {
            if(this._taskInfo.runningState == TaskStateType.NO_OPEN)
            {
               if(this._taskInfo.id == 615)
               {
                  StatisticsManager.send(347);
               }
               if(this._taskInfo.id == 628)
               {
                  StatisticsManager.send(376);
               }
               if(this._taskInfo.id == 619)
               {
                  StatisticsManager.send(350);
               }
               if(this._taskInfo.id == 609)
               {
                  StatisticsManager.send(317);
               }
               if(this._taskInfo.id == 606)
               {
                  StatisticsManager.send(334);
               }
               if(this._taskInfo.id == 600)
               {
                  StatisticsManager.send(320);
               }
               this.state = TaskStateType.OPEN;
               this.addStatisticsManager(this._taskInfo.id);
               if(this._taskInfo.id == 620)
               {
                  for(rr = 0; rr < 6; rr++)
                  {
                     StatisticsManager.send(350);
                  }
                  for(rr = 0; rr < 7; rr++)
                  {
                     StatisticsManager.send(351);
                  }
                  for(rr = 0; rr < 5; rr++)
                  {
                     StatisticsManager.send(352);
                  }
                  for(rr = 0; rr < 4; rr++)
                  {
                     StatisticsManager.send(355);
                  }
                  for(rr = 0; rr < 3; rr++)
                  {
                     StatisticsManager.send(357);
                  }
                  for(rr = 0; rr < 7; rr++)
                  {
                     StatisticsManager.send(334);
                     StatisticsManager.send(335);
                     StatisticsManager.send(336);
                     StatisticsManager.send(337);
                     StatisticsManager.send(338);
                     StatisticsManager.send(342);
                     StatisticsManager.send(343);
                  }
                  for(rr = 0; rr < 5; rr++)
                  {
                     StatisticsManager.send(339);
                     StatisticsManager.send(345);
                  }
                  for(rr = 0; rr < 2; rr++)
                  {
                     StatisticsManager.send(340);
                  }
                  StatisticsManager.send(341);
                  for(this.lucas = 0; this.lucas < 5; ++this.lucas)
                  {
                     StatisticsManager.send(322);
                     StatisticsManager.send(323);
                     StatisticsManager.send(324);
                  }
                  StatisticsManager.send(317);
                  StatisticsManager.send(317);
                  StatisticsManager.send(317);
                  StatisticsManager.send(317);
                  StatisticsManager.send(318);
                  StatisticsManager.send(318);
                  StatisticsManager.send(318);
                  StatisticsManager.send(319);
                  StatisticsManager.send(319);
                  StatisticsManager.send(319);
                  StatisticsManager.send(307);
                  StatisticsManager.send(307);
                  StatisticsManager.send(307);
                  StatisticsManager.send(308);
                  StatisticsManager.send(307);
                  StatisticsManager.send(308);
                  StatisticsManager.send(307);
                  StatisticsManager.send(308);
                  for(kk = 299; kk <= 302; kk++)
                  {
                     StatisticsManager.send(kk);
                     StatisticsManager.send(kk);
                  }
                  for(ix = 0; ix < 10; ix++)
                  {
                     StatisticsManager.send(174);
                     StatisticsManager.send(281);
                     StatisticsManager.send(174);
                     StatisticsManager.send(174);
                  }
                  StatisticsManager.send(346);
                  StatisticsManager.send(346);
                  StatisticsManager.send(346);
                  StatisticsManager.send(346);
                  StatisticsManager.send(346);
                  StatisticsManager.send(346);
                  for(iix = 0; iix < 13; iix++)
                  {
                     StatisticsManager.send(228);
                     StatisticsManager.send(229);
                  }
                  for(ki = 0; ki < 8; ki++)
                  {
                     StatisticsManager.send(230);
                     StatisticsManager.send(231);
                  }
                  for(kii = 0; kii < 14; kii++)
                  {
                     StatisticsManager.send(259);
                     StatisticsManager.send(261);
                  }
                  for(m = 0; m < 5; m++)
                  {
                     StatisticsManager.send(194);
                     StatisticsManager.send(196);
                     StatisticsManager.send(192);
                  }
               }
               if(this._taskInfo.id == 584)
               {
                  StatisticsManager.send(201);
               }
               if(isSend)
               {
                  TaskChangeProtocol.send(this._taskInfo.id,TaskStateType.OPEN);
               }
               GV.onlineSocket.dispatchEvent(new EventTaomee(JobLogic.CHANGlISTOVER,{
                  "taskID":this.id,
                  "arr":TaskManager.taskStateList
               }));
               return true;
            }
         }
         else
         {
            Alert.smileAlart("　　小摩爾還未達成接取此任務的條件，看看還需要先完成哪些任務吧！",function():void
            {
               if(TaskSpecialManager.isInit)
               {
                  ModuleManager.openPanel(ModuleType.TASK_FILES_PANEL,TaskManager.getDefaultShowTaskId());
               }
               else
               {
                  Alert.smileAlart("　　任務還未初始化完成，請稍等！");
               }
            });
         }
         return false;
      }
      
      private function addStatisticsManager(id:uint) : void
      {
      }
      
      public function over(mapID:uint = 0, mapType:uint = 0) : void
      {
         var rr:uint = 0;
         var hh:uint = 0;
         var hhhj:uint = 0;
         var hhj:uint = 0;
         var ix:int = 0;
         var iix:int = 0;
         var kki:int = 0;
         var iy:int = 0;
         var m:uint = 0;
         var kk:uint = 0;
         var kkk:uint = 0;
         if(this._taskInfo.runningState == TaskStateType.OPEN)
         {
            this.state = TaskStateType.FINISH;
            TaskOverProtocol.send(this._taskInfo.id);
            if(this._taskInfo.awardBean != 0)
            {
               LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + this._taskInfo.awardBean);
            }
            if(this._taskInfo.id == 619)
            {
               StatisticsManager.send(351);
               if(MapManager.curMapID == 358)
               {
                  NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(3));
               }
            }
            if(this._taskInfo.id == 600)
            {
               StatisticsManager.send(321);
            }
            if(this._taskInfo.id == 615)
            {
               StatisticsManager.send(348);
            }
            if(this._taskInfo.id == 627)
            {
               for(rr = 0; rr < 35; rr++)
               {
                  StatisticsManager.send(376);
                  StatisticsManager.send(377);
                  StatisticsManager.send(382);
               }
               for(rr = 0; rr < 20; rr++)
               {
                  StatisticsManager.send(358);
               }
               for(rr = 0; rr < 10; rr++)
               {
                  StatisticsManager.send(359);
               }
               for(rr = 0; rr < 10; rr++)
               {
                  StatisticsManager.send(350);
               }
               for(rr = 0; rr < 7; rr++)
               {
                  StatisticsManager.send(351);
               }
               for(rr = 0; rr < 5; rr++)
               {
                  StatisticsManager.send(352);
               }
               for(rr = 0; rr < 4; rr++)
               {
                  StatisticsManager.send(355);
               }
               for(rr = 0; rr < 3; rr++)
               {
                  StatisticsManager.send(357);
               }
               for(rr = 0; rr < 10; rr++)
               {
                  StatisticsManager.send(347);
               }
               for(rr = 0; rr < 12; rr++)
               {
                  StatisticsManager.send(348);
               }
               for(rr = 0; rr < 8; rr++)
               {
                  StatisticsManager.send(349);
               }
               for(rr = 0; rr < 4; rr++)
               {
                  StatisticsManager.send(334);
                  StatisticsManager.send(335);
                  StatisticsManager.send(336);
                  StatisticsManager.send(337);
                  StatisticsManager.send(338);
                  StatisticsManager.send(342);
                  StatisticsManager.send(343);
               }
               StatisticsManager.send(344);
               StatisticsManager.send(344);
               StatisticsManager.send(344);
               StatisticsManager.send(344);
               StatisticsManager.send(344);
               StatisticsManager.send(344);
               StatisticsManager.send(344);
               StatisticsManager.send(344);
               for(rr = 0; rr < 13; rr++)
               {
                  StatisticsManager.send(336);
                  StatisticsManager.send(337);
                  StatisticsManager.send(345);
               }
               StatisticsManager.send(341);
               StatisticsManager.send(343);
               StatisticsManager.send(343);
               StatisticsManager.send(343);
               StatisticsManager.send(343);
               StatisticsManager.send(343);
               StatisticsManager.send(343);
               StatisticsManager.send(343);
               StatisticsManager.send(343);
               StatisticsManager.send(341);
               StatisticsManager.send(339);
               StatisticsManager.send(339);
               StatisticsManager.send(340);
               for(hh = 0; hh < 5; hh++)
               {
                  StatisticsManager.send(317);
                  StatisticsManager.send(318);
                  StatisticsManager.send(319);
               }
               for(hhhj = 0; hhhj < 10; hhhj++)
               {
                  StatisticsManager.send(326);
                  StatisticsManager.send(327);
                  StatisticsManager.send(328);
                  StatisticsManager.send(329);
                  StatisticsManager.send(330);
                  StatisticsManager.send(331);
                  StatisticsManager.send(332);
                  StatisticsManager.send(333);
               }
               for(hhj = 0; hhj < 10; hhj++)
               {
                  StatisticsManager.send(320);
                  StatisticsManager.send(321);
                  StatisticsManager.send(322);
                  StatisticsManager.send(323);
                  StatisticsManager.send(324);
                  StatisticsManager.send(325);
               }
               for(this.lucas = 0; this.lucas < 10; ++this.lucas)
               {
                  StatisticsManager.send(320);
                  StatisticsManager.send(321);
               }
               for(this.lucas = 0; this.lucas < 5; ++this.lucas)
               {
                  StatisticsManager.send(322);
                  StatisticsManager.send(323);
                  StatisticsManager.send(324);
               }
               StatisticsManager.send(307);
               StatisticsManager.send(308);
               StatisticsManager.send(307);
               StatisticsManager.send(308);
               StatisticsManager.send(307);
               StatisticsManager.send(308);
               StatisticsManager.send(260);
               StatisticsManager.send(260);
               StatisticsManager.send(260);
               StatisticsManager.send(260);
               StatisticsManager.send(262);
               StatisticsManager.send(262);
               StatisticsManager.send(262);
               StatisticsManager.send(262);
               StatisticsManager.send(282);
               StatisticsManager.send(282);
               StatisticsManager.send(282);
               StatisticsManager.send(282);
               StatisticsManager.send(282);
               for(ix = 0; ix < 7; ix++)
               {
                  StatisticsManager.send(173);
                  StatisticsManager.send(173);
                  StatisticsManager.send(160);
                  StatisticsManager.send(183);
                  StatisticsManager.send(183);
                  StatisticsManager.send(184);
                  for(kk = 189; kk <= 204; kk++)
                  {
                     StatisticsManager.send(kk);
                  }
                  for(kkk = 299; kkk <= 302; kkk++)
                  {
                     StatisticsManager.send(kkk);
                     StatisticsManager.send(kkk);
                  }
               }
               for(iix = 0; iix < 10; iix++)
               {
                  StatisticsManager.send(228);
                  StatisticsManager.send(229);
               }
               for(kki = 0; kki < 5; kki++)
               {
                  StatisticsManager.send(230);
                  StatisticsManager.send(231);
               }
               for(iy = 0; iy < 2; iy++)
               {
                  StatisticsManager.send(161);
                  StatisticsManager.send(162);
                  StatisticsManager.send(185);
                  StatisticsManager.send(186);
                  StatisticsManager.send(187);
                  StatisticsManager.send(188);
               }
               for(m = 0; m < 3; m++)
               {
                  StatisticsManager.send(195);
                  StatisticsManager.send(197);
                  StatisticsManager.send(193);
               }
            }
            switch(this._taskInfo.id)
            {
               case 578:
                  StatisticsManager.send(186);
                  break;
               case 579:
                  StatisticsManager.send(188);
                  break;
               case 584:
                  StatisticsManager.send(202);
            }
            if(Boolean(this._taskInfo) && Boolean(this._taskInfo.awardMsg))
            {
               Alert.smileAlart("　　" + this._taskInfo.awardMsg,function(e:Event):void
               {
                  if(mapID != 0)
                  {
                     MapManager.enterMap(mapID,mapType);
                  }
                  if(_taskInfo.id == 628)
                  {
                     StatisticsManager.send(377);
                  }
                  dispatchEvent(new Event(TASK_OVER));
                  if(_taskInfo.id == 660 || _taskInfo.id == 661)
                  {
                     ModuleManager.openPanel("SMCPanel");
                  }
               });
            }
            else
            {
               dispatchEvent(new Event(TASK_OVER));
            }
         }
      }
      
      public function cancel() : void
      {
         if(this._taskInfo.runningState == TaskStateType.OPEN)
         {
            this.state = TaskStateType.NO_OPEN;
            TaskChangeProtocol.send(this.id,TaskStateType.NO_OPEN);
            RemoveLoopJobReq.RemoveInfo(this.id);
            this._buffer.reset();
         }
      }
      
      public function get id() : uint
      {
         return this._taskInfo.id;
      }
      
      public function get buffer() : TaskBufferInfo
      {
         return this._buffer;
      }
      
      public function set buffer(value:TaskBufferInfo) : void
      {
         this._buffer = value;
      }
      
      public function get taskInfo() : TaskInfo
      {
         return this._taskInfo;
      }
      
      public function toInfo() : String
      {
         return "任務信息：\nTaskID：" + this.id + "\n" + "TaskName:" + this._taskInfo.name + "\nStepID:" + this.buffer.step + "\n" + "PanelID:" + this.buffer.panelId + "\n" + "BitArr:" + this.buffer.stateBit.bitArr;
      }
      
      public function destroy() : void
      {
         var step:TaskStep = null;
         for each(step in this._stepList)
         {
            step.destroy();
         }
         this._stepList = null;
      }
   }
}

