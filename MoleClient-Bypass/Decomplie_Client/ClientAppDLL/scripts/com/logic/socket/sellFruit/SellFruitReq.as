package com.logic.socket.sellFruit
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import flash.events.EventDispatcher;
   
   public class SellFruitReq extends EventDispatcher
   {
      
      public function SellFruitReq()
      {
         super();
      }
      
      public static function sendSellFruitReq(Itmid:uint, Cnt:uint) : void
      {
         MsgHead.PkgLen = 25;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.SELL_FRUIT_REQUEST);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(Itmid);
         GV.onlineSocket.writeUnsignedInt(Cnt);
         GV.onlineSocket.flush();
      }
   }
}

