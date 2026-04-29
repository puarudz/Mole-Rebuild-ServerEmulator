package com.logic.socket.clothReview2008
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   
   public class ClothReviewSocket
   {
      
      public static const GET_VOTE_INFO_CMD:int = 8105;
      
      public static const VOTE_CMD:int = 8104;
      
      public function ClothReviewSocket()
      {
         super();
      }
      
      public static function getVoteInfo() : void
      {
         MsgHead.Command = GET_VOTE_INFO_CMD;
         GF.writeHead();
      }
      
      public static function res_GetVoteInfo() : void
      {
         var obj:Object = null;
         var arr:Array = [];
         var count:int = int(GV.onlineSocket.readUnsignedInt());
         for(var i:int = 0; i < count; i++)
         {
            obj = new Object();
            obj.itemID = GV.onlineSocket.readUnsignedInt();
            obj.score = GV.onlineSocket.readUnsignedInt();
            arr.push(obj);
         }
         var o:Object = {
            "count":count,
            "arr":arr
         };
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + GET_VOTE_INFO_CMD,o));
      }
      
      public static function vote(count:int, arr:Array) : void
      {
         MsgHead.Command = VOTE_CMD;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(count);
         for(var i:int = 0; i < count; i++)
         {
            tempByteArray.writeUnsignedInt(arr[i].itemID);
            tempByteArray.writeUnsignedInt(arr[i].score);
         }
         GF.writeHead(tempByteArray);
      }
      
      public static function res_Vote() : void
      {
         var o:Object = {};
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + VOTE_CMD,o));
      }
   }
}

