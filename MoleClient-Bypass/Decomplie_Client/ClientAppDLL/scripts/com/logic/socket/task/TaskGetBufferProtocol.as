package com.logic.socket.task
{
   import com.common.msgHead.MsgHead;
   import com.common.util.BitArray;
   import com.global.staticData.CommandID;
   import com.logic.socket.smc.expandItem.GetLoopJobRes;
   import com.mole.info.TaskBufferInfo;
   import com.mole.net.SocketProtocol;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class TaskGetBufferProtocol extends SocketProtocol
   {
      
      private var _taskID:uint;
      
      private var _taskBuffer:TaskBufferInfo;
      
      public function TaskGetBufferProtocol()
      {
         super(CommandID.LOOP_SMCJOB_GET);
      }
      
      public static function send(jobID:uint) : void
      {
         MsgHead.Command = CommandID.LOOP_SMCJOB_GET;
         var bodyData:ByteArray = new ByteArray();
         bodyData.writeUnsignedInt(jobID);
         GF.writeHead(bodyData);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         var taskData:BitArray = new BitArray();
         bodyData.readBytes(taskData,0,54);
         var getTaskRes:GetLoopJobRes = new GetLoopJobRes();
         getTaskRes.getBackFun(taskData);
         taskData.position = 0;
         this._taskID = taskData.readUnsignedInt();
         this._taskBuffer = new TaskBufferInfo();
         this._taskBuffer.bufferData = taskData;
      }
      
      public function get taskID() : uint
      {
         return this._taskID;
      }
      
      public function get taskBuffer() : TaskBufferInfo
      {
         return this._taskBuffer;
      }
   }
}

