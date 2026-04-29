package com.logic.socket.raimblowLoL
{
   import com.global.staticData.CommandID;
   import com.mole.net.SocketProtocol;
   import flash.utils.IDataInput;
   
   public class GetLollipopsProtocol extends SocketProtocol
   {
      
      private var _flag:uint;
      
      private var _index:uint;
      
      public function GetLollipopsProtocol()
      {
         super(CommandID.LOLLIPS_RAINBLOW_GET);
      }
      
      public static function send(flag:uint) : void
      {
         GF.sendSocket(CommandID.LOLLIPS_RAINBLOW_GET,flag);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         this._flag = bodyData.readUnsignedInt();
         this._index = bodyData.readUnsignedInt();
      }
      
      public function get flag() : uint
      {
         return this._flag;
      }
      
      public function get index() : uint
      {
         return this._index;
      }
   }
}

