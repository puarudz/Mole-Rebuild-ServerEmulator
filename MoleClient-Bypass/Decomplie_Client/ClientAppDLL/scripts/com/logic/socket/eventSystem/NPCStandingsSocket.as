package com.logic.socket.eventSystem
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   
   public class NPCStandingsSocket
   {
      
      public function NPCStandingsSocket()
      {
         super();
      }
      
      public static function getNpcStandings(NPC_ID:uint) : void
      {
         MsgHead.Command = 1912;
         var byteArray:ByteArray = new ByteArray();
         byteArray.writeUnsignedInt(NPC_ID);
         GF.writeHead(byteArray);
      }
      
      public static function res_getNpcStandings() : void
      {
         var obj:Object = new Object();
         obj.npcID = GV.onlineSocket.readUnsignedInt();
         obj.standgings = GV.onlineSocket.readShort();
         obj.times = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1912,obj));
      }
      
      public static function changeNpcStandings(NPC_ID:uint, standingValue:int) : void
      {
         MsgHead.Command = 1914;
         var byteArray:ByteArray = new ByteArray();
         byteArray.writeUnsignedInt(NPC_ID);
         byteArray.writeInt(standingValue);
         GF.writeHead(byteArray);
      }
      
      public static function res_changeNpcStandings() : void
      {
         var obj:Object = new Object();
         obj.npcID = GV.onlineSocket.readUnsignedInt();
         obj.standgings = GV.onlineSocket.readShort();
         obj.times = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1914,obj));
      }
   }
}

