package com.logic.socket.coinBuy
{
   import com.event.EventTaomee;
   
   public class CoinParApplyRes
   {
      
      public static var GETITEM_OK:String = "buy_coinParItem_ok";
      
      public function CoinParApplyRes()
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
         var Par_num:uint = GV.onlineSocket.readUnsignedInt();
         var Par_Balance_num:uint = GV.onlineSocket.readUnsignedInt();
         Obj.Par_num = Par_num / 100;
         Obj.Par_Balance_num = Par_Balance_num / 100;
         var obj_s:Object = {"obj":Obj};
         GV.onlineSocket.dispatchEvent(new EventTaomee(GETITEM_OK,obj_s));
      }
   }
}

