package com.logic.socket.huluGroup
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import flash.utils.ByteArray;
   
   public class outGroup
   {
      
      public function outGroup()
      {
         super();
      }
      
      public function doAction(GroupId:uint) : void
      {
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(GroupId);
         MsgHead.Command = CommandID.GROUP_OUTGROUP;
         GF.writeHead(tempByteArray);
      }
      
      public function ActionRes() : void
      {
         var outGroupObj:Object = {};
         outGroupObj.Groupid = GV.onlineSocket.readUnsignedInt();
         outGroupObj.Userid = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("CMD_" + CommandID.GROUP_OUTGROUP,outGroupObj));
      }
   }
}

