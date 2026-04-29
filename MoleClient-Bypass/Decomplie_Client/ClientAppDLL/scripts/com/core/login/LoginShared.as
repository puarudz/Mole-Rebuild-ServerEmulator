package com.core.login
{
   import com.mole.net.MoleSharedObject;
   import flash.events.AsyncErrorEvent;
   import flash.events.Event;
   import flash.events.NetStatusEvent;
   import flash.net.SharedObject;
   
   public class LoginShared
   {
      
      private static var _sharedObj:SharedObject;
      
      public static const LOGIN_DATA:String = "loginData";
      
      public static const LIST:String = "list";
      
      private static var _moleCount:uint = 5;
      
      public function LoginShared()
      {
         super();
      }
      
      public static function setup() : void
      {
         getLoginData();
      }
      
      public static function get isRead51Mole() : Boolean
      {
         return getValue("is61Mole");
      }
      
      public static function set isRead51Mole(value:Boolean) : void
      {
         modify("is61Mole",value);
      }
      
      private static function analysis(obj:Object) : Object
      {
         var newObj:Object = new Object();
         if(Boolean(obj.id))
         {
            newObj.userID = obj.id;
            newObj.remID = obj.rid;
            newObj.pwd = obj.pwd;
            newObj.remPwd = obj.rpwd;
            newObj.nick = obj.nickName;
            newObj.Family = obj.Family;
            MoleSharedObject.getMoleData(newObj.userID).data.clothArray = obj.clothArray;
            return newObj;
         }
         return null;
      }
      
      public static function modify(key:Object, value:Object) : void
      {
         _sharedObj.data[key] = value;
         try
         {
            _sharedObj.flush();
         }
         catch(e:Error)
         {
            trace("本地禁用SO寫入。");
         }
      }
      
      public static function getValue(key:Object) : *
      {
         if(_sharedObj == null)
         {
            getLoginData();
         }
         return _sharedObj.data[key];
      }
      
      public static function get loginList() : Array
      {
         return getValue(LIST);
      }
      
      public static function set loginList(list:Array) : void
      {
         modify(LIST,list);
      }
      
      public static function getUser(userID:Object) : Object
      {
         var userObj:Object = null;
         var obj:Object = null;
         for each(userObj in loginList)
         {
            if(userObj.userID == userID)
            {
               return userObj;
            }
         }
         obj = new Object();
         obj.userID = userID;
         return obj;
      }
      
      public static function removeUser(userID:Object) : void
      {
         var userObj:Object = null;
         var list:Array = new Array();
         for each(userObj in loginList)
         {
            if(userObj.userID != userID)
            {
               list.push(userObj);
            }
         }
         loginList = list;
      }
      
      public static function getAccountState(s:String) : uint
      {
         var mimiExp:RegExp = /^[0-9]{5,10}$/;
         var emailExp:RegExp = /\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/;
         var accountExp:RegExp = /^[a-zA-Z0-9_]{6,20}$/;
         var telExp:RegExp = /^[0-9]{11}$/;
         if(mimiExp.test(s) == true)
         {
            return 1;
         }
         if(emailExp.test(s) == true)
         {
            return 2;
         }
         if(accountExp.test(s) == true)
         {
            return 3;
         }
         if(telExp.test(s) == true)
         {
            return 4;
         }
         return 0;
      }
      
      public static function addUser(obj:Object, userObj:Object = null) : void
      {
         var tmpKey:* = undefined;
         var loginObj:Object = null;
         var curUserObj:Object = null;
         var min:Number = NaN;
         var tmpObj:Object = null;
         var j:uint = 0;
         var date:Date = new Date();
         var list:Array = loginList;
         list = list == null ? [] : list;
         var idx:int = -1;
         for(var i:uint = 0; i < list.length; i++)
         {
            loginObj = list[i];
            if(Boolean(loginObj.userCode))
            {
               if(loginObj.userCode == obj.userCode || loginObj.userID == obj.userID)
               {
                  idx = int(i);
                  if(obj.time > loginObj.time)
                  {
                     for(tmpKey in obj)
                     {
                        loginObj[tmpKey] = obj[tmpKey];
                     }
                  }
                  loginObj.time = date.time;
                  break;
               }
            }
            else if(loginObj.userID == obj.userID)
            {
               idx = int(i);
               if(obj.time > loginObj.time)
               {
                  for(tmpKey in obj)
                  {
                     loginObj[tmpKey] = obj[tmpKey];
                  }
               }
               loginObj.time = date.time;
               break;
            }
         }
         if(idx == -1)
         {
            obj.time = date.time;
            list.push(obj);
            if(Boolean(userObj))
            {
               curUserObj = MoleSharedObject.getMoleData(obj.userID).data;
               for(tmpKey in userObj)
               {
                  curUserObj[tmpKey] = userObj[tmpKey];
               }
            }
         }
         while(list.length > _moleCount)
         {
            min = date.time;
            for(j = 0; j < list.length; j++)
            {
               tmpObj = list[j];
               if(tmpObj.time < min)
               {
                  min = Number(tmpObj.time);
                  idx = int(j);
               }
            }
            list.splice(idx,1);
         }
         loginList = list;
      }
      
      public static function getLoginData() : Object
      {
         if(_sharedObj == null)
         {
            _sharedObj = SharedObject.getLocal("mole/login","/");
            _sharedObj.addEventListener(NetStatusEvent.NET_STATUS,onSOFail);
            _sharedObj.addEventListener(AsyncErrorEvent.ASYNC_ERROR,onSOFail);
         }
         return _sharedObj.data;
      }
      
      private static function onSOFail(e:Event) : void
      {
         trace(e);
      }
      
      public static function getCurMoleDate() : SharedObject
      {
         return MoleSharedObject.moleSO;
      }
   }
}

