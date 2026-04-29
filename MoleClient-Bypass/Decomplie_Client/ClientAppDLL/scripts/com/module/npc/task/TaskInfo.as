package com.module.npc.task
{
   import com.common.util.ClassUtil;
   import com.module.npc.NPCInfo;
   
   public class TaskInfo
   {
      
      public static var taskLimit:uint = 1000000;
      
      public var isLocalTask:Boolean;
      
      public var jobID:uint;
      
      public var npcID:uint;
      
      public var attitudeValue:int;
      
      public var isVip:Boolean;
      
      public var jobType:uint;
      
      public var jobStatus:uint;
      
      public var maxJobNum:uint;
      
      public var jobNum:uint;
      
      public var random:uint;
      
      public var attitudeObj:Object;
      
      public function TaskInfo(info:Object)
      {
         var name:String = null;
         this.attitudeObj = {};
         super();
         for(name in info)
         {
            try
            {
               this[name] = info[name];
            }
            catch(Err:Error)
            {
               throw NPCInfo + "缺少關鍵字:" + name;
            }
         }
         this.isLocalTask = this.isLocalTask > taskLimit ? true : false;
      }
      
      public static function getEmptyNPCInfo(npcID:int = 0, taskID:int = 0, random:Number = 100) : TaskInfo
      {
         var jobObj:Object = new Object();
         jobObj.attitudeValue = 0;
         jobObj.isVip = 0;
         jobObj.jobType = 0;
         jobObj.maxJobNum = 1;
         jobObj.jobStatus = 0;
         jobObj.jobNum = 0;
         jobObj.jobID = taskID;
         jobObj.random = random;
         jobObj.npcID = npcID;
         return new TaskInfo(jobObj);
      }
      
      public function get taskMessageMabage() : ITaskMessageManage
      {
         var NPC:Class = ClassUtil.getClass("com.module.npc::NPC") as Class;
         return NPC["getNPCInfo"](this.npcID).taskMessageManage;
      }
   }
}

