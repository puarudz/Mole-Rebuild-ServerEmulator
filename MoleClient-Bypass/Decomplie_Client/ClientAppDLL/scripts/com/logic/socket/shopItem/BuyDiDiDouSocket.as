package com.logic.socket.shopItem
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class BuyDiDiDouSocket
   {
      
      public function BuyDiDiDouSocket()
      {
         super();
      }
      
      public function buyItemRequest(itemId:uint, itemCount:uint) : void
      {
         MsgHead.Command = 1256;
         var byte:ByteArray = new ByteArray();
         byte.writeUnsignedInt(itemId);
         byte.writeUnsignedInt(itemCount);
         GF.writeHead(byte);
      }
      
      public function buyItemResponse() : void
      {
         var _data_input:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.itemId = _data_input.readUnsignedInt();
         obj.itemCount = _data_input.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1256,obj));
      }
   }
}

