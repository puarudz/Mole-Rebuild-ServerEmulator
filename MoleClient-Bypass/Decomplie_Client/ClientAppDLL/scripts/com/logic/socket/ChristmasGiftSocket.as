package com.logic.socket
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   
   public class ChristmasGiftSocket
   {
      
      public function ChristmasGiftSocket()
      {
         super();
      }
      
      public static function getGift(id:int) : void
      {
         id -= 1;
         MsgHead.Command = 1975;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(id);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getGift() : void
      {
         var InfoObj:Object = new Object();
         InfoObj.Pos = GV.onlineSocket.readUnsignedInt();
         InfoObj.Pos += 1;
         InfoObj.UID = GV.onlineSocket.readUnsignedInt();
         InfoObj.ItemID = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1975,InfoObj));
      }
      
      public static function res_giftRain() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1974));
      }
      
      public static function getStarCount() : void
      {
         MsgHead.Command = 1978;
         GF.writeHead();
      }
      
      public static function res_getStarCount() : void
      {
         var obj:Object = new Object();
         obj.count = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1978,obj));
      }
      
      public static function getFootGift() : void
      {
         MsgHead.Command = 1981;
         GF.writeHead();
      }
      
      public static function res_getFootGift() : void
      {
         var obj:Object = new Object();
         obj.type = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1981,obj));
      }
      
      public static function getMiCoin() : void
      {
         MsgHead.Command = 1982;
         GF.writeHead();
      }
      
      public static function res_getMiCoin() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1982));
      }
      
      public static function exchangeTang(itemID:uint, count:uint, NPCID:uint, isGetGift:uint) : void
      {
         MsgHead.Command = 1523;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(itemID);
         tempByteArray.writeUnsignedInt(count);
         tempByteArray.writeUnsignedInt(NPCID);
         tempByteArray.writeUnsignedInt(isGetGift);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_exchangeTang() : void
      {
         var id:uint = 0;
         var InfoObj:Object = new Object();
         InfoObj.Record = GV.onlineSocket.readUnsignedInt();
         InfoObj.itemArr = new Array();
         for(var i:uint = 0; i < InfoObj.Record; i++)
         {
            id = GV.onlineSocket.readUnsignedInt();
            InfoObj.itemArr.push(id);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1523,InfoObj));
      }
      
      public static function getFemaleTiger() : void
      {
         MsgHead.Command = 1985;
         GF.writeHead();
      }
      
      public static function res_getFemaleTiger() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1985));
      }
      
      public static function exYuanBao(itemID:uint, count:uint) : void
      {
         MsgHead.Command = 1986;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(itemID);
         tempByteArray.writeUnsignedInt(count);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_exYuanBao() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1986));
      }
   }
}

