package com.logic.socket.smc
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   
   public class JobSocket
   {
      
      public function JobSocket()
      {
         super();
      }
      
      public static function pickMomoHat(hatID:uint, type:uint = 0) : void
      {
         MsgHead.Command = 1916;
         var byteArray:ByteArray = new ByteArray();
         byteArray.writeUnsignedInt(hatID);
         byteArray.writeUnsignedInt(type);
         GF.writeHead(byteArray);
      }
      
      public static function res_pickMomoHat() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1916));
      }
      
      public static function pickMomoCloth(id:uint) : void
      {
         MsgHead.Command = 1927;
         var byteArray:ByteArray = new ByteArray();
         byteArray.writeUnsignedInt(id);
         GF.writeHead(byteArray);
      }
      
      public static function res_pickMomoCloth() : void
      {
         var obj:Object = new Object();
         obj.itemID1 = GV.onlineSocket.readUnsignedInt();
         obj.itemID2 = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1927,obj));
      }
   }
}

