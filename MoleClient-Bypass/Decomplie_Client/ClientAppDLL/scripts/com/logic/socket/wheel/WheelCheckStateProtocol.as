package com.logic.socket.wheel
{
   import com.global.staticData.CommandID;
   import com.mole.net.SocketProtocol;
   import flash.utils.IDataInput;
   
   public class WheelCheckStateProtocol extends SocketProtocol
   {
      
      private var _seatList:Array;
      
      public function WheelCheckStateProtocol()
      {
         super(CommandID.WHEEL_CHECK_STATE);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         this._seatList = new Array();
         for(var i:uint = 0; i < 4; i++)
         {
            this._seatList.push(bodyData.readUnsignedInt());
         }
      }
      
      public function get seatList() : Array
      {
         return this._seatList;
      }
   }
}

