package com.logic.socket.huluGroup
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   
   public class getGroupList
   {
      
      public function getGroupList()
      {
         super();
      }
      
      public function doAction() : void
      {
         MsgHead.Command = CommandID.GROUP_GETGROUPLIST;
         GF.writeHead();
      }
      
      public function getList() : void
      {
         var groupListObj:Object = new Object();
         groupListObj.Count = GV.onlineSocket.readUnsignedInt();
         var groupList:Array = new Array();
         var flagList:Array = new Array();
         for(var i:int = 0; i < groupListObj.Count; i++)
         {
            groupList.push(GV.onlineSocket.readUnsignedInt());
            flagList.push(GV.onlineSocket.readUnsignedInt());
         }
         groupListObj.groupList = groupList;
         groupListObj.flagList = flagList;
         GV.onlineSocket.dispatchEvent(new EventTaomee("CMD_" + CommandID.GROUP_GETGROUPLIST,groupListObj));
      }
   }
}

