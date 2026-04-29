package com.core.gameSimulator
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.socketlogic.baseSocket.ProxySocket;
   import com.core.socketlogic.noticeExit.NoticeExitRes;
   import com.event.EventTaomee;
   import com.global.links.Links;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.external.ExternalInterface;
   import flash.net.LocalConnection;
   import flash.net.registerClassAlias;
   import flash.system.ApplicationDomain;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class SEI extends EventDispatcher
   {
      
      public static var mainConnection:LocalConnection;
      
      private static var owner:SEI;
      
      public static var getStage:DisplayObject;
      
      public static var getMain:Sprite;
      
      public static var MainConnectURI:String;
      
      public static var GameConnectURI:String;
      
      public static var SessionObj:Object;
      
      public static var gameID:uint;
      
      public static var userID:uint;
      
      public static var Seq:uint;
      
      public static var CONVEYANCE:String = "conveyance";
      
      public static var ON_CONNECTION_ERROR:String = "onConnectionError";
      
      public static var GAME_SWF:String = "gameSwf";
      
      public static var isShutDown:Boolean = false;
      
      public var SEI_Dic:Dictionary = new Dictionary();
      
      public var checkBrowserStatusTimer:Timer;
      
      public function SEI()
      {
         super();
         if(ExternalInterface.available)
         {
            ExternalInterface.addCallback(SEI_Event.REVERT_GAME_MSG,this.revertGameMsg);
            ExternalInterface.addCallback(SEI_Event.REVERT_GAME_OBJ,this.revertGameObj);
            ExternalInterface.addCallback(SEI_Event.REVERT_GAME_BYTE,this.revertGameByte);
            this.SEI_Dic[Event.CONNECT] = this.tryConnectGame;
            this.SEI_Dic[Event.CONNECT + "_Data"] = this.connectGameData;
            this.SEI_Dic[Event.INIT] = this.connectGameSuc;
            this.SEI_Dic[Event.UNLOAD] = this.closeLayer;
            mainConnection = new LocalConnection();
            mainConnection.client = this;
            BC.addEvent(this,mainConnection,StatusEvent.STATUS,this.onStatus);
            BC.addEvent(this,GV.onlineSocket,ProxySocket.SOCKET_SHUTDOWN,this.onShutDown);
            BC.addEvent(this,GV.onlineClass,NoticeExitRes.NOTICE_EXIT,this.onShutDown);
            userID = GV.MyInfo_userID;
            Seq = uint(Math.random() * 987654321);
            MainConnectURI = "main_" + userID + "_" + Seq;
            GameConnectURI = "game_" + userID + "_" + Seq;
            this.createConnection();
         }
         owner = this;
      }
      
      public static function getSEI() : SEI
      {
         if(Boolean(owner))
         {
            return owner;
         }
         return new SEI();
      }
      
      private function createConnection() : void
      {
         mainConnection.connect(MainConnectURI);
      }
      
      public function B2S(b:ByteArray) : String
      {
         var t:String = null;
         var s:String = "";
         var op:uint = b.position;
         b.position = 0;
         while(Boolean(b.bytesAvailable))
         {
            t = b.readUnsignedByte().toString(16);
            s += t.length == 1 ? "0" + t : t;
         }
         b.position = op;
         return s;
      }
      
      public function S2B(s:String) : ByteArray
      {
         var b:ByteArray = new ByteArray();
         var l:uint = uint(s.length);
         if(l == 0 || Boolean(l % 2))
         {
            throw new Error("字符長度為" + String(l) + ",參數非偶數或為空!");
         }
         var i:uint = 0;
         while(i < l)
         {
            b.writeByte(parseInt(s.substr(i,2),16));
            i += 2;
         }
         b.position = 0;
         return b;
      }
      
      public function tryConnectGame() : void
      {
         GC.clearGTimeout(this.checkBrowserStatusTimer);
         this.checkBrowserStatusTimer = GC.setGTimeout(this.closeLayer,10000);
         var connectionObj:ConnectionData = new ConnectionData(gameID,SessionObj);
         registerClassAlias("mole.61.com",ConnectionData);
         this.sendMainObj(connectionObj);
         this.sendMainMsg(Event.COMPLETE);
      }
      
      public function connectGameData(data:String) : void
      {
         GameConnectURI = data;
      }
      
      public function connectGameSuc() : void
      {
         GC.clearGTimeout(this.checkBrowserStatusTimer);
      }
      
      public function revertGameMsg(msg:String) : void
      {
         if(Boolean(this.SEI_Dic[msg]))
         {
            this.SEI_Dic[msg]();
         }
         dispatchEvent(new EventTaomee(SEI_Event.REVERT_GAME_MSG,msg));
      }
      
      public function revertGameObj(msg:String) : void
      {
         var b:ByteArray = this.S2B(msg) as ByteArray;
         var o:Object = b.readObject();
         var t:String = o.type;
         if(t == "MainInfo")
         {
            this["D_" + t](o.type2,o.data);
         }
         else if(t == "System")
         {
            this.SEI_Dic[o.type2](String(o.data));
         }
         else
         {
            dispatchEvent(new EventTaomee(SEI_Event.REVERT_GAME_OBJ,o));
         }
      }
      
      public function revertGameByte(msg:String) : void
      {
         var b:ByteArray = this.S2B(msg) as ByteArray;
         dispatchEvent(new EventTaomee(SEI_Event.REVERT_GAME_BYTE,b));
         var byteArray:ByteArray = new ByteArray();
         b.readBytes(byteArray);
         this.sendMainByte(byteArray);
      }
      
      public function doAction(funName:String, ... args) : void
      {
         var len:int = int(args.length);
         if(len > 0)
         {
            if(len == 1)
            {
               mainConnection.send(GameConnectURI,funName,args[0]);
            }
            else if(len == 2)
            {
               mainConnection.send(GameConnectURI,funName,args[0],args[1]);
            }
            else if(len == 3)
            {
               mainConnection.send(GameConnectURI,funName,args[0],args[1],args[2]);
            }
            else if(len == 4)
            {
               mainConnection.send(GameConnectURI,funName,args[0],args[1],args[2],args[3]);
            }
            else if(len == 5)
            {
               mainConnection.send(GameConnectURI,funName,args[0],args[1],args[2],args[3],args[4]);
            }
            else if(len == 6)
            {
               mainConnection.send(GameConnectURI,funName,args[0],args[1],args[2],args[3],args[4],args[5]);
            }
            else if(len == 7)
            {
               mainConnection.send(GameConnectURI,funName,args[0],args[1],args[2],args[3],args[4],args[5],args[6]);
            }
            else if(len == 8)
            {
               mainConnection.send(GameConnectURI,funName,args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
            }
            else if(len == 9)
            {
               mainConnection.send(GameConnectURI,funName,args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8]);
            }
         }
         else
         {
            mainConnection.send(MainConnectURI,funName);
         }
      }
      
      public function sendMainMsg(s:String) : void
      {
         mainConnection.send(GameConnectURI,SEI_Event.REVERT_MAIN_MSG,s);
      }
      
      public function sendMainObj(o:Object) : void
      {
         var b:ByteArray = new ByteArray();
         b.writeObject(o);
         var s:String = this.B2S(b) as String;
         mainConnection.send(GameConnectURI,SEI_Event.REVERT_MAIN_OBJ,s);
      }
      
      public function sendMainByte(b:ByteArray) : void
      {
         var s:String = this.B2S(b) as String;
         mainConnection.send(GameConnectURI,SEI_Event.REVERT_MAIN_BYTE,s);
      }
      
      public function setRoot(_root:Sprite) : void
      {
         getStage = _root.stage;
         getMain = _root;
      }
      
      public function closeLayer() : void
      {
         mainConnection.send(GameConnectURI,"closeLayer");
         mainConnection.send(GameConnectURI,"closeLocalConnection");
         BC.removeEvent(this,GV.onlineSocket,ProxySocket.SOCKET_SHUTDOWN,this.onShutDown);
         if(gameID == 50 || gameID == 51 || gameID == 52 || gameID == 49)
         {
            GF.leaveGame2(true);
         }
         GC.setGTimeout(function():*
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.call("closeGameLayer");
            }
            SEI.getSEI().dispatchEvent(new EventTaomee(ON_CONNECTION_ERROR));
         },10);
      }
      
      public function Effect_shakeXY(num:int) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("shake_xy",num);
         }
      }
      
      public function Effect_shakeX(num:int) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("shake_x",num);
         }
      }
      
      public function Effect_shakeY(num:int) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("shake_y",num);
         }
      }
      
      public function openGame(_gameID:uint) : void
      {
         if(isShutDown)
         {
            return;
         }
         gameID = _gameID;
         if(ExternalInterface.available)
         {
            ExternalInterface.call("openGameLayer",gameID,userID,Seq,Links.version);
         }
      }
      
      private function onShutDown(E:*) : void
      {
         isShutDown = true;
         this.closeLocalConnection();
      }
      
      private function closeLocalConnection() : void
      {
         if(Boolean(GameConnectURI))
         {
            this.doAction(GameConnectURI,"closeLocalConnection");
         }
         GC.setGTimeout(this.closeSEI,50);
      }
      
      public function closeSEI(... e) : void
      {
         mainConnection.close();
      }
      
      public function hideMainLayer() : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("hideMainLayer");
         }
      }
      
      public function alert(... msg) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("alertMsg",msg);
         }
      }
      
      private function onStatus(event:StatusEvent) : void
      {
         switch(event.level)
         {
            case "status":
               trace("LocalConnection.send() succeeded");
               break;
            case "error":
               trace("LocalConnection.send() failed");
         }
      }
      
      public function errorAlart(msg:String) : void
      {
         Alert.showAlert(MainManager.getGameLevel(),msg,"",6,"D");
      }
      
      public function _trace(... msg) : void
      {
         trace(msg);
      }
      
      public function D_MainInfo(name:String, data:*) : void
      {
         var cls:Class = ApplicationDomain.currentDomain.getDefinition("com.module.gameSimulator::MainInfo") as Class;
         cls[name](data);
      }
   }
}

