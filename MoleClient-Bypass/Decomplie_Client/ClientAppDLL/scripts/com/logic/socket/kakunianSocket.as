package com.logic.socket
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.IDataInput;
   
   public class kakunianSocket
   {
      
      public function kakunianSocket()
      {
         super();
      }
      
      public static function trainingNumRequest() : void
      {
         MsgHead.Command = 6028;
         GF.writeHead();
      }
      
      public static function trainingNumResponse() : void
      {
         var _data_input:IDataInput = GV.onlineSocket;
         var count:uint = _data_input.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 6028,count));
      }
      
      public static function DomesticateRequest() : void
      {
         MsgHead.Command = 6027;
         GF.writeHead();
      }
      
      public static function DomesticateResponse() : void
      {
         var _data_input:IDataInput = GV.onlineSocket;
         var flag:uint = _data_input.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 6027,flag));
      }
   }
}

