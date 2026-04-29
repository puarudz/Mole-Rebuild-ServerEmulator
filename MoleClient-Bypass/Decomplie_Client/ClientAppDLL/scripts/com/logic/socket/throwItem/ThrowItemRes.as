package com.logic.socket.throwItem
{
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import flash.events.EventDispatcher;
   
   public class ThrowItemRes extends EventDispatcher
   {
      
      public static var THROW_ITEM:String = "throw_item";
      
      public function ThrowItemRes()
      {
         super();
      }
      
      public function throwItem() : void
      {
         var throwItemObj:Object = new Object();
         throwItemObj.UserID = GV.onlineSocket.readUnsignedInt();
         throwItemObj.ItemID = GV.onlineSocket.readUnsignedInt();
         throwItemObj.EndX = GV.onlineSocket.readUnsignedInt();
         throwItemObj.EndY = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(THROW_ITEM,throwItemObj));
         if(throwItemObj.ItemID == 150001)
         {
            GF.sendSocket(CommandID.GOLDEN_BEAN_REWARD,0,9);
         }
      }
   }
}

