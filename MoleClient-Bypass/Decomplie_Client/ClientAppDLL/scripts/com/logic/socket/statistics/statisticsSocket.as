package com.logic.socket.statistics
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   
   public class statisticsSocket
   {
      
      private static var countNum:int;
      
      public function statisticsSocket()
      {
         super();
      }
      
      public static function Statistics(newsID:uint) : void
      {
         MsgHead.Command = 6034;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(newsID);
         if(countNum < 255)
         {
            ++countNum;
         }
         else
         {
            countNum = 0;
         }
         tempByteArray.writeUnsignedInt(countNum);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_Statistics() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 6034));
      }
   }
}

