package com.core.socketlogic.baseSocket
{
   import com.common.msgHead.MsgHead;
   import com.core.info.LocalUserInfo;
   import flash.utils.ByteArray;
   import org.taomee.net.LoggerType;
   import org.taomee.net.tmf.HeadInfo;
   import org.taomee.net.tmf.TMF;
   
   public class MoleGameSocket extends MoleSocket
   {
      
      private static var _instance:MoleGameSocket;
      
      private var version:uint = MsgHead.Version;
      
      private var result:uint = 0;
      
      public function MoleGameSocket(userID:uint = 0)
      {
         super(userID);
      }
      
      public static function get instance() : MoleGameSocket
      {
         if(!_instance)
         {
            _instance = new MoleGameSocket(LocalUserInfo.getUserID());
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         _instance.close();
         _instance = null;
      }
      
      public static function sendCmd(cmdID:uint, ... args) : void
      {
         var arg:* = undefined;
         var byteLen:uint = 0;
         var bodyData:ByteArray = null;
         if(instance.connected)
         {
            byteLen = 0;
            bodyData = new ByteArray();
            for each(arg in args)
            {
               if(arg is String)
               {
                  bodyData.writeUTFBytes(arg);
               }
               else if(arg is ByteArray)
               {
                  bodyData.writeBytes(arg);
               }
               else if(arg is uint)
               {
                  bodyData.writeUnsignedInt(arg);
               }
               else
               {
                  bodyData.writeInt(arg);
               }
            }
            instance.send(cmdID,[bodyData]);
         }
      }
      
      public static function addCommandListener(commandID:uint, listener:Function) : void
      {
         instance.addCommandListener(commandID,listener);
      }
      
      public static function removeCommandListener(commandID:uint, listener:Function) : void
      {
         instance.removeCommandListener(commandID,listener);
      }
      
      override public function send(cmdID:uint, args:Array, endian:String = null) : void
      {
         var data:ByteArray = createBody(args,endian);
         var pkLen:uint = HEAD_LEN + data.length;
         writeUnsignedInt(pkLen);
         writeByte(this.version);
         writeUnsignedInt(cmdID);
         writeUnsignedInt(userID);
         writeUnsignedInt(this.result);
         writeBytes(data,0,data.length);
         flush();
         parselogger(LoggerType.OUTPUT,cmdID,data.length);
      }
      
      override protected function outputCommand(headInfo:HeadInfo, data:ByteArray = null) : void
      {
         var tmfClass:Class = null;
         if(data == null)
         {
            data = new ByteArray();
            MoleHeadInfo(headInfo).packLen = 0;
            dispatchCommand(headInfo.commandID,headInfo);
         }
         else
         {
            MoleHeadInfo(headInfo).packLen = data.bytesAvailable;
            tmfClass = TMF.getClass(headInfo.commandID);
            dispatchCommand(headInfo.commandID,headInfo,new tmfClass(data));
         }
         this.version = MoleHeadInfo(headInfo).verson;
         this.result = MoleHeadInfo(headInfo).result;
      }
   }
}

