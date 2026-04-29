package com.logic.socket
{
   import com.global.staticData.CommandID;
   import com.mole.net.SocketProtocol;
   import flash.utils.IDataInput;
   
   public class PreLoginTimeProtocol extends SocketProtocol
   {
      
      private var _preTime:Number;
      
      private var _tarDate:Number;
      
      private var _isInTime:Boolean;
      
      public function PreLoginTimeProtocol()
      {
         super(CommandID.PRE_LOGIN_TIME);
      }
      
      override protected function decodeData(bodyData:IDataInput) : void
      {
         this._preTime = bodyData.readUnsignedInt();
         if(this._preTime < 20130101)
         {
            this._isInTime = true;
         }
         else
         {
            this._isInTime = false;
         }
      }
      
      public function get isInTime() : Boolean
      {
         return this._isInTime;
      }
      
      public function get preTime() : Number
      {
         return this._preTime;
      }
   }
}

