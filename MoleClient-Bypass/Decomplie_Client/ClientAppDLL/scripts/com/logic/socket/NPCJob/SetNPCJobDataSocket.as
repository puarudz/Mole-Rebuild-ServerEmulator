package com.logic.socket.NPCJob
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   
   public class SetNPCJobDataSocket
   {
      
      public static var SET_JOB_DATA:String = "set_job_data";
      
      public function SetNPCJobDataSocket()
      {
         super();
      }
      
      public static function setJobData(jobID:uint, obj:Object) : void
      {
         MsgHead.Command = 3103;
         var byteArray:ByteArray = new ByteArray();
         byteArray.writeUnsignedInt(jobID);
         byteArray.writeUnsignedInt(obj.flag);
         byteArray.length = 54;
         GF.writeHead(byteArray);
      }
      
      public static function res_setJobData() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee(SET_JOB_DATA));
      }
   }
}

