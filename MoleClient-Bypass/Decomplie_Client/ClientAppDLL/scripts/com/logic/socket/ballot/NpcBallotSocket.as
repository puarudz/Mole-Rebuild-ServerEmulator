package com.logic.socket.ballot
{
   import com.common.msgHead.MsgHead;
   import com.common.util.BitArray;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class NpcBallotSocket
   {
      
      public function NpcBallotSocket()
      {
         super();
      }
      
      public static function NpcBallotReq() : void
      {
         MsgHead.Command = 2008;
         var tempByteArray:ByteArray = new ByteArray();
         GF.writeHead(tempByteArray);
      }
      
      public static function NpcBallotRes() : void
      {
         var type:uint = 0;
         var input:IDataInput = GV.onlineSocket;
         var dataByte:BitArray = new BitArray();
         var obj:Object = new Object();
         var _arr:Array = [];
         obj.type = input.readUnsignedInt();
         _arr.push(obj.type);
         for(var i:int = 0; i < 7; i++)
         {
            type = input.readUnsignedInt();
            _arr.push(type);
         }
         for(i = _arr.length - 1; i > 0; i--)
         {
            dataByte.writeUnsignedInt(_arr[i]);
         }
         dataByte.writeUnsignedInt(obj.type);
         obj.arr = _arr;
         obj.data = dataByte;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 2008,obj));
      }
   }
}

