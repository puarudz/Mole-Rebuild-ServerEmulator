package com.logic.socket.gotBigProp
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   
   public class GotPropOnlyOneTime
   {
      
      public function GotPropOnlyOneTime()
      {
         super();
      }
      
      public static function gotManyPropOneTimeRequest() : void
      {
         MsgHead.Command = 1994;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(1);
         GF.writeHead(tempByteArray);
      }
      
      public static function getChosenNpcRequest(npcType:uint) : void
      {
         var tempByteArray:ByteArray = null;
         if(npcType == 3 || npcType == 4 || npcType == 7)
         {
            MsgHead.Command = 1994;
            tempByteArray = new ByteArray();
            tempByteArray.writeUnsignedInt(npcType);
            GF.writeHead(tempByteArray);
         }
      }
      
      public static function trainingMarkRequest(data:uint) : void
      {
         MsgHead.Command = 1994;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(data);
         GF.writeHead(tempByteArray);
      }
      
      public static function gotManyPropOneTimeResponse() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1994,null));
      }
   }
}

