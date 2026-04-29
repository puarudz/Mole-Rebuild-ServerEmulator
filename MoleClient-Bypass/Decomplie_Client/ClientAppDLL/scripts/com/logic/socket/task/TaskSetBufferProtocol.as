package com.logic.socket.task
{
   import com.common.msgHead.MsgHead;
   import com.common.util.BitArray;
   import com.global.staticData.CommandID;
   import com.logic.socket.smc.expandItem.SetLoopJobRes;
   import com.mole.net.SocketProtocol;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class TaskSetBufferProtocol extends SocketProtocol
   {
      
      public function TaskSetBufferProtocol()
      {
         super(CommandID.LOOP_SMCJOB_SET);
      }
      
      public static function send(jobID:uint, buffer:ByteArray) : void
      {
         MsgHead.Command = CommandID.LOOP_SMCJOB_SET;
         var bodyData:BitArray = new BitArray();
         bodyData.writeUnsignedInt(jobID);
         bodyData.writeBytes(buffer);
         bodyData.length = 54;
         GF.writeHead(bodyData);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         var setLoopJobRes:SetLoopJobRes = new SetLoopJobRes();
         setLoopJobRes.getBackFun();
      }
   }
}

