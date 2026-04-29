package com.logic.socket.house
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   
   public class HouseSocket
   {
      
      public function HouseSocket()
      {
         super();
      }
      
      public static function setMomoPhoto(clothArr:Array, type:int = 161070) : void
      {
         MsgHead.Command = 8540;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(type);
         tempByteArray.writeUnsignedInt(clothArr.length);
         for(var i:uint = 0; i < clothArr.length; i++)
         {
            tempByteArray.writeUnsignedInt(clothArr[i]);
         }
         GF.writeHead(tempByteArray);
      }
      
      public static function res_setMomoPhoto() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 8540));
      }
      
      public static function getMomoPhoto(tempUserId:int, type:int = 161070) : void
      {
         MsgHead.Command = 8541;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(tempUserId);
         tempByteArray.writeUnsignedInt(type);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getMomoPhoto() : void
      {
         var obj:Object = new Object();
         obj.arr = new Array();
         var type:int = int(GV.onlineSocket.readUnsignedInt());
         obj.clothArrCount = GV.onlineSocket.readUnsignedInt();
         for(var i:uint = 0; i < obj.clothArrCount; i++)
         {
            obj.arr.push(GV.onlineSocket.readUnsignedInt());
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 8541,obj));
      }
      
      public static function getGroupPhotoData(tempUserId:int) : void
      {
         MsgHead.Command = 1980;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(tempUserId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getGroupPhotoData() : void
      {
         var obj:Object = new Object();
         obj.arr = new Array();
         obj.clothArrCount = GV.onlineSocket.readUnsignedInt();
         for(var i:uint = 0; i < obj.clothArrCount; i++)
         {
            obj.arr.push(GV.onlineSocket.readUnsignedInt());
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1980,obj));
      }
      
      public static function setGroupPhotoData(clothArr:Array) : void
      {
         MsgHead.Command = 1979;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(clothArr.length);
         for(var i:uint = 0; i < clothArr.length; i++)
         {
            tempByteArray.writeUnsignedInt(clothArr[i]);
         }
         GF.writeHead(tempByteArray);
      }
      
      public static function res_setGroupPhotoData() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1979));
      }
      
      public static function setMomoPhotoData(momoType:uint, clothArr:Array) : void
      {
         MsgHead.Command = 1933;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(momoType);
         tempByteArray.writeUnsignedInt(clothArr.length);
         for(var i:uint = 0; i < clothArr.length; i++)
         {
            tempByteArray.writeUnsignedInt(clothArr[i]);
         }
         GF.writeHead(tempByteArray);
      }
      
      public static function res_setMomoPhotoData() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1933));
      }
      
      public static function getMomoPhotoData(tempUserId:int) : void
      {
         MsgHead.Command = 1934;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(tempUserId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getMomoPhotoData() : void
      {
         var obj:Object = new Object();
         obj.arr = new Array();
         obj.momoType = GV.onlineSocket.readUnsignedInt();
         obj.clothArrCount = GV.onlineSocket.readUnsignedInt();
         for(var i:uint = 0; i < obj.clothArrCount; i++)
         {
            obj.arr.push(GV.onlineSocket.readUnsignedInt());
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1934,obj));
      }
      
      public static function getModelShowCloths() : void
      {
         MsgHead.Command = 1939;
         GF.writeHead();
      }
      
      public static function res_getModelShowCloths() : void
      {
         var objs:Object = null;
         var i:uint = 0;
         trace(GV.onlineSocket.bytesAvailable);
         var obj:Object = new Object();
         obj.arr = new Array();
         obj.modelCount = GV.onlineSocket.readUnsignedInt();
         trace("模特數量：  " + obj.modelCount);
         for(var m:int = 0; m < obj.modelCount; m++)
         {
            objs = new Object();
            objs.modelArr = new Array();
            objs.modelId = GV.onlineSocket.readUnsignedInt();
            trace("模特id: " + objs.modelId);
            objs.modelClothCount = GV.onlineSocket.readUnsignedInt();
            trace("模特衣服數量： " + objs.modelClothCount);
            for(i = 0; i < objs.modelClothCount; i++)
            {
               objs.modelArr.push(GV.onlineSocket.readUnsignedInt());
            }
            obj.arr.push(objs);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1939,obj));
      }
      
      public static function modelClothsTomoleCloths(tempModelId:int) : void
      {
         MsgHead.Command = 1940;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(tempModelId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_modelClothsTomoleCloths() : void
      {
         var obj:Object = new Object();
         obj.arr = new Array();
         obj.itmid = GV.onlineSocket.readUnsignedInt();
         obj.clothArrCount = GV.onlineSocket.readUnsignedInt();
         for(var i:uint = 0; i < obj.clothArrCount; i++)
         {
            obj.arr.push(GV.onlineSocket.readUnsignedInt());
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1940,obj));
      }
      
      public static function moleClothsToModelCloths(tempModelId:int) : void
      {
         MsgHead.Command = 1941;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(tempModelId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_moleClothsToModelCloths() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1941));
      }
      
      public static function getBell() : void
      {
         MsgHead.Command = 1960;
         GF.writeHead();
      }
      
      public static function res_getBell() : void
      {
         var obj:Object = new Object();
         obj.itemId = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1960,obj));
      }
   }
}

