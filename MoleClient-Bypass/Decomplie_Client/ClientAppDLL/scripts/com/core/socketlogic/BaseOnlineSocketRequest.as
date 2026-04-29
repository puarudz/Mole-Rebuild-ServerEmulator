package com.core.socketlogic
{
   import com.common.msgHead.MsgHead;
   import flash.utils.ByteArray;
   
   public class BaseOnlineSocketRequest
   {
      
      public function BaseOnlineSocketRequest()
      {
         super();
      }
      
      protected static function initAction(commandID:int, ... args) : void
      {
         var i:* = undefined;
         GV.onlineSocket.writeUnsignedInt(MsgHead.PkgLen);
         GV.onlineSocket.writeByte(MsgHead.Version);
         GV.onlineSocket.writeUnsignedInt(commandID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.UserID);
         GV.onlineSocket.writeUnsignedInt(MsgHead.Result);
         for each(i in args)
         {
            if(i is int)
            {
               GV.onlineSocket.writeUnsignedInt(i);
            }
            else if(i is ByteArray)
            {
               GV.onlineSocket.writeBytes(i);
            }
            else if(i is Boolean)
            {
               GV.onlineSocket.writeBoolean(i);
            }
            else
            {
               if(!(i is String))
               {
                  throw new Error("基類中沒有定義此數據類型的寫入方法，請在子類中執行寫入動作！");
               }
               GV.onlineSocket.writeUTFBytes(i);
            }
         }
      }
      
      protected static function flush() : void
      {
         GV.onlineSocket.flush();
      }
   }
}

