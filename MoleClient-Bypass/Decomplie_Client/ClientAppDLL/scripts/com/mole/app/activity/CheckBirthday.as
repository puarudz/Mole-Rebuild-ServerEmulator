package com.mole.app.activity
{
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   
   public class CheckBirthday
   {
      
      private static var _year:uint;
      
      private static var _month:uint;
      
      private static var _day:uint;
      
      public function CheckBirthday()
      {
         super();
      }
      
      public static function CheckKFCBirthday() : uint
      {
         var setDate:Date = new Date(LocalUserInfo.getBookBirthday() * 1000);
         if(setDate.getFullYear() > 2009)
         {
            _year = 2009;
         }
         else
         {
            _year = setDate.getFullYear();
         }
         _month = setDate.getMonth() + 1;
         _day = setDate.getDate();
         var _curDate:Date = ServerUpTime.getInstance().date;
         var _curMonth:uint = _curDate.month + 1;
         var _curDay:uint = _curDate.date;
         if(_curMonth == _month && _day == _curDay)
         {
            return 1;
         }
         if(_year == 1970 && _month == 1 && _day == 1)
         {
            return 2;
         }
         return 0;
      }
   }
}

