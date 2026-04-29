package com.logic.loadUserInfoList
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class LoaderUserInfoList extends EventDispatcher
   {
      
      public static const LOAD_USER_LIST_OVER:String = "LoaderUserInfoList LOAD_USER_LIST_OVER";
      
      private var _userList:Array;
      
      private var _tempLoadList:Array;
      
      public function LoaderUserInfoList()
      {
         super();
      }
      
      public function get userInfoList() : Array
      {
         return this._userList;
      }
      
      public function LoadUserList(value:Array) : void
      {
         var obj:Object = null;
         if(Boolean(value))
         {
            this._userList = new Array();
            for each(obj in value)
            {
               if(obj is int)
               {
                  this._userList.push(new UserInfoLoader(int(obj)));
               }
               else if(obj.hasOwnProperty("id"))
               {
                  this._userList.push(new UserInfoLoader(int(obj.id)));
               }
            }
            this._tempLoadList = this._userList.slice();
            this.LoadUsersInfo();
         }
      }
      
      private function LoadUsersInfo() : void
      {
         var userInfo:UserInfoLoader = null;
         if(this._tempLoadList.length > 0)
         {
            userInfo = this._tempLoadList.pop();
            BC.addEvent(this,userInfo,UserInfoLoader.LOAD_USER_INFO_OK,this.OnUserInfoLoadOK);
            userInfo.InitUserInfo();
         }
         else
         {
            this.InitOK();
         }
      }
      
      private function OnUserInfoLoadOK(e:Event) : void
      {
         BC.removeEvent(this,e.currentTarget,UserInfoLoader.LOAD_USER_INFO_OK,this.OnUserInfoLoadOK);
         this.LoadUsersInfo();
      }
      
      private function InitOK() : void
      {
         this.dispatchEvent(new Event(LOAD_USER_LIST_OVER));
      }
   }
}

