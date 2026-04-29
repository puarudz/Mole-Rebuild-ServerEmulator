package org.taomee.net.tmf
{
   import flash.utils.IDataInput;
   
   public class HeadInfo
   {
      
      private var _commandID:uint;
      
      private var _userID:uint;
      
      private var _result:int;
      
      private var _error:uint;
      
      public function HeadInfo(data:IDataInput = null)
      {
         super();
         if(data != null)
         {
            this._commandID = data.readUnsignedShort();
            this._userID = data.readUnsignedInt();
            this._result = data.readInt();
            this._error = data.readUnsignedInt();
         }
      }
      
      public function get commandID() : uint
      {
         return this._commandID;
      }
      
      public function get userID() : uint
      {
         return this._userID;
      }
      
      public function get result() : int
      {
         return this._result;
      }
      
      public function get error() : uint
      {
         return this._error;
      }
      
      public function set commandID(val:uint) : void
      {
         this._commandID = val;
      }
      
      public function set userID(val:uint) : void
      {
         this._userID = val;
      }
      
      public function set result(val:int) : void
      {
         this._result = val;
      }
      
      public function set error(val:uint) : void
      {
         this._error = val;
      }
   }
}

