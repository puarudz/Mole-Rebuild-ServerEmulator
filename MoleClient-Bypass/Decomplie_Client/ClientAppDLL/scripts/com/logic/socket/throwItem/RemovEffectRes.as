package com.logic.socket.throwItem
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class RemovEffectRes extends EventDispatcher
   {
      
      public static var REMOVE_EFFECT_SUCC:String = "REMOVE_EFFECT_SUCC";
      
      public function RemovEffectRes()
      {
         super();
      }
      
      public function throwItem() : void
      {
         var throwItemObj:Object = new Object();
         throwItemObj.ChangeID = GV.onlineSocket.readUnsignedInt();
         throwItemObj.UserID = GV.onlineSocket.readUnsignedInt();
         throwItemObj.ItemID = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(REMOVE_EFFECT_SUCC,throwItemObj));
      }
   }
}

