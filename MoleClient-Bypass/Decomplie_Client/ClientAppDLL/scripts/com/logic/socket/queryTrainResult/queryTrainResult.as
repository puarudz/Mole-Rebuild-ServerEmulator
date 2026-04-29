package com.logic.socket.queryTrainResult
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.IDataInput;
   
   public class queryTrainResult
   {
      
      public function queryTrainResult()
      {
         super();
      }
      
      public static function queryTrainResultFun() : void
      {
         MsgHead.Command = 807;
         GF.writeHead();
      }
      
      public static function res_queryTrainResultFun() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.Step = output.readUnsignedInt();
         obj.Exp = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 807,obj));
      }
      
      public static function queryNewCardBook() : void
      {
         MsgHead.Command = 1223;
         GF.writeHead();
      }
      
      public static function res_queryNewCardBook() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.ret = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1223,obj));
      }
      
      public static function receiveCardBrand() : void
      {
         MsgHead.Command = 1222;
         GF.writeHead();
      }
      
      public static function res_receiveCardBrand() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1222));
      }
      
      public static function recDragonEggs() : void
      {
         MsgHead.Command = 1226;
         GF.writeHead();
      }
      
      public static function res_recDragonEggs() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.id = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1226,obj));
      }
   }
}

