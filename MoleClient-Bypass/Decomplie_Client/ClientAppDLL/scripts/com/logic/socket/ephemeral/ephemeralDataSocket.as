package com.logic.socket.ephemeral
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class ephemeralDataSocket
   {
      
      public function ephemeralDataSocket()
      {
         super();
      }
      
      public static function getData(_type:uint) : void
      {
         MsgHead.Command = 1215;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(_type);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getData() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.type = output.readUnsignedInt();
         obj.data = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1215,obj));
      }
      
      public static function setData(_type:uint, _data:uint) : void
      {
         MsgHead.Command = 1216;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(_type);
         tempByteArray.writeUnsignedInt(_data);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_setData() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1216));
      }
      
      public static function setObjData(_type:uint, _data:Object) : void
      {
         MsgHead.Command = 1099;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(_type);
         tempByteArray.writeObject(_data);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_setObjData() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1099));
      }
      
      public static function getObjData(_type:uint) : void
      {
         MsgHead.Command = 1098;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(_type);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getObjData() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.type = output.readUnsignedInt();
         obj.data = output.readObject();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1098,obj));
      }
      
      public static function convertItem(itemId:uint) : void
      {
         MsgHead.Command = 1128;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(itemId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_convertItem() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.itemId = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1128,obj));
      }
   }
}

