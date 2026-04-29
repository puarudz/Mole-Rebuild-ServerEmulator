package com.mole.app
{
   import com.common.util.TongjiUtil;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.active.MoleKingActy;
   import com.logic.active.SendOnlineData;
   import com.logic.active.TimeTravelActy;
   import com.logic.socket.LoginLibaoSocket;
   import com.logic.task.SummerActivityCtr;
   import com.logic.task.TaskDiceCurse;
   import com.logic.task.TaskMagicSpirite;
   import com.logic.temp.RainblowCDtime;
   import com.module.acclimationSMC.AcclimationSMCManager;
   import com.module.angelFight.AngelFightMain;
   import com.module.angelPark.AngelMainControler;
   import com.module.elementKnight.ElementKnightInfoManager;
   import com.module.lamuPkSys.LamuPkMainControler;
   import com.module.magicSpirit.MagicSpiritManager;
   import com.module.magicSpirit.bag.BagMagicSpiritManager;
   import com.module.popupMsg.PopupMsgCtl;
   import com.module.superGift.thanksgivingModule;
   import com.mole.app.manager.ActivityTmpDataManager;
   import com.mole.app.manager.BoardcastPopupMsgManager;
   import com.mole.app.manager.BroadcastMessageManager;
   import com.mole.app.manager.FootPrintManager;
   import com.mole.app.manager.GameLoaderConfigManager;
   import com.mole.app.manager.GameScoreSubmitManager;
   import com.mole.app.manager.IceBabyManager;
   import com.mole.app.manager.KFCManager;
   import com.mole.app.manager.KeyboardManager;
   import com.mole.app.manager.LamuWorldManager;
   import com.mole.app.manager.LoginGiftManager;
   import com.mole.app.manager.MoleDataManager;
   import com.mole.app.manager.NPCDialogManager;
   import com.mole.app.manager.NPCInfoManager;
   import com.mole.app.manager.OnlineManager;
   import com.mole.app.manager.PigFootprintManager;
   import com.mole.app.manager.SearchSomethingManager;
   import com.mole.app.manager.SessionManager;
   import com.mole.app.manager.SuitSwapManager;
   import com.mole.app.manager.TaskSpecialManager;
   import com.mole.app.manager.TipsManager;
   import com.mole.app.manager.TransfigurationManager;
   import com.mole.app.manager.VideoSubjectManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.task.TaskManager;
   import com.mole.app.utils.PlayMovie;
   import com.mole.debug.DebugManager;
   import com.mole.manager.DialogManager;
   import com.mole.net.MoleSharedObject;
   import com.mole.net.SocketErrorConfig;
   import com.view.noticeView.noticeView;
   import flash.external.ExternalInterface;
   
   public class MainAppEntry
   {
      
      private static var _urlParams:*;
      
      public function MainAppEntry()
      {
         super();
      }
      
      public static function setup() : void
      {
         noticeView.setup(MainManager.topUI.getMovieClip("notice_mc"));
         DebugManager.setup();
         KeyboardManager.setup();
         TipsManager.setup();
         OnlineManager.setup();
         SocketErrorConfig.setup();
         PigFootprintManager.instance.Init();
         ServerUpTime.getInstance().init();
         LamuPkMainControler.Init();
         AngelMainControler.Init();
         AngelFightMain.instance.Init();
         checkOpenAngelGift();
         VideoSubjectManager.setup();
         DialogManager.setup();
         GameScoreSubmitManager.setup();
         MapManager.setup();
         NPCInfoManager.setup();
         NPCDialogManager.setup();
         LamuWorldManager.setup();
         SummerActivityCtr.inst.getStepData();
         checkInvited();
         BoardcastPopupMsgManager.setup();
         FootPrintManager.inst.init();
         LoginGiftManager.checkWeekGift();
         SessionManager.setup();
         TransfigurationManager.setup();
         ActivityTmpDataManager.setup();
         SearchSomethingManager.instance;
         ElementKnightInfoManager.getInstace().setup();
         TimeTravelActy.inst.init();
         MoleKingActy.inst.init();
         MoleDataManager.setup();
         BagMagicSpiritManager.getInstance().setup();
         SendOnlineData.inst.init();
         TaskMagicSpirite.inst.setStep();
         MagicSpiritManager.getInstance();
         AcclimationSMCManager.getInstance().initFun();
      }
      
      public static function setup1() : void
      {
         TaskManager.setup();
         TaskSpecialManager.setup();
         IceBabyManager.setup();
         PopupMsgCtl.setup();
         SuitSwapManager.setup();
         KFCManager.setup();
         GameLoaderConfigManager.setup();
         LoginLibaoSocket.getlongPackageInfo();
         BroadcastMessageManager.setup();
         var add:RainblowCDtime = RainblowCDtime.init;
         TongjiUtil.sendTongji(11,LocalUserInfo.getUserID().toString());
      }
      
      private static function onLongPackageEvent(evt:EventTaomee) : void
      {
         var movie:PlayMovie = null;
         LoginLibaoSocket.getLoginInfo();
         if(evt.EventObj.flag == 1)
         {
            movie = PlayMovie.play("resource/task/longPackageMC.swf",function():void
            {
               movie.movie_mc.name_txt.text = "　　親愛的" + GV.MyInfo_nickName + "，你已經超過1個月沒有回到莊園了。目前海妖館正在熱建中，我送你2條食人花花、2條金傲蕉、2條火龍果魚，快點去看看吧！";
            },null,function():void
            {
               movie.destroy();
               TaskDiceCurse.inst.openSystem();
            });
         }
      }
      
      private static function checkInvited() : void
      {
         var invitedIP:uint = 0;
         var molingIp:uint = 0;
         if(ExternalInterface.available)
         {
            invitedIP = uint(getWebArg("invite_uid"));
            molingIp = uint(getWebArg("moling_id"));
            if(invitedIP != 0)
            {
               if(molingIp == 0)
               {
                  GF.sendSocket(CommandID.LAXIN_NEW_PLAYER_REGISTER,invitedIP);
               }
               else if(ActivityTmpDataManager.isNewPlayer)
               {
                  GF.sendSocket(CommandID.MOLE_FAIRY_INVITATION_FRIEND,invitedIP,molingIp);
                  ExternalInterface.call("js_alert","打印出了邀請人ID" + invitedIP);
               }
            }
            ExternalInterface.call("js_alert","，沒有打印出了邀請人ID" + invitedIP);
         }
      }
      
      private static function getWebArg(name:String) : String
      {
         if(ExternalInterface.available)
         {
            if(!_urlParams)
            {
               _urlParams = ExternalInterface.call("getUrlParams");
            }
            if(Boolean(_urlParams))
            {
               return _urlParams[name];
            }
         }
         return "";
      }
      
      private static function checkOpenAngelGift() : void
      {
         var daNow:Date = null;
         var day:int = 0;
         var lastLogin:Object = null;
         if(!LocalUserInfo.isVIP() && LocalUserInfo.onceIsVIP())
         {
            daNow = ServerUpTime.getInstance().date;
            day = daNow.day;
            day = day == 0 ? 7 : day;
            lastLogin = MoleSharedObject.moleObj.lastLogin;
            if(lastLogin == null || day < lastLogin.day || day >= lastLogin.day && daNow.time - lastLogin.time >= 7 * 24 * 60 * 60 * 1000)
            {
               thanksgivingModule.getInstance().openWindowsFun();
               lastLogin = new Object();
               lastLogin.day = day;
               lastLogin.time = daNow.time;
               MoleSharedObject.moleObj.lastLogin = lastLogin;
               MoleSharedObject.flush();
            }
         }
      }
   }
}

