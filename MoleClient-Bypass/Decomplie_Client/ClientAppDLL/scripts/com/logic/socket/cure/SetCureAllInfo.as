package com.logic.socket.cure
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class SetCureAllInfo extends BaseOnlineSocketRequest
   {
      
      public function SetCureAllInfo()
      {
         super();
      }
      
      public static function GetAllInfo() : void
      {
         MsgHead.PkgLen = 17;
         initAction(CommandID.CURE_ALL_INFO);
         flush();
      }
      
      public static function SetCureDortorOn(IP:uint) : void
      {
         MsgHead.PkgLen = 21;
         initAction(CommandID.CURE_DOCTOR_ON);
         GV.onlineSocket.writeUnsignedInt(IP);
         flush();
      }
      
      public static function SetCureInvalidOn(IP:uint) : void
      {
         MsgHead.PkgLen = 21;
         initAction(CommandID.CURE_INVALID_ON);
         GV.onlineSocket.writeUnsignedInt(IP);
         flush();
      }
      
      public static function SetCureDortorOut() : void
      {
         MsgHead.PkgLen = 17;
         initAction(CommandID.CURE_DOCTOR_OUT);
         flush();
      }
      
      public static function SetCureInvalidOut() : void
      {
         MsgHead.PkgLen = 17;
         initAction(CommandID.CURE_INVALID_OUT);
         flush();
      }
      
      public static function SetCureDortorOne() : void
      {
         MsgHead.PkgLen = 17;
         initAction(CommandID.CURE_DOCTOR_ONE);
         flush();
      }
      
      public static function SetCureDortorTwo() : void
      {
         MsgHead.PkgLen = 17;
         initAction(CommandID.CURE_DOCTOR_TWO);
         flush();
      }
      
      public static function SetCureDortorWork() : void
      {
         MsgHead.PkgLen = 17;
         initAction(CommandID.CURE_DOCTOR_WORK);
         flush();
      }
      
      public static function EatMedicine(userID:uint, petID:uint, itemID:uint) : void
      {
         MsgHead.PkgLen = 21;
         initAction(CommandID.CURE_EAT);
         GV.onlineSocket.writeUnsignedInt(userID);
         GV.onlineSocket.writeUnsignedInt(petID);
         GV.onlineSocket.writeUnsignedInt(itemID);
         flush();
      }
   }
}

