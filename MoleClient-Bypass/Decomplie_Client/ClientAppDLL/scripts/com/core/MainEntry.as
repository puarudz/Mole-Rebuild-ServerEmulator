package com.core
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.info.ServerInfo;
   import com.core.info.VersionInfo;
   import com.core.loading.Loading;
   import com.core.manager.IndexManager;
   import com.core.manager.LevelManager;
   import com.core.manager.LoadingManager;
   import com.core.manager.ServerListManager;
   import com.core.manager.SocketXMLManager;
   import com.core.manager.postCardManager;
   import com.core.newloader.MCLoader;
   import com.event.MCLoadEvent;
   import com.global.staticData.XMLInfo;
   import com.mole.debug.DebugManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.system.ApplicationDomain;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import org.taomee.bean.BeanManager;
   import org.taomee.manager.TaomeeManager;
   
   public class MainEntry extends Sprite
   {
      
      private static var _loginType:uint;
      
      private static var _adByte:ByteArray;
      
      private static var _instance:MainEntry;
      
      private var _loaderMC:MCLoader;
      
      private var _serverID:uint;
      
      private var _serverArr:Array;
      
      private var _socketPort:int;
      
      private var _socketIP:String;
      
      private var _userID:int;
      
      private var _session:ByteArray;
      
      public var gameBg:MovieClip;
      
      public function MainEntry()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.addToStage);
         _instance = this;
      }
      
      public static function get loginType() : uint
      {
         return _loginType;
      }
      
      public static function get adByte() : ByteArray
      {
         return _adByte;
      }
      
      public static function get instance() : MainEntry
      {
         return _instance;
      }
      
      private function addToStage(evt:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.addToStage);
         TaomeeManager.stage = this.stage;
         TaomeeManager.stageSize(960,560);
      }
      
      public function setConfig(versionManager:Object, debug:Boolean = false) : void
      {
         VL.setup(versionManager,debug);
         DebugManager.DEBUG = debug;
      }
      
      public function init(serXml:XML, serNameDict:Dictionary, beanXml:XML, resApp:ApplicationDomain, ip:String, port:int, userID:int, session:ByteArray, serverID:uint, serverArrs:Array, dllBytes:ByteArray, loginType:uint, adByte:ByteArray) : void
      {
         _loginType = loginType;
         _adByte = adByte;
         LevelManager.setup(this);
         LoadingManager.setApp(resApp);
         ServerListManager.setup(serNameDict);
         BeanManager.config(beanXml);
         this._serverID = serverID;
         this._serverArr = serverArrs;
         this._socketPort = port;
         this._socketIP = ip;
         this._userID = userID;
         this._session = session;
         GV.dllArrayByte = dllBytes;
         this.initVerSion(serXml);
         GoodsInfo.parseXML(XMLInfo.SuitXmlData);
         SocketXMLManager.initXML(XMLInfo.socketXmlData);
         postCardManager.info(XMLInfo.postListXML);
         var NPC:* = getDefinitionByName("com.module.npc::NPC");
         if(Boolean(NPC))
         {
            NPC.init();
         }
         this.loadindex();
      }
      
      private function initVerSion(xml:XML) : void
      {
         ServerInfo.parseXML(xml);
         VersionInfo.parseXML(xml);
      }
      
      private function loadindex() : void
      {
         this._loaderMC = new MCLoader("resource/ui/index.swf",this,Loading.MAIN_LOAD,"加載摩爾莊園......",false);
         this._loaderMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadOverRootMC);
         this._loaderMC.addEventListener(MCLoadEvent.ERROR,this.loadFailRootMC);
         this._loaderMC.doLoad();
      }
      
      private function loadOverRootMC(event:MCLoadEvent) : void
      {
         var app:ApplicationDomain = event.getLoader().contentLoaderInfo.applicationDomain;
         IndexManager.getInstance().setIndexApp2(app);
         this._loaderMC.removeEventListener(MCLoadEvent.ON_SUCCESS,this.loadOverRootMC);
         this._loaderMC.removeEventListener(MCLoadEvent.ERROR,this.loadFailRootMC);
         MainManager.setMCLoader(this._loaderMC);
         MainManager.init(this._socketIP,this._socketPort,this._userID,this._session,this._serverID,this._serverArr);
      }
      
      private function loadFailRootMC(event:MCLoadEvent) : void
      {
         this._loaderMC.removeEventListener(MCLoadEvent.ON_SUCCESS,this.loadOverRootMC);
         this._loaderMC.removeEventListener(MCLoadEvent.ERROR,this.loadFailRootMC);
         this._loaderMC.clear();
         throw new Error("index.swf加載出錯");
      }
   }
}

