package com.logic.socket.clearAngels
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   
   public class ClearAngelsGameStartSocket
   {
      
      public function ClearAngelsGameStartSocket()
      {
         super();
      }
      
      public static function gameBeginFun(prop_Id:int) : void
      {
         MsgHead.Command = 7073;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(prop_Id);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_gameBeginFun() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 7073));
      }
   }
}

