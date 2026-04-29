package com.logic.socket.leaveMapOrRoom
{
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class LeaveMapRes extends EventDispatcher
   {
      
      public static var LEAVE_MAP_ROOM:String = "leave_map_room";
      
      public static var LEAVE_ROOM_MYSELF:String = "leave_room_self";
      
      public function LeaveMapRes()
      {
         super();
      }
      
      public function leaveMap() : void
      {
         var userId:int = 0;
         var Count:int = int(GV.onlineSocket.readUnsignedInt());
         var useIdArr:Array = new Array();
         for(var i:int = 0; i < Count; i++)
         {
            userId = int(GV.onlineSocket.readUnsignedInt());
            useIdArr.push(userId);
         }
         for(var j:int = 0; j < useIdArr.length; j++)
         {
            if(useIdArr[j] == LocalUserInfo.getUserID())
            {
               GV.onlineSocket.dispatchEvent(new EventTaomee(LEAVE_ROOM_MYSELF));
            }
            else
            {
               GV.onlineSocket.dispatchEvent(new EventTaomee(LEAVE_MAP_ROOM,{
                  "type":3,
                  "data":[{"UserID":useIdArr[j]}]
               }));
            }
         }
      }
   }
}

