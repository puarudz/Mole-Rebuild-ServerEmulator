package com.logic.socket.lookOverFriendOnline
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class LookOverFriendOnlineRes extends EventDispatcher
   {
      
      public static var LOOK_OVER_ONLINE_FRIEND:String = "look_over_online_friend";
      
      public static var LOOK_OVER_ONLINE_HOME:String = "look_over_online_home";
      
      public function LookOverFriendOnlineRes()
      {
         super();
      }
      
      public static function lookOverFriendHome() : void
      {
         var obj:Object = null;
         var FriendObj:Object = new Object();
         FriendObj.arr = new Array();
         var Count:uint = GV.onlineSocket.readUnsignedInt();
         for(var i:uint = 0; i < Count; i++)
         {
            obj = new Object();
            obj.ID = GV.onlineSocket.readUnsignedInt();
            obj.Time = GV.onlineSocket.readUnsignedInt();
            obj.PetFlag = GV.onlineSocket.readUnsignedInt();
            FriendObj.arr.push(obj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(LOOK_OVER_ONLINE_HOME,FriendObj));
      }
      
      public function lookOverFriendOnline() : void
      {
         var serverFriendArr:Array = null;
         var serverObj:Object = null;
         var j:uint = 0;
         var friendObj:Object = null;
         var onlineObj:Object = {};
         var serverCountObj:Object = new Object();
         var serverArr:Array = new Array();
         var serverCount:uint = GV.onlineSocket.readUnsignedShort();
         for(var i:uint = 0; i < serverCount; i++)
         {
            serverFriendArr = new Array();
            serverObj = new Object();
            serverObj.serverID = GV.onlineSocket.readUnsignedShort();
            serverObj.friendCount = GV.onlineSocket.readUnsignedInt();
            for(j = 0; j < serverObj.friendCount; j++)
            {
               friendObj = new Object();
               friendObj.UserID = GV.onlineSocket.readUnsignedInt();
               friendObj.Is_online = GV.onlineSocket.readUnsignedByte();
               friendObj.serID = serverObj.serverID;
               serverFriendArr.push(friendObj);
               if(friendObj.Is_online == 1)
               {
                  onlineObj[friendObj.UserID] = friendObj;
               }
            }
            serverObj.friendArr = serverFriendArr;
            serverArr.push(serverObj);
         }
         serverCountObj.severFriend = serverArr;
         serverCountObj.onlineObj = onlineObj;
         GV.onlineSocket.dispatchEvent(new EventTaomee(LOOK_OVER_ONLINE_FRIEND,serverCountObj));
      }
   }
}

