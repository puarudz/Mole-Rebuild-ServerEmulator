package com.mole.app.manager
{
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.session.BringTagoutLoginSocket;
   import com.logic.socket.vipSession.VipSessionReq;
   import com.logic.socket.vipSession.VipSessionRes;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.Tick;
   
   public class SessionManager
   {
      
      public static var sessionTime:uint;
      
      public static var sessionStr:String;
      
      public static var session151:ByteArray;
      
      private static const TIMER_STEP:uint = 1000 * 60 * 5;
      
      public function SessionManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         Tick.instance.addRender(getSession,TIMER_STEP);
         getSession();
         GV.onlineSocket.addCmdListener(CommandID.GET_PAY_PWD_STATE,getPwdStateBk);
         GF.sendSocket(CommandID.GET_PAY_PWD_STATE);
      }
      
      private static function getPwdStateBk(evt:SocketEvent) : void
      {
         var recData:ByteArray = evt.data as ByteArray;
         LocalUserInfo.needPayPwd = recData.readUnsignedInt() == 1;
      }
      
      private static function getSession(time:uint = 0) : void
      {
         var vip:VipSessionReq = new VipSessionReq();
         GV.onlineSocket.addEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,getSessionBack);
         vip.sendReq();
         GV.onlineSocket.addEventListener("read_" + 426,getSessionHeroGame);
         BringTagoutLoginSocket.get_GameSID(151);
      }
      
      private static function getSessionHeroGame(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 426,getSessionHeroGame);
         session151 = evt.EventObj as ByteArray;
      }
      
      private static function getSessionBack(evt:EventTaomee) : void
      {
         sessionTime = evt.EventObj.Time;
         sessionStr = evt.EventObj.Session;
      }
   }
}

