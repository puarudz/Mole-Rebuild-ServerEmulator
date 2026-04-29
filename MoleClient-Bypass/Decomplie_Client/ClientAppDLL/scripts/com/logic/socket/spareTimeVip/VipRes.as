package com.logic.socket.spareTimeVip
{
   import com.event.EventTaomee;
   
   public class VipRes
   {
      
      public static var VIP_LEAVE_TIME:String = "vip_leave_time";
      
      public function VipRes()
      {
         super();
      }
      
      public static function vipResFunc() : void
      {
         var vipObj:Object = new Object();
         vipObj.DaysLeft = GV.onlineSocket.readUnsignedInt();
         vipObj.flag = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(VIP_LEAVE_TIME,vipObj));
      }
   }
}

