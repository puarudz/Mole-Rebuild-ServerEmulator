package com.logic.socket.haircut
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class HaircutSocket
   {
      
      public function HaircutSocket()
      {
         super();
      }
      
      public static function getBarbershopSit() : void
      {
         MsgHead.Command = 60016;
         var tempByteArray:ByteArray = new ByteArray();
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getBarbershopSit() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var arr:Array = new Array();
         var obj:Object = new Object();
         for(var i:int = 0; i < 6; i++)
         {
            if(Boolean(i % 2))
            {
               obj.state = output.readUnsignedInt();
               arr.push(obj);
            }
            else
            {
               obj = new Object();
               obj.Uid = output.readUnsignedInt();
            }
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 60016,arr));
      }
   }
}

