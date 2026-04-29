package com.logic.socket.temp
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   
   public class Map259Socket
   {
      
      public static const PAPA_QUE:int = 8587;
      
      public function Map259Socket()
      {
         super();
      }
      
      public static function req_papaQue(data:Array) : void
      {
         MsgHead.Command = PAPA_QUE;
         var tempByteArray:ByteArray = new ByteArray();
         var i:int = 0;
         var len:int = int(data.length);
         tempByteArray.writeUnsignedInt(len);
         for(i = 0; i < len; i++)
         {
            tempByteArray.writeUnsignedInt(data[i].que);
            tempByteArray.writeUnsignedInt(data[i].ans);
         }
         GF.writeHead(tempByteArray);
      }
      
      public static function res_papaQue() : void
      {
         var value1:int = int(GV.onlineSocket.readUnsignedInt());
         var value2:int = int(GV.onlineSocket.readUnsignedInt());
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + PAPA_QUE,value2));
      }
   }
}

