package com.logic.socket.angelsAndDemons
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   
   public class AngelsWarEndResultsSocket
   {
      
      public function AngelsWarEndResultsSocket()
      {
         super();
      }
      
      public static function angelsWarEndResultsFun(task_id:int, Is_pass:int, Barrier_level:int, Total_score:int, arr:Array, prizeArr:Array, deadArr:Array) : void
      {
         MsgHead.Command = 7072;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(task_id);
         tempByteArray.writeUnsignedInt(Is_pass);
         tempByteArray.writeUnsignedInt(Barrier_level);
         tempByteArray.writeUnsignedInt(Total_score);
         tempByteArray.writeUnsignedInt(arr.length);
         tempByteArray.writeUnsignedInt(prizeArr.length);
         tempByteArray.writeUnsignedInt(deadArr.length);
         for(var i:int = 0; i < arr.length; i++)
         {
            tempByteArray.writeUnsignedInt(arr[i].id);
            tempByteArray.writeUnsignedInt(arr[i].count);
         }
         for(i = 0; i < prizeArr.length; i++)
         {
            tempByteArray.writeUnsignedInt(prizeArr[i].prize_id);
            tempByteArray.writeUnsignedInt(prizeArr[i].prize_count);
         }
         for(i = 0; i < deadArr.length; i++)
         {
            tempByteArray.writeUnsignedInt(deadArr[i].attack_id);
            tempByteArray.writeUnsignedInt(deadArr[i].attack_count);
         }
         GF.writeHead(tempByteArray);
      }
      
      public static function res_angelsWarEndResultsFun() : void
      {
         var b:Object = null;
         var obj:Object = new Object();
         obj.id = GV.onlineSocket.readUnsignedInt();
         obj.exp = GV.onlineSocket.readUnsignedInt();
         obj.level = GV.onlineSocket.readUnsignedInt();
         obj.count = GV.onlineSocket.readUnsignedInt();
         obj.arr = new Array();
         for(var i:int = 0; i < obj.count; i++)
         {
            b = new Object();
            b.awardId = GV.onlineSocket.readUnsignedInt();
            b.awardCount = GV.onlineSocket.readUnsignedInt();
            obj.arr.push(b);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 7072,obj));
      }
   }
}

