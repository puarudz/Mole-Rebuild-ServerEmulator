package com.logic.loadUserInfoList
{
   import com.event.EventTaomee;
   import com.logic.socket.getUserBasicInfo.GetUserBasicInfoReq;
   import com.logic.socket.getUserBasicInfo.GetUserBasicInfoRes;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class UserInfoLoader extends EventDispatcher
   {
      
      public static const LOAD_USER_INFO_OK:String = "UserInfoLoader LOAD_USER_INFO_OK";
      
      private var _id:int;
      
      private var _name:String;
      
      private var _data:Object;
      
      public function UserInfoLoader(id:int)
      {
         super();
         this._id = id;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function get isVip() : Boolean
      {
         return Boolean(this._data.Vip >> 0 & 1);
      }
      
      public function get color() : int
      {
         return this._data.Color;
      }
      
      public function get isOnline() : Boolean
      {
         return this._data.Status < 3 && this._data.Status >= 0;
      }
      
      public function InitUserInfo() : void
      {
         BC.addEvent(this,GV.onlineSocket,GetUserBasicInfoRes.GET_USER_BASIC_INFO,this.onReadUserInfo);
         new GetUserBasicInfoReq().getUserBasicInfo(this._id);
      }
      
      private function onReadUserInfo(e:EventTaomee) : void
      {
         if(e.EventObj.UserID == this._id)
         {
            BC.removeEvent(this,GV.onlineSocket,GetUserBasicInfoRes.GET_USER_BASIC_INFO,this.onReadUserInfo);
            this._data = e.EventObj;
            this._name = this._data.Nick;
            this.InitOK();
         }
      }
      
      private function InitOK() : void
      {
         this.dispatchEvent(new Event(LOAD_USER_INFO_OK));
      }
   }
}

