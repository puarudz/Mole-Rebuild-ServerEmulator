package com.logic.socket.searchMole
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import flash.events.EventDispatcher;
   
   public class searchMoleReq extends EventDispatcher
   {
      
      public function searchMoleReq()
      {
         super();
      }
      
      public static function sendReq(id:Number) : void
      {
         MsgHead.PkgLen = 21;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.SEARCH_MOLE);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(id);
         GV.onlineSocket.flush();
      }
   }
}

