package com.logic.socket.smc.PickItem
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class PickItemRes extends EventDispatcher
   {
      
      public static var PICK_ITEM:String = "pick_item";
      
      public function PickItemRes()
      {
         super();
      }
      
      public function pickItem() : void
      {
         var pickItemObj:Object = new Object();
         pickItemObj.ItemID = GV.onlineSocket.readUnsignedInt();
         pickItemObj.Count = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(PICK_ITEM,pickItemObj));
      }
   }
}

