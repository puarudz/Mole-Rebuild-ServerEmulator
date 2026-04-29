package com.logic.socket.propMake
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class propMakeSocket
   {
      
      public function propMakeSocket()
      {
         super();
      }
      
      public static function propmake(type:int, num:int) : void
      {
         MsgHead.Command = 1995;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(type);
         tempByteArray.writeUnsignedInt(num);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_propmake() : void
      {
         var obj:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var infoObj:Object = {};
         var totalTrueArr:Array = [];
         infoObj.Count = output.readUnsignedInt();
         for(var i:int = 0; i < infoObj.Count; i++)
         {
            obj = new Object();
            obj.itemID = output.readUnsignedInt();
            obj.count = output.readUnsignedInt();
            totalTrueArr.push(obj);
         }
         infoObj.arr = totalTrueArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1995,infoObj));
      }
   }
}

