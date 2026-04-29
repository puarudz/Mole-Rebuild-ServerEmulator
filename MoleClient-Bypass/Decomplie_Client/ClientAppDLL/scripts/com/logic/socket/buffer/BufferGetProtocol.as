package com.logic.socket.buffer
{
   import com.global.staticData.CommandID;
   import com.mole.net.SocketProtocol;
   import flash.utils.IDataInput;
   
   public class BufferGetProtocol extends SocketProtocol
   {
      
      private var _type:uint;
      
      private var _data:uint;
      
      public function BufferGetProtocol()
      {
         super(CommandID.BUFFER_GET);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         this._type = bodyData.readUnsignedInt();
         this._data = bodyData.readUnsignedInt();
      }
      
      public function get type() : uint
      {
         return this._type;
      }
      
      public function get data() : uint
      {
         return this._data;
      }
   }
}

