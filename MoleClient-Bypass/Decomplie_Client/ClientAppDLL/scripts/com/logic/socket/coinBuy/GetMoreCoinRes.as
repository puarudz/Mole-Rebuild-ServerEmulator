package com.logic.socket.coinBuy
{
   import com.event.EventTaomee;
   
   public class GetMoreCoinRes
   {
      
      public static var GETITEM_OK:String = "getmore_coinItem_ok";
      
      public function GetMoreCoinRes()
      {
         super();
      }
      
      public function getBackFun() : void
      {
         var objs:Object = null;
         var prc:uint = 0;
         var prc_vip:uint = 0;
         var prc_unvip:uint = 0;
         var Obj:Object = new Object();
         Obj.Count = GV.onlineSocket.readUnsignedInt();
         Obj.Arr = [];
         if(Obj.Count == 0)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee(GETITEM_OK,{"obj":Obj}));
            return;
         }
         var lg:uint = uint(Obj.Count);
         for(var i:uint = 0; i < lg; i++)
         {
            objs = new Object();
            objs.ID = GV.onlineSocket.readUnsignedInt();
            prc = GV.onlineSocket.readUnsignedInt();
            prc_vip = GV.onlineSocket.readUnsignedInt();
            prc_unvip = GV.onlineSocket.readUnsignedInt();
            objs.Price = prc / 100;
            objs.VIP_Price = prc_vip / 100;
            objs.UNVIP_Price = prc_unvip / 100;
            Obj.Arr.push(objs);
         }
         var obj_s:Object = {"obj":Obj};
         GV.onlineSocket.dispatchEvent(new EventTaomee(GETITEM_OK,obj_s));
      }
   }
}

