package com.mole.net.events
{
   import flash.events.Event;
   import org.taomee.net.tmf.HeadInfo;
   
   public class SocketEvent extends Event
   {
      
      public static const ERROR:String = "SocketEvent_error";
      
      public static const SUCCESS:String = "SocketEvent_success";
      
      public static const CLOSE:String = "SocketEvent_Close";
      
      public static const DATA:String = "SocketEvent_Data";
      
      private var _headInfo:HeadInfo;
      
      private var _bodyData:*;
      
      public function SocketEvent(type:String, headInfo:HeadInfo, bodyData:* = null)
      {
         super(type);
         this._headInfo = headInfo;
         this._bodyData = bodyData;
      }
      
      public function get headInfo() : HeadInfo
      {
         return this._headInfo;
      }
      
      public function get bodyInfo() : *
      {
         return this._bodyData;
      }
      
      public function get cmdID() : uint
      {
         return this._headInfo.commandID;
      }
      
      public function get errorID() : int
      {
         return this._headInfo.error;
      }
      
      override public function clone() : Event
      {
         return new SocketEvent(this.type,this._headInfo,this._bodyData);
      }
   }
}

