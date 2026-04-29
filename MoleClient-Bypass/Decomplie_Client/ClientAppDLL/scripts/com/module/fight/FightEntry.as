package com.module.fight
{
   import com.core.socketlogic.baseSocket.MoleGameSocket;
   import com.core.socketlogic.baseSocket.MoleSocket;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class FightEntry extends EventDispatcher
   {
      
      private static var _instance:FightEntry;
      
      public static const ENTER_GAME_SERVER_OK:String = "enter_game_server_ok";
      
      public static const NEW_ANGEL_FIGHT_OVER:String = "new_angel_fight_over";
      
      private var enterGameSerObj:Object;
      
      public var isInGameSev:Boolean;
      
      public function FightEntry()
      {
         super();
      }
      
      public static function get instance() : FightEntry
      {
         if(!_instance)
         {
            _instance = new FightEntry();
         }
         return _instance;
      }
      
      public function enterFightGameSev(gameId:uint) : void
      {
         if(!this.isInGameSev)
         {
            GV.onlineSocket.addCmdListener(CommandID.CONNECT_GAME_SERVER_REQ,this.getGameServerInfoBack);
            GF.sendSocket(CommandID.CONNECT_GAME_SERVER_REQ,gameId);
         }
      }
      
      private function getGameServerInfoBack(evt:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.CONNECT_GAME_SERVER_REQ,this.getGameServerInfoBack);
         var recData:ByteArray = evt.data as ByteArray;
         this.enterGameSerObj = new Object();
         var sessionByte:ByteArray = new ByteArray();
         this.enterGameSerObj.ip = recData.readUTFBytes(16);
         this.enterGameSerObj.port = recData.readUnsignedShort();
         recData.readBytes(sessionByte,0,112);
         this.enterGameSerObj.sessionID = sessionByte;
         MoleGameSocket.instance.connectServer(this.enterGameSerObj.ip,this.enterGameSerObj.port);
         MoleGameSocket.instance.addEventListener(MoleSocket.SOCKET_SUCCESS,this.gameServerConnectSuc);
      }
      
      private function gameServerConnectSuc(evt:EventTaomee) : void
      {
         MoleGameSocket.instance.addEventListener(MoleSocket.SOCKET_SUCCESS,this.gameServerConnectSuc);
         MoleGameSocket.sendCmd(CommandID.CHECK_GAME_SER,this.enterGameSerObj.sessionID);
         MoleGameSocket.addCommandListener(CommandID.CHECK_GAME_SER,this.checkGameSerBack);
      }
      
      protected function checkGameSerBack(evt:SocketEvent) : void
      {
         dispatchEvent(new Event(ENTER_GAME_SERVER_OK));
         this.isInGameSev = true;
      }
   }
}

