package com.logic.socket.JJLCard
{
   import com.event.EventTaomee;
   
   public class ExchangeMagicCardRes
   {
      
      public static var EXCHANGE_MAGIC_FINISH:String = "exchange_magic_finish";
      
      public function ExchangeMagicCardRes()
      {
         super();
      }
      
      public function backFun() : void
      {
         var obj:Object = new Object();
         obj.count = GV.onlineSocket.readUnsignedInt();
         obj.itemID = GV.onlineSocket.readUnsignedInt();
         obj.itemCount = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("exchange_magic_finish",{"obj":obj}));
      }
   }
}

