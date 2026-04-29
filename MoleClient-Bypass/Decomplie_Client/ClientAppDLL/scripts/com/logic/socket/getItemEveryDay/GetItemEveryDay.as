package com.logic.socket.getItemEveryDay
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class GetItemEveryDay
   {
      
      public function GetItemEveryDay()
      {
         super();
      }
      
      public static function req_getItemEveryDay(type:int) : void
      {
         if(type == 49)
         {
            return;
         }
         MsgHead.Command = 1117;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(type);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getItemEveryDay() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = {};
         obj.type = output.readUnsignedInt();
         obj.itemid = output.readUnsignedInt();
         obj.itmeCount = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1117,obj));
      }
      
      public static function req_getSceneItemEvent(type:int) : void
      {
         MsgHead.Command = 2012;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(type);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getSceneItemEvent() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = {};
         obj.itemid = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 2012,obj));
      }
      
      public static function req_getItemEveryDay2(type:int, conut:int) : void
      {
         MsgHead.Command = 1118;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(type);
         tempByteArray.writeUnsignedInt(conut);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getItemEveryDay2() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = {};
         obj.type = output.readUnsignedInt();
         obj.itemid = output.readUnsignedInt();
         obj.itmeCount = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1117,obj));
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1118,obj));
      }
   }
}

