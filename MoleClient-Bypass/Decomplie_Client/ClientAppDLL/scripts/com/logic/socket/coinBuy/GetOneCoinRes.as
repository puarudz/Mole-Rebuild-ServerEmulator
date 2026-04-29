package com.logic.socket.coinBuy
{
   import com.event.EventTaomee;
   
   public class GetOneCoinRes
   {
      
      public static var GETITEM_OK:String = "getone_coinItem_ok";
      
      public function GetOneCoinRes()
      {
         super();
      }
      
      public function getBackFun() : void
      {
         var objs:Object = new Object();
         objs.ID = GV.onlineSocket.readUnsignedInt();
         objs.Price = GV.onlineSocket.readUnsignedInt();
         objs.VIP_Price = GV.onlineSocket.readUnsignedInt();
         objs.UNVIP_Price = GV.onlineSocket.readUnsignedInt();
         var obj_s:Object = {"obj":objs};
         GV.onlineSocket.dispatchEvent(new EventTaomee(GETITEM_OK,obj_s));
      }
   }
}

