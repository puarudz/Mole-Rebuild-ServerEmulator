package com.logic.socket.HatchLongEgg
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class HatchLongEggSocket
   {
      
      public function HatchLongEggSocket()
      {
         super();
      }
      
      public static function getLongEggTimer() : void
      {
         MsgHead.Command = 1237;
         GF.writeHead();
      }
      
      public static function res_getLongEggTimer() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.itemId = output.readUnsignedInt();
         obj.time = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1237,obj));
      }
      
      public static function hatchLongEgg(longEggId:int) : void
      {
         MsgHead.Command = 1233;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(longEggId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_hatchLongEgg() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.itemID = output.readUnsignedInt();
         obj.time = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1233,obj));
      }
      
      public static function speedHatchLongEgg(itemID:int) : void
      {
         MsgHead.Command = 1234;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(itemID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_speedHatchLongEgg() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.goodsId = output.readUnsignedInt();
         obj.time = output.readUnsignedInt();
         obj.useTime = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1234,obj));
      }
      
      public static function getLongEgg() : void
      {
         MsgHead.Command = 1235;
         GF.writeHead();
      }
      
      public static function res_getLongEgg() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.longId = output.readUnsignedInt();
         obj.eggId = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1235,obj));
      }
   }
}

