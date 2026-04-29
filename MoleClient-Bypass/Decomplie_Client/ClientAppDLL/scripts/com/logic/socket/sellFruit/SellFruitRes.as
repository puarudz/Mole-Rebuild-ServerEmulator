package com.logic.socket.sellFruit
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class SellFruitRes extends EventDispatcher
   {
      
      public static var SOLD_FRUIT_SUCC:String = "SOLD_FRUIT_SUCC";
      
      public function SellFruitRes()
      {
         super();
      }
      
      public function getSoldFruitRes() : void
      {
         var obj:Object = new Object();
         obj.Yxb = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(SOLD_FRUIT_SUCC,obj));
      }
   }
}

