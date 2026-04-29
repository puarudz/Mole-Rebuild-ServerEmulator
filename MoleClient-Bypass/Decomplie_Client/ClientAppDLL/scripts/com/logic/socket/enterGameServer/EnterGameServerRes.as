package com.logic.socket.enterGameServer
{
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.mole.net.SocketProtocol;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class EnterGameServerRes extends SocketProtocol
   {
      
      public static var ENTER_GAMESER:String = "enter_gameser";
      
      private var _ip:String;
      
      private var _port:uint;
      
      private var _session:ByteArray;
      
      private var _peopleList:Array;
      
      public function EnterGameServerRes()
      {
         super(CommandID.ENTER_GAME_SER);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         var enterGameUserObj:Object = null;
         var enterGameSerObj:Object = new Object();
         var enterGameArr:Array = new Array();
         var byte:ByteArray = new ByteArray();
         this._ip = enterGameSerObj.IP = GV.onlineSocket.readUTFBytes(16);
         this._port = enterGameSerObj.Port = GV.onlineSocket.readUnsignedShort();
         GV.onlineSocket.readBytes(byte,0,112);
         this._session = enterGameSerObj.SessionID = byte;
         this._peopleList = new Array();
         enterGameSerObj.Count = GV.onlineSocket.readUnsignedByte();
         for(var i:int = 0; i < enterGameSerObj.Count; i++)
         {
            enterGameUserObj = new Object();
            enterGameUserObj.UserID = GV.onlineSocket.readUnsignedInt();
            enterGameUserObj.Itemid = GV.onlineSocket.readUnsignedByte();
            enterGameArr.push(enterGameUserObj);
            this._peopleList.push(enterGameUserObj);
         }
         enterGameSerObj.userArr = enterGameArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee(ENTER_GAMESER,enterGameSerObj));
      }
      
      public function get ip() : String
      {
         return this._ip;
      }
      
      public function get port() : uint
      {
         return this._port;
      }
      
      public function get session() : ByteArray
      {
         return this._session;
      }
      
      public function get peopleList() : Array
      {
         return this._peopleList;
      }
   }
}

