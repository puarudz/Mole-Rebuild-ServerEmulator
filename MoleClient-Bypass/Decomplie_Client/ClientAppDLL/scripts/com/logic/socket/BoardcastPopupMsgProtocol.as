package com.logic.socket
{
   import com.global.staticData.CommandID;
   import com.mole.net.SocketProtocol;
   import flash.utils.IDataInput;
   
   public class BoardcastPopupMsgProtocol extends SocketProtocol
   {
      
      private var _userID:uint;
      
      private var _nick:String;
      
      public function BoardcastPopupMsgProtocol()
      {
         super(CommandID.BOARDCAST_POPUP_MSG);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         this._userID = bodyData.readUnsignedInt();
         this._nick = bodyData.readUTFBytes(16);
      }
      
      public function get userID() : uint
      {
         return this._userID;
      }
      
      public function get nick() : String
      {
         return this._nick;
      }
   }
}

