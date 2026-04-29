package com.logic.socket.examinePack
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class examinePackStuff
   {
      
      private static var arr:Array = [];
      
      public function examinePackStuff()
      {
         super();
      }
      
      public static function examinePack_create(usedArr:Array, isUseQueryImpl:Boolean = false) : void
      {
         MsgHead.Command = 1915;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(usedArr.length);
         for(var i:uint = 0; i < usedArr.length; i++)
         {
            tempByteArray.writeUnsignedInt(usedArr[i]);
         }
         GF.writeHead(tempByteArray);
         if(isUseQueryImpl)
         {
            arr.push(1);
         }
         else
         {
            arr.push(0);
         }
      }
      
      public static function res_examinePack_create() : void
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
         var b:Boolean = int(arr.shift()) == 1 ? true : false;
         if(b)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("QueryItem_read_" + 1915,infoObj));
         }
         else
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1915,infoObj));
         }
      }
   }
}

