package com.mole.app.info
{
   import com.mole.app.type.SocketType;
   
   public class SocketInfo
   {
      
      private var _cmdID:int;
      
      private var _sendFunc:String;
      
      private var _sendParams:Array;
      
      private var _eventName:String;
      
      public var state:int;
      
      public function SocketInfo(cmdID:int, eventName:String, sendFunc:String, sendParams:Array = null)
      {
         super();
         this._cmdID = cmdID;
         this._eventName = eventName;
         this._sendFunc = sendFunc;
         this.state = SocketType.WATTING;
         this._sendParams = sendParams;
      }
      
      public function get cmdID() : int
      {
         return this._cmdID;
      }
      
      public function get eventName() : String
      {
         return this._eventName;
      }
      
      public function get sendFunc() : String
      {
         return this._sendFunc;
      }
      
      public function get sendParams() : Array
      {
         return this._sendParams;
      }
   }
}

