package com.module.acclimationSMC.socket
{
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.module.acclimationSMC.AcclimationSMCManager;
   import com.module.acclimationSMC.data.AcclimationSMC_ItemInfo;
   import com.module.acclimationSMC.data.AcclimationSMC_UserInfo;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class AcclimationSMC_SocketInfo extends EventDispatcher
   {
      
      private static var _inst:AcclimationSMC_SocketInfo;
      
      public static var GETUSERINFO:String = "get_user_info";
      
      public static var GETSTOCKADEINFO:String = "get_stockade_info";
      
      public function AcclimationSMC_SocketInfo(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function getInstance() : AcclimationSMC_SocketInfo
      {
         if(_inst == null)
         {
            _inst = new AcclimationSMC_SocketInfo();
         }
         return _inst;
      }
      
      public function getUserInfo(userID:uint = 0) : void
      {
         trace("AcclimationSMC_SocketInfo::   getUserInfo  =========",11085,userID);
         GV.onlineSocket.addEventListener("SocketEvent_error",this.backError11085);
         GV.onlineSocket.addCmdListener(CommandID.ID_11085,this.back11085);
         GF.sendSocket(CommandID.ID_11085,userID);
      }
      
      private function backError11085(e:*) : void
      {
         GV.onlineSocket.removeEventListener("SocketEvent_error",this.backError11085);
         GV.onlineSocket.removeCmdListener(CommandID.ID_11085,this.back11085);
      }
      
      private function back11085(e:SocketEvent) : void
      {
         GV.onlineSocket.removeEventListener("SocketEvent_error",this.backError11085);
         GV.onlineSocket.removeCmdListener(CommandID.ID_11085,this.back11085);
         var date:ByteArray = e.data as ByteArray;
         var userInfo:AcclimationSMC_UserInfo = new AcclimationSMC_UserInfo();
         userInfo.userid = date.readUnsignedInt();
         userInfo.level = date.readUnsignedByte();
         userInfo.exp = date.readUnsignedInt();
         userInfo.needExp = date.readUnsignedInt();
         userInfo.bagsize = date.readUnsignedShort();
         userInfo.exchg_bagsize = date.readUnsignedShort();
         userInfo.max_training_num = date.readUnsignedByte();
         userInfo.training_lv = date.readUnsignedByte();
         userInfo.instrument1 = date.readUnsignedInt();
         userInfo.instrument2 = date.readUnsignedInt();
         dispatchEvent(new EventTaomee(GETUSERINFO,userInfo));
         if(userInfo.userid == LocalUserInfo.getUserID())
         {
            AcclimationSMCManager.getInstance().userInfo = userInfo;
         }
      }
      
      public function getStockade(userID:uint = 0) : void
      {
         trace("AcclimationSMC_SocketInfo::   getStockade  =========",11086,userID);
         GV.onlineSocket.addEventListener("SocketEvent_error",this.backError11086);
         GV.onlineSocket.addCmdListener(CommandID.ID_11086,this.back11086);
         GF.sendSocket(CommandID.ID_11086,userID);
      }
      
      private function backError11086(e:*) : void
      {
         GV.onlineSocket.removeEventListener("SocketEvent_error",this.backError11086);
         GV.onlineSocket.removeCmdListener(CommandID.ID_11086,this.back11086);
      }
      
      private function back11086(e:SocketEvent) : void
      {
         var one:Object = null;
         var info:AcclimationSMC_ItemInfo = null;
         GV.onlineSocket.removeEventListener("SocketEvent_error",this.backError11086);
         GV.onlineSocket.removeCmdListener(CommandID.ID_11086,this.back11086);
         var date:ByteArray = e.data as ByteArray;
         if(date == null)
         {
            return;
         }
         var obj:Object = new Object();
         obj.count = date.readUnsignedInt();
         obj.arr = new Array();
         obj.friendArr = [null,null];
         for(var i:uint = 0; i < obj.count; i++)
         {
            one = new Object();
            one.masterid = date.readUnsignedInt();
            one.puttime = date.readUnsignedInt();
            one.itemid = date.readUnsignedInt();
            one.pos_x = date.readUnsignedByte();
            one.training_time = date.readUnsignedInt();
            info = AcclimationSMCManager.makeItemInfo(one.itemid);
            info.masterid = one.masterid;
            info.puttime = one.puttime;
            info.pos_x = one.pos_x;
            info.training_time = one.training_time;
            if(info.pos_x == 8 || info.pos_x == 9)
            {
               info.isFriend = 1;
               obj.friendArr[info.pos_x - 8] = info;
            }
            obj.arr.push(info);
         }
         dispatchEvent(new EventTaomee(GETSTOCKADEINFO,obj));
      }
   }
}

