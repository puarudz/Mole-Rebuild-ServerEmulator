package com.logic.socket.addBlackList
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   
   public class AddBlackListReq
   {
      
      public static const LIST_BLACK:String = "list_black";
      
      public function AddBlackListReq()
      {
         super();
      }
      
      public function addBlackList(UserID:int) : void
      {
         MsgHead.Result = 0;
         MsgHead.PkgLen = 21;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.ADD_BLACKLIST);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(UserID);
         GV.onlineSocket.flush();
         GV.onlineSocket.dispatchEvent(new EventTaomee(LIST_BLACK,{"id":UserID}));
      }
   }
}

