package com.module.acclimationSMC
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.logic.socket.myProfession.MyProfessionReq;
   import com.logic.socket.myProfession.MyProfessionRes;
   import com.module.acclimationSMC.bag.AcclimationSMC_accBag;
   import com.module.acclimationSMC.data.AcclimationSMC_ItemInfo;
   import com.module.acclimationSMC.data.AcclimationSMC_UserInfo;
   import com.module.acclimationSMC.socket.AcclimationSMC_SocketInfo;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.module.AppModuleControl;
   import com.mole.app.task.TaskManager;
   import com.mole.app.task.type.TaskStateType;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class AcclimationSMCManager extends EventDispatcher
   {
      
      private static var strategyXML:XML;
      
      private static var composeXML:XML;
      
      private static var guideXML:XML;
      
      private static var swapXML:XML;
      
      private static var docileXML:XML;
      
      private static var _mainPanel_userInfo:AcclimationSMC_UserInfo;
      
      private static var _mainPanel_workInfo:Array;
      
      private static var _inst:AcclimationSMCManager;
      
      public static var CLOSE_MAINPANEL:String = "close_mainPanel";
      
      public static var CLOSE_CHARTPANEL:String = "close_chartPanel";
      
      public static var INIT_ACC_BAG:String = "init_acclimation_bag";
      
      public static var BAG_CLICK_CHART:String = "bag_clickone_setchart";
      
      public static var REF_WORKING_INFO:String = "main_ref_working";
      
      private static var _levelMsg:Array = ["","初級","中級","高級","特級","精英","至尊"];
      
      public static var MainPanel_ref_workInfo:Boolean = false;
      
      public static var _stockadeIP:int = -1;
      
      public var ISAcclimation:Boolean = false;
      
      private var _userInfo:AcclimationSMC_UserInfo;
      
      private var _accBag:AcclimationSMC_accBag;
      
      public function AcclimationSMCManager()
      {
         super();
      }
      
      public static function openMainPanel(userid:uint = 0) : void
      {
         if(TaskManager.getTaskState(1404) != TaskStateType.FINISH)
         {
            if(TaskManager.getTaskState(1403) != TaskStateType.FINISH)
            {
               ModuleManager.openPanel("SMCPanel");
            }
            else
            {
               TaskManager.checkEnterMap(80);
            }
            return;
         }
         if(userid == 0)
         {
            userid = uint(LocalUserInfo.getUserID());
         }
         getInstance().removeEventListener(CLOSE_CHARTPANEL,closeChartFun);
         getInstance().removeEventListener(CLOSE_MAINPANEL,closeFun);
         getInstance().addEventListener(CLOSE_CHARTPANEL,closeChartFun);
         getInstance().addEventListener(CLOSE_MAINPANEL,closeFun);
         var app:AppModuleControl = ModuleManager.openPanel("AcclimationSMC_MainPanel",{
            "moduleID":userid,
            "unClose":1
         });
         app.removeCloseEvent();
      }
      
      protected static function closeFun(e:Event) : void
      {
         getInstance().removeEventListener(CLOSE_CHARTPANEL,closeChartFun);
         getInstance().removeEventListener(CLOSE_MAINPANEL,closeFun);
         ModuleManager.closePanel("AcclimationSMC_MainPanel");
      }
      
      protected static function closeChartFun(e:Event) : void
      {
         ModuleManager.closePanel("AcclimationSMC_ChartPanel");
      }
      
      public static function openRaidersPanel(ID:int = -1) : void
      {
         ModuleManager.openPanel("AcclimationSMC_RaidersPanel",{"itemID":ID});
      }
      
      public static function getIconURLByID(id:uint) : String
      {
         var url:String = "resource/acclimationSMC/icon/" + id + ".swf";
         return url;
      }
      
      public static function getIconBGURLByID(id:uint) : String
      {
         var url:String = "resource/acclimationSMC/iconBg/" + id + ".swf";
         return url;
      }
      
      public static function get MainPanelUserInfo() : AcclimationSMC_UserInfo
      {
         return _mainPanel_userInfo;
      }
      
      public static function set MainPanelUserInfo(info:AcclimationSMC_UserInfo) : void
      {
         _mainPanel_userInfo = info;
      }
      
      public static function get MainPanel_workInfo() : Array
      {
         return _mainPanel_workInfo;
      }
      
      public static function set MainPanel_workInfo(info:Array) : void
      {
         _mainPanel_workInfo = info;
         MainPanel_ref_workInfo = false;
      }
      
      public static function makeItemInfo(id:uint = 0, count:uint = 0, inBag:uint = 0) : AcclimationSMC_ItemInfo
      {
         var obj:Object = GoodsInfo.getInfoById(id);
         var info:AcclimationSMC_ItemInfo = new AcclimationSMC_ItemInfo();
         info.id = id;
         info.source = getOneGuide(id).@source;
         info.count = count;
         info.isExp = inBag;
         info.name = obj.name;
         info.exp = obj.exp;
         info.mount = obj.mount;
         info.sell = obj.SellPrice;
         info.time = obj.time * 60;
         info.type = obj.type;
         info.value = obj.value;
         info.valueMsg = _levelMsg[obj.value];
         info.iconURL = AcclimationSMCManager.getIconURLByID(id);
         info.iconBgURL = AcclimationSMCManager.getIconBGURLByID(info.mount);
         return info;
      }
      
      public static function getOneGuide(id:uint = 0) : XML
      {
         var _gxml:XML = null;
         if(guideXML == null)
         {
            guideXML = XML(new XMLInfo.mole_beast_guide());
         }
         _gxml = XML(guideXML.Item.(@id == id));
         return _gxml;
      }
      
      public static function getOneCompose(id:uint = 0) : XML
      {
         var _gxml:XML = null;
         if(composeXML == null)
         {
            composeXML = XML(new XMLInfo.mole_beast_mount_compose());
         }
         _gxml = XML(composeXML.Item.(@id == id));
         return _gxml;
      }
      
      public static function getOneStrategy(id:uint = 0) : XML
      {
         var _gxml:XML = null;
         if(strategyXML == null)
         {
            strategyXML = XML(new XMLInfo.mole_beast_strategy());
         }
         _gxml = XML(strategyXML.beast.(@id == id));
         return _gxml;
      }
      
      public static function getOneSwap(id:uint = 0) : XML
      {
         var _gxml:XML = null;
         if(swapXML == null)
         {
            swapXML = XML(new XMLInfo.mole_beast_swap());
         }
         _gxml = XML(swapXML.Item.(@id == id));
         return _gxml;
      }
      
      public static function getOneDocile(id:uint = 0) : XML
      {
         var _gxml:XML = null;
         if(docileXML == null)
         {
            docileXML = XML(new XMLInfo.mole_beast_docile());
         }
         _gxml = XML(docileXML.beast.(@id == id));
         return _gxml;
      }
      
      public static function getIsWorking(info:AcclimationSMC_ItemInfo) : uint
      {
         var bln:uint = 0;
         if(info.training_time == 0)
         {
            return 0;
         }
         var server:Number = ServerUpTime.getInstance().date.time;
         var lg:int = int(server / 1000) + 5 - info.training_time;
         if(lg > 0 && lg < info.time)
         {
            bln = 1;
         }
         else if(lg >= info.time)
         {
            bln = 2;
         }
         return bln;
      }
      
      public static function showFullAlert(str:String = "保險") : void
      {
         Alert.angryAlart("你的馴化獸" + str + "背包已滿，請清理後再來兌換吧！");
      }
      
      public static function getInstance() : AcclimationSMCManager
      {
         if(_inst == null)
         {
            _inst = new AcclimationSMCManager();
         }
         return _inst;
      }
      
      public function initFun() : void
      {
         GV.onlineSocket.addEventListener(MyProfessionRes.GET_MY_PROFESSION,this.getMyProfession1);
         MyProfessionReq.req(LocalUserInfo.getUserID());
      }
      
      public function getMyProfession1(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(MyProfessionRes.GET_MY_PROFESSION,this.getMyProfession1);
         var Arr:Array = e.EventObj.arr;
         if(Arr[14] == 0)
         {
            this.ISAcclimation = false;
         }
         else
         {
            this.ISAcclimation = true;
         }
         if(this.ISAcclimation == true)
         {
            AcclimationSMC_SocketInfo.getInstance().addEventListener(AcclimationSMC_SocketInfo.GETUSERINFO,this.backUserInfo);
            AcclimationSMC_SocketInfo.getInstance().getUserInfo(LocalUserInfo.getUserID());
         }
      }
      
      private function backUserInfo(e:EventTaomee) : void
      {
         AcclimationSMC_SocketInfo.getInstance().removeEventListener(AcclimationSMC_SocketInfo.GETUSERINFO,this.backUserInfo);
         var info:AcclimationSMC_UserInfo = e.EventObj as AcclimationSMC_UserInfo;
         this.userInfo = info;
      }
      
      public function set userInfo(info:AcclimationSMC_UserInfo) : void
      {
         this._userInfo = info;
         this._userInfo.nick = LocalUserInfo.getNickName();
         this._userInfo.color = LocalUserInfo.getFamily();
         if(LocalUserInfo.isVIP())
         {
            this._userInfo.friend_size = 2;
         }
      }
      
      public function get userInfo() : AcclimationSMC_UserInfo
      {
         return this._userInfo;
      }
      
      public function get friendArr() : Array
      {
         var obj:Object = null;
         var arr:Array = [];
         var selfarr:Array = this.userInfo.friendArr;
         for(var i:uint = 0; i < selfarr.length; i++)
         {
            obj = selfarr[i];
            if(obj != null)
            {
               arr.push(obj);
            }
         }
         return arr;
      }
      
      public function set accBag(info:AcclimationSMC_accBag) : void
      {
         this._accBag = info;
      }
      
      public function get accBag() : AcclimationSMC_accBag
      {
         return this._accBag;
      }
      
      public function chartFunBag(type:uint = 0) : int
      {
         if(this.accBag == null)
         {
            return -1;
         }
         var flag:int = -1;
         if(type == 0)
         {
            if(this.accBag.InBag_size < getInstance().userInfo.bagsize)
            {
               flag = 0;
            }
            else
            {
               flag = 1;
            }
         }
         else if(this.accBag.ExpBag_size < getInstance().userInfo.exchg_bagsize)
         {
            flag = 0;
         }
         else
         {
            flag = 1;
         }
         return flag;
      }
      
      public function getAccUserLevel() : uint
      {
         var level:uint = 0;
         if(this.ISAcclimation == false)
         {
            return 0;
         }
         if(Boolean(this._userInfo))
         {
            level = this._userInfo.level;
         }
         return level;
      }
      
      public function destroy() : void
      {
         BC.removeEvent(this);
      }
   }
}

