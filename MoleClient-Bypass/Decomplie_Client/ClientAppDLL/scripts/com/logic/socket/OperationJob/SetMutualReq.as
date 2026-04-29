package com.logic.socket.OperationJob
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   import flash.utils.ByteArray;
   
   public class SetMutualReq extends BaseOnlineSocketRequest
   {
      
      public function SetMutualReq()
      {
         super();
      }
      
      public static function removeInfo() : void
      {
         var a:MsgHead = null;
         MsgHead.PkgLen = 40 + 17;
         initAction(CommandID.MUTUAL_OPERATION_SET);
         var myArr:ByteArray = new ByteArray();
         for(var i:uint = 0; i < 40; i++)
         {
            myArr.writeByte(0);
         }
         GV.onlineSocket.writeBytes(myArr);
         flush();
      }
      
      public static function SetInfo(tepe:uint = 0, job:uint = 0, count:uint = 0) : void
      {
         MsgHead.PkgLen = 40 + 17;
         initAction(CommandID.MUTUAL_OPERATION_SET);
         GV.onlineSocket.writeUnsignedInt(tepe);
         GV.onlineSocket.writeByte(job);
         GV.onlineSocket.writeUnsignedInt(count);
         var myArr:ByteArray = new ByteArray();
         for(var i:uint = 0; i < 31; i++)
         {
            myArr.writeByte(0);
         }
         GV.onlineSocket.writeBytes(myArr);
         flush();
      }
   }
}

