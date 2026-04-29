package com.logic.socket.angelsAndDemons
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   
   public class AngelsWarBeginSocket
   {
      
      public function AngelsWarBeginSocket()
      {
         super();
      }
      
      public static function angelsWarBeginFun(id:int) : void
      {
         MsgHead.Command = 7071;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(id);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_angelsWarBeginFun() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 7071));
      }
   }
}

