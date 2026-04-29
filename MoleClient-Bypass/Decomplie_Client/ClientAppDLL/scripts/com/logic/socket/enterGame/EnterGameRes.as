package com.logic.socket.enterGame
{
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.mole.net.SocketProtocol;
   import flash.utils.IDataInput;
   
   public class EnterGameRes extends SocketProtocol
   {
      
      public static var ENTER_GAME:String = "enter_game";
      
      private var _userID:uint;
      
      private var _itemID:uint;
      
      private var _action:uint;
      
      private var _direction:uint;
      
      private var _status:uint;
      
      private var _gameID:uint;
      
      private var _groupID:uint;
      
      public function EnterGameRes()
      {
         super(CommandID.enterGame);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         var enterGameObj:Object = new Object();
         this._userID = enterGameObj.UserID = GV.onlineSocket.readUnsignedInt();
         this._itemID = enterGameObj.ItemID = GV.onlineSocket.readUnsignedInt();
         this._action = enterGameObj.Action = GV.onlineSocket.readUnsignedInt();
         this._direction = enterGameObj.Direction = GV.onlineSocket.readUnsignedByte();
         this._status = enterGameObj.Status = GV.onlineSocket.readUnsignedShort();
         this._gameID = enterGameObj.GameID = GV.onlineSocket.readUnsignedShort();
         this._groupID = enterGameObj.GroupID = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(ENTER_GAME,enterGameObj));
      }
      
      public function get userID() : uint
      {
         return this._userID;
      }
      
      public function get itemID() : uint
      {
         return this._itemID;
      }
      
      public function get action() : uint
      {
         return this._action;
      }
      
      public function get direction() : uint
      {
         return this._direction;
      }
      
      public function get status() : uint
      {
         return this._status;
      }
      
      public function get gameID() : uint
      {
         return this._gameID;
      }
      
      public function get groupID() : uint
      {
         return this._groupID;
      }
   }
}

