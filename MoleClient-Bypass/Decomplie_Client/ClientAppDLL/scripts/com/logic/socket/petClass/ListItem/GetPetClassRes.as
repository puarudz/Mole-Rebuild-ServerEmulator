package com.logic.socket.petClass.ListItem
{
   import com.event.EventTaomee;
   
   public class GetPetClassRes
   {
      
      public static var GET_CLASS:String = "get_petclass";
      
      public function GetPetClassRes()
      {
         super();
      }
      
      public function ListClass() : void
      {
         var i:int = 0;
         var obj:Object = null;
         var arr:Array = new Array();
         var count:uint = GV.onlineSocket.readUnsignedInt();
         if(count > 0)
         {
            for(i = 0; i < count; i++)
            {
               obj = new Object();
               obj.petID = GV.onlineSocket.readUnsignedInt();
               obj.petNick = GV.onlineSocket.readUTFBytes(16);
               obj.petColor = GV.onlineSocket.readUnsignedInt();
               obj.petLevel = GV.onlineSocket.readUnsignedByte();
               obj.classID = GV.onlineSocket.readUnsignedInt();
               obj.classStep = GV.onlineSocket.readUnsignedInt();
               obj.client_data = GV.onlineSocket.readUnsignedInt();
               obj.arr = this.getArr(obj.client_data);
               arr.push(obj);
            }
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("get_petclass",{"petClass":arr}));
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

