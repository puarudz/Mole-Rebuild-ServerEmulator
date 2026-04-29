package com.logic.socket
{
   import com.global.staticData.CommandID;
   import com.mole.net.SocketProtocol;
   import flash.utils.IDataInput;
   
   public class GetRedPacketProtocol extends SocketProtocol
   {
      
      private var _state:int;
      
      private var _itemID:int;
      
      private var _count:int;
      
      public function GetRedPacketProtocol()
      {
         super(CommandID.GET_RED_PACKET);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         this._state = bodyData.readUnsignedInt();
         this._itemID = bodyData.readUnsignedInt();
         this._count = bodyData.readUnsignedInt();
      }
      
      public function get state() : int
      {
         return this._state;
      }
      
      public function get itemID() : int
      {
         return this._itemID;
      }
      
      public function get count() : int
      {
         return this._count;
      }
   }
}

