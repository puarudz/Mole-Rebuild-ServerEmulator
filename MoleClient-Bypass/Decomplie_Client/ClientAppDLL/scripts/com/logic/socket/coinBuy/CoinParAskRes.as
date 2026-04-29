package com.logic.socket.coinBuy
{
   import com.event.EventTaomee;
   
   public class CoinParAskRes
   {
      
      public static var GETITEM_OK:String = "ask_coinParItem_ok";
      
      public function CoinParAskRes()
      {
         super();
      }
      
      public function getBackFun() : void
      {
         var Obj:Object = new Object();
         var Pay_num:uint = GV.onlineSocket.readUnsignedInt();
         var Par_num:uint = GV.onlineSocket.readUnsignedInt();
         Obj.Pay_num = Pay_num / 100;
         Obj.Par_num = Par_num / 100;
         var obj_s:Object = {"obj":Obj};
         GV.onlineSocket.dispatchEvent(new EventTaomee(GETITEM_OK,obj_s));
      }
   }
}

