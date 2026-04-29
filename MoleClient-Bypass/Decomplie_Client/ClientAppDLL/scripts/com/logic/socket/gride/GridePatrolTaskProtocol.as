package com.logic.socket.gride
{
   import com.common.msgHead.MsgHead;
   import com.global.staticData.CommandID;
   import com.mole.net.SocketProtocol;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class GridePatrolTaskProtocol extends SocketProtocol
   {
      
      private var _type:uint;
      
      private var _state:uint;
      
      private var _result:uint;
      
      public function GridePatrolTaskProtocol()
      {
         super(CommandID.GRIDE_PATROL_TASK);
      }
      
      public static function send(type:uint) : void
      {
         MsgHead.Command = CommandID.GRIDE_PATROL_TASK;
         var bodyData:ByteArray = new ByteArray();
         bodyData.writeUnsignedInt(type);
         GF.writeHead(bodyData);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         this._type = bodyData.readUnsignedInt();
         this._state = bodyData.readUnsignedInt();
         this._result = bodyData.readUnsignedInt();
      }
      
      public function get type() : uint
      {
         return this._type;
      }
      
      public function get state() : uint
      {
         return this._state;
      }
      
      public function get result() : uint
      {
         return this._result;
      }
   }
}

