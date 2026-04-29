package com.logic.socket.session
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class BringTagoutLoginSocket
   {
      
      public function BringTagoutLoginSocket()
      {
         super();
      }
      
      public static function getSID() : void
      {
         MsgHead.Command = 2010;
         var tempByteArray:ByteArray = new ByteArray();
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getSID() : void
      {
         var byte:ByteArray = new ByteArray();
         IDataInput(GV.onlineSocket as IDataInput).readBytes(byte);
         byte.position = 0;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 2010,byte));
      }
      
      public static function get_GameSID(gameID:int) : void
      {
         MsgHead.Command = 426;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(gameID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_res_getSID() : void
      {
         var byte:ByteArray = new ByteArray();
         IDataInput(GV.onlineSocket as IDataInput).readBytes(byte);
         byte.position = 0;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 426,byte));
      }
      
      public function SendWaterRes() : void
      {
      }
   }
}

