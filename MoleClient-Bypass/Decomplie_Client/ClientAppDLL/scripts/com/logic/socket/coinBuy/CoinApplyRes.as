package com.logic.socket.coinBuy
{
   import com.event.EventTaomee;
   
   public class CoinApplyRes
   {
      
      public static var GETITEM_OK:String = "buy_coinItem_ok";
      
      public function CoinApplyRes()
      {
         super();
      }
      
      public function getBackFun() : void
      {
         var Obj:Object = new Object();
         var Pay_num:uint = GV.onlineSocket.readUnsignedInt();
         var Balance_num:uint = GV.onlineSocket.readUnsignedInt();
         Obj.Pay_num = Pay_num / 100;
         Obj.Balance_num = Balance_num / 100;
         var obj_s:Object = {"obj":Obj};
         GV.onlineSocket.dispatchEvent(new EventTaomee(GETITEM_OK,obj_s));
      }
   }
}

