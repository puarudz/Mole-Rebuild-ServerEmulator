package com.mole.app.manager
{
   import com.core.info.LocalUserInfo;
   import com.global.staticData.CommandID;
   import com.mole.app.type.ModuleType;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class MoleDataManager
   {
      
      private static var _data:*;
      
      private static var _enabled:Boolean = true;
      
      public function MoleDataManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         GV.onlineSocket.addCmdListener(CommandID.MOLE_LEVEL_UP_NOTI,moleLevelUpNotiHandler);
         GV.onlineSocket.addCmdListener(CommandID.SYNCHRONOUS_MONEY,moleMoneyHandle);
      }
      
      private static function moleMoneyHandle(event:SocketEvent) : void
      {
         var money:uint = 0;
         var bytearr:ByteArray = event.data as ByteArray;
         if(Boolean(bytearr))
         {
            money = bytearr.readUnsignedInt();
            LocalUserInfo.setYXQ(money);
         }
      }
      
      private static function moleLevelUpNotiHandler(event:SocketEvent) : void
      {
         _data = event.data;
         checkNeedNoti();
      }
      
      private static function checkNeedNoti() : void
      {
         if(_enabled && Boolean(_data))
         {
            ModuleManager.openPanel(ModuleType.MoleLevelUpPanel,_data);
            _data = null;
         }
      }
      
      public static function get enabled() : Boolean
      {
         return _enabled;
      }
      
      public static function set enabled(value:Boolean) : void
      {
         _enabled = value;
         if(_enabled)
         {
            checkNeedNoti();
         }
      }
   }
}

