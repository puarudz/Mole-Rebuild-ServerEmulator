package com.logic.socket.defend
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   
   public class defendSocket
   {
      
      public function defendSocket()
      {
         super();
      }
      
      public static function seedefendTime(_uID:uint, ID:int) : void
      {
         MsgHead.Command = 1991;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(_uID);
         tempByteArray.writeUnsignedInt(ID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_seedefendTime() : void
      {
         var obj:Object = new Object();
         obj.ID = GV.onlineSocket.readUnsignedInt();
         obj.Time = GV.onlineSocket.readUnsignedInt();
         obj.PwaterCou = GV.onlineSocket.readUnsignedInt();
         obj.IkillCou = GV.onlineSocket.readUnsignedInt();
         obj.AwaterCou = GV.onlineSocket.readUnsignedInt();
         obj.Acatch = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1991,obj));
      }
      
      public static function eatfood(ID:int, itemID:uint, count:uint) : void
      {
         MsgHead.Command = 1990;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(ID);
         tempByteArray.writeUnsignedInt(itemID);
         tempByteArray.writeUnsignedInt(count);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_eatfood() : void
      {
         var obj:Object = new Object();
         obj.Time = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1990,obj));
      }
      
      public static function backDefend(ID:int) : void
      {
         MsgHead.Command = 1989;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(ID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_backDefend() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1989));
      }
   }
}

