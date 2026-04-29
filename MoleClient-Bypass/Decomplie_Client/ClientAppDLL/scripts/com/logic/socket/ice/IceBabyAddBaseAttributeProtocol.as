package com.logic.socket.ice
{
   import com.global.staticData.CommandID;
   import com.mole.net.SocketProtocol;
   import flash.utils.IDataInput;
   
   public class IceBabyAddBaseAttributeProtocol extends SocketProtocol
   {
      
      private var _state:uint;
      
      private var _type:uint;
      
      private var _game:uint;
      
      private var _award:uint;
      
      public function IceBabyAddBaseAttributeProtocol()
      {
         super(CommandID.ICE_BABY_ADD_BASE_ATTRIBUTE);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         this._state = bodyData.readUnsignedInt();
         this._type = bodyData.readUnsignedInt();
         this._game = bodyData.readUnsignedInt();
         this._award = bodyData.readUnsignedInt();
      }
      
      public function get state() : uint
      {
         return this._state;
      }
      
      public function get type() : uint
      {
         return this._type;
      }
      
      public function get award() : uint
      {
         return this._award;
      }
      
      public function get game() : uint
      {
         return this._game;
      }
   }
}

