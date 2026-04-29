package com.logic.socket.fireGrand
{
   import com.global.staticData.CommandID;
   import com.mole.net.SocketProtocol;
   import flash.utils.IDataInput;
   
   public class QueryFireInfoProtocol extends SocketProtocol
   {
      
      private var _userID:uint;
      
      public function QueryFireInfoProtocol()
      {
         super(CommandID.FIREGRAND_QUERY_FIREINFO);
      }
      
      public static function send() : void
      {
         GF.sendSocket(CommandID.FIREGRAND_QUERY_FIREINFO);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         this._userID = bodyData.readUnsignedInt();
      }
      
      public function get userID() : uint
      {
         return this._userID;
      }
   }
}

