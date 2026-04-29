package com.logic.socket.coinBuy
{
   import com.event.EventTaomee;
   
   public class GetOneCoinInfoRes
   {
      
      public static var GETITEM_OK:String = "getone_coinInfo_ok";
      
      public function GetOneCoinInfoRes()
      {
         super();
      }
      
      public function getBackFun() : void
      {
         var Obj:Object = new Object();
         Obj.ID = GV.onlineSocket.readUnsignedInt();
         Obj.Price = GV.onlineSocket.readUnsignedInt();
         Obj.VIP_Price = GV.onlineSocket.readUnsignedInt();
         Obj.UNVIP_Price = GV.onlineSocket.readUnsignedInt();
         Obj.Must_vip = GV.onlineSocket.readByte();
         Obj.Max_num = GV.onlineSocket.readUnsignedInt();
         Obj.Total_num = GV.onlineSocket.readUnsignedInt();
         Obj.Curr_num = GV.onlineSocket.readUnsignedInt();
         Obj.flag = GV.onlineSocket.readByte();
         Obj.Other = GV.onlineSocket.readByte();
         var obj_s:Object = {"obj":Obj};
         GV.onlineSocket.dispatchEvent(new EventTaomee(GETITEM_OK,obj_s));
      }
   }
}

