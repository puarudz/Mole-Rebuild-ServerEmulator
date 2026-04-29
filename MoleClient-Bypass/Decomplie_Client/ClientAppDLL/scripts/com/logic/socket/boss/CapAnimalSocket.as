package com.logic.socket.boss
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   
   public class CapAnimalSocket
   {
      
      public function CapAnimalSocket()
      {
         super();
      }
      
      public static function capAnimal(_itemID:uint) : void
      {
         MsgHead.Command = 1992;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(_itemID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_capAnimal() : void
      {
         var Obj:Object = new Object();
         Obj.itemID = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1992,Obj));
      }
   }
}

