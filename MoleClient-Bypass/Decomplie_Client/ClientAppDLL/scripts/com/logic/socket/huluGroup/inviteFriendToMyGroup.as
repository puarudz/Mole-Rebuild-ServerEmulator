package com.logic.socket.huluGroup
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import flash.utils.ByteArray;
   
   public class inviteFriendToMyGroup
   {
      
      public function inviteFriendToMyGroup()
      {
         super();
      }
      
      public function doAction(GroupId:uint, UserID:uint) : void
      {
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(GroupId);
         tempByteArray.writeUnsignedInt(UserID);
         MsgHead.Command = CommandID.GROUP_INVITEFRIEND_TO_MYGROUP;
         GF.writeHead(tempByteArray);
      }
      
      public function ActionRes() : void
      {
         var addUserObj:Object = {};
         addUserObj.Groupid = GV.onlineSocket.readUnsignedInt();
         addUserObj.Userid = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("CMD_" + CommandID.GROUP_INVITEFRIEND_TO_MYGROUP,addUserObj));
      }
   }
}

