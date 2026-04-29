package com.logic.socket.petClass.expandItem
{
   import com.event.EventTaomee;
   import flash.display.Sprite;
   import flash.utils.ByteArray;
   
   public class GetPetClassJobRes extends Sprite
   {
      
      public static var GET_BACK:String = "get_back_classjob";
      
      public function GetPetClassJobRes()
      {
         super();
      }
      
      public function getBackFun() : void
      {
         var obj:Object = new Object();
         obj.petID = GV.onlineSocket.readUnsignedInt();
         obj.classID = GV.onlineSocket.readUnsignedInt();
         if(obj.classID == 101)
         {
            this.makeClassJob(obj);
         }
         if(obj.classID == 102)
         {
            this.makeClassJob(obj);
         }
         if(obj.classID == 103)
         {
            this.makeClassJob(obj);
         }
         if(obj.classID == 104)
         {
            this.makeClassJob(obj);
         }
      }
      
      private function makeClassJob(obj:Object) : void
      {
         obj.status = GV.onlineSocket.readUnsignedInt();
         obj.arr = this.getArr(obj.status);
         var lg:uint = 50 - 12;
         var arr:ByteArray = new ByteArray();
         for(var i:int = 0; i < lg; i++)
         {
            arr.writeByte(0);
         }
         GV.onlineSocket.readBytes(arr);
         GV.onlineSocket.dispatchEvent(new EventTaomee("get_back_classjob",{"obj":obj}));
      }
      
      private function getArr(status:uint) : Array
      {
         var arr:Array = [];
         for(var i:uint = 0; i < 32; i++)
         {
            arr.push(uint(Boolean(status >> i & 2)));
         }
         return arr;
      }
   }
}

