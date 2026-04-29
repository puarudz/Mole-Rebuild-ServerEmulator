package com.mole.net
{
   import com.mole.net.events.SocketEvent;
   import com.mole.net.interfaces.ISocketProtocol;
   import flash.utils.IDataInput;
   
   public class SocketProtocol implements ISocketProtocol
   {
      
      protected var _cmdID:uint;
      
      public function SocketProtocol(cmdID:uint)
      {
         super();
         this._cmdID = cmdID;
      }
      
      public function decode(bodyData:IDataInput = null) : void
      {
         bodyData = bodyData == null ? GV.onlineSocket : bodyData;
         this.decodeData(bodyData);
         this.decodeEvent();
      }
      
      protected function decodeData(bodyData:IDataInput) : void
      {
      }
      
      private function decodeEvent() : void
      {
         GV.onlineSocket.dispatchEvent(new SocketEvent(SocketEvent.DATA + this._cmdID.toString(),null,this));
      }
   }
}

