package com.logic.socket.throwItem
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class ThrowEffectItemRes extends EventDispatcher
   {
      
      public static var EFFECT_ITEM:String = "effect_item";
      
      public static var EFFECT_TIME:String = "effect_time";
      
      public function ThrowEffectItemRes()
      {
         super();
      }
      
      public function throwItem() : void
      {
         var throwItemObj:Object = new Object();
         throwItemObj.UserID = GV.onlineSocket.readUnsignedInt();
         throwItemObj.ChangeID = GV.onlineSocket.readUnsignedInt();
         throwItemObj.ItemID = GV.onlineSocket.readUnsignedInt();
         throwItemObj.OtherID = GV.onlineSocket.readUnsignedInt();
         throwItemObj.FlashTag = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(EFFECT_ITEM,throwItemObj));
      }
      
      public function ItemInvalidation() : void
      {
         var throwItemObj:Object = new Object();
         throwItemObj.UserID = GV.onlineSocket.readUnsignedInt();
         throwItemObj.ItemID = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(EFFECT_TIME,throwItemObj));
      }
   }
}

