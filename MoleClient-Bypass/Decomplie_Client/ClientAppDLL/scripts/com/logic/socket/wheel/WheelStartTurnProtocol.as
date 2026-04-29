package com.logic.socket.wheel
{
   import com.global.staticData.CommandID;
   import com.mole.net.SocketProtocol;
   import flash.utils.IDataInput;
   
   public class WheelStartTurnProtocol extends SocketProtocol
   {
      
      private var _point:uint;
      
      private var _userID:uint;
      
      private var _itemID:uint;
      
      private var _itemCount:uint;
      
      public function WheelStartTurnProtocol()
      {
         super(CommandID.WHEEL_START_TURN);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         this._point = bodyData.readUnsignedInt();
         this._userID = bodyData.readUnsignedInt();
         this._itemID = bodyData.readUnsignedInt();
         this._itemCount = bodyData.readUnsignedInt();
      }
      
      public function get point() : uint
      {
         return this._point;
      }
      
      public function get userID() : uint
      {
         return this._userID;
      }
      
      public function get itemID() : uint
      {
         return this._itemID;
      }
      
      public function get itemCount() : uint
      {
         return this._itemCount;
      }
   }
}

