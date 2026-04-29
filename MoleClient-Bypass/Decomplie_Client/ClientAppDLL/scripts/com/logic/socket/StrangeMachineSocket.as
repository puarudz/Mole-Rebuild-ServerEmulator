package com.logic.socket
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class StrangeMachineSocket
   {
      
      public function StrangeMachineSocket()
      {
         super();
      }
      
      public static function sellProp(pid:uint) : void
      {
         MsgHead.Command = 1521;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(pid);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_sellProp() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var propID:int = int(output.readUnsignedInt());
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1521,propID));
      }
   }
}

