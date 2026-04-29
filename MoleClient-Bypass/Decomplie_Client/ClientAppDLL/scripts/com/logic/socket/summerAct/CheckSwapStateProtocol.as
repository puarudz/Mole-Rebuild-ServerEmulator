package com.logic.socket.summerAct
{
   import com.common.util.BitArray;
   import com.global.staticData.CommandID;
   import com.mole.net.SocketProtocol;
   import flash.utils.IDataInput;
   
   public class CheckSwapStateProtocol extends SocketProtocol
   {
      
      private var _typeID:uint;
      
      private var _stateBit:BitArray;
      
      public function CheckSwapStateProtocol()
      {
         super(CommandID.CHECK_SWAP_STATE);
      }
      
      public static function send(type:uint) : void
      {
         GF.sendSocket(CommandID.CHECK_SWAP_STATE,type);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         this._stateBit = new BitArray();
         bodyData.readBytes(this._stateBit,0,4);
         this._typeID = bodyData.readUnsignedInt();
      }
      
      public function get stateBit() : BitArray
      {
         return this._stateBit;
      }
      
      public function get typeID() : uint
      {
         return this._typeID;
      }
   }
}

