package com.logic.socket.userSurvey
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import flash.events.EventDispatcher;
   
   public class userSurveyReq extends EventDispatcher
   {
      
      public function userSurveyReq()
      {
         super();
      }
      
      public static function sendReq() : void
      {
         MsgHead.PkgLen = 17;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.USERSURVEY);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.flush();
      }
   }
}

