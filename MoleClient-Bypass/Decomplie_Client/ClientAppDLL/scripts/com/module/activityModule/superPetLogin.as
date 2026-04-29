package com.module.activityModule
{
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.vipSession.VipSessionReq;
   import com.logic.socket.vipSession.VipSessionRes;
   import com.logic.switchMapLogic.switchMapLogic;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.loadExtentPanel.LoadSLPetSecretBookPanel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class superPetLogin
   {
      
      private static var loadGame:LoadGame;
      
      private static var loadSLPetSecretBookPanel:LoadSLPetSecretBookPanel;
      
      private static var webURL:String = "pay.51mole.com.tw";
      
      private var bookPanel:MovieClip;
      
      public function superPetLogin()
      {
         super();
      }
      
      public static function gotoPay() : void
      {
         var vip:VipSessionReq = new VipSessionReq();
         GV.onlineSocket.addEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,getSession);
         vip.sendReq();
      }
      
      private static function getSession(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,getSession);
         var url:String = "http://pay.61.com.tw/member/login_by_sign.php?type=5&userid=" + LocalUserInfo.getUserID() + "&time=" + evt.EventObj.Time + "&sign=" + evt.EventObj.Session;
         var targetURL:URLRequest = new URLRequest(url);
         navigateToURL(targetURL,"_blank");
      }
      
      public static function openBUG() : void
      {
         var vip:VipSessionReq = new VipSessionReq();
         GV.onlineSocket.addEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,getBUG);
         vip.sendReq();
      }
      
      private static function getBUG(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,getBUG);
         var id:int = LocalUserInfo.getUserID();
         var url:String = "http://event.51mole.com.tw/question/index.php?userid=" + id + "&time=" + evt.EventObj.Time + "&sign=" + evt.EventObj.Session;
         ExternalInterface.call("CloseMessageBox",url);
      }
      
      public static function gameBuy() : void
      {
         var vip:VipSessionReq = new VipSessionReq();
         GV.onlineSocket.addEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,showGame);
         vip.sendReq();
      }
      
      private static function showGame(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,showGame);
         var url:String = "http://pay.61.com.tw/member/login_by_sign.php?type=1&userid=" + LocalUserInfo.getUserID() + "&time=" + evt.EventObj.Time + "&sign=" + evt.EventObj.Session;
         var targetURL:URLRequest = new URLRequest(url);
         navigateToURL(targetURL,"_blank");
      }
      
      public static function mapBuy() : void
      {
         var vip:VipSessionReq = new VipSessionReq();
         GV.onlineSocket.addEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,showMapGame);
         vip.sendReq();
      }
      
      private static function showMapGame(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,showMapGame);
         var url:String = "http://" + webURL + "/game_buy/buy.php?index=8&userid=" + LocalUserInfo.getUserID() + "&time=" + evt.EventObj.Time + "&sign=" + evt.EventObj.Session;
         ExternalInterface.call("CloseMessageBox",url);
      }
      
      public static function bookBuy() : void
      {
         var vip:VipSessionReq = new VipSessionReq();
         GV.onlineSocket.addEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,showbookBuyGame);
         vip.sendReq();
      }
      
      private static function showbookBuyGame(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,showbookBuyGame);
         var url:String = "http://" + webURL + "/toys/index.html?index=saler&userid=" + LocalUserInfo.getUserID() + "&time=" + evt.EventObj.Time + "&sign=" + evt.EventObj.Session;
         ExternalInterface.call("CloseMessageBox",url);
      }
      
      public static function SatetyBoxReq() : void
      {
         var vip:VipSessionReq = new VipSessionReq();
         GV.onlineSocket.addEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,showSatetyBox);
         vip.sendReq();
      }
      
      private static function showSatetyBox(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,showSatetyBox);
         var id:int = LocalUserInfo.getUserID();
         var url:String = "http://pay.61.com.tw/account/index?userid=" + id + "&time=" + evt.EventObj.Time + "&sign=" + evt.EventObj.Session;
         var targetURL:URLRequest = VL.getURLRequest(url);
         targetURL.url = url;
         navigateToURL(targetURL,"_blank");
      }
      
      public static function forgetPass() : void
      {
         var vip:VipSessionReq = new VipSessionReq();
         GV.onlineSocket.addEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,passHandler);
         vip.sendReq();
      }
      
      private static function passHandler(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,passHandler);
         var id:int = LocalUserInfo.getUserID();
         var url:String = "http://account.61.com.tw/forget?uid=" + LocalUserInfo.getUserID();
         trace("url",url);
         var targetURL:URLRequest = VL.getURLRequest(url);
         targetURL.url = url;
         navigateToURL(targetURL,"_blank");
      }
      
      public static function cardSaleAddress() : void
      {
         var vip:VipSessionReq = new VipSessionReq();
         GV.onlineSocket.addEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,showCardAddress);
         vip.sendReq();
      }
      
      private static function showCardAddress(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,showCardAddress);
         var url:String = "http://www.xthink.com.tw/member/buy_card_addr/default.html?index=saler&userid=" + LocalUserInfo.getUserID() + "&time=" + evt.EventObj.Time + "&sign=" + evt.EventObj.Session;
         ExternalInterface.call("CloseMessageBox",url);
      }
      
      public static function directDoctorURL() : void
      {
         var vip:VipSessionReq = new VipSessionReq();
         GV.onlineSocket.addEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,showDoctorURL);
         vip.sendReq();
      }
      
      private static function showDoctorURL(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,showDoctorURL);
         var url:String = "http://reg.51mole.com.tw/doctor/index.php?userid=" + LocalUserInfo.getUserID() + "&time=" + evt.EventObj.Time + "&sign=" + evt.EventObj.Session;
         ExternalInterface.call("CloseMessageBox",url);
      }
      
      public static function loadMoleDoctor() : void
      {
         var vip:VipSessionReq = new VipSessionReq();
         GV.onlineSocket.addEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,moleDoctor);
         vip.sendReq();
      }
      
      private static function moleDoctor(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,moleDoctor);
         var url:String = "http://event.51mole.com.tw/happytown/index.php?userid=" + LocalUserInfo.getUserID() + "&time=" + evt.EventObj.Time + "&sign=" + evt.EventObj.Session;
         ExternalInterface.call("CloseMessageBox",url);
      }
      
      public static function loadMoleDoctorOnly() : void
      {
         var vip:VipSessionReq = new VipSessionReq();
         GV.onlineSocket.addEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,moleDoctorOnly);
         vip.sendReq();
      }
      
      private static function moleDoctorOnly(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,moleDoctorOnly);
         var url:String = "http://event.51mole.com.tw/happytown/index.php?userid=" + LocalUserInfo.getUserID() + "&time=" + evt.EventObj.Time + "&sign=" + evt.EventObj.Session;
         ExternalInterface.call("CloseMessageBox",url);
      }
      
      public static function showMoleAmbassador() : void
      {
         GV.onlineSocket.removeEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,showMoleAmbassador);
         var url:String = "http://mole.xthink.com.tw/090108/index.aspx?userid=" + LocalUserInfo.getUserID();
         ExternalInterface.call("CloseMessageBox",url);
      }
      
      public static function gotoLoverUrl() : void
      {
         GV.onlineSocket.removeEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,gotoLoverUrl);
         var url:String = "http://mole.xthink.com.tw/090520/index.aspx?userid=" + LocalUserInfo.getUserID();
         ExternalInterface.call("CloseMessageBox",url);
      }
      
      public static function gotoHotRush() : void
      {
         var vip:VipSessionReq = new VipSessionReq();
         GV.onlineSocket.addEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,hotRush);
         vip.sendReq();
      }
      
      private static function hotRush(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,hotRush);
         var url:String = "http://event.51mole.com.tw/qa/main.php?userid=" + LocalUserInfo.getUserID() + "&time=" + evt.EventObj.Time + "&sign=" + evt.EventObj.Session;
         ExternalInterface.call("CloseMessageBox",url);
      }
      
      public static function lelePackUrl() : void
      {
         var vip:VipSessionReq = new VipSessionReq();
         GV.onlineSocket.addEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,lelePack);
         vip.sendReq();
      }
      
      private static function lelePack(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,lelePack);
         var url:String = "http://event.51mole.com.tw/card/index.php?userid=" + LocalUserInfo.getUserID() + "&time=" + evt.EventObj.Time + "&sign=" + evt.EventObj.Session;
         ExternalInterface.call("CloseMessageBox",url);
      }
      
      public static function openSLPetSecret() : void
      {
         if(Boolean(loadGame))
         {
            return;
         }
         GV.onlineSocket.addEventListener("removeMapEvent",removeEventHandler);
         GV.onlineSocket.addEventListener("removeSLBook",removeSLBookHandler);
         GV.onlineSocket.addEventListener("solveSLBook",solveSLBookSLBookHandler);
         GV.onlineSocket.addEventListener("SLBook_gotoMap",gotoMapSLBookSLBookHandler);
         loadGame = new LoadGame("resource/besmearBook/SLPetSecret.swf","正在打開超級拉姆的秘密",MainManager.getGameLevel());
      }
      
      public static function openSLPetSecret2() : void
      {
         if(Boolean(loadSLPetSecretBookPanel))
         {
            return;
         }
         GV.onlineSocket.addEventListener("removeMapEvent",removeEventHandler2);
         GV.onlineSocket.addEventListener("removeSLBook",removeSLBookHandler2);
         loadSLPetSecretBookPanel = new LoadSLPetSecretBookPanel("resource/besmearBook/SLPetSecret.swf","正在打開超級拉姆的秘密",MainManager.getGameLevel());
      }
      
      private static function removeEventHandler2(event:Event) : void
      {
         GV.onlineSocket.removeEventListener("removeSLBook",removeSLBookHandler2);
         if(Boolean(loadSLPetSecretBookPanel))
         {
            GC.stopAllMC(loadSLPetSecretBookPanel.panle2);
         }
         loadSLPetSecretBookPanel = null;
      }
      
      private static function removeSLBookHandler2(event:Event) : void
      {
         GV.onlineSocket.removeEventListener("removeSLBook",removeSLBookHandler2);
         GC.stopAllMC(loadSLPetSecretBookPanel.panle2);
         MainManager.getGameLevel().removeChild(loadSLPetSecretBookPanel.panle2);
         loadSLPetSecretBookPanel = null;
      }
      
      private static function removeEventHandler(event:Event) : void
      {
         GV.onlineSocket.removeEventListener("removeSLBook",removeSLBookHandler);
         if(Boolean(loadGame))
         {
            GC.stopAllMC(loadGame.panle);
         }
         loadGame = null;
      }
      
      private static function removeSLBookHandler(event:Event) : void
      {
         GV.onlineSocket.removeEventListener("SLBook_gotoMap",gotoMapSLBookSLBookHandler);
         GV.onlineSocket.removeEventListener("solveSLBook",solveSLBookSLBookHandler);
         GV.onlineSocket.removeEventListener("removeSLBook",removeSLBookHandler);
         GC.stopAllMC(loadGame.panle);
         MainManager.getGameLevel().removeChild(loadGame.panle);
         loadGame = null;
      }
      
      private static function solveSLBookSLBookHandler(event:Event) : void
      {
         gameBuy();
      }
      
      private static function gotoMapSLBookSLBookHandler(event:Event) : void
      {
         if(LocalUserInfo.getMapID() != 78)
         {
            GV.Room_DefaultRoomID = 0;
            LocalUserInfo.setMapID(0);
            switchMapLogic.switchMapLogicHandler(78);
         }
         GV.onlineSocket.removeEventListener("SLBook_gotoMap",gotoMapSLBookSLBookHandler);
      }
      
      public static function payBuy() : void
      {
         var vip:VipSessionReq = new VipSessionReq();
         GV.onlineSocket.addEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,showPayBuy);
         vip.sendReq();
      }
      
      private static function showPayBuy(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(VipSessionRes.GET_VIP_SESSION_SUCC,showPayBuy);
         var url:String = "http://pay.61.com/page/promotion.php?userid=" + LocalUserInfo.getUserID() + "&time=" + evt.EventObj.Time + "&sign=" + evt.EventObj.Session;
         trace(url);
         ExternalInterface.call("CloseMessageBox",url);
      }
   }
}

