package com.logic.socket.postCard
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class getAllCardRes extends EventDispatcher
   {
      
      public static var GETBACKALLCARD_INFO:String = "getback_allcard";
      
      public function getAllCardRes()
      {
         super();
      }
      
      public function getBackFun() : void
      {
         var i:uint = 0;
         var unCardID:uint = 0;
         var j:uint = 0;
         var CardID:uint = 0;
         var targetObj:Object = new Object();
         targetObj.TotalCnt = GV.onlineSocket.readUnsignedShort();
         if(targetObj.TotalCnt == 0)
         {
            targetObj.UnreadCnt = GV.onlineSocket.readUnsignedShort();
            targetObj.ReadCnt = GV.onlineSocket.readUnsignedShort();
         }
         else
         {
            targetObj.UnreadCnt = GV.onlineSocket.readUnsignedShort();
            if(targetObj.UnreadCnt > 0)
            {
               targetObj.UnRead_arr = new Array();
               for(i = 0; i < targetObj.UnreadCnt; i++)
               {
                  unCardID = uint(GV.onlineSocket.readUnsignedInt());
                  targetObj.UnRead_arr.push(unCardID);
               }
            }
            targetObj.ReadCnt = GV.onlineSocket.readUnsignedShort();
            if(targetObj.ReadCnt > 0)
            {
               targetObj.Read_arr = new Array();
               for(j = 0; j < targetObj.ReadCnt; j++)
               {
                  CardID = uint(GV.onlineSocket.readUnsignedInt());
                  targetObj.Read_arr.push(CardID);
               }
            }
         }
         var myobj:Object = {"obj":targetObj};
         GV.onlineSocket.dispatchEvent(new EventTaomee(GETBACKALLCARD_INFO,myobj));
      }
   }
}

