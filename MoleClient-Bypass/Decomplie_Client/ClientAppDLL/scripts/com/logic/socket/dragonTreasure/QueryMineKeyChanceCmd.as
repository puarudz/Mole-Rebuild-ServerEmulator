package com.logic.socket.dragonTreasure
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   
   public class QueryMineKeyChanceCmd
   {
      
      public static const READ_8087:String = "read_8087";
      
      public function QueryMineKeyChanceCmd()
      {
         super();
      }
      
      public static function sendReq() : void
      {
         MsgHead.Command = 8087;
         GF.writeHead();
      }
      
      public static function res_QueryMineKeyChanceCmd() : void
      {
         var flag:* = GV.onlineSocket.readUnsignedInt();
         var obj:Object = {};
         obj.flag = flag;
         GV.onlineSocket.dispatchEvent(new EventTaomee(QueryMineKeyChanceCmd.READ_8087,obj));
      }
   }
}

