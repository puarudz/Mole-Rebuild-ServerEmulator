package com.logic.socket.superlamuParty
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class superlamuPartySocket
   {
      
      public function superlamuPartySocket()
      {
         super();
      }
      
      public static function treasurebowl(entryId:int, itemoutIndex:int = 0, moneycount:int = 0) : void
      {
         MsgHead.Command = CommandID.TreasureBowl;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(entryId);
         tempByteArray.writeUnsignedInt(itemoutIndex);
         tempByteArray.writeUnsignedInt(moneycount);
         GF.writeHead(tempByteArray);
      }
      
      public static function treasurebowl2(entryId:int, itemoutIndex:int = 0, moneycount:int = 0) : void
      {
         MsgHead.Command = CommandID.TreasureBowl2;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(entryId);
         tempByteArray.writeUnsignedInt(itemoutIndex);
         tempByteArray.writeUnsignedInt(moneycount);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_treasurebowl() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.type = output.readUnsignedInt();
         obj.itemId = output.readUnsignedInt();
         obj.count = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + CommandID.TreasureBowl,obj));
      }
   }
}

