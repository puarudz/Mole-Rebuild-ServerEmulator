package com.logic.socket.NPCJob
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.module.npc.task.TaskEvent;
   import com.module.npc.task.TaskInfo;
   import flash.utils.ByteArray;
   
   public class NpcJobSocket
   {
      
      public static var ACCEPT_JOB:String = "accept_job";
      
      public static var OVER_JOB:String = "over_job";
      
      public static var CANCEL_JOB:String = "cancel_job";
      
      public static var GET_JOB:String = "get_job";
      
      public static var GET_NPC_JOB:String = "get_npc_job";
      
      public static var GET_SMC_INFO:String = "get_smc_info";
      
      public static var GET_SMC_DATE:String = "get_smc_date";
      
      public function NpcJobSocket()
      {
         super();
      }
      
      public static function architectInfo() : void
      {
         MsgHead.Command = 919;
         var byteArray:ByteArray = new ByteArray();
         GF.writeHead(byteArray);
      }
      
      public static function res_architectInfo() : void
      {
         var obj:Object = new Object();
         obj.ser = GV.onlineSocket.readUnsignedInt();
         obj.exp = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_SMC_INFO,obj));
      }
      
      public static function smcProfessional() : void
      {
         MsgHead.Command = 1269;
         var byteArray:ByteArray = new ByteArray();
         GF.writeHead(byteArray);
      }
      
      public static function res_smcProfessional() : void
      {
         var mapObj:Object = null;
         var obj:Object = new Object();
         obj.Count = GV.onlineSocket.readUnsignedInt();
         var getPayArr:Array = [];
         for(var i:int = 0; i < obj.Count; i++)
         {
            mapObj = new Object();
            mapObj.id = GV.onlineSocket.readUnsignedInt();
            mapObj.ser = GV.onlineSocket.readUnsignedInt();
            mapObj.exp = GV.onlineSocket.readUnsignedInt();
            getPayArr.push(mapObj);
         }
         obj.arr = getPayArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_SMC_DATE,obj));
      }
      
      public static function acceptNpcJob(jobID:uint) : void
      {
         MsgHead.Command = 3101;
         var byteArray:ByteArray = new ByteArray();
         byteArray.writeUnsignedInt(jobID);
         GF.writeHead(byteArray);
      }
      
      public static function res_accepthNpcJob() : void
      {
         var obj:Object = new Object();
         obj.jobID = GV.onlineSocket.readUnsignedInt();
         obj.npcID = GV.onlineSocket.readUnsignedInt();
         obj.attitudeValue = GV.onlineSocket.readUnsignedInt();
         obj.isVip = GV.onlineSocket.readUnsignedInt();
         obj.jobType = getJobType(GV.onlineSocket.readUnsignedInt());
         obj.maxJobNum = GV.onlineSocket.readUnsignedInt();
         obj.jobStatus = GV.onlineSocket.readUnsignedInt();
         obj.jobNum = GV.onlineSocket.readUnsignedInt();
         TaskEvent.dispatchEvent(new TaskEvent(TaskEvent.UP_DATA,new TaskInfo(obj)));
         GV.onlineSocket.dispatchEvent(new EventTaomee(ACCEPT_JOB,obj));
      }
      
      public static function overNpcJob(jobID:uint, selectID:uint = 0) : void
      {
         var randomValue:int = 0;
         MsgHead.Command = 3102;
         var byteArray:ByteArray = new ByteArray();
         byteArray.writeUnsignedInt(jobID);
         if(selectID == 10000)
         {
            randomValue = int(Math.random() * 100 % 2);
            byteArray.writeUnsignedInt(randomValue);
         }
         else
         {
            byteArray.writeUnsignedInt(selectID);
         }
         GF.writeHead(byteArray);
      }
      
      public static function res_overNpcJob() : void
      {
         var itemObj:Object = null;
         var obj:Object = new Object();
         obj.jobID = GV.onlineSocket.readUnsignedInt();
         obj.npcID = GV.onlineSocket.readUnsignedInt();
         obj.attitudeValue = GV.onlineSocket.readUnsignedInt();
         obj.isVip = GV.onlineSocket.readUnsignedInt();
         obj.jobType = getJobType(GV.onlineSocket.readUnsignedInt());
         obj.maxJobNum = GV.onlineSocket.readUnsignedInt();
         obj.jobStatus = GV.onlineSocket.readUnsignedInt();
         obj.jobNum = GV.onlineSocket.readUnsignedInt();
         TaskEvent.dispatchEvent(new TaskEvent(TaskEvent.UP_DATA,new TaskInfo(obj)));
         obj.Count = GV.onlineSocket.readUnsignedInt();
         obj.itemArray = new Array();
         for(var i:int = 0; i < obj.Count; i++)
         {
            itemObj = new Object();
            itemObj.itemID = GV.onlineSocket.readUnsignedInt();
            itemObj.itemCount = GV.onlineSocket.readUnsignedInt();
            obj.itemArray.push(itemObj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(OVER_JOB,obj));
      }
      
      public static function giveupNpcJob(jobID:uint) : void
      {
         MsgHead.Command = 3107;
         var byteArray:ByteArray = new ByteArray();
         byteArray.writeUnsignedInt(jobID);
         GF.writeHead(byteArray);
      }
      
      public static function res_giveupNpcJob() : void
      {
         var obj:Object = new Object();
         obj.jobID = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(CANCEL_JOB,obj));
      }
      
      public static function askNpcJob(jobID:uint) : void
      {
         MsgHead.Command = 3105;
         var byteArray:ByteArray = new ByteArray();
         byteArray.writeUnsignedInt(jobID);
         GF.writeHead(byteArray);
      }
      
      public static function res_askNpcJob() : void
      {
         var obj:Object = new Object();
         obj.jobID = GV.onlineSocket.readUnsignedInt();
         obj.npcID = GV.onlineSocket.readUnsignedInt();
         obj.attitudeValue = GV.onlineSocket.readUnsignedInt();
         obj.isVip = GV.onlineSocket.readUnsignedInt();
         obj.jobType = getJobType(GV.onlineSocket.readUnsignedInt());
         obj.maxJobNum = GV.onlineSocket.readUnsignedInt();
         obj.jobStatus = GV.onlineSocket.readUnsignedInt();
         obj.jobNum = GV.onlineSocket.readUnsignedInt();
         TaskEvent.dispatchEvent(new TaskEvent(TaskEvent.UP_DATA,new TaskInfo(obj)));
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_JOB,obj));
      }
      
      public static function askAllNpcJob(npcID:uint) : void
      {
         MsgHead.Command = 3106;
         var byteArray:ByteArray = new ByteArray();
         byteArray.writeUnsignedInt(npcID);
         GF.writeHead(byteArray);
      }
      
      public static function res_askAllNpcJob() : void
      {
         var jobObj:Object = null;
         var obj:Object = new Object();
         obj.jobCount = GV.onlineSocket.readUnsignedInt();
         obj.jobArr = new Array();
         for(var i:int = 0; i < obj.jobCount; i++)
         {
            jobObj = new Object();
            jobObj.jobID = GV.onlineSocket.readUnsignedInt();
            jobObj.npcID = GV.onlineSocket.readUnsignedInt();
            jobObj.attitudeValue = GV.onlineSocket.readUnsignedInt();
            jobObj.isVip = GV.onlineSocket.readUnsignedInt();
            jobObj.jobType = getJobType(GV.onlineSocket.readUnsignedInt());
            jobObj.maxJobNum = GV.onlineSocket.readUnsignedInt();
            jobObj.jobStatus = GV.onlineSocket.readUnsignedInt();
            jobObj.jobNum = GV.onlineSocket.readUnsignedInt();
            TaskEvent.dispatchEvent(new TaskEvent(TaskEvent.UP_DATA,new TaskInfo(jobObj)));
            obj.jobArr.push(jobObj);
            obj.npcID = jobObj.npcID;
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_NPC_JOB,obj));
      }
      
      private static function getJobType(data:uint) : uint
      {
         for(var i:int = 0; i < 32; i++)
         {
            if(uint(Boolean(data >> i & 1)) == 1)
            {
               return i;
            }
         }
         return 3;
      }
   }
}

