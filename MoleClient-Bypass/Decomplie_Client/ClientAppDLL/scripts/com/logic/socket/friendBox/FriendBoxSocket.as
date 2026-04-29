package com.logic.socket.friendBox
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class FriendBoxSocket
   {
      
      public function FriendBoxSocket()
      {
         super();
      }
      
      public static function setFriendBoxRequest(itemId:uint, itemCount:uint) : void
      {
         MsgHead.Command = 1247;
         var byte:ByteArray = new ByteArray();
         byte.writeUnsignedInt(itemId);
         byte.writeUnsignedInt(itemCount);
         GF.writeHead(byte);
      }
      
      public static function setFriendBoxResponse() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1247));
      }
      
      public static function getFriendBoxRequest(userId:uint, itemId:uint, count:uint) : void
      {
         MsgHead.Command = 1248;
         var byte:ByteArray = new ByteArray();
         byte.writeUnsignedInt(userId);
         byte.writeUnsignedInt(itemId);
         byte.writeUnsignedInt(count);
         GF.writeHead(byte);
      }
      
      public static function getFriendBoxResponse() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1248));
      }
      
      public static function getFriendBoxInfoRequest(userId:uint) : void
      {
         MsgHead.Command = 1249;
         var byte:ByteArray = new ByteArray();
         byte.writeUnsignedInt(userId);
         GF.writeHead(byte);
      }
      
      public static function getFriendBoxInfoResponse() : void
      {
         var arr:Array = null;
         var i:int = 0;
         var _data_input:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.count = _data_input.readUnsignedInt();
         if(obj.count > 0)
         {
            arr = new Array();
            for(i = 0; i < obj.count; i++)
            {
               arr[i] = new Object();
               arr[i].itemId = _data_input.readUnsignedInt();
               arr[i].itemCount = _data_input.readUnsignedInt();
            }
            obj.arr = arr;
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1249,obj));
      }
      
      public static function getFriendBoxRecordRequest(userId:uint) : void
      {
         MsgHead.Command = 1250;
         var byte:ByteArray = new ByteArray();
         byte.writeUnsignedInt(userId);
         GF.writeHead(byte);
      }
      
      public static function getFriendBoxRecordResponse() : void
      {
         var arr:Array = null;
         var i:int = 0;
         var _data_input:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.count = _data_input.readUnsignedInt();
         if(obj.count > 0)
         {
            arr = new Array();
            for(i = 0; i < obj.count; i++)
            {
               arr[i] = new Object();
               arr[i].userId = _data_input.readUnsignedInt();
               arr[i].itemId = _data_input.readUnsignedInt();
               arr[i].nick = _data_input.readUTFBytes(16);
               arr[i].color = _data_input.readUnsignedInt();
               arr[i].isvip = _data_input.readUnsignedInt();
               arr[i].stamp = _data_input.readUnsignedInt();
            }
            obj.arr = arr;
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1250,obj));
      }
   }
}

