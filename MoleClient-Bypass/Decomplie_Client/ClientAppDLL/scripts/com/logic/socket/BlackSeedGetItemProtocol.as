package com.logic.socket
{
   import com.global.staticData.CommandID;
   import com.mole.net.SocketProtocol;
   import flash.utils.IDataInput;
   
   public class BlackSeedGetItemProtocol extends SocketProtocol
   {
      
      private var _idOne:int;
      
      private var _numOne:int;
      
      private var _idTwo:int;
      
      private var _numTwo:int;
      
      public function BlackSeedGetItemProtocol()
      {
         super(CommandID.BLACK_SEED_GET_ITEM);
      }
      
      public static function send() : void
      {
         GF.sendSocket(CommandID.BLACK_SEED_GET_ITEM);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         this._idOne = bodyData.readUnsignedInt();
         this._numOne = bodyData.readUnsignedInt();
         this._idTwo = bodyData.readUnsignedInt();
         this._numTwo = bodyData.readUnsignedInt();
      }
      
      public function get idOne() : uint
      {
         return this._idOne;
      }
      
      public function get numOne() : uint
      {
         return this._numOne;
      }
      
      public function get idTwo() : uint
      {
         return this._idTwo;
      }
      
      public function get numTwo() : uint
      {
         return this._numTwo;
      }
   }
}

