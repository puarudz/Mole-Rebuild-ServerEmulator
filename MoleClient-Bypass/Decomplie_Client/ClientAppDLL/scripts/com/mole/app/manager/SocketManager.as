package com.mole.app.manager
{
   import com.core.manager.SocketDataManager;
   import com.core.manager.SocketXMLManager;
   import com.mole.app.info.SocketInfo;
   
   public class SocketManager
   {
      
      private static var _socketData:SocketDataManager;
      
      public function SocketManager()
      {
         super();
      }
      
      public static function add(cmdInfo:SocketInfo) : void
      {
         new SocketDispose(cmdInfo);
         if(_socketData == null)
         {
            _socketData = SocketXMLManager.getSocketData(SocketXMLManager.ONLINE_SERVER);
         }
         _socketData.send(cmdInfo.cmdID,cmdInfo.sendFunc,cmdInfo.sendParams);
      }
   }
}

import com.event.EventTaomee;
import com.mole.app.info.SocketInfo;
import com.mole.app.type.SocketType;
import com.mole.debug.DebugManager;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

class SocketDispose
{
   
   private var _timeID:uint;
   
   private var _cmdInfo:SocketInfo;
   
   public function SocketDispose(cmdInfo:SocketInfo)
   {
      var paramList:Array;
      super();
      this._cmdInfo = cmdInfo;
      paramList = [cmdInfo.cmdID];
      paramList = paramList.concat(cmdInfo.sendParams);
      GV.onlineSocket.addEventListener(cmdInfo.eventName,this.getInfoOver);
      this._timeID = setTimeout(function():void
      {
         destroy();
         DebugManager.traceMsg("协议返回超时！",false);
      },15000);
   }
   
   private function getInfoOver(e:EventTaomee) : void
   {
      var obj:Object = null;
      this._cmdInfo.state = SocketType.GET_BACK;
      if(e.EventObj != null)
      {
         obj = e.EventObj;
      }
      else
      {
         obj = {};
      }
      obj.cmdInfo = this._cmdInfo;
      GV.onlineSocket.dispatchEvent(new EventTaomee(this._cmdInfo.eventName + "_sm",obj));
      this.destroy();
   }
   
   public function destroy() : void
   {
      GV.onlineSocket.removeEventListener(this._cmdInfo.eventName,this.getInfoOver);
      clearTimeout(this._timeID);
   }
}
