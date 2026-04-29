package com.logic.socket.fireGrand
{
   import com.global.staticData.CommandID;
   import com.mole.net.SocketProtocol;
   import flash.utils.IDataInput;
   
   public class EnterLeaveFirePlaceProtocol extends SocketProtocol
   {
      
      private var _userID:uint;
      
      private var _flag:uint;
      
      public function EnterLeaveFirePlaceProtocol()
      {
         super(CommandID.FIREGRAND_ENTER_LEAVE_FIRE_PLACE);
      }
      
      public static function send(flag:uint) : void
      {
         GF.sendSocket(CommandID.FIREGRAND_ENTER_LEAVE_FIRE_PLACE,flag);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         this._userID = bodyData.readUnsignedInt();
         this._flag = bodyData.readUnsignedInt();
      }
      
      public function get userID() : uint
      {
         return this._userID;
      }
      
      public function get flag() : uint
      {
         return this._flag;
      }
   }
}

