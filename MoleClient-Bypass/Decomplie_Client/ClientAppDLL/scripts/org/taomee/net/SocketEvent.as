package org.taomee.net
{
   import flash.events.Event;
   import org.taomee.net.tmf.HeadInfo;
   
   public class SocketEvent extends Event
   {
      
      public static const SOCKET_ERROR:String = "socketError";
      
      private var _headInfo:HeadInfo;
      
      private var _data:Object;
      
      public function SocketEvent(type:String, headInfo:HeadInfo, data:Object = null)
      {
         super(type);
         this._headInfo = headInfo;
         this._data = data;
      }
      
      public function get headInfo() : HeadInfo
      {
         return this._headInfo;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
   }
}

