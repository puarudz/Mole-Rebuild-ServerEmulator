package com.logic.socket.huluGroup
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import flash.utils.ByteArray;
   
   public class postilToMyGroup
   {
      
      public function postilToMyGroup()
      {
         super();
      }
      
      public function doAction(accept:int, initiator:uint, groupId:uint) : void
      {
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeByte(accept);
         tempByteArray.writeUnsignedInt(initiator);
         tempByteArray.writeUnsignedInt(groupId);
         MsgHead.Command = CommandID.GROUP_POSTILTOMYGROUP;
         GF.writeHead(tempByteArray);
      }
      
      public function ActionRes() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("CMD_" + CommandID.GROUP_POSTILTOMYGROUP));
      }
   }
}

