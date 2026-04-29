package com.logic.socket.userSurvey
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import flash.events.EventDispatcher;
   
   public class userBirthReq extends EventDispatcher
   {
      
      public function userBirthReq()
      {
         super();
      }
      
      public static function sendReq(birth:uint, type:uint) : void
      {
         MsgHead.PkgLen = 22;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.USER_BIRTH);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(birth);
         GV.onlineSocket.writeByte(type);
         GV.onlineSocket.flush();
      }
   }
}

