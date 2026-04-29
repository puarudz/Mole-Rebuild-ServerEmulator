package com.logic.socket.doWork
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class DoWorkSocket
   {
      
      public function DoWorkSocket()
      {
         super();
      }
      
      public static function doWork_getMoney(TomOrNik:int = 1) : void
      {
         MsgHead.Command = 1481;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(TomOrNik);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_doWork_getMoney() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var moneyNum:uint = output.readUnsignedInt();
         var Flag:uint = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1481,moneyNum));
         GV.onlineSocket.dispatchEvent(new EventTaomee("hasLevel_" + 1481,Flag));
      }
      
      public static function doWork_setHasBiudCard() : void
      {
         MsgHead.Command = 1485;
         var tempByteArray:ByteArray = new ByteArray();
         GF.writeHead(tempByteArray);
      }
      
      public static function res_doWork_setHasBiudCard() : void
      {
         var output:IDataInput = GV.onlineSocket;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1485));
      }
      
      public static function doWork_getWordInfo() : void
      {
         MsgHead.Command = 1482;
         var tempByteArray:ByteArray = new ByteArray();
         GF.writeHead(tempByteArray);
      }
      
      public static function res_doWork_getWordInfo() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var returnObj:Object = {};
         returnObj.Total = output.readUnsignedInt();
         returnObj.Tom_last_wek = output.readUnsignedInt();
         returnObj.Nik_last_wek = output.readUnsignedInt();
         returnObj.Tom_this_wek = output.readUnsignedInt();
         returnObj.Nik_this_wek = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1482,returnObj));
      }
      
      public static function doWork_getWage() : void
      {
         MsgHead.Command = 1483;
         var tempByteArray:ByteArray = new ByteArray();
         GF.writeHead(tempByteArray);
      }
      
      public static function res_doWork_getWage() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var cuurentMonney:uint = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1483,cuurentMonney));
      }
      
      public static function doWork_UpgradedChiefEngineer() : void
      {
         MsgHead.Command = 1484;
         var tempByteArray:ByteArray = new ByteArray();
         GF.writeHead(tempByteArray);
      }
      
      public static function res_doWork_UpgradedChiefEngineer() : void
      {
         var output:IDataInput = GV.onlineSocket;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1484));
      }
   }
}

