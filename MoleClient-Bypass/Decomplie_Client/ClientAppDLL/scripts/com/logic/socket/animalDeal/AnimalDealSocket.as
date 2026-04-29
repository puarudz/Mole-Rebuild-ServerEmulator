package com.logic.socket.animalDeal
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   
   public class AnimalDealSocket
   {
      
      public function AnimalDealSocket()
      {
         super();
      }
      
      public static function askAnimalCount(animalID:uint) : void
      {
         MsgHead.Command = 1959;
         var byteArray:ByteArray = new ByteArray();
         byteArray.writeUnsignedInt(animalID);
         GF.writeHead(byteArray);
      }
      
      public static function res_askAnimalCount() : void
      {
         var obj:Object = new Object();
         obj.animalID = GV.onlineSocket.readUnsignedInt();
         obj.animalCount = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1959,obj));
      }
      
      public static function buyAnimalCount(animalID:uint) : void
      {
         MsgHead.Command = 1925;
         var byteArray:ByteArray = new ByteArray();
         byteArray.writeUnsignedInt(animalID);
         GF.writeHead(byteArray);
      }
      
      public static function res_buyAnimalCount() : void
      {
         var obj:Object = new Object();
         obj.animalID = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1925,obj));
      }
      
      public static function milking_the_cow() : void
      {
         MsgHead.Command = 1993;
         var byteArray:ByteArray = new ByteArray();
         GF.writeHead(byteArray);
      }
      
      public static function res_milking_the_cow() : void
      {
         var obj:Object = new Object();
         obj.itemID = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1993,obj));
      }
   }
}

