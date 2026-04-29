package com.logic.socket.myProfession
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import flash.utils.ByteArray;
   
   public class MyProfessionReq
   {
      
      public function MyProfessionReq()
      {
         super();
      }
      
      public static function req(userid:uint) : void
      {
         MsgHead.PkgLen = 21;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.GET_MY_PROFESSION);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(userid);
         GV.onlineSocket.flush();
      }
      
      public static function checkIsSLKnight(userid:uint) : void
      {
         MsgHead.Command = 1239;
         var byte:ByteArray = new ByteArray();
         byte.writeUnsignedInt(userid);
         GF.writeHead(byte);
      }
   }
}

