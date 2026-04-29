package com.module.activityModule
{
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.spareTimeVip.VipReq;
   import com.logic.socket.spareTimeVip.VipRes;
   
   public class CheckVip
   {
      
      public static var VIP_DAYS:String = "vip_days";
      
      public function CheckVip()
      {
         super();
      }
      
      public function listVip() : void
      {
         GV.onlineSocket.addEventListener(VipRes.VIP_LEAVE_TIME,this.vipLeftHandler);
         VipReq.vipFunc();
      }
      
      private function vipLeftHandler(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(VipRes.VIP_LEAVE_TIME,this.vipLeftHandler);
         var leftObj:Object = new Object();
         leftObj = evt.EventObj;
         leftObj.bool = false;
         switch(leftObj.DaysLeft)
         {
            case 1:
            case 3:
            case 5:
               leftObj.bool = true;
         }
         LocalUserInfo.vipDays = leftObj.DaysLeft;
         GV.onlineSocket.dispatchEvent(new EventTaomee(VIP_DAYS,leftObj));
      }
   }
}

