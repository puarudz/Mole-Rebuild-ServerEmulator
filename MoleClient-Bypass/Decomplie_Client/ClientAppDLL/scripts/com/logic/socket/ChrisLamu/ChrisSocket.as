package com.logic.socket.ChrisLamu
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class ChrisSocket
   {
      
      public function ChrisSocket()
      {
         super();
      }
      
      public static function getEpistolize(title:String, superPrise:String) : void
      {
         var b:ByteArray = null;
         MsgHead.Command = 1967;
         var tempByteArray:ByteArray = new ByteArray();
         b = new ByteArray();
         b.writeUTFBytes(title);
         b.length = 180;
         tempByteArray.writeBytes(b);
         b = new ByteArray();
         b.writeUTFBytes(superPrise);
         b.length = 180;
         tempByteArray.writeBytes(b);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getEpistolize() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1967));
      }
      
      public static function getSeeInfo() : void
      {
         MsgHead.Command = 1968;
         GF.writeHead();
      }
      
      public static function res_getSeeInfo() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = {};
         obj.surprose = output.readUTFBytes(180);
         obj.whisper = output.readUTFBytes(180);
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1968,obj));
      }
      
      public static function getBeastInfo(_usID:int) : void
      {
         MsgHead.Command = 1486;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(_usID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getBeastInfo() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = {};
         obj.count = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1486,obj));
      }
   }
}

