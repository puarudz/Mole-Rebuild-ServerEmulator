package com.logic.socket.lookOverFriendOnline
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   
   public class LookOverFriendOnlineReq
   {
      
      public function LookOverFriendOnlineReq()
      {
         super();
      }
      
      public function lookOverFriendOnline(Isonline:int, count:int, _userIdArr1:Array) : void
      {
         var id:int = 0;
         var userIdArr1:Array = _userIdArr1.slice(0);
         var newArray:Array = [];
         while(Boolean(userIdArr1.length))
         {
            id = userIdArr1.shift();
            if(newArray.indexOf(id) < 0)
            {
               if(id > 0)
               {
                  newArray.push(id);
               }
            }
         }
         if(newArray.length > 200)
         {
            newArray = newArray.slice(0,200);
         }
         count = int(newArray.length);
         var len:int = int(newArray.length);
         MsgHead.PkgLen = 22 + len * 4;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.LOOK_OVER_FRIEND_ONLINE);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeByte(Isonline);
         GV.onlineSocket.writeUnsignedInt(count);
         for(var i:int = 0; i < newArray.length; i++)
         {
            GV.onlineSocket.writeUnsignedInt(newArray[i]);
         }
         GV.onlineSocket.flush();
      }
      
      public function lookOverFriendHome(_userIdArr1:Array) : void
      {
         var id:int = 0;
         var userIdArr1:Array = _userIdArr1.slice(0);
         var newArray:Array = [];
         while(Boolean(userIdArr1.length))
         {
            id = userIdArr1.shift();
            if(newArray.indexOf(id) < 0)
            {
               if(id > 0)
               {
                  newArray.push(id);
               }
            }
         }
         if(newArray.length > 200)
         {
            newArray = newArray.slice(0,200);
         }
         var len:int = int(newArray.length);
         MsgHead.PkgLen = 21 + len * 4;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.HOME_PET_UPDATE);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(len);
         for(var i:int = 0; i < len; i++)
         {
            GV.onlineSocket.writeUnsignedInt(newArray[i]);
         }
         GV.onlineSocket.flush();
      }
   }
}

