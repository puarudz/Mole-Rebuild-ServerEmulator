package com.logic.socket
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   
   public class HelpAngelsGetAngelSocket
   {
      
      public function HelpAngelsGetAngelSocket()
      {
         super();
      }
      
      public static function helpAngelsGetAngelFun(id:uint) : void
      {
         MsgHead.Command = 7087;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(id);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_helpAngelsGetAngelFun() : void
      {
         var obj:Object = new Object();
         obj.angelId = GV.onlineSocket.readUnsignedInt();
         obj.angelCount = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 7087,obj));
      }
   }
}

