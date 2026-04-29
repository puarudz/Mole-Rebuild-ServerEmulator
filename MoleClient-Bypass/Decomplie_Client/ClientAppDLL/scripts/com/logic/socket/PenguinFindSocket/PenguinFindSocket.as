package com.logic.socket.PenguinFindSocket
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class PenguinFindSocket
   {
      
      public function PenguinFindSocket()
      {
         super();
      }
      
      public static function getPenguinData() : void
      {
         MsgHead.Command = 1387;
         GF.writeHead();
      }
      
      public static function res_getPenguinData() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = {};
         obj.penguinCount = output.readUnsignedInt();
         obj.saveData = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1387,obj));
      }
      
      public static function setPenguinData(sign:int, value:int) : void
      {
         MsgHead.Command = 1388;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(sign);
         tempByteArray.writeUnsignedInt(value);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_setPenguinData() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = {};
         obj.penguinId = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1388,obj));
      }
   }
}

