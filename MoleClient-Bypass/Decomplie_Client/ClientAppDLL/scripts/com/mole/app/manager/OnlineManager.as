package com.mole.app.manager
{
   import com.common.Alert.Alert;
   import com.core.info.LocalUserInfo;
   import com.core.manager.LevelManager;
   import com.global.staticData.CommandID;
   import com.module.popupMsg.PopupMsgCtl;
   import com.mole.app.ui.InfoBox;
   import com.mole.debug.DebugManager;
   import com.mole.net.SocketErrorConfig;
   import com.mole.net.events.SocketEvent;
   import com.mole.net.info.SocketErrorInfo;
   import com.mole.net.type.SocketErrorPromptType;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.setTimeout;
   import org.taomee.net.tmf.HeadInfo;
   
   public class OnlineManager
   {
      
      private static var timeFlag:uint;
      
      public function OnlineManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         GV.onlineSocket.addEventListener(Event.CLOSE,onSocketClose);
         GV.onlineSocket.addEventListener(SocketEvent.ERROR,onSocketError);
         GV.onlineSocket.addCmdListener(CommandID.cli_proto_use_plug_in_noti,waiguaHnadle);
      }
      
      private static function waiguaHnadle(e:Event) : void
      {
         var alert:* = Alert.showAlert(LevelManager.topLevel,"由於使用外掛本次連接已斷開，請嘗試重新登陸！","",6,"D");
         LevelManager.topLevel.addChildAt(LevelManager.drawBG(),LevelManager.topLevel.numChildren - 1);
         alert.addEventListener("CLICK" + 1,onRefreshPage);
         timeFlag = setTimeout(onRefreshPage,3000,1);
      }
      
      private static function onSocketClose(e:Event) : void
      {
         if(LocalUserInfo.isRepeatLogin)
         {
            return;
         }
         var alert:* = Alert.showAlert(LevelManager.topLevel,"本次連接已斷開，請嘗試重新登陸！","",6,"D");
         alert.addEventListener("CLICK" + 1,onRefreshPage);
      }
      
      private static function onRefreshPage(evt:*) : void
      {
         var urlRequest:URLRequest = VL.getURLRequest("http://mole.61.com.tw/");
         navigateToURL(urlRequest,"_self");
      }
      
      public static function send(cmdID:uint, ... args) : void
      {
         var paramList:Array = [cmdID];
         paramList = paramList.concat(args);
         GF.sendSocket.apply(null,paramList);
      }
      
      private static function onSocketError(e:SocketEvent) : void
      {
         var headInfo:HeadInfo = e.headInfo;
         dispatchErrorListener(headInfo.commandID,headInfo,null);
         if(!hasErrorListener(headInfo.commandID))
         {
            socketError(headInfo.commandID,headInfo.error);
         }
      }
      
      private static function socketError(cmdID:uint, errorID:int) : void
      {
         var socketErrorInfo:SocketErrorInfo = SocketErrorConfig.getErrorInfo(cmdID,errorID);
         var msg:String = "    " + socketErrorInfo.msg;
         if(socketErrorInfo.untreated)
         {
            if(DebugManager.DEBUG)
            {
               InfoBox.show(socketErrorInfo.msg);
            }
         }
         else if(socketErrorInfo.type == SocketErrorPromptType.INFO_BOX)
         {
            if(DebugManager.DEBUG)
            {
               InfoBox.show(msg);
            }
         }
         else if(socketErrorInfo.type == SocketErrorPromptType.SPEAKER)
         {
            if(DebugManager.DEBUG)
            {
               PopupMsgCtl.PopupMsg(msg);
            }
         }
         else if(socketErrorInfo.type == SocketErrorPromptType.ALERT)
         {
            if(DebugManager.DEBUG)
            {
               trace(msg);
            }
         }
      }
      
      public static function addCmdListener(cmdID:uint, succeedListener:Function, failFun:Function = null) : void
      {
         if(succeedListener != null)
         {
            GV.onlineSocket.addEventListener(SocketEvent.DATA + cmdID.toString(),succeedListener);
         }
         if(failFun != null)
         {
            GV.onlineSocket.addEventListener(SocketEvent.DATA + cmdID.toString(),succeedListener);
         }
      }
      
      public static function removeCmdListener(cmdID:uint, succeedListener:Function, failFun:Function = null) : void
      {
         if(succeedListener != null)
         {
            GV.onlineSocket.removeEventListener(SocketEvent.DATA + cmdID.toString(),succeedListener);
         }
         if(failFun != null)
         {
            GV.onlineSocket.removeEventListener(SocketEvent.DATA + cmdID.toString(),succeedListener);
         }
      }
      
      public static function dispatchCmdListener(cmdID:uint, headInfo:HeadInfo, bodyInfo:*) : void
      {
         GV.onlineSocket.dispatchEvent(new SocketEvent(SocketEvent.DATA + cmdID.toString(),headInfo,bodyInfo));
      }
      
      public static function hasCmdListener(cmdID:uint) : Boolean
      {
         return GV.onlineSocket.hasEventListener(SocketEvent.DATA + cmdID.toString());
      }
      
      public static function addErrorListener(cmdID:uint, errorListener:Function) : void
      {
         GV.onlineSocket.addEventListener(SocketEvent.ERROR + cmdID.toString(),errorListener);
      }
      
      public static function removeErrorListener(cmdID:uint, errorListener:Function) : void
      {
         GV.onlineSocket.removeEventListener(SocketEvent.ERROR + cmdID,errorListener);
      }
      
      public static function dispatchErrorListener(cmdID:uint, headInfo:HeadInfo, bodyInfo:*) : void
      {
         GV.onlineSocket.dispatchEvent(new SocketEvent(SocketEvent.ERROR + cmdID.toString(),headInfo,bodyInfo));
      }
      
      public static function hasErrorListener(cmdID:uint) : Boolean
      {
         return GV.onlineSocket.hasEventListener(SocketEvent.ERROR + cmdID.toString());
      }
   }
}

