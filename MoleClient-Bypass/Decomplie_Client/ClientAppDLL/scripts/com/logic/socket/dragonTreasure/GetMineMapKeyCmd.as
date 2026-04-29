package com.logic.socket.dragonTreasure
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   
   public class GetMineMapKeyCmd
   {
      
      public static const READ_8086:String = "read_8086";
      
      public function GetMineMapKeyCmd()
      {
         super();
      }
      
      public static function sendReq() : void
      {
         MsgHead.Command = 8086;
         GF.writeHead();
      }
      
      public static function res_GetMineMapKeyCmd() : void
      {
         var obj:Object = {};
         obj.ItemID = GV.onlineSocket.readUnsignedInt();
         obj.ItemCount = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(GetMineMapKeyCmd.READ_8086,obj));
      }
   }
}

