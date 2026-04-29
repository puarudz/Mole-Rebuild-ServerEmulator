package com.logic.socket.award
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   
   public class QuGameSockte
   {
      
      public function QuGameSockte()
      {
         super();
      }
      
      public static function quGame_create(type:int, usedArr:Array) : void
      {
         MsgHead.Command = 1327;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(type);
         tempByteArray.writeUnsignedInt(usedArr.length);
         for(var i:uint = 0; i < usedArr.length; i++)
         {
            tempByteArray.writeUnsignedInt(i + 1);
            tempByteArray.writeUnsignedInt(usedArr[i]);
         }
         GF.writeHead(tempByteArray);
      }
      
      public static function res_quGame_create() : void
      {
         var i_obj:Object = null;
         var count:* = GV.onlineSocket.readUnsignedInt();
         var obj:Object = {};
         obj.arr = [];
         for(var i:int = 0; i < count; i++)
         {
            i_obj = new Object();
            i_obj.itemId = GV.onlineSocket.readUnsignedInt();
            i_obj.count = GV.onlineSocket.readUnsignedInt();
            obj.arr.push(i_obj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1327,obj));
      }
   }
}

