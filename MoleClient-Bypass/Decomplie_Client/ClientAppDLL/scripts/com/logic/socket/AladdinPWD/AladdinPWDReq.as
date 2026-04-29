package com.logic.socket.AladdinPWD
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   
   public class AladdinPWDReq extends EventDispatcher
   {
      
      public function AladdinPWDReq()
      {
         super();
      }
      
      public static function sendReq(pwd:String) : void
      {
         MsgHead.PkgLen = 29;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.ALADDIN_PWD);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUTFBytes(pwd);
         GV.onlineSocket.flush();
      }
      
      public static function send32Req(type:uint, pwd:String) : void
      {
         MsgHead.PkgLen = 17 + 36;
         MsgHead.Result = 0;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.ALADDIN_PWD_NEW);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         GV.onlineSocket.writeUnsignedInt(type);
         var buf:ByteArray = new ByteArray();
         buf.writeUTFBytes(pwd);
         while(buf.length < 32)
         {
            buf.writeByte(0);
         }
         GV.onlineSocket.writeBytes(buf);
         GV.onlineSocket.flush();
      }
      
      public static function usePWD32Req(pwd:String, userid:uint, itemarr:Array) : void
      {
         var item:* = undefined;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(CommandID.USE_ALADDIN_PWD_NEW);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         var buf:ByteArray = new ByteArray();
         buf.writeUTFBytes(pwd);
         while(buf.length < 32)
         {
            buf.writeByte(0);
         }
         GV.onlineSocket.writeBytes(buf);
         GV.onlineSocket.writeUnsignedInt(userid);
         GV.onlineSocket.writeShort(itemarr.length);
         for(var i:uint = 0; i < itemarr.length; i++)
         {
            item = itemarr[i];
            if(item is int)
            {
               GV.onlineSocket.writeUnsignedInt(item);
               GV.onlineSocket.writeUnsignedInt(1);
            }
            else
            {
               GV.onlineSocket.writeUnsignedInt(item.id);
               GV.onlineSocket.writeUnsignedInt(item.count);
            }
         }
         GV.onlineSocket.flush();
      }
   }
}

