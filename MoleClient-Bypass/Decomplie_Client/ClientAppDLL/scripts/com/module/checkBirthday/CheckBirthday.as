package com.module.checkBirthday
{
   import com.core.info.LocalUserInfo;
   import com.logic.socket.getServerTimer.getServerTimerReq;
   
   public class CheckBirthday
   {
      
      private static var returnObj:Array = new Array();
      
      public function CheckBirthday()
      {
         super();
      }
      
      public function checkBirth(cls:*, fun:String) : void
      {
         returnObj.push({
            "obj":cls,
            "fun":fun
         });
         getServerTimerReq.getServerTimer(this,"getServerTimer");
      }
      
      public function getServerTimer(E:Date) : void
      {
         var tempObj:Object = null;
         var days:int = E.getDate();
         var hours:int = E.getHours();
         var month:int = E.getMonth() + 1;
         var isBirthDay:uint = 0;
         var bornDate:Date = new Date(LocalUserInfo.getBookBirthday() * 1000);
         var bornDay:uint = bornDate.getDate();
         var bornMonth:uint = bornDate.getMonth() + 1;
         if(LocalUserInfo.getBookBirthday() == 0)
         {
            isBirthDay = 2;
         }
         else if(days == bornDay && month == bornMonth)
         {
            isBirthDay = 1;
         }
         while(Boolean(returnObj.length))
         {
            tempObj = returnObj.shift();
            tempObj.obj[tempObj.fun](isBirthDay);
         }
      }
   }
}

