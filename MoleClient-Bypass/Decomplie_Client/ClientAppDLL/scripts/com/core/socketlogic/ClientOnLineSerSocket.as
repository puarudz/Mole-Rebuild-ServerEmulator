package com.core.socketlogic
{
   import com.adobe.crypto.MD5;
   import com.common.msgHead.MsgHead;
   import com.common.util.TongjiUtil;
   import com.core.MainEntry;
   import com.core.info.LocalUserInfo;
   import com.core.manager.SocketDataManager;
   import com.core.manager.SocketXMLManager;
   import com.core.socketlogic.baseSocket.ProxySocket;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.interfaces.ExtendsInterface;
   import com.mole.debug.DebugManager;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.system.Security;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.getDefinitionByName;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   
   public class ClientOnLineSerSocket extends Sprite
   {
      
      public static var onlineTime:Number;
      
      public static var SEND_DATA:String = "send_data";
      
      public static var SOCKET_SHUTDOWN:String = "onLinesocket_shutdown";
      
      public static var SOCKET_SUCCESS:String = "socket_success";
      
      public static var SOCKET_ERROR:String = "socket_error";
      
      public static var DATA_NOT_ENOUGH:String = "data_not_enough";
      
      public static var DATA_TOO_BIG:String = "data_too_big";
      
      public static var REGIST_FAIL:String = "regist_fail";
      
      public static var GET_BASIC_MESSAGE:String = "get_basic_message";
      
      public static var PASSWORD_FAULT:String = "password_fault";
      
      public static var SEND_FAIL:String = "send_fail";
      
      public static var GET_MAP_MESSAGE:String = "get_map_message";
      
      public static var USER_NOT_ACTIVATION:String = "user_not_activation";
      
      public static var GET_BUBBLES_MESSAGE:String = "get_bubbles_message";
      
      public static var ROOM_SERVER_FULL:String = "room_server_full";
      
      public static var GET_WALK_MESSAGE:String = "get_walk_message";
      
      public static var GET_WALK_FAIL:String = "get_walk_fail";
      
      public static var SEND_CHATMSG:String = "send_chatmsg";
      
      public static var NONE_ITEM:String = "none_item";
      
      public static var NOTENOUGH_LEVEl:String = "notenough_level";
      
      public static var POSITION_HAVE:String = "position_have";
      
      public static var SYSTEM_BUSY:String = "system_busy";
      
      public static var ALREADY_ONLIST:String = "already_onlist";
      
      public static var OTHER_SPACE_LOGIN:String = "other_space_login";
      
      public static var TALK_DIRTY:String = "talk_dirty";
      
      public static var OFF_LINE:String = "OFF_LINE";
      
      public static var ERROR_GAME:String = "error_game";
      
      public static var ERROR_GETCANDY_MOMO:String = "error_getCandy_momo";
      
      private var socket:ProxySocket;
      
      private var ip:String;
      
      private var port:int;
      
      public var S_ip:String;
      
      public var S_port:int;
      
      private var is_head:Boolean;
      
      private var socketDataManager:SocketDataManager;
      
      private var parseSocketErrorCodeClass:*;
      
      private var _isTransferLogin:Boolean;
      
      private var _timerID:uint;
      
      public function ClientOnLineSerSocket(ip:String = null, port:uint = 0)
      {
         super();
         this.socketDataManager = SocketXMLManager.getSocketData(SocketXMLManager.ONLINE_SERVER);
         this.parseSocketErrorCodeClass = getDefinitionByName("com.logic.socket.ParseSocketErrorCode");
         this.parseSocketErrorCodeClass.setSocketInstance(this);
         this.S_ip = ip;
         this.S_port = port;
         this.socket = new ProxySocket();
         this.socket.note = this.socketDataManager.dataDict;
         this.is_head = true;
         Security.loadPolicyFile("xmlsocket://" + ip + ":" + port);
         this.configureListeners();
         this._isTransferLogin = false;
         this.onConnect(this.S_ip,this.S_port);
      }
      
      private function onConnect(ip:String, port:uint) : void
      {
         this.socket.connect(ip,port);
         TongjiUtil.sendTongji(6,TongjiUtil.nowUserId.toString());
         this._timerID = setTimeout(this.onTransferConnect,6000);
      }
      
      private function onTransferConnect() : void
      {
         this._isTransferLogin = true;
         clearTimeout(this._timerID);
         this.onConnect(this.transferIP,this.transferPort);
      }
      
      private function configureListeners() : void
      {
         this.socket.addEventListener(Event.CLOSE,this.closeHandler);
         this.socket.addEventListener(Event.CONNECT,this.connectHandler);
         this.socket.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
         this.socket.addEventListener(ProgressEvent.SOCKET_DATA,this.socketDataHandler);
      }
      
      private function connectHandler(event:Event) : void
      {
         TongjiUtil.sendTongji(7,TongjiUtil.nowUserId.toString());
         clearTimeout(this._timerID);
         GV.onlineSocket = this.socket;
         dispatchEvent(new EventTaomee(SOCKET_SUCCESS));
         if(this._isTransferLogin)
         {
            this.LoginTransfer();
         }
         this.onlineSerLogin();
      }
      
      private function securityErrorHandler(event:SecurityErrorEvent) : void
      {
         if(this._isTransferLogin = false)
         {
            this.onTransferConnect();
         }
      }
      
      private function ioErrorHandler(event:IOErrorEvent) : void
      {
         if(this._isTransferLogin = false)
         {
            this.onTransferConnect();
         }
         else
         {
            dispatchEvent(new EventTaomee(SOCKET_ERROR));
         }
      }
      
      private function socketDataHandler(event:ProgressEvent) : void
      {
         this.socketData();
      }
      
      private function closeHandler(event:Event) : void
      {
         var obj:Object = new Object();
         obj.message = "Severclose";
         try
         {
            if(Boolean(this.socket))
            {
               this.socket.removeEventListener(Event.CLOSE,this.closeHandler);
               this.socket.removeEventListener(Event.CONNECT,this.connectHandler);
               this.socket.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
               this.socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
               this.socket.removeEventListener(ProgressEvent.SOCKET_DATA,this.socketDataHandler);
               this.socket.close();
            }
         }
         catch(e:Error)
         {
            trace("ClientOlineSerSocket::",e);
         }
         if(!GV.isDefault)
         {
            dispatchEvent(new EventTaomee(SOCKET_SHUTDOWN,obj));
         }
      }
      
      private function get transferIP() : String
      {
         return DebugManager.DEBUG ? "10.1.1.23" : "123.150.163.118";
      }
      
      private function get transferPort() : uint
      {
         return DebugManager.DEBUG ? 6668 : 6665;
      }
      
      public function onlineSerLogin() : void
      {
         onlineTime = getTimer();
         var tba:ByteArray = MsgHead.Session;
         MsgHead.PkgLen = 37 + MsgHead.Session.length + 2;
         this.socket.writeInt(MsgHead.PkgLen);
         this.socket.writeByte(MsgHead.Version);
         this.socket.writeInt(CommandID.loginOnlineSre);
         this.socket.writeInt(MsgHead.UserID);
         this.socket.writeInt(MsgHead.Result);
         this.socket.writeShort(GV.serverID);
         var ba:ByteArray = new ByteArray();
         ba.writeBytes(MsgHead.Session);
         ba.position = 0;
         ba.readByte();
         ba.readShort();
         var start1:uint = ba.readUnsignedInt();
         ba.readByte();
         ba.readShort();
         var start2:uint = ba.readUnsignedInt();
         var str:String = "fREd hAo crAzy BAby in Our ProgRAm?";
         var b:String = String(MD5.hash(start2 + str.substr(5,11) + start1));
         this.socket.writeUTFBytes(b.substr(6,16));
         this.socket.writeInt(MsgHead.SessionLen);
         this.socket.writeBytes(MsgHead.Session);
         this.socket.writeUnsignedInt(MainEntry.loginType);
         this.socket.writeBytes(MainEntry.adByte);
         this.socket.flush();
         TongjiUtil.sendTongji(8,TongjiUtil.nowUserId.toString());
      }
      
      public function socketData() : void
      {
         var tempByteArr:ByteArray = null;
         var objArr:Array = new Array();
         MsgHead.PkgLen = this.socket.readUnsignedInt();
         MsgHead.Version = this.socket.readUnsignedByte();
         MsgHead.Command = this.socket.readUnsignedInt();
         MsgHead.UserID = this.socket.readUnsignedInt();
         MsgHead.Result = this.socket.readUnsignedInt();
         if(MsgHead.Result == 0)
         {
            try
            {
               this.socketDataManager.action(MsgHead.Command);
            }
            catch(e:Error)
            {
               tempByteArr = new ByteArray();
               if(MsgHead.PkgLen > 0)
               {
                  try
                  {
                     socket.readBytes(tempByteArr,0,MsgHead.PkgLen);
                  }
                  catch(ee:Error)
                  {
                  }
               }
               ExtendsInterface.parse(tempByteArr,MsgHead.Command);
            }
         }
         else
         {
            this.parseSocketErrorCodeClass.parse(MsgHead.Result);
         }
      }
      
      public function getUserListReq(Grid:int = 0) : void
      {
         var id:Number = LocalUserInfo.getMapID() == 0 ? GV.backup_mapID : LocalUserInfo.getMapID();
         LocalUserInfo.setMapID(id);
         GF.sendSocket(CommandID.allSceneUser,LocalUserInfo.getMapID(),LocalUserInfo.getMapType(),LocalUserInfo.getMyInfo_Grid());
      }
      
      public function mapReq(MapID:Number, type:int = 0) : void
      {
         MsgHead.Result = 0;
         GF.sendSocket(CommandID.listMapMsg,MapID,type);
      }
      
      public function blowBubble() : void
      {
         MsgHead.PkgLen = 17;
         this.socket.writeUnsignedInt(MsgHead.PkgLen);
         this.socket.writeByte(MsgHead.Version);
         this.socket.writeUnsignedInt(CommandID.blowBubbles);
         this.socket.writeUnsignedInt(MsgHead.UserID);
         this.socket.writeUnsignedInt(MsgHead.Result);
         this.socket.flush();
      }
      
      public function walking(x:int, y:int, UseItem:int = 0, Grid:int = 0) : void
      {
         GF.sendSocket(CommandID.walking,x,y,UseItem,Grid);
      }
      
      public function chating(Friend:Number, MSG:String) : void
      {
         var MsgLen:int = 0;
         var msgStr:String = MSG + "0";
         var byte:ByteArray = new ByteArray();
         var max:int = 136;
         byte.writeUTFBytes(msgStr);
         if(byte.length > max)
         {
            byte.length = max;
         }
         MsgLen = int(byte.length);
         GF.sendSocket(CommandID.chating,Friend,MsgLen,byte);
      }
      
      public function LoginTransfer() : void
      {
         var byte:ByteArray = new ByteArray();
         byte.writeUnsignedInt(this.ipToint(this.S_ip));
         byte.writeShort(this.S_port);
         GF.sendSocket(CommandID.restart_onling,byte);
      }
      
      public function FillString(str:String, maxLen:int) : ByteArray
      {
         var len:int = 0;
         var i:int = 0;
         var byte:ByteArray = new ByteArray();
         var zero:int = 0;
         byte.writeUTFBytes(str);
         len = int(byte.length);
         if(len < maxLen)
         {
            for(i = len; i < maxLen; i++)
            {
               byte.writeByte(zero);
            }
            return byte;
         }
         return byte;
      }
      
      private function ipToint(ip:String) : int
      {
         var ipArr:Array = ip.split(".");
         ipArr[0] = int(ipArr[0]);
         ipArr[1] = int(ipArr[1]);
         ipArr[2] = int(ipArr[2]);
         ipArr[3] = int(ipArr[3]);
         return (ipArr[0] << 24) + (ipArr[1] << 16) + (ipArr[2] << 8) + ipArr[3];
      }
   }
}

