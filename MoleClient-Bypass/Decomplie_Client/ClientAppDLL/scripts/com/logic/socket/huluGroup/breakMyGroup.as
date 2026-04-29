package com.logic.socket.huluGroup
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import flash.utils.ByteArray;
   
   public class breakMyGroup
   {
      
      public function breakMyGroup()
      {
         super();
      }
      
      public function doAction(GroupId:uint) : void
      {
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(GroupId);
         MsgHead.Command = CommandID.GROUP_BREAKMYGROUP;
         GF.writeHead(tempByteArray);
      }
      
      public function ActionRes() : void
      {
         var Groupid:uint = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("CMD_" + CommandID.GROUP_BREAKMYGROUP,Groupid));
      }
   }
}

