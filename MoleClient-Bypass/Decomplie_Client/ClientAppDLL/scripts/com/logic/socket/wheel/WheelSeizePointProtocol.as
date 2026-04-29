package com.logic.socket.wheel
{
   import com.global.staticData.CommandID;
   import com.mole.net.SocketProtocol;
   import flash.utils.IDataInput;
   
   public class WheelSeizePointProtocol extends SocketProtocol
   {
      
      private var _op:uint;
      
      private var _state:uint;
      
      public function WheelSeizePointProtocol()
      {
         super(CommandID.WHEEL_SEIZE_POINT);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         this._op = bodyData.readUnsignedInt();
         this._state = bodyData.readUnsignedInt();
      }
      
      public function get state() : uint
      {
         return this._state;
      }
      
      public function get op() : uint
      {
         return this._op;
      }
   }
}

