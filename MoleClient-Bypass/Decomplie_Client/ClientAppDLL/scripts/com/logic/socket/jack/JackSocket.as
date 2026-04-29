package com.logic.socket.jack
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   
   public class JackSocket
   {
      
      public static const THROW_WATHER_CMD:int = 8543;
      
      public static const GET_TREE_INFO_CMD:int = 8544;
      
      public static const THROW_WATHER:String = "read_8543";
      
      public static const GET_TREE_INFO:String = "read_8544";
      
      public function JackSocket()
      {
         super();
      }
      
      public static function throwWaterBall() : void
      {
         MsgHead.Command = THROW_WATHER_CMD;
         GF.writeHead();
      }
      
      public static function res_ThrowWaterBall() : void
      {
         var itemID:int = int(GV.onlineSocket.readUnsignedInt());
         var o:Object = {"itemID":itemID};
         GV.onlineSocket.dispatchEvent(new EventTaomee(THROW_WATHER,o));
      }
      
      public static function getTreeInfo() : void
      {
         MsgHead.Command = GET_TREE_INFO_CMD;
         GF.writeHead();
      }
      
      public static function res_GetTreeInfo() : void
      {
         var count:int = int(GV.onlineSocket.readUnsignedInt());
         var o:Object = {"count":count};
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_TREE_INFO,o));
      }
   }
}

