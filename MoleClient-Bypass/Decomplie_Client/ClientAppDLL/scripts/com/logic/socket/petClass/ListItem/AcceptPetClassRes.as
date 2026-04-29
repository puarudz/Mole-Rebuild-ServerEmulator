package com.logic.socket.petClass.ListItem
{
   import com.event.EventTaomee;
   
   public class AcceptPetClassRes
   {
      
      public static var ACCEPT_CLASS:String = "accept_petclass";
      
      public function AcceptPetClassRes()
      {
         super();
      }
      
      public function ListClass() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("accept_petclass"));
      }
   }
}

