package com.logic.socket.huluGroup
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import flash.utils.ByteArray;
   
   public class requestAddToGroup
   {
      
      public function requestAddToGroup()
      {
         super();
      }
      
      public function doAction(GroupID:uint, msg:String) : void
      {
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(GroupID);
         var tempByteArray2:ByteArray = new ByteArray();
         tempByteArray2.writeUTFBytes(msg);
         tempByteArray2.position = 0;
         var Reason_len:uint = tempByteArray2.length;
         tempByteArray.writeUnsignedInt(Reason_len);
         tempByteArray.writeBytes(tempByteArray2,0);
         MsgHead.Command = CommandID.GROUP_REQUESTADDTOGROUP;
         GF.writeHead(tempByteArray);
      }
      
      public function ActionRes() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("CMD_" + CommandID.GROUP_REQUESTADDTOGROUP));
      }
   }
}

