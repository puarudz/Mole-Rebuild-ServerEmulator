package com.logic.socket
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   
   public class cottonSocket
   {
      
      public function cottonSocket()
      {
         super();
      }
      
      public static function getCotton(type:int) : void
      {
         MsgHead.Command = 5700;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(type);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getCotton() : void
      {
         var obj:Object = new Object();
         obj.typeID = GV.onlineSocket.readUnsignedInt();
         obj.ItemID = GV.onlineSocket.readUnsignedInt();
         obj.ItemEX = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 5700,obj));
      }
   }
}

