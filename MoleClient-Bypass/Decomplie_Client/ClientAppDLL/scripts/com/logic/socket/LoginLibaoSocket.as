package com.logic.socket
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   
   public class LoginLibaoSocket
   {
      
      public static var DISPLAY_SHELLS_CMD:int = 8549;
      
      public static var INQUIRY_INFO_CMD:int = 8551;
      
      public function LoginLibaoSocket()
      {
         super();
      }
      
      public static function getLoginInfo() : void
      {
         MsgHead.Command = 6024;
         GF.writeHead();
      }
      
      public static function res_getLoginInfo() : void
      {
         var obj:Object = new Object();
         obj.day = GV.onlineSocket.readUnsignedInt();
         obj.totalDay = GV.onlineSocket.readUnsignedInt();
         obj.round = GV.onlineSocket.readUnsignedInt();
         obj.date = GV.onlineSocket.readUnsignedInt();
         obj.flag = Boolean(GV.onlineSocket.readUnsignedInt());
         var count:uint = GV.onlineSocket.readUnsignedInt();
         var arr:Array = [];
         for(var i:int = 0; i < count; i++)
         {
            arr[i] = {};
            arr[i].itemID = GV.onlineSocket.readUnsignedInt();
            arr[i].count = GV.onlineSocket.readUnsignedInt();
         }
         obj.arr = arr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 6024,obj));
      }
      
      public static function getlongPackageInfo() : void
      {
      }
      
      public static function res_getlongPackageInfo() : void
      {
         var obj:Object = new Object();
         obj.flag = GV.onlineSocket.readUnsignedInt();
         var count:uint = GV.onlineSocket.readUnsignedInt();
         var arr:Array = [];
         for(var i:int = 0; i < count; i++)
         {
            arr[i] = {};
            arr[i].itemID = GV.onlineSocket.readUnsignedInt();
            arr[i].count = GV.onlineSocket.readUnsignedInt();
         }
         obj.arr = arr;
      }
      
      public static function getQueryHeroGame(type:int) : void
      {
         MsgHead.Command = 6029;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(type);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getQueryHeroGame() : void
      {
         var obj:Object = new Object();
         obj.id = GV.onlineSocket.readUnsignedInt();
         obj.flag = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 6029,obj));
      }
      
      public static function getTotallHeroInfo() : void
      {
         MsgHead.Command = 6030;
         GF.writeHead();
      }
      
      public static function res_getTotallHeroInfo() : void
      {
         var obj:Object = new Object();
         obj.count = GV.onlineSocket.readUnsignedInt();
         var arr:Array = [];
         for(var i:int = 0; i < obj.count; i++)
         {
            arr[i] = {};
            arr[i].id = GV.onlineSocket.readUnsignedInt();
         }
         obj.arr = arr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 6030,obj));
      }
      
      public static function setDisplayShells(_type:int) : void
      {
         MsgHead.Command = DISPLAY_SHELLS_CMD;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(_type);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_setDisplayShells() : void
      {
         var obj:Object = new Object();
         obj.usID = GV.onlineSocket.readUnsignedInt();
         obj.flga = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + DISPLAY_SHELLS_CMD,obj));
      }
      
      public static function getInquiryInfo(_type:int = 0) : void
      {
         MsgHead.Command = INQUIRY_INFO_CMD;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(_type);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getInquiryInfo() : void
      {
         var obj:Object = new Object();
         obj.falg = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + INQUIRY_INFO_CMD,obj));
      }
   }
}

