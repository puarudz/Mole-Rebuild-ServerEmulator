package com.logic.socket.huluGroup
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import flash.utils.ByteArray;
   
   public class getGroupBaseInfo
   {
      
      public function getGroupBaseInfo()
      {
         super();
      }
      
      public function doAction(GroupId:uint) : void
      {
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(GroupId);
         MsgHead.Command = CommandID.GROUP_GETGROUPBASEINFO;
         GF.writeHead(tempByteArray);
      }
      
      public function ActionRes() : void
      {
         var groupInfo:Object = {};
         groupInfo.Groupid = GV.onlineSocket.readUnsignedInt();
         groupInfo.Ownerid = GV.onlineSocket.readUnsignedInt();
         groupInfo.GroupName = GV.onlineSocket.readUTFBytes(25);
         groupInfo.Type = GV.onlineSocket.readUnsignedInt();
         groupInfo.content = GV.onlineSocket.readUTFBytes(121);
         groupInfo.Count = GV.onlineSocket.readUnsignedInt();
         var UserArray:Array = new Array();
         var tempUserID:uint = 0;
         for(var i:uint = 0; i < groupInfo.Count; i++)
         {
            tempUserID = GV.onlineSocket.readUnsignedInt();
            UserArray.push(tempUserID);
         }
         groupInfo.UserArray = UserArray;
         GV.onlineSocket.dispatchEvent(new EventTaomee("CMD_" + CommandID.GROUP_GETGROUPBASEINFO,groupInfo));
      }
   }
}

