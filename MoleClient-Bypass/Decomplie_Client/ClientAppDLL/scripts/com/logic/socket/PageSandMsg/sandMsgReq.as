package com.logic.socket.PageSandMsg
{
   import com.common.msgHead.MsgHead;
   import com.core.info.LocalUserInfo;
   import com.global.staticData.CommandID;
   import flash.utils.ByteArray;
   
   public class sandMsgReq
   {
      
      public function sandMsgReq()
      {
         super();
      }
      
      public function sandFun(Type:int, tit:String, msg:String) : void
      {
         var i:uint = 0;
         var sandType:int = Type;
         var IsVIP:Boolean = LocalUserInfo.isVIP();
         if(Type <= 1004 && IsVIP)
         {
            sandType = Type + 1000;
         }
         var titStr:String = tit;
         var titbyte:ByteArray = new ByteArray();
         titbyte.writeUTFBytes(titStr);
         var lg:uint = 104 - titbyte.length;
         if(lg > 0)
         {
            for(i = 0; i < lg; i++)
            {
               titbyte.writeByte(0);
            }
         }
         titbyte.writeUTFBytes(String(GV.MyInfo_nickName));
         var lgg:uint = 120 - titbyte.length;
         if(lgg > 0)
         {
            for(i = 0; i < lgg; i++)
            {
               titbyte.writeByte(0);
            }
         }
         var msgStr:String = msg;
         var msgbyte:ByteArray = new ByteArray();
         msgbyte.writeUTFBytes(msgStr);
         var Msg_len:uint = msgbyte.length;
         MsgHead.PkgLen = 17 + 8 + 120 + Msg_len;
         if(MsgHead.Result != 0)
         {
            MsgHead.Result = 0;
         }
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.PAGESANDMSG);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(sandType);
         GV.onlineSocket.writeUnsignedInt(Msg_len + 120);
         GV.onlineSocket.writeBytes(titbyte);
         GV.onlineSocket.writeBytes(msgbyte);
         GV.onlineSocket.flush();
      }
   }
}

