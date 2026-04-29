package com.logic.socket.clearAngels
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   
   public class ClearAngelsOverSocket
   {
      
      public function ClearAngelsOverSocket()
      {
         super();
      }
      
      public static function clearAngelsOverFunt() : void
      {
         MsgHead.Command = 7076;
         GF.writeHead();
      }
      
      public static function res_clearAngelsOverFunt() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 7076));
      }
   }
}

