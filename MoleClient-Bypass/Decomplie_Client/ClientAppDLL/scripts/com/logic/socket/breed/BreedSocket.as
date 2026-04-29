package com.logic.socket.breed
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   
   public class BreedSocket
   {
      
      public function BreedSocket()
      {
         super();
      }
      
      public static function beginBreed(sitNum:int, up:* = true) : void
      {
         MsgHead.Command = 1923;
         if(Boolean(up))
         {
            up = 1;
         }
         else
         {
            up = 0;
         }
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(up);
         tempByteArray.writeUnsignedInt(sitNum);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_beginBreed() : void
      {
         var obj:Object = new Object();
         obj.breedNum = GV.onlineSocket.readUnsignedInt();
         obj.otherUID = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1923,obj));
      }
      
      public static function selectBreed() : void
      {
         MsgHead.Command = 1926;
         var tempByteArray:ByteArray = new ByteArray();
         GF.writeHead(tempByteArray);
      }
      
      public static function res_selectBreed() : void
      {
         var i:int;
         var breedObj:Object = null;
         var obj:Object = new Object();
         try
         {
            obj.count = GV.onlineSocket.readUnsignedInt();
         }
         catch(E:*)
         {
            return;
         }
         obj.arr = new Array();
         for(i = 0; i < obj.count; i++)
         {
            breedObj = new Object();
            breedObj.kindID = GV.onlineSocket.readUnsignedInt();
            breedObj.itemID = GV.onlineSocket.readUnsignedInt();
            breedObj.time = GV.onlineSocket.readUnsignedInt();
            obj.arr.push(breedObj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1926,obj));
      }
      
      public static function getBreedResult(kindID:int) : void
      {
         MsgHead.Command = 1929;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(kindID);
         GF.writeHead(tempByteArray);
      }
      
      public static function allExchange(type:int) : void
      {
         MsgHead.Command = 1987;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(type);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_allExchange() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1987));
      }
      
      public static function getPlaceInfo() : void
      {
         MsgHead.Command = 1924;
         var tempByteArray:ByteArray = new ByteArray();
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetPlaceInfo() : void
      {
         var obj:Object = new Object();
         obj.userID1 = GV.onlineSocket.readUnsignedInt();
         obj.animal1 = GV.onlineSocket.readUnsignedInt();
         obj.userID2 = GV.onlineSocket.readUnsignedInt();
         obj.animal2 = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1924,obj));
      }
   }
}

