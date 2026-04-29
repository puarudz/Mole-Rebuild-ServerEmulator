package com.mole.app.manager
{
   public class SystemTimeUtil
   {
      
      private static var _sysID:uint;
      
      public function SystemTimeUtil()
      {
         super();
      }
      
      public static function checkSysTime(sysID:uint) : Boolean
      {
         _sysID = sysID;
         if(SystemTimeController.instance.checkSysTimeAchieve(_sysID))
         {
            return true;
         }
         return false;
      }
   }
}

