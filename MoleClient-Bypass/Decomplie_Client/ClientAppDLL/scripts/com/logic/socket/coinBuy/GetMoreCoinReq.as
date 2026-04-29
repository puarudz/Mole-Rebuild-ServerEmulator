package com.logic.socket.coinBuy
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class GetMoreCoinReq extends BaseOnlineSocketRequest
   {
      
      public function GetMoreCoinReq()
      {
         super();
      }
      
      public static function Info(Arr:Array) : void
      {
         var Count:uint = Arr.length;
         MsgHead.Result = 0;
         MsgHead.PkgLen = 17 + 4 * Count;
         initAction(CommandID.COIN_GETMORE);
         GV.onlineSocket.writeUnsignedInt(Count);
         for(var i:uint = 0; i < Count; i++)
         {
            GV.onlineSocket.writeUnsignedInt(Arr[i]);
         }
         flush();
      }
   }
}

