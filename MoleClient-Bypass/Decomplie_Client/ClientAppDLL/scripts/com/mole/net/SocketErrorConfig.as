package com.mole.net
{
   import com.common.data.HashMap;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.mole.net.info.SocketErrorInfo;
   
   public class SocketErrorConfig
   {
      
      private static var _socketErrorMap:HashMap;
      
      private static var _socketXmlResId:uint;
      
      public function SocketErrorConfig()
      {
         super();
      }
      
      public static function setup() : void
      {
         _socketErrorMap = new HashMap();
         DownLoadManager.addEventListener(DownLoadEvent.COMPLETE,onLoadSocketErrorComplete);
         _socketXmlResId = DownLoadManager.add("resource/xml/socket/SocketErrorConfig.xml",ResType.STRING,true);
      }
      
      public static function getErrorInfo(cmdId:uint, errorCode:int) : SocketErrorInfo
      {
         var socketErrorInfo:SocketErrorInfo = _socketErrorMap.getValue(getSocketErrorKey(cmdId,errorCode));
         if(socketErrorInfo == null)
         {
            socketErrorInfo = new SocketErrorInfo(cmdId,errorCode,"錯誤碼[cmdID=" + cmdId + ", errorID=" + errorCode + "]",2,true);
         }
         return socketErrorInfo;
      }
      
      private static function onLoadSocketErrorComplete(e:DownLoadEvent) : void
      {
         var socketErrorXml:XML = null;
         var cmd:uint = 0;
         var socketErrorInfo:SocketErrorInfo = null;
         var cmdXml:XML = null;
         var codeXml:XML = null;
         if(_socketXmlResId == e.resInfo.resId)
         {
            DownLoadManager.removeEventListener(DownLoadEvent.COMPLETE,onLoadSocketErrorComplete);
            socketErrorXml = XML(e.data);
            for each(cmdXml in socketErrorXml.children())
            {
               cmd = uint(cmdXml.@CmdID);
               for each(codeXml in cmdXml.children())
               {
                  socketErrorInfo = new SocketErrorInfo(cmd,int(codeXml.@Code),codeXml.@Msg,uint(codeXml.@Type),false);
                  _socketErrorMap.add(getSocketErrorKey(socketErrorInfo.cmdId,socketErrorInfo.errorCode),socketErrorInfo);
               }
            }
         }
      }
      
      private static function getSocketErrorKey(cmdId:uint, errorCode:int) : String
      {
         return cmdId.toString() + "_" + errorCode;
      }
   }
}

