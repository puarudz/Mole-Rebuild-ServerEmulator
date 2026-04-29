package com.mole.app.manager
{
   import com.core.MainManager;
   import com.core.info.ServerUpTime;
   import com.mole.net.MoleSharedObject;
   
   public class VipMonthPayManager
   {
      
      private static var _inst:VipMonthPayManager;
      
      public function VipMonthPayManager()
      {
         super();
      }
      
      public static function get inst() : VipMonthPayManager
      {
         if(_inst == null)
         {
            _inst = new VipMonthPayManager();
         }
         return _inst;
      }
      
      public function init() : void
      {
         var dateOld:Date = null;
         var dayOld:int = 0;
         var dayNow:int = 0;
         var date:Date = ServerUpTime.getInstance().date;
         if(MoleSharedObject.moleObj.vipMonthClickDate == undefined)
         {
            ModuleManager.openPanel("HappySummerSuperIntroPanel",null,"正在加載面板，請耐心等待......",MainManager.getTopLevel());
            MoleSharedObject.moleObj.vipMonthClickDate = date;
         }
         else
         {
            dateOld = MoleSharedObject.moleObj.vipMonthClickDate;
            dayOld = dateOld.day;
            dayNow = date.day;
            dayOld = dayOld == 0 ? 7 : dayOld;
            dayNow = dayNow == 0 ? 7 : dayNow;
            if(date.time - dateOld.time > 7 * 24 * 3600 * 1000 || dayOld < 5 && dayNow >= 5)
            {
               ModuleManager.openPanel("HappySummerSuperIntroPanel",null,"正在加載面板，請耐心等待......",MainManager.getTopLevel());
               MoleSharedObject.moleObj.vipMonthClickDate = date;
            }
         }
      }
   }
}

