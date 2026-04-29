package com.logic.socket.coinBuy
{
   import com.event.EventTaomee;
   
   public class ISCoinRes
   {
      
      public static var GETITEM_OK:String = "is_coin_bln";
      
      public function ISCoinRes()
      {
         super();
      }
      
      public function getBackFun() : void
      {
         var Obj:Object = new Object();
         Obj.Bln = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(GETITEM_OK,Obj));
      }
   }
}

