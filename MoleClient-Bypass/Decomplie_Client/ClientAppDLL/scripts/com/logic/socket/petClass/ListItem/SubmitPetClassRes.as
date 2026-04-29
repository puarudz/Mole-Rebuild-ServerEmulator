package com.logic.socket.petClass.ListItem
{
   import com.event.EventTaomee;
   
   public class SubmitPetClassRes
   {
      
      public static var SUBMIT_PETCLASS:String = "submit_petclass";
      
      public function SubmitPetClassRes()
      {
         super();
      }
      
      public function ListClass() : void
      {
         var flag:uint = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("submit_petclass",{"petFlag":flag}));
      }
   }
}

