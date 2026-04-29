package com.mole.net.info
{
   public class SocketErrorInfo
   {
      
      private var _cmdId:uint;
      
      private var _errorCode:int;
      
      private var _msg:String;
      
      private var _type:uint;
      
      private var _untreated:Boolean;
      
      public function SocketErrorInfo(cmdId:uint, errorCode:int, msg:String, type:uint = 1, untreated:Boolean = true)
      {
         super();
         this._cmdId = cmdId;
         this._errorCode = errorCode;
         this._msg = msg;
         this._type = type;
         this._untreated = untreated;
      }
      
      public function get type() : uint
      {
         return this._type;
      }
      
      public function get msg() : String
      {
         return this._msg;
      }
      
      public function get errorCode() : int
      {
         return this._errorCode;
      }
      
      public function get cmdId() : uint
      {
         return this._cmdId;
      }
      
      public function get untreated() : Boolean
      {
         return this._untreated;
      }
   }
}

