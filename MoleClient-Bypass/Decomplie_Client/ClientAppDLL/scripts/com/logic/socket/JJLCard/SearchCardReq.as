package com.logic.socket.JJLCard
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class SearchCardReq extends BaseOnlineSocketRequest
   {
      
      public function SearchCardReq()
      {
         super();
      }
      
      public static function findFun(myID:uint, wantID:uint) : void
      {
         MsgHead.PkgLen = 8 + 17;
         initAction(CommandID.SEARCH_JJL_CARD);
         GV.onlineSocket.writeUnsignedInt(myID);
         GV.onlineSocket.writeUnsignedInt(wantID);
         flush();
      }
   }
}

