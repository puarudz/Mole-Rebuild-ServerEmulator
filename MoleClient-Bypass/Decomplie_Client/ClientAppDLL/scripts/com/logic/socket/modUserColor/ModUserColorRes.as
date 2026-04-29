package com.logic.socket.modUserColor
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class ModUserColorRes extends EventDispatcher
   {
      
      public static var MOD_USER_COLOR:String = "MOD_USER_COLOR";
      
      public function ModUserColorRes()
      {
         super();
      }
      
      public function modUserColor() : void
      {
         var getUsersBasicObj:Object = new Object();
         getUsersBasicObj.UserID = GV.onlineSocket.readUnsignedInt();
         getUsersBasicObj.Nick = GV.onlineSocket.readUTFBytes(16);
         getUsersBasicObj.Color = GV.onlineSocket.readUnsignedInt();
         getUsersBasicObj.Vip = GV.onlineSocket.readUnsignedInt();
         getUsersBasicObj.MapID = GV.onlineSocket.readUnsignedInt();
         getUsersBasicObj.MapType = GV.onlineSocket.readUnsignedInt();
         getUsersBasicObj.Status = GV.onlineSocket.readUnsignedByte();
         getUsersBasicObj.Action = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(MOD_USER_COLOR,getUsersBasicObj));
      }
   }
}

