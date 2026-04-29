package com.module.npc.task
{
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   public class TaskMessageManage extends EventDispatcher implements ITaskMessageManage
   {
      
      public var tasklist_Array:Array;
      
      public var condition_Array:Array;
      
      public var t_t:Dictionary;
      
      public var t_c:Dictionary;
      
      public function TaskMessageManage(info:Object)
      {
         super();
         this.formatMessage(info);
      }
      
      private function formatMessage(info:Object) : void
      {
         if(info is String)
         {
            info = {
               "tasklist":{"t":[]},
               "condition":{"t":[]}
            };
         }
         if(!info.tasklist)
         {
            info.tasklist = {"t":[]};
         }
         if(!info.condition)
         {
            info.condition = {"t":[]};
         }
         if(info.tasklist is String)
         {
            info.tasklist = {"t":[]};
         }
         if(info.condition is String)
         {
            info.condition = {"t":[]};
         }
         this.tasklist_Array = info.tasklist.t is Array ? info.tasklist.t : [info.tasklist.t];
         this.condition_Array = info.condition.t is Array ? info.condition.t : [info.condition.t];
         this.replaceMsg(this.tasklist_Array,"t");
         this.replaceMsg2(this.condition_Array,"c");
      }
      
      private function replaceMsg(arr:Array, tag:String) : void
      {
         var taskid:int = 0;
         this["t_" + tag] = new Dictionary();
         for(var i:int = 0; i < arr.length; i++)
         {
            arr[i] = new TaskMessage(arr[i],tag);
            taskid = int(arr[i].id);
            this["t_" + tag][taskid] = arr[i];
         }
      }
      
      private function replaceMsg2(arr:Array, tag:String) : void
      {
         this["t_" + tag] = new Dictionary();
         for(var i:int = 0; i < arr.length; i++)
         {
            arr[i] = new TaskConditionMessage(arr[i],tag);
            this["t_" + tag][TaskConditionMessage(arr[i]).id] = arr[i];
         }
      }
      
      public function getTaskMsg(id:int = 0) : TaskMessage
      {
         if(!this.t_t[String(id)])
         {
            throw "該NPC不存在這個任務,請檢查配置表...";
         }
         return this.t_t[String(id)];
      }
      
      public function getConditionMsg(id:int = 0) : TaskConditionMessage
      {
         if(!this.t_c[String(id)])
         {
            throw "該NPC不存在這個判斷邏輯,請檢查配置表...";
         }
         return this.t_c[String(id)];
      }
      
      public function get taskNeedments() : Array
      {
         var list:Array = [];
         for(var i:int = 0; i < this.tasklist_Array.length; i++)
         {
            list = list.concat(TaskMessage(this.tasklist_Array[i]).itemsList);
         }
         return list;
      }
      
      public function get taskList() : Array
      {
         var list:Array = [];
         for(var i:int = 0; i < this.tasklist_Array.length; i++)
         {
            list.push(this.tasklist_Array[i]);
         }
         return list;
      }
   }
}

