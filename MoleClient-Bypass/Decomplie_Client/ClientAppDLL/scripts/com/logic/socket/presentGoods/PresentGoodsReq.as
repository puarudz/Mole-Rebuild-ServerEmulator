package com.logic.socket.presentGoods
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import flash.utils.ByteArray;
   
   public class PresentGoodsReq
   {
      
      public function PresentGoodsReq()
      {
         super();
      }
      
      public static function req(ItemID:int) : void
      {
         MsgHead.PkgLen = 21;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.PRESENT_GOODS);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(ItemID);
         GV.onlineSocket.flush();
      }
      
      public static function PresentToFirend(Type:int, Msg:String, Friendid:uint, Count:int = 1) : void
      {
         MsgHead.PkgLen = 21;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.SWAP_GOODS_AND_PRESENT);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(Type);
         GV.onlineSocket.writeUnsignedInt(Count);
         var buf:ByteArray = new ByteArray();
         buf.writeUTFBytes(Msg);
         while(buf.length < 151)
         {
            buf.writeByte(0);
         }
         GV.onlineSocket.writeBytes(buf);
         GV.onlineSocket.writeUnsignedInt(Friendid);
         GV.onlineSocket.flush();
      }
      
      public static function buyHat(ItemID:int) : void
      {
         MsgHead.PkgLen = 21;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.TWELVE_HAT);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(ItemID);
         GV.onlineSocket.flush();
      }
      
      public static function sendPresentNum() : void
      {
         MsgHead.Command = 1354;
         GF.writeHead();
      }
      
      public static function res_sendPresentNum() : void
      {
         var obj:Object = new Object();
         obj.num = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1354,obj));
      }
      
      public static function getMyPresent(itemid:uint) : void
      {
         MsgHead.Command = 1353;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(itemid);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getMyPresent() : void
      {
         var obj:Object = new Object();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1353));
      }
   }
}

