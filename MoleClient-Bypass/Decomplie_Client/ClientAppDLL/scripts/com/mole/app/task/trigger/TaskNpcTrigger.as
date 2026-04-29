package com.mole.app.task.trigger
{
   import com.mole.app.info.NPCDialogOptionInfo;
   import com.mole.app.map.object.MapNPCObject;
   import com.mole.app.task.TaskStep;
   import com.mole.app.task.action.TaskSayAction;
   import com.mole.app.type.ActionType;
   import com.view.MapManageView.MapManageView;
   
   public class TaskNpcTrigger extends TaskTriggerBase
   {
      
      private var _npcID:uint;
      
      private var _option:String;
      
      public function TaskNpcTrigger(triggerXml:XML, step:TaskStep)
      {
         super(triggerXml,step);
         this._npcID = uint(triggerXml.@ID);
         this._option = triggerXml.@Option;
         _mapID = uint(triggerXml.@MapID);
         if(_mapID == 0)
         {
            _mapID = step.mapID;
         }
      }
      
      override public function check(data:Object) : Object
      {
         var dialogOptionInfo:NPCDialogOptionInfo = null;
         var sayAction:TaskSayAction = null;
         var npcID:uint = data as uint;
         if(npcID == this._npcID && isBit && isNoBit)
         {
            sayAction = _actionList[0] as TaskSayAction;
            dialogOptionInfo = new NPCDialogOptionInfo(this._option,ActionType.TASK_FUNCTION,startAction,sayAction == null,[step.task.buffer.step]);
         }
         return dialogOptionInfo;
      }
      
      override protected function applyTask() : void
      {
         super.applyTask();
         var mapNPCObject:MapNPCObject = MapManageView.inst.mapControl.getMapNPCObjectByNPCID(this._npcID);
         if(Boolean(mapNPCObject))
         {
            mapNPCObject.removeTaskFlag(_step.task.id);
         }
      }
      
      override public function addTaskFlag() : void
      {
         var flagState:int = 0;
         super.addTaskFlag();
         if(step.task.buffer.step == 1)
         {
            flagState = 0;
         }
         else
         {
            flagState = 1;
         }
         var npcID:uint = uint(triggerXML.@ID);
         var _mapNPCObject:MapNPCObject = MapManageView.inst.mapControl.getMapNPCObjectByNPCID(npcID);
         if(!_mapNPCObject)
         {
            trace("這個地圖不存在這個任務需要的npc，需要去加載一個npc出來");
            _mapNPCObject = MapManageView.inst.mapControl.addNPCObject(triggerXML);
         }
         _mapNPCObject.addTaskFlag(step.task.id,flagState);
      }
      
      public function get npcID() : uint
      {
         return this._npcID;
      }
   }
}

