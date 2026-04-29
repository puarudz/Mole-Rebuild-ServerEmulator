package com.logic.socket.huluGroup
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import flash.utils.ByteArray;
   
   public class createGroup
   {
      
      public function createGroup()
      {
         super();
      }
      
      public function doAction(GroupName:String, GroupType:int, content:String) : void
      {
         var tempByteArray:ByteArray = new ByteArray();
         var tt1ByteArray:ByteArray = new ByteArray();
         tt1ByteArray.writeUTFBytes(GroupName);
         while(tt1ByteArray.length < 25)
         {
            tt1ByteArray.writeByte(0);
         }
         tt1ByteArray.position = 0;
         tempByteArray.writeBytes(tt1ByteArray,0);
         tempByteArray.writeUnsignedInt(GroupType);
         var tt2ByteArray:ByteArray = new ByteArray();
         tt2ByteArray.writeUTFBytes(content);
         while(tt2ByteArray.length < 121)
         {
            tt2ByteArray.writeByte(0);
         }
         tt2ByteArray.position = 0;
         tempByteArray.writeBytes(tt2ByteArray,0);
         MsgHead.Command = CommandID.GROUP_CREATEGROUP;
         GF.writeHead(tempByteArray);
      }
      
      public function ActionRes() : void
      {
         var Groupid:uint = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("CMD_" + CommandID.GROUP_CREATEGROUP,Groupid));
      }
   }
}

