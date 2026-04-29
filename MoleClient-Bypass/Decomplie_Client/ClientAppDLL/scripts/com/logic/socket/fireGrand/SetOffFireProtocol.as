package com.logic.socket.fireGrand
{
   import com.common.util.StringUtil;
   import com.global.staticData.CommandID;
   import com.mole.net.SocketProtocol;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class SetOffFireProtocol extends SocketProtocol
   {
      
      private var _userID:uint;
      
      private var _num:uint;
      
      private var _strInfo:String;
      
      public function SetOffFireProtocol()
      {
         super(CommandID.FIREGRAND_SETOFF_FIRE);
      }
      
      public static function send(num:uint, strInfo:String) : void
      {
         var byte:ByteArray = new ByteArray();
         byte.writeUnsignedInt(num);
         byte.writeBytes(StringUtil.FillString(strInfo,64));
         GF.sendSocket(CommandID.FIREGRAND_SETOFF_FIRE,byte);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         this._userID = bodyData.readUnsignedInt();
         this._num = bodyData.readUnsignedInt();
         this._strInfo = bodyData.readUTFBytes(64);
      }
      
      public function get userID() : uint
      {
         return this._userID;
      }
      
      public function get num() : uint
      {
         return this._num;
      }
      
      public function get strInfo() : String
      {
         return this._strInfo;
      }
   }
}

