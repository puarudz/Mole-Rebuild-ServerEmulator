package com.logic.socket.angelsAndDemons
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   
   public class GetFightScoreByIDSocket
   {
      
      public function GetFightScoreByIDSocket()
      {
         super();
      }
      
      public static function getFightScoreByIDFun(mapID:int) : void
      {
         MsgHead.Command = 7005;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(mapID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getFightScoreByIDFun() : void
      {
         var obj:Object = new Object();
         obj.mapID = GV.onlineSocket.readUnsignedInt();
         obj.easy = GV.onlineSocket.readUnsignedInt();
         obj.nomal = GV.onlineSocket.readUnsignedInt();
         obj.hard = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 7005,obj));
      }
   }
}

