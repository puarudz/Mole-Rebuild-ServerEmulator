package com.mole.app.map.object
{
   import com.event.EventTaomee;
   import com.mole.app.map.info.MapNPCInfo;
   import com.mole.app.task.Task;
   import com.mole.app.task.TaskManager;
   import com.mole.debug.DebugManager;
   import com.mole.utils.URLUtil;
   import com.taomee.mole.cache.CacheManager;
   import com.view.MapManageView.MapManageView;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import org.taomee.ds.HashMap;
   import org.taomee.loader.ContentInfo;
   
   public class MapNPCObject extends MapObjectBase
   {
      
      private static const NPC_PATH:String = "";
      
      private var _mapNpcInfo:MapNPCInfo = new MapNPCInfo();
      
      private const taskFlagName:String = "Task_Flag";
      
      private var _hash:HashMap;
      
      private var _taskFlag:MovieClip;
      
      private var _currentTaskFlagState:int = -1;
      
      private var _tasking:Boolean;
      
      private var _task:Task;
      
      public function MapNPCObject(npcXml:XML)
      {
         this._mapNpcInfo.initXml(npcXml);
         if(Boolean(this._mapNpcInfo.npcInfo))
         {
            super(String(npcXml.@Layer),"npc_" + this._mapNpcInfo.npcInfo.id,npcXml);
         }
         else
         {
            DebugManager.traceMsg("找不到NPC ID-->" + npcXml.@ID);
         }
      }
      
      public function get mapNpcInfo() : MapNPCInfo
      {
         return this._mapNpcInfo;
      }
      
      override protected function getObjectURL() : String
      {
         return URLUtil.getNPCURL(uint(_configXML.@ID));
      }
      
      override protected function onMapObjectDisappearHandler(evt:EventTaomee) : void
      {
         var arr:Array = evt.EventObj as Array;
         var resName:String = arr[0];
         var level:String = arr[1];
         if(resName == _resName && level == _levelName)
         {
            if(Boolean(this._taskFlag))
            {
               this._taskFlag[arr[2]] = arr[3];
            }
         }
      }
      
      public function addTaskFlag(taskID:uint, flagState:int = 0) : void
      {
         if(this._hash == null)
         {
            this._hash = new HashMap();
            this.loadTaskFlag(flagState);
         }
         else if(flagState == 1 && this._currentTaskFlagState == 0)
         {
            this.loadTaskFlag(flagState);
         }
         this._hash.add(taskID,flagState);
      }
      
      private function loadTaskFlag(flagState:int) : void
      {
         this._currentTaskFlagState = flagState;
         CacheManager.getPhasorContent(URLUtil.getTaskFlagURL(flagState),"Task_Flag",this.onLoaderNPCTaskFlagComplete);
      }
      
      private function onLoaderNPCTaskFlagComplete(contentInfo:ContentInfo) : void
      {
         if(this._taskFlag != null)
         {
            if(Boolean(MapManageView.inst.mapLevel.topLevel.getChildByName(this.taskFlagName)))
            {
               MapManageView.inst.mapLevel.topLevel.removeChild(this._taskFlag);
            }
         }
         this._taskFlag = contentInfo.content;
         this._taskFlag.name = this.taskFlagName;
         this.setTaskFlagLocation();
      }
      
      private function setTaskFlagLocation() : void
      {
         var npc_mc:DisplayObject = null;
         var rect:Rectangle = null;
         if(_levelName == "")
         {
            _levelName = "depthLevel";
         }
         var level_mc:DisplayObjectContainer = MapManageView.inst.mapLevel[_levelName];
         if(Boolean(level_mc.getChildByName(_resName)))
         {
            npc_mc = level_mc.getChildByName(_resName);
            rect = npc_mc.getBounds(level_mc);
            this._taskFlag.x = npc_mc.x;
            this._taskFlag.y = npc_mc.y - 70;
            MapManageView.inst.mapLevel.topLevel.addChild(this._taskFlag);
            if(this._tasking)
            {
               this._taskFlag.visible = false;
               this._tasking = false;
            }
            _npcLoadCompleteHandler = null;
         }
         else
         {
            _npcLoadCompleteHandler = this.setTaskFlagLocation;
         }
      }
      
      public function removeTaskFlag(taskID:uint) : void
      {
         var arr:Array = null;
         var hasFlag_0:Boolean = false;
         var hasFlag_1:Boolean = false;
         var i:int = 0;
         if(!this._hash)
         {
            return;
         }
         this._hash.remove(taskID);
         if(this._hash.length == 0)
         {
            MapManageView.inst.mapLevel.topLevel.removeChild(this._taskFlag);
            this._taskFlag = null;
            this._hash = null;
         }
         else
         {
            if(Boolean(this._taskFlag))
            {
               this._tasking = true;
               this._taskFlag.visible = false;
               this._task = TaskManager.getTask(taskID);
               this._task.addEventListener(Task.TASK_OVER,this.onTaskOverHandler);
            }
            arr = this._hash.getValues();
            for(i = 0; i < arr.length; i++)
            {
               if(arr[i] == 1)
               {
                  hasFlag_1 = true;
                  break;
               }
               if(arr[i] == 0)
               {
                  hasFlag_0 = true;
               }
            }
            if(hasFlag_0 && !hasFlag_1)
            {
               if(this._currentTaskFlagState == 1)
               {
                  this.loadTaskFlag(0);
               }
            }
         }
      }
      
      private function onTaskOverHandler(evt:Event) : void
      {
         if(Boolean(this._taskFlag))
         {
            this._taskFlag.visible = true;
            this._task.removeEventListener(Task.TASK_OVER,this.onTaskOverHandler);
            this._task = null;
         }
      }
   }
}

