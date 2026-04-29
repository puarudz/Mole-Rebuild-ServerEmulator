package com.logic.socket.lockHome
{
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class lockHomeRes extends EventDispatcher
   {
      
      public static var USER_LOCKHOME:String = "user_lockhome";
      
      public function lockHomeRes()
      {
         super();
      }
      
      public function doAction() : void
      {
         var getUsersBasicObj:Object = new Object();
         getUsersBasicObj.UserID = GV.onlineSocket.readUnsignedInt();
         getUsersBasicObj.Nick = GV.onlineSocket.readUTFBytes(16);
         getUsersBasicObj.Color = GV.onlineSocket.readUnsignedInt();
         getUsersBasicObj.restaurantSign = GV.onlineSocket.readUnsignedInt();
         getUsersBasicObj.restaurantLevel = GV.onlineSocket.readUnsignedInt();
         getUsersBasicObj.Vip = GV.onlineSocket.readUnsignedInt();
         getUsersBasicObj.MapID = GV.onlineSocket.readUnsignedInt();
         getUsersBasicObj.MapType = GV.onlineSocket.readUnsignedInt();
         getUsersBasicObj.Status = GV.onlineSocket.readUnsignedByte();
         getUsersBasicObj.Action = GV.onlineSocket.readUnsignedInt();
         LocalUserInfo.setVip(getUsersBasicObj.Vip);
         GV.onlineSocket.dispatchEvent(new EventTaomee(USER_LOCKHOME,getUsersBasicObj));
      }
   }
}

