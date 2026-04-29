package com.view.noticeView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.common.util.DisplayUtil;
   import com.common.util.MovieClipUtil;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.info.MapInfo;
   import com.core.manager.LevelManager;
   import com.core.manager.UIManager;
   import com.core.socketlogic.ClientOnLineSerSocket;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.global.staticData.ModuleNameManager;
   import com.logic.mapEvent.MapEvent;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.addBlackList.AddBlackListReq;
   import com.logic.socket.addBlackList.AddBlackListRes;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.logic.socket.postCard.getOnlyNumReq;
   import com.logic.socket.postCard.getOnlyNumRes;
   import com.logic.socket.responsetAddFrend.ResAddFrendReq;
   import com.logic.socket.textNotice.TextNoticeRes;
   import com.module.LocusWork.NumSprite;
   import com.module.friendList.friendView.BView;
   import com.module.friendList.friendView.FView;
   import com.module.friendList.friendView.GView;
   import com.module.hulupuModule.HistoryView;
   import com.module.myselfTalk.selfTalk;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.NewStatisticsManager;
   import com.mole.app.manager.OnlineManager;
   import com.mole.app.manager.SimpleIntrPanelManager;
   import com.mole.app.manager.StatisticsManager;
   import com.mole.app.manager.SystemTimeController;
   import com.mole.app.manager.TaskSpecialManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.module.AppModuleControl;
   import com.mole.app.module.ModuleEvent;
   import com.mole.app.task.TaskManager;
   import com.mole.app.type.ModuleType;
   import com.taomee.mole.library.utils.TimeFormat;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.activity.Task83.StatisticsClass;
   import com.view.userPanelView.userPanelView;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class noticeView extends MovieClip
   {
      
      private static var _owner:noticeView;
      
      private var onlineTime:uint = 0;
      
      private var postcardLogics:postcardLogic;
      
      private var talkUI:selfTalk;
      
      private var _toolUI:MovieClip;
      
      private var mymsg:msgView;
      
      private var myeve:eveView;
      
      private var myISblack:Boolean = false;
      
      private var blackList:Array;
      
      private var newBlackID:uint = 0;
      
      private var _news_btn:SimpleButton;
      
      private var _mail_mc:MovieClip;
      
      private var _mailCount:NumSprite;
      
      private var _msg_mc:MovieClip;
      
      private var _task_btn:SimpleButton;
      
      private var _smc_btn:SimpleButton;
      
      private var _game_btn:SimpleButton;
      
      private var _gift_btn:SimpleButton;
      
      private var _vip_btn:SimpleButton;
      
      private var _activity_btn:SimpleButton;
      
      private var _onLinePresent_mc:MovieClip;
      
      private var _clothes_btn:SimpleButton;
      
      private var _dragon_btn:SimpleButton;
      
      private var _weenPanel_btn:SimpleButton;
      
      private var _mole_travel:SimpleButton;
      
      private var _weenLight_mc:MovieClip;
      
      private var _goldBean_btn:SimpleButton;
      
      private var _theHelp_btn:SimpleButton;
      
      private var _goSchool:SimpleButton;
      
      private var _luckFollow:SimpleButton;
      
      private var _warOfWarrior:SimpleButton;
      
      private var _afuhao:SimpleButton;
      
      private var _lanternBtn:SimpleButton;
      
      private var _my2014:SimpleButton;
      
      private var _school:SimpleButton;
      
      private var _btnYear:SimpleButton;
      
      private var _cherryBlossom:SimpleButton;
      
      private var _childFestival:SimpleButton;
      
      private var _newEgg:SimpleButton;
      
      private var _newUrl:SimpleButton;
      
      private var _wadidongBtn:SimpleButton;
      
      private var _yuzhuBtn:SimpleButton;
      
      private var _heiyirenbtn:SimpleButton;
      
      private var _weenClickTimes:uint;
      
      private var _timeGapVec:Vector.<uint>;
      
      private var _prizeTypeVec:Vector.<uint>;
      
      private var _dayTypeVec:Vector.<uint>;
      
      private var _stateVec:Vector.<uint>;
      
      private var _roop:uint;
      
      private var _presentIndex:uint;
      
      private var _timeStr:String;
      
      private var _reverTime:Number;
      
      private var _presentArr:Array;
      
      private var _extendEventMC:MovieClip = null;
      
      public function noticeView(target:MovieClip)
      {
         var a:uint = 0;
         var open:Function = null;
         this._timeGapVec = new <uint>[60,300,1800,3600,5400];
         this._prizeTypeVec = new <uint>[61,62,63,64,65];
         this._dayTypeVec = new <uint>[31001,31002,31003,31004,31005];
         super();
         open = function():void
         {
            clearTimeout(a);
            if(SystemTimeController.instance.checkSysTimeAchieve(3561))
            {
               _toolUI["chongbangdeegg"].addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void
               {
                  ModuleManager.openPanel("ChongBangDaRenPanel");
               });
            }
            else
            {
               _toolUI["chongbangdeegg"].visible = false;
            }
         };
         this._toolUI = target;
         this._toolUI.scrollRect = new Rectangle(0,0,960,560);
         this._heiyirenbtn = this._toolUI["heiyirenbtn"];
         this._wadidongBtn = this._toolUI["wadidongBtn"];
         this._news_btn = this._toolUI["news_btn"];
         this._mail_mc = this._toolUI["mail_mc"];
         this._mail_mc.count_mc.visible = false;
         this._mailCount = new NumSprite(this._mail_mc.count_mc,0,false);
         this._yuzhuBtn = this._toolUI["yuzhuBtn"];
         this._game_btn = this._toolUI["game_btn"];
         this._gift_btn = this._toolUI["mapName_mc"]["gift_btn"];
         this._gift_btn.visible = false;
         this._onLinePresent_mc = this._toolUI["mapName_mc"]["onLinePresent_mc"];
         tip.tipTailDisPlayObject(this._onLinePresent_mc,"在線禮包");
         this._msg_mc = this._toolUI["msg_mc"];
         this._msg_mc.buttonMode = true;
         this._task_btn = this._toolUI["job_btn"];
         this._smc_btn = this._toolUI["SMC_btn"];
         this._vip_btn = this._toolUI["vip_btn"];
         this._activity_btn = this._toolUI["activity_btn"];
         this._clothes_btn = this._toolUI["clothes_btn"];
         this._weenPanel_btn = this._toolUI["weenPanel_btn"];
         this._weenLight_mc = this._toolUI["weenLight_mc"];
         this._goldBean_btn = this._toolUI["goldBeanBtn"];
         this._theHelp_btn = this._toolUI["theHelp_btn"];
         this._warOfWarrior = this._toolUI["warOfWarrior"];
         this._afuhao = this._toolUI["afuhao"];
         this._my2014 = this._toolUI["my2014"];
         this._cherryBlossom = this._toolUI["cherryBtn"];
         this._newUrl = this._toolUI["newUrl"];
         this._childFestival = this._toolUI["childFestival"];
         this._lanternBtn = this._toolUI["lanternBtn"];
         this._school = this._toolUI["schoolBtn"];
         this._btnYear = this._toolUI["btnYear"];
         this._clothes_btn.visible = false;
         this._heiyirenbtn.addEventListener(MouseEvent.CLICK,this.OnHandleHeiYiRen);
         this._yuzhuBtn.addEventListener(MouseEvent.CLICK,this.OnHandleYuzhu);
         this._wadidongBtn.addEventListener(MouseEvent.CLICK,this.OpenSearchRoad);
         this._smc_btn.addEventListener(MouseEvent.CLICK,this.onOpenSMC);
         this._task_btn.addEventListener(MouseEvent.CLICK,this.onOpenTaskUI);
         this._news_btn.addEventListener(MouseEvent.CLICK,this.onOpenNews);
         this._msg_mc.addEventListener(MouseEvent.CLICK,this.onOpenMsg);
         this._toolUI.eve_btn.addEventListener(MouseEvent.CLICK,this.showLastEvent);
         this._goldBean_btn.addEventListener(MouseEvent.CLICK,this.goldBeanHandle);
         this._game_btn.addEventListener(MouseEvent.CLICK,this.onOpenGamePanel);
         this._vip_btn.addEventListener(MouseEvent.CLICK,this.onOpenVip);
         this._activity_btn.addEventListener(MouseEvent.CLICK,this.onOpenActivity);
         this._clothes_btn.addEventListener(MouseEvent.CLICK,this.onOpenCloakTaskGuidePanel);
         this._theHelp_btn.addEventListener(MouseEvent.CLICK,this.onClickHelp);
         this._warOfWarrior.addEventListener(MouseEvent.CLICK,this.onClickWarOfWarrior);
         this._afuhao.addEventListener(MouseEvent.CLICK,this.onClickafuhao);
         this._my2014.addEventListener(MouseEvent.CLICK,this.onMy2014);
         this._school.addEventListener(MouseEvent.CLICK,this.onClickSchool);
         this._btnYear.addEventListener(MouseEvent.CLICK,this.onYear);
         this._lanternBtn.addEventListener(MouseEvent.CLICK,this.onLaunter);
         this._cherryBlossom.addEventListener(MouseEvent.CLICK,this.onClickCherry);
         this._childFestival.addEventListener(MouseEvent.CLICK,this.onClickChild);
         a = setTimeout(open,1000);
         this.init();
         GV.onlineSocket.addEventListener(MapEvent.CHANGE_MAP_COMPLETE,this.onLoadClothMovie);
         OnlineManager.addCmdListener(CommandID.FINISH_SOMETHING,this.dayTypeHandle);
         finishSomethingReq.sendReq(31726);
      }
      
      public static function setup(ui:MovieClip) : void
      {
         ui.name = "notice_mc";
         _owner = new noticeView(ui);
         LevelManager.toolLevel.addChild(ui);
      }
      
      public static function get owner() : noticeView
      {
         return _owner;
      }
      
      public function GetUI() : MovieClip
      {
         return this._toolUI;
      }
      
      private function OnHandleYuzhu(e:MouseEvent) : void
      {
         ModuleManager.openPanel("YearNewSpecialBagPanel");
      }
      
      private function onClickBlackWhite(event:MouseEvent) : void
      {
         MapManager.enterMap(68);
      }
      
      private function onMy2014(event:MouseEvent) : void
      {
         ModuleManager.openPanel("my2014Panel");
      }
      
      private function onClickChild(e:MouseEvent) : *
      {
         navigateToURL(new URLRequest("http://w.61.com.tw/action/repeater2.aspx?num=4920&url=http://event.61.com.tw/taomee_event/event-center/201504_kids/activity/"),"_blank");
      }
      
      private function onClickCherry(event:MouseEvent) : void
      {
         ModuleManager.openPanel("CherryBlossomFestivalPanel");
         ModuleManager.openPanel("YearNewSpecialBagPanel");
      }
      
      private function OnHandleHeiYiRen(event:MouseEvent) : *
      {
         ModuleManager.openPanel("FightingVsDevil");
      }
      
      private function OpenSearchRoad(event:MouseEvent) : void
      {
         ModuleManager.openPanel("DailyRollPanel");
      }
      
      private function onClickEgg(event:MouseEvent) : void
      {
         var s:String = "http://w.61.com.tw/action/repeater2.aspx?num=5049&url=http://www.oocircle.com/event_03/transfer";
         navigateToURL(new URLRequest(s),"_blank");
      }
      
      private function onUrlGo(event:MouseEvent) : void
      {
         var s:String = "http://w.61.com.tw/action/repeater2.aspx?num=5160&url=http://event.61.com.tw/taomee_event/event-center/201505_charity/";
         navigateToURL(new URLRequest(s),"_blank");
      }
      
      private function onLaunter(event:MouseEvent) : void
      {
         MapManager.enterMap(38);
      }
      
      private function onClickSchool(event:MouseEvent) : void
      {
         ModuleManager.openPanel("OnlineGiftsPanel");
      }
      
      private function onYear(event:MouseEvent) : void
      {
         var s:String = "http://event.61.com.tw/taomee_event/201502_mole/?mode=list&choice_type=dress";
         navigateToURL(new URLRequest(s),"_blank");
      }
      
      private function onClickafuhao(event:MouseEvent) : void
      {
         MapManager.enterMap(37);
      }
      
      private function onClickyangzhishengyi(event:MouseEvent) : void
      {
         ModuleManager.openPanel("SheepClothPanel");
      }
      
      protected function onClickWarOfWarrior(event:MouseEvent) : void
      {
         ModuleManager.openPanel("AbbeyMemoirsPanel");
      }
      
      protected function onEnglishCompetition(evt:MouseEvent) : void
      {
         ModuleManager.openPanel("MoleNewStartPanel");
      }
      
      protected function onClickHelp(event:MouseEvent) : void
      {
         ModuleManager.openPanel("LittleHelperPanel");
      }
      
      private function goldBeanHandle(e:MouseEvent) : void
      {
         ModuleManager.openPanel(ModuleType.GOLDEN_BEAN_REWARD);
      }
      
      private function onClickMoling(e:MouseEvent) : void
      {
         ModuleManager.openPanel("MagicSpiritLegenPanel");
      }
      
      public function dayTypeHandle(e:*) : void
      {
         OnlineManager.removeCmdListener(CommandID.FINISH_SOMETHING,this.dayTypeHandle);
         var somethingPro:finishSomethingRes = e.bodyInfo;
         if(somethingPro.Type == 31726)
         {
            if(Boolean(somethingPro.Done))
            {
               this._weenClickTimes = 1;
               this._weenLight_mc.visible = false;
               DisplayUtil.removeForParent(this._weenLight_mc);
            }
            else
            {
               this._weenClickTimes = 0;
               this._weenLight_mc.visible = true;
            }
         }
      }
      
      private function onLoadClothMovie(e:*) : void
      {
         GV.onlineSocket.removeEventListener(MapEvent.CHANGE_MAP_COMPLETE,this.onLoadClothMovie);
         this._stateVec = new Vector.<uint>(5,true);
         this._roop = 0;
         setTimeout(function():void
         {
            checkState(_roop);
         },3000);
      }
      
      private function checkState(index:uint) : void
      {
         OnlineManager.addCmdListener(CommandID.FINISH_SOMETHING,this.dayTypeHandlehaha);
         finishSomethingReq.sendReq(this._dayTypeVec[index]);
      }
      
      public function dayTypeHandlehaha(e:*) : void
      {
         var m:uint = 0;
         var i:uint = 0;
         OnlineManager.removeCmdListener(CommandID.FINISH_SOMETHING,this.dayTypeHandlehaha);
         var somethingPro:finishSomethingRes = e.bodyInfo;
         if(somethingPro.Type == this._dayTypeVec[this._roop])
         {
            if(Boolean(somethingPro.Done))
            {
               this._stateVec[this._roop] = somethingPro.Done;
            }
            else
            {
               this._stateVec[this._roop] = 0;
            }
         }
         if(this._roop < this._timeGapVec.length - 1)
         {
            ++this._roop;
            this.checkState(this._roop);
         }
         else
         {
            trace("_stateVec" + this._stateVec);
            for(i = 0; i < this._stateVec.length; i++)
            {
               if(this._stateVec[i] > 0)
               {
                  m++;
               }
            }
            if(m >= 5)
            {
               this._onLinePresent_mc.visible = false;
            }
            else
            {
               GV.onlineSocket.addEventListener("notice_getOnLineTimeNum",this.getOnLineTimeNum);
               this._onLinePresent_mc.mouseEnabled = true;
               this._onLinePresent_mc.mouseChildren = true;
               this._onLinePresent_mc.buttonMode = true;
               BC.removeEvent(this,this._onLinePresent_mc);
               BC.addEvent(this,this._onLinePresent_mc,MouseEvent.CLICK,this.onClickPresented);
            }
         }
      }
      
      private function getOnLineTimeNum(e:EventTaomee) : void
      {
         this.onlineTime = uint(e.EventObj.num);
         this.showTimeState();
      }
      
      private function showTimeState() : void
      {
         for(var i:uint = 0; i < this._stateVec.length; i++)
         {
            if(this._stateVec[i] == 0)
            {
               this._presentIndex = i;
               break;
            }
         }
         this._reverTime = this._timeGapVec[this._presentIndex] - this.onlineTime;
         if(this._reverTime < 0)
         {
            this._reverTime = 0;
         }
         this._timeStr = TimeFormat.getTimeStrFromSec(this._reverTime,TimeFormat.TIME_FORMAT_HHMMSS);
         if(this._onLinePresent_mc.currentFrame == 1)
         {
            this._onLinePresent_mc["time_txt"].text = this._timeStr;
         }
         if(this._reverTime == 0)
         {
            this._onLinePresent_mc.gotoAndStop(2);
         }
      }
      
      private function onClickPresented(e:Event) : void
      {
         this._presentArr = null;
         this._presentArr = new Array();
         this._onLinePresent_mc.mouseEnabled = false;
         this._onLinePresent_mc.mouseChildren = false;
         this._onLinePresent_mc.buttonMode = false;
         var curPreIndex:uint = this._presentIndex + 1;
         for(var i:uint = 0; i < curPreIndex; i++)
         {
            if(this._stateVec[i] == 0)
            {
               this._presentArr.push(this._prizeTypeVec[i]);
            }
         }
         this.getPrize(this._presentArr);
      }
      
      public function get stateVec() : Vector.<uint>
      {
         return this._stateVec;
      }
      
      private function getPrize(arr:Array) : void
      {
         ModuleManager.openPanel("OnlineAwardPanel",{"vec":this._stateVec});
      }
      
      public function resOnLineTime() : void
      {
         this._roop = this._presentIndex;
         this._onLinePresent_mc.gotoAndStop(1);
         MovieClipUtil.playAppointFrameAndFunc(this._onLinePresent_mc,1,function():void
         {
            checkState(_roop);
         });
      }
      
      private function getPrizeHandle(evt:*) : void
      {
         var itemList:Array = null;
         var itemObj:Object = null;
         var msg:String = null;
         var i:uint = 0;
         BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.getPrize);
         if(evt.EventObj.Count != 0)
         {
            itemList = evt.EventObj.arr;
            for each(itemObj in itemList)
            {
               if(itemObj.itemID == 0)
               {
                  LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + itemObj.count);
               }
            }
            msg = "    恭喜你獲得";
            for(i = 0; i < itemList.length; i++)
            {
               msg += itemList[i].count + "個" + GoodsInfo.getItemNameByID(itemList[i].itemID) + ",";
            }
            Alert.smileAlart(msg);
            this._presentArr.splice(0,1);
            this.getPrize(this._presentArr);
         }
      }
      
      private function onCloth(e:MouseEvent) : void
      {
         ModuleManager.openPanel("SLClothBoxPanel");
      }
      
      private function onOenModule(e:MouseEvent) : void
      {
         var moduleName:String = null;
         var spoName:String = null;
         var targetName:String = e.target.parent.name;
         if(targetName == "notice_mc")
         {
            targetName = e.target.name;
         }
         if(targetName.indexOf(ModuleNameManager.OPENMODULE) != -1)
         {
            moduleName = targetName.slice(11);
            ModuleManager.openPanel(moduleName);
            StatisticsManager.whenOpenModule(moduleName);
         }
         else if(targetName.indexOf(ModuleNameManager.SPO) != -1)
         {
            spoName = targetName.slice(4);
            StatisticsManager.whenOpenModule(spoName);
            SimpleIntrPanelManager.show(spoName);
         }
      }
      
      private function onDenseFrog(evt:MouseEvent) : void
      {
         ModuleManager.openPanel("WelVulcanCupUI");
      }
      
      private function socksHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.socksHandler);
      }
      
      private function onOpenTravel(evt:MouseEvent) : void
      {
         StatisticsManager.send(530);
         ModuleManager.openPanel("TaskSchedulePanel");
      }
      
      private function onOpenActivity(e:MouseEvent) : void
      {
         ModuleManager.openPanel(ModuleType.ACTIVITY_TIMING_PANEL);
      }
      
      private function onOpenVip(e:MouseEvent) : void
      {
         StatisticsManager.send(478);
         ModuleManager.openPanel("SuperLahmDemonstrate");
      }
      
      private function onOpenGamePanel(e:MouseEvent) : void
      {
         StatisticsManager.send(479);
         ModuleManager.openPanel(ModuleType.GAME_COMPILATIONS_PANEL);
      }
      
      private function onOpenCloakTaskGuidePanel(e:MouseEvent) : void
      {
         ModuleManager.openPanel(ModuleType.CLOAKTASKGUIDEPANEL);
      }
      
      public function init() : void
      {
         this.mymsg = new msgView();
         this.myeve = new eveView();
         this.talkUI = new selfTalk();
         this.postcardLogics = new postcardLogic();
         this.delBtnsM();
         this.delBtnsE();
         this.chartInfo();
         GV.onlineSocket.addEventListener("wordMapChang_over",this.wordMapChange);
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeMapFun);
         GV.onlineSocket.addEventListener("read_" + 10015,this.beAddBlack);
         GV.onlineSocket.addEventListener(TextNoticeRes.TEXT_NOTICE,this.chartMsg);
         GV.onlineClass.addEventListener(ClientOnLineSerSocket.SEND_CHATMSG,this.getTalkData);
         GV.onlineSocket.addEventListener("CMD_" + CommandID.GROUP_BREAKMYGROUP,this.getEveDel);
         GV.onlineSocket.addEventListener("CMD_" + CommandID.GROUP_HULUCHAT,this.getGData);
         GV.onlineSocket.addEventListener(AddBlackListReq.LIST_BLACK,this.NewBlack);
         GV.onlineSocket.addEventListener("return_black_friend",this.returnBlackArr);
         this.beginJobInfo();
      }
      
      public function set extendEventMC(value:MovieClip) : void
      {
         if(Boolean(this._extendEventMC))
         {
            this._extendEventMC.removeEventListener(MouseEvent.CLICK,this.showLastEvent);
         }
         this._extendEventMC = value;
         if(Boolean(this._extendEventMC))
         {
            this._extendEventMC.addEventListener(MouseEvent.CLICK,this.showLastEvent);
            this._extendEventMC.gotoAndStop(1);
         }
      }
      
      public function get emailNum() : int
      {
         return this._mailCount.value;
      }
      
      private function wordMapChange(e:Event) : void
      {
         var info:MapInfo = MapInfo.currentMapInfo();
         if(Boolean(info.isHideTopUI))
         {
            this._toolUI.visible = false;
         }
         else
         {
            this._toolUI.visible = true;
         }
         if(Boolean(info.name == "farm" || info.name == "dining" || info.name == MapInfo.MAPTYPE_CLASS || info.name == MapInfo.MAP_TYPE_ANGEL) || Boolean(info.isFightWorld) || Boolean(info.isHideTopUI))
         {
            this._toolUI.mapName_mc.visible = false;
         }
         else
         {
            this._toolUI.visible = true;
            if(Boolean(info) && Boolean(info.note))
            {
               this._toolUI.mapName_mc.map_txt.text = info.note;
               this._toolUI.mapName_mc.visible = true;
            }
            else
            {
               this._toolUI.mapName_mc.visible = false;
            }
         }
      }
      
      private function removeMapFun(e:Event) : void
      {
         this._toolUI.visible = false;
      }
      
      private function beAddBlack(e:EventTaomee) : void
      {
         var j:int = 0;
         var o:Object = e.EventObj;
         var mc:MovieClip = MainManager.getAppLevel().getChildByName("friendMC") as MovieClip;
         var userID:int = int(o.userID);
         if(MainManager.getGlobalObject().data.ServerFriendsList != null)
         {
            for(j = 0; j < MainManager.getGlobalObject().data.ServerFriendsList.length; j++)
            {
               if(MainManager.getGlobalObject().data.ServerFriendsList[j].friend == userID)
               {
                  MainManager.getGlobalObject().data.ServerFriendsList.splice(j,1);
                  MainManager.getGlobalObject().data.FriendsList.splice(j,1);
                  MainManager.getGlobalObject().flush();
                  break;
               }
            }
         }
         if(!(!mc && !GV.isChangeMap))
         {
            FView.delFriendSuccess(null);
         }
      }
      
      private function beginJobInfo(e:* = null) : void
      {
         GV.onlineSocket.addEventListener("chatBlackListOver",this.blackFunOK);
         BView.blackViewInit(1);
      }
      
      private function blackFunOK(e:*) : void
      {
         GV.onlineSocket.removeEventListener("chatBlackListOver",this.blackFunOK);
         this.myISblack = true;
         this.blackList = BView.blackList;
         GV.onlineSocket.addEventListener("read_" + 1527,this.read1527Event);
         GV.onlineSocket.addEventListener(getOnlyNumRes.ONLY_NUM,this.reNewCardsNum);
         getOnlyNumReq.Info();
      }
      
      private function read1527Event(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 1527,this.read1527Event);
         getOnlyNumReq.Info();
      }
      
      private function NewBlack(event:EventTaomee) : void
      {
         this.newBlackID = event.EventObj.id;
         GV.onlineSocket.addEventListener(AddBlackListRes.ADD_BLACK_LIST,this.makeNewBlack);
      }
      
      private function makeNewBlack(event:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(AddBlackListRes.ADD_BLACK_LIST,this.makeNewBlack);
         var getBlackObj:Object = new Object();
         getBlackObj.UserID = this.newBlackID;
         this.blackList.push(getBlackObj);
      }
      
      private function returnBlackArr(event:EventTaomee) : void
      {
         var obj:Object = null;
         var j:uint = 0;
         var ID:uint = uint(event.EventObj.id);
         var lg:uint = this.blackList.length;
         var returnArr:Array = [];
         for(var i:uint = 0; i < lg; i++)
         {
            obj = this.blackList[i];
            if(obj.UserID == ID)
            {
               returnArr.push(i);
            }
         }
         if(returnArr.length > 0)
         {
            lg = returnArr.length;
            for(j = 0; j < lg; j++)
            {
               this.blackList.splice(returnArr[j],1);
            }
         }
      }
      
      private function reNewCardsNum(event:EventTaomee = null) : void
      {
         var num:uint = uint(event.EventObj.Num);
         if(num > this.emailNum)
         {
            UIManager.getSound("MessageSound").play(0,1);
         }
         this._mailCount.value = num;
      }
      
      private function onOpenSMC(e:*) : void
      {
         if(MainManager.getGlobalObject().data.isArchitect != 3)
         {
            MainManager.getGlobalObject().data.isArchitect = 3;
            MainManager.getGlobalObject().flush();
         }
         if(TaskSpecialManager.isInit)
         {
            StatisticsManager.send(481);
            ModuleManager.openPanel(ModuleType.SMC_PANEL);
         }
         else
         {
            Alert.smileAlart("　　任務還未初始化完成，請稍等！");
         }
      }
      
      private function onOpenTaskUI(e:*) : void
      {
         if(TaskSpecialManager.isInit)
         {
            StatisticsManager.send(480);
            ModuleManager.openPanel(ModuleType.TASK_FILES_PANEL,TaskManager.getDefaultShowTaskId());
         }
         else
         {
            Alert.smileAlart("　　任務還未初始化完成，請稍等！");
         }
      }
      
      public function chartInfo() : void
      {
         var lg:int = int(GV.myInfo_noticeArr.length);
         for(var i:int = 0; i < lg; i++)
         {
            if(GV.myInfo_noticeArr[i].Type == 302)
            {
               this.myeve.talkInfo(GV.myInfo_noticeArr[i]);
               this.showBtnE();
            }
            else if(GV.myInfo_noticeArr[i].Type > 100)
            {
               if(!(GV.myInfo_noticeArr[i].Type == 603 && Boolean(LocalUserInfo.getVip() & 0x10)))
               {
                  this.myeve.info(GV.myInfo_noticeArr[i]);
                  this.showBtnE();
               }
            }
            else
            {
               this.mymsg.info(GV.myInfo_noticeArr[i]);
               UIManager.getSound("MessageSound").play(0,1);
               this.showBtnM();
            }
         }
      }
      
      private function getGData(E:EventTaomee) : void
      {
         var obj:Object = null;
         var groupView:MovieClip = null;
         var msgObj:Object = E.EventObj;
         if(!GView.screenFlagObj[msgObj.Croupid])
         {
            HistoryView.getInstanceByGroup(msgObj.Croupid).addItem({
               "MSG":msgObj.Content,
               "USERID":msgObj.Userid,
               "USERNAME":msgObj.Userid
            });
            groupView = MainManager.getAppLevel().getChildByName("group_" + msgObj.Croupid) as MovieClip;
            if(!groupView && !this.myeve.groupObj[msgObj.Croupid])
            {
               obj = {
                  "Type":303,
                  "UserID":msgObj.Userid,
                  "CroupID":msgObj.Croupid,
                  "Content":msgObj.Content
               };
               this.myeve.groupObj[msgObj.Croupid] = true;
               this.myeve.talkGInfo(obj);
               this.showBtnE();
            }
         }
      }
      
      private function getEveDel(E:EventTaomee) : void
      {
         var Groupid:uint = uint(E.EventObj);
         if(Boolean(GView.groupInfoObj[Groupid]))
         {
            if(GView.groupInfoObj[Groupid].Ownerid == GV.MyInfo_userID)
            {
               GView.groupInfoObj[Groupid] = null;
               return;
            }
            GView.groupInfoObj[Groupid] = null;
         }
         var Obj:Object = {
            "Type":1006,
            "UserID":0,
            "Nick":"小摩爾",
            "Map":Groupid
         };
         this.myeve.info(Obj);
         this.showBtnE();
         this.myeve.groupObj[Groupid] = false;
      }
      
      public function getTalkData(e:*) : void
      {
         var talkObj:Object = null;
         var arrObj:Object = null;
         if(e.EventObj.obj.Friend != 0)
         {
            talkObj = {
               "Type":302,
               "UserID":e.EventObj.obj.ID,
               "Nick":e.EventObj.obj.Nike,
               "InfoMsg":e.EventObj.obj.MSG
            };
            if(this.checkBlackLiset(talkObj.UserID))
            {
               return;
            }
            if(talkObj.UserID == GV.MyInfo_userID)
            {
               arrObj = {
                  "UserID":LocalUserInfo.getUserID(),
                  "Nick":LocalUserInfo.getNickName(),
                  "InfoMsg":e.EventObj.obj.MSG,
                  "Mid":e.EventObj.obj.Friend
               };
               this.talkUI.addselfTalkLine(arrObj);
               GF.addRecentFriend(e.EventObj.obj.Friend);
            }
            else
            {
               if(!MainManager.getAppLevel().getChildByName("talkNoticeMC" + talkObj.UserID))
               {
                  if(talkObj.UserID != GV.MyInfo_userID)
                  {
                     this.myeve.talkInfo(talkObj);
                     this.showBtnE();
                  }
               }
               else
               {
                  this.myeve.addTalkLine(talkObj);
               }
               GF.addRecentFriend(talkObj);
            }
         }
      }
      
      private function checkBlackLiset(userID:*) : Boolean
      {
         var i:int = 0;
         if(this.myISblack)
         {
            for(i = 0; i < this.blackList.length; i++)
            {
               if(userID == this.blackList[i].UserID)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function chartMsg(e:EventTaomee) : void
      {
         var r:ResAddFrendReq = null;
         var messageID:* = e.EventObj.UserID;
         var messageType:* = e.EventObj.Type;
         if(messageType == 603 && Boolean(LocalUserInfo.getVip() & 0x10))
         {
            r = new ResAddFrendReq();
            r.resAddFrend(e.EventObj.UserID,0);
            return;
         }
         if(e.EventObj.Type > 100)
         {
            if(!this.checkBlackLiset(messageID))
            {
               if(messageType == 604 && eveView.myAdd_arr.indexOf(messageID) != -1)
               {
                  this.myeve.renovateArr(messageID);
               }
               else
               {
                  this.myeve.info(e.EventObj);
                  this.showBtnE();
               }
            }
         }
         else
         {
            this.mymsg.info(e.EventObj);
            this.showBtnM();
         }
         if(e.EventObj.Type == 604)
         {
            if(e.EventObj.ICON == 1)
            {
               if(!MainManager.getGlobalObject().data.FriendsList)
               {
                  MainManager.getGlobalObject().data.FriendsList = new Array();
               }
               if(userPanelView.checkUser(e.EventObj.UserID))
               {
                  MainManager.getGlobalObject().data.ServerFriendsList.push({
                     "friend":e.EventObj.UserID,
                     "time":0
                  });
                  MainManager.getGlobalObject().data.FriendsList.push({
                     "Vip":-1,
                     "Color":0,
                     "UserID":e.EventObj.UserID,
                     "time":-1,
                     "type":e.EventObj.Type,
                     "map":e.EventObj.Map,
                     "Nick":e.EventObj.Nike,
                     "icon":e.EventObj.ICON,
                     "schema":e.EventObj.Schema,
                     "infoMsgLen":e.EventObj.InfoMsgLen,
                     "infoMsg":e.EventObj.InfoMsg
                  });
                  MainManager.getGlobalObject().flush();
                  GV.onlineSocket.dispatchEvent(new EventTaomee(userPanelView.ADDFRIEND_SUCCESS));
               }
            }
            else
            {
               GV.onlineSocket.dispatchEvent(new EventTaomee(userPanelView.ADDFRIEND_FAIL));
            }
         }
      }
      
      public function showBtnM() : void
      {
         this._msg_mc.gotoAndStop(2);
         this._msg_mc.visible = true;
      }
      
      public function showBtnE() : void
      {
         this._toolUI.eve_btn.visible = true;
         this._toolUI.eve_mc.gotoAndPlay(2);
      }
      
      public function delBtnsM() : void
      {
         this._msg_mc.visible = false;
      }
      
      public function delBtnsE() : void
      {
         this._toolUI.eve_btn.visible = false;
         this._toolUI.eve_mc.gotoAndStop(1);
      }
      
      public function onOpenMsg(e:MouseEvent = null) : void
      {
         if(!GV.isChangeMap)
         {
            if(Boolean(this.mymsg.nowLg))
            {
               this.mymsg.showTip();
            }
         }
         if(this.mymsg.nowLg == 0)
         {
            this.delBtnsM();
         }
      }
      
      public function showLastEvent(e:MouseEvent = null) : void
      {
         StatisticsClass.getInstance().init(67679213);
         if(!GV.isChangeMap)
         {
            if(eveView.isMC == 0)
            {
               if(eveView.nowLg == 1)
               {
                  this.delBtnsE();
               }
               this.myeve.showTip();
            }
         }
         else
         {
            eveView.isMC = 0;
         }
      }
      
      private function onOpenNews(e:MouseEvent = null) : void
      {
         NewStatisticsManager.send(786);
         var newsPanel:AppModuleControl = ModuleManager.openPanel(ModuleType.NEWS_PAPER_PANEL);
         newsPanel.addEventListener(ModuleEvent.DESTROY,this.onCloseNewsPanel);
         var peopleView:PeopleManageView = GV.MAN_PEOPLE;
         if(Boolean(peopleView))
         {
            peopleView.openBook(true);
         }
      }
      
      private function onCloseNewsPanel(e:ModuleEvent) : void
      {
         var newsPanel:AppModuleControl = e.currentTarget as AppModuleControl;
         if(Boolean(newsPanel))
         {
            newsPanel.removeEventListener(ModuleEvent.DESTROY,this.onCloseNewsPanel);
         }
         var peopleView:PeopleManageView = GV.MAN_PEOPLE;
         if(Boolean(peopleView))
         {
            peopleView.closeBook(true);
         }
      }
      
      public function showCloakClothesIcon() : void
      {
         this._clothes_btn.visible = true;
      }
      
      public function delCloakClothesIcon() : void
      {
         this._clothes_btn.visible = false;
      }
      
      public function isCanGetOnlineAwarad(bool:Boolean) : void
      {
      }
   }
}

