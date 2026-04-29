package com.core
{
   import com.common.data.UILibrary;
   import com.common.msgHead.MsgHead;
   import com.common.util.TongjiUtil;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.gameSimulator.SEI;
   import com.core.info.LocalUserInfo;
   import com.core.login.LoginShared;
   import com.core.manager.LevelManager;
   import com.core.manager.UIManager;
   import com.core.newloader.MCLoader;
   import com.core.objectPool.ObjectPool;
   import com.event.MCLoadEvent;
   import com.global.staticData.CommandID;
   import com.mole.net.MoleSharedObject;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.net.SharedObject;
   import flash.system.ApplicationDomain;
   import flash.system.System;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import org.taomee.bean.BeanEvent;
   import org.taomee.bean.BeanManager;
   
   public class MainManager
   {
      
      private static var gcTimer:Timer;
      
      private static var mcloader:MCLoader;
      
      private static var _topUILibrary:UILibrary;
      
      private static const UI_PATH:String = "resource/ui/ui.swf";
      
      private static var _isBeaned:Boolean = false;
      
      public function MainManager()
      {
         super();
      }
      
      public static function setMCLoader(i:MCLoader) : void
      {
         mcloader = i;
      }
      
      public static function getMCLoader() : MCLoader
      {
         return mcloader;
      }
      
      public static function init(ip:String, port:int, userID:int, Session:ByteArray, serverID:uint, serverArrs:Array) : void
      {
         GV.GF = GF;
         var moveTo:* = getDefinitionByName("com.logic.FindPathLogic.MoveTo");
         GV.MoveTo_Class = moveTo;
         ER.ID = userID;
         ER.Email = "";
         ER.isLogin = 1;
         ER.serverName = serverArrs[serverID];
         GV.serverID = serverID;
         GV.serverArrs = serverArrs;
         gcTimer = new Timer(1000 * 1800,0);
         gcTimer.addEventListener(TimerEvent.TIMER,timerEventGC);
         gcTimer.start();
         MsgHead.UserID = userID;
         MsgHead.Session = Session;
         MsgHead.SessionLen = Session.length;
         loadUserInfo(ip,port);
      }
      
      private static function loadUserInfo(ip:String, port:int) : void
      {
         var userInfo:LocalUserInfo = new LocalUserInfo(ip,port);
         userInfo.addEventListener(LocalUserInfo.USERINFO_OVER,onGetUserInfo);
         userInfo.connectSocket();
         trace("----------------------------------流程00000：獲取個人資料");
      }
      
      private static function onGetUserInfo(event:Event) : void
      {
         trace("----------------------------------流程1：獲取個人資料完成\n\n\n 開始加載UI");
         mcloader.getLoadingStyle().setTitle("正在進入摩爾莊園......");
         mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,onLoadUI);
         mcloader.addEventListener(MCLoadEvent.ERROR,failLoadUI);
         mcloader.load(VL.getURLRequest(UI_PATH));
         var loginObj:Object = LoginShared.getUser(LocalUserInfo.getUserID());
         loginObj.nick = LocalUserInfo.getNickName();
         loginObj.Family = LocalUserInfo.getFamily();
         loginObj.roleType = LocalUserInfo.roleType;
         if(Boolean(loginObj.userCode))
         {
            LocalUserInfo.setUserCode(loginObj.userCode);
         }
         LoginShared.addUser(loginObj);
         GF.sendSocket(CommandID.CLI_PROTO_INIT_PLAYER_EX);
      }
      
      public static function get topUI() : UILibrary
      {
         return _topUILibrary;
      }
      
      private static function onLoadUI(event:MCLoadEvent) : void
      {
         var loader:Loader;
         var app:ApplicationDomain;
         var resID:uint;
         mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,onLoadUI);
         mcloader.removeEventListener(MCLoadEvent.ERROR,failLoadUI);
         loader = event.getLoader();
         app = loader.contentLoaderInfo.applicationDomain;
         UIManager.setApp(app);
         resID = DownLoadManager.add("resource/ui/topUI.swf",ResType.DISPLAY_OBJECT,true);
         DownLoadManager.addEvent(resID,function(e:DownLoadEvent):void
         {
            _topUILibrary = new UILibrary(e.loader.contentLoaderInfo.applicationDomain);
            var cls:Class = getDefinitionByName("com.view.PeopleView.BoneInfo") as Class;
            cls["Init"]();
            cls["popBoneInfo"]();
            GV.MAN_PEOPLE = new MovieClip();
            initMapManageView();
         });
      }
      
      private static function failLoadUI(event:MCLoadEvent) : void
      {
         mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,onLoadUI);
         mcloader.removeEventListener(MCLoadEvent.ERROR,failLoadUI);
         throw new Error("UI資源加載錯誤");
      }
      
      private static function initMapManageView() : void
      {
         trace("----------------------------------流程2：UI加載完成,初始化地圖管理類");
         var cls:Class = getDefinitionByName("com.view.MapManageView.MapManageView") as Class;
         var MapManageMC:* = new cls();
         GV.map_ManagerChange = MapManageMC;
         MapManageMC.defaultMap(mcloader);
         MapManageMC.addEventListener(Event.INIT,onMapInitComplete);
         var MainAppEntry:Object = getDefinitionByName("com.mole.app.MainAppEntry");
         MainAppEntry.setup();
      }
      
      private static function onMapInitComplete(event:Event) : void
      {
         var MainAppEntry:Object = null;
         var mapControlLogic:* = undefined;
         TongjiUtil.sendTongji(10,LocalUserInfo.getUserID().toString());
         if(!_isBeaned)
         {
            initBean();
            _isBeaned = true;
            MainAppEntry = getDefinitionByName("com.mole.app.MainAppEntry");
            MainAppEntry.setup1();
         }
         else
         {
            mapControlLogic = BeanManager.getBeanInstance("MapControlLogic");
            mapControlLogic.init();
         }
      }
      
      private static function initBean() : void
      {
         BeanManager.addEventListener(BeanEvent.COMPLETE,onBeanComplete);
         BeanManager.start("1");
         trace("----------------------------------全部完成，執行BEAN控制");
      }
      
      private static function onBeanComplete(event:BeanEvent) : void
      {
         BeanManager.removeEventListener(BeanEvent.COMPLETE,onBeanComplete);
         GV.JobViews = BeanManager.getBeanInstance("JobView");
         GV.JobLogics = BeanManager.getBeanInstance("JobLogic");
         SEI.getSEI().setRoot(getRootMC());
      }
      
      private static function timerEventGC(evt:TimerEvent) : void
      {
         var Memort_mb:int = System.totalMemory / 1000 / 1000;
         if(Memort_mb > 100)
         {
            ObjectPool.clearObjectPool();
         }
      }
      
      public static function getGlobalObject() : SharedObject
      {
         return MoleSharedObject.moleSO;
      }
      
      public static function getStage() : Stage
      {
         return LevelManager.stage;
      }
      
      public static function getStageWidth() : int
      {
         return LevelManager.WIDTH;
      }
      
      public static function getStageHeight() : int
      {
         return LevelManager.HEIGHT;
      }
      
      public static function getRootMC() : Sprite
      {
         return LevelManager.root;
      }
      
      public static function getGameLevel() : Sprite
      {
         return LevelManager.gameLevel;
      }
      
      public static function getAlertLevel() : Sprite
      {
         return LevelManager.alertLevel;
      }
      
      public static function getTopLevel() : Sprite
      {
         return LevelManager.topLevel;
      }
      
      public static function getAppLevel() : Sprite
      {
         return LevelManager.appLevel;
      }
      
      public static function getToolLevel() : Sprite
      {
         return LevelManager.toolLevel;
      }
      
      public static function getBaseLevel() : Sprite
      {
         return LevelManager.mapLevel;
      }
      
      public static function centerObj(obj:DisplayObject, owner:DisplayObject = null) : void
      {
         if(Boolean(owner))
         {
            obj.x = owner.x + (owner.width - obj.width) / 2;
            obj.y = owner.y + (owner.height - obj.height) / 2;
         }
         else
         {
            obj.x = (getStageWidth() - obj.width) / 2;
            obj.y = (getStageHeight() - obj.height) / 2;
         }
      }
      
      public static function get debugLevel() : Sprite
      {
         return LevelManager.debugLevel;
      }
      
      public static function get tipLevel() : Sprite
      {
         return LevelManager.tipLevel;
      }
      
      public static function getIsMember() : Boolean
      {
         return true;
      }
   }
}

