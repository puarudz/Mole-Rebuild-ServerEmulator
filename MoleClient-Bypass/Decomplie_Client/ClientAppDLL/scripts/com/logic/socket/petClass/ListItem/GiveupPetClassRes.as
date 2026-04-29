package com.logic.socket.petClass.ListItem
{
   import com.event.EventTaomee;
   
   public class GiveupPetClassRes
   {
      
      public static var GIVEUP_PETCLASS:String = "giveup_petclass";
      
      public function GiveupPetClassRes()
      {
         super();
      }
      
      public function ListClass() : void
      {
         var flag:uint = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("giveup_petclass",{"petFlag":flag}));
      }
   }
}

