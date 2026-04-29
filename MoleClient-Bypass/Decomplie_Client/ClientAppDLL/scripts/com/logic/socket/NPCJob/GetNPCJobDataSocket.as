package com.logic.socket.NPCJob
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   
   public class GetNPCJobDataSocket
   {
      
      public static var GET_JOB_DATA:String = "GET_JOB_DATA";
      
      public function GetNPCJobDataSocket()
      {
         super();
      }
      
      public static function getJobData(jobID:uint) : void
      {
         MsgHead.Command = 3104;
         var byteArray:ByteArray = new ByteArray();
         byteArray.writeUnsignedInt(jobID);
         GF.writeHead(byteArray);
      }
      
      public static function res_getJobData() : void
      {
         var obj:Object = new Object();
         obj.jobID = GV.onlineSocket.readUnsignedInt();
         obj.flag = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_JOB_DATA,obj));
      }
   }
}

