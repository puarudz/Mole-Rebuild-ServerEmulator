package com.logic.socket.getUserBasicInfo
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class GetUserBasicInfoRes extends EventDispatcher
   {
      
      public static var GET_USER_BASIC_INFO:String = "get_user_basic_info";
      
      public function GetUserBasicInfoRes()
      {
         super();
      }
      
      public function getUserBasicInfo() : void
      {
         var getUsersBasicObj:Object = new Object();
         getUsersBasicObj.UserID = GV.onlineSocket.readUnsignedInt();
         getUsersBasicObj.Nick = GV.onlineSocket.readUTFBytes(16);
         getUsersBasicObj.Color = GV.onlineSocket.readUnsignedInt();
         getUsersBasicObj.Dining_flag = GV.onlineSocket.readUnsignedInt();
         getUsersBasicObj.Dining_level = GV.onlineSocket.readUnsignedInt();
         getUsersBasicObj.Vip = GV.onlineSocket.readUnsignedInt();
         getUsersBasicObj.MapID = GV.onlineSocket.readUnsignedInt();
         getUsersBasicObj.MapType = GV.onlineSocket.readUnsignedInt();
         getUsersBasicObj.Status = GV.onlineSocket.readUnsignedByte();
         getUsersBasicObj.Action = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_USER_BASIC_INFO,getUsersBasicObj));
      }
   }
}

