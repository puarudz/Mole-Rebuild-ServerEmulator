package com.logic.socket
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   
   public class GetAngelSeedsSocket
   {
      
      public static var num:uint = 0;
      
      public function GetAngelSeedsSocket()
      {
         super();
      }
      
      public static function getAngelSeeds(type:int, arr:Array) : void
      {
         MsgHead.Command = 6031;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(type);
         for(var i:int = 0; i < arr.length; i++)
         {
            tempByteArray.writeUnsignedInt(arr[i]);
         }
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getAngelSeeds() : void
      {
         var itemId:uint = 0;
         var obj:Object = new Object();
         var arr:Array = [];
         for(var i:int = 0; i < 4; i++)
         {
            itemId = GV.onlineSocket.readUnsignedInt();
            arr.push(itemId);
         }
         obj.arr = arr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 6031,obj));
      }
   }
}

