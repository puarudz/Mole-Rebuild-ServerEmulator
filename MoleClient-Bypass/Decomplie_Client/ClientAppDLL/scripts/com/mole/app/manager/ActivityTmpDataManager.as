package com.mole.app.manager
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.staticData.CommandID;
   import com.logic.socket.getUserBasicInfo.GetUserBasicInfoReq;
   import com.logic.socket.getUserBasicInfo.GetUserBasicInfoRes;
   import com.logic.socket.superlamuParty.superlamuPartySocket;
   import com.module.activityModule.Presented;
   import com.module.popupMsg.PopupMsgCtl;
   import com.mole.app.info.CompenStateControl;
   import com.mole.app.info.CompenStateInfo;
   import com.mole.app.type.ModuleType;
   import com.mole.app.utils.Tool;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   
   public class ActivityTmpDataManager
   {
      
      private static var _ed:EventDispatcher;
      
      private static var _compeninfo:CompenStateInfo;
      
      private static var _buchangType2:QueryItemCntManager;
      
      private static var _buchangType:QueryItemCntManager;
      
      private static var luckyCount:int;
      
      private static var luckyList:Array;
      
      private static var _blessTimer:Timer;
      
      private static var _blessCount:uint;
      
      private static var _blessNum:uint;
      
      public static var leveId:uint;
      
      public static var subLevelId:uint;
      
      public static var randomMapID:uint;
      
      private static var momoDiaryMC:MovieClip;
      
      public static var ARCHAEOLOGY_PANEL_GETINFO:Object = null;
      
      public static var task382OverPanel_obj:Object = null;
      
      public static var WorshipPanelInfo:Object = null;
      
      public static var BlackAngelTwoInfo:Object = null;
      
      public static var swallowcallBln:Boolean = false;
      
      public static var swallowgameBln:Boolean = false;
      
      public static var Task622isOn:uint = 0;
      
      public static var AgilityTestPanel_flag:int = 0;
      
      private static var team:uint = 0;
      
      private static const KNIGHT_TRANSFER_SWAP_ID:Array = [2615,2616,2617,2618,2619,2620,2621,2622,2623,2624];
      
      public static var isLetterTask:Boolean = false;
      
      public static var currentTaskId:int = -1;
      
      public static var currentTaskStatus:Boolean = false;
      
      public static var curTaskId:uint = 0;
      
      public static var currentMap:uint = 392;
      
      public static var loveTestFlag:uint = 0;
      
      public static var loveTestArray:Array = [0,0,0,0,0,0,0,0];
      
      public static var getMagicWater:Boolean = false;
      
      public static var isCallingGod:Boolean = false;
      
      public static var isNewPlayer:Boolean = false;
      
      public static var inviteFriendClicked:Boolean = false;
      
      public function ActivityTmpDataManager()
      {
         super();
      }
      
      public static function get ed() : EventDispatcher
      {
         if(!_ed)
         {
            _ed = new EventDispatcher();
         }
         return _ed;
      }
      
      public static function setup() : void
      {
         var taskMC:Sprite;
         ModuleManager.openPanel("NeverDisposePanel",null,"",null,false);
         taskMC = MainManager.getToolLevel().getChildByName("notice_mc") as Sprite;
         if(Boolean(taskMC))
         {
            var _temp_2:* = taskMC["open7dayPanel"];
            var _temp_1:* = MouseEvent.CLICK;
            with({})
            {
               
               _temp_2.addEventListener(_temp_1,function openDearmAttPanel(e:MouseEvent):void
               {
                  StatisticsManager.send(535);
                  ModuleManager.openPanel("Task382Panel_3");
               });
               openTask382overPanel();
               taskMC["vip_btn"].visible = false;
               taskMC["open_AccountSecurityPanel"].visible = false;
               taskMC["open_HallowmasBoxPanel"].addEventListener(MouseEvent.CLICK,openHBPPanel);
               if(Boolean(taskMC["open_ChristmasGiftBag"]))
               {
                  taskMC["open_ChristmasGiftBag"].visible = false;
               }
               taskMC["open_WindyGardenSupplyPanel"].addEventListener(MouseEvent.CLICK,function():void
               {
                  ModuleManager.openPanel("NightngaleAndRosePanel");
               });
               taskMC["MengSi"].addEventListener(MouseEvent.CLICK,function():void
               {
                  ModuleManager.openPanel(ModuleType.MENG_SI_TE_MAIN_PANEL);
               });
               taskMC["longqishi_btn"].addEventListener(MouseEvent.CLICK,function():void
               {
                  SimpleIntrPanelManager.show("LamuDiceBuyUI");
               });
               taskMC["open_mimijiayuan"].addEventListener(MouseEvent.CLICK,function():void
               {
                  var urlRequest:URLRequest = new URLRequest("http://dc.61.com/Question/realQ?qn_id=29");
                  navigateToURL(urlRequest,"_blank");
               });
               taskMC["aFuSmallShop"].addEventListener(MouseEvent.CLICK,function():void
               {
                  ModuleManager.openPanel("WeenActivityPanel");
               });
               taskMC["weenActSec"].addEventListener(MouseEvent.CLICK,function():void
               {
                  ModuleManager.openPanel("WeenActivitySecondPanel");
               });
               taskMC["loveAfternoonTea"].addEventListener(MouseEvent.CLICK,function():void
               {
                  ModuleManager.openPanel("BestloveAfternoonTeaPanel");
               });
               taskMC["iceHouse"].addEventListener(MouseEvent.CLICK,function():void
               {
                  ModuleManager.openPanel("ConsumerToMountPanel");
               });
            }
            blessBegin();
            compenPanelOpen();
            GV.onlineSocket.addCmdListener(CommandID.COME_BK_STATUS,typepepeHandle);
            GF.sendSocket(CommandID.COME_BK_STATUS,2022);
            GV.onlineSocket.addCmdListener(CommandID.ANGEL_KALUOLA_LUCKY_LIST,kaluolaLuckyList);
            GV.onlineSocket.addCmdListener(CommandID.COME_BK_STATUS,getStatusHandler);
            GF.sendSocket(CommandID.COME_BK_STATUS,602);
            GV.onlineSocket.addCmdListener(CommandID.GET_KNIGHT_TRANSFER_STATE,getKnightTransferState);
            GF.sendSocket(CommandID.GET_KNIGHT_TRANSFER_STATE);
         }
         
         private static function typepepeHandle(e:SocketEvent) : void
         {
            GV.onlineSocket.removeCmdListener(CommandID.COME_BK_STATUS,typepepeHandle);
            var data:ByteArray = e.data as ByteArray;
            data.position = 0;
            var type:uint = data.readUnsignedInt();
         }
         
         private static function buchanghandle(e:SocketEvent) : void
         {
            GV.onlineSocket.removeCmdListener(CommandID.MOMO_BUCHANG,buchanghandle);
            var recData:ByteArray = e.data as ByteArray;
            if(recData == null)
            {
               return;
            }
            recData.position = 0;
            var state:uint = recData.readUnsignedInt();
            if(state == 1)
            {
               ModuleManager.openPanel("MemeXiaJiaBuChangPanel");
            }
         }
         
         public static function addMLtaskEvent() : void
         {
            var _temp_2:* = GV.onlineSocket;
            var _temp_1:* = "MagciSpirite_guide_over";
            with({})
            {
               _temp_2.addEventListener(_temp_1,function ap():void
               {
                  GV.onlineSocket.removeEventListener("MagciSpirite_guide_over",ap);
                  ModuleManager.openPanel("Task382OverPanel",{"showUIType":3});
               });
            }
            
            private static function openTask382overPanel() : void
            {
               GV.onlineSocket.addCmdListener(8606,back8606_1022);
               GF.sendSocket(8606,1022);
            }
            
            private static function back8606_1022(e:*) : void
            {
               var myBirthday:uint = 0;
               var date:Date = null;
               var minTime:Number = NaN;
               var taskMC:Sprite = null;
               GV.onlineSocket.removeCmdListener(8606,back8606_1022);
               var data:ByteArray = e.data as ByteArray;
               var state:uint = data.readUnsignedInt();
               var arr:Array = [];
               var flag:uint = 0;
               for(var i:uint = 0; i < 8; i++)
               {
                  flag = uint(Boolean(state >> i & 1));
                  arr.push(flag);
               }
               if(arr[7] == 0)
               {
                  myBirthday = uint(LocalUserInfo.getBirthday());
                  date = new Date(2014,2,28,0,0,0);
                  minTime = date.getTime() / 1000;
                  if(myBirthday >= minTime)
                  {
                     taskMC = MainManager.getToolLevel().getChildByName("notice_mc") as Sprite;
                     if(Boolean(taskMC))
                     {
                        taskMC["open7dayPanel"].visible = true;
                     }
                  }
               }
            }
            
            private static function getKnightTransferState(evt:SocketEvent) : void
            {
               GV.onlineSocket.removeCmdListener(CommandID.GET_KNIGHT_TRANSFER_STATE,getKnightTransferState);
               var recData:ByteArray = evt.data as ByteArray;
               recData.position = 0;
               team = recData.readUnsignedInt();
               GV.onlineSocket.addCmdListener(9124,back9124);
               GF.sendSocket(9124,1);
            }
            
            private static function back9124(e:*) : void
            {
               var id:uint = 0;
               var num:uint = 0;
               var obj:Object = null;
               GV.onlineSocket.removeCmdListener(9124,back9124);
               var date:ByteArray = e.data as ByteArray;
               var count:uint = date.readUnsignedInt();
               if(count == 0)
               {
                  return;
               }
               var _arr:Array = ["水元素騎士：恭喜你的隊伍在本屆火神盃貢獻排行榜獲得殿軍，獎勵：","火元素騎士：恭喜你的隊伍在本屆火神盃貢獻排行榜獲得亞軍，獎勵：","風元素騎士：恭喜你的隊伍在本屆火神盃貢獻排行榜獲得季軍，獎勵：","地元素騎士：恭喜你的隊伍在本屆火神盃貢獻排行榜獲得冠軍，獎勵："];
               var _msg:String = "";
               if(team > 0)
               {
                  _msg = _arr[team - 1];
               }
               for(var i:uint = 0; i < count; i++)
               {
                  id = date.readUnsignedInt();
                  num = date.readUnsignedInt();
                  obj = GoodsInfo.getInfoById(id);
                  if(id == 0)
                  {
                     _msg += num + "摩爾豆、";
                     LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + num);
                  }
                  else if(uint(obj.typeObject.id) == 43)
                  {
                     _msg += GoodsInfo.getItemNameByID(id) + "卡牌x" + num + "、";
                  }
                  else
                  {
                     _msg += GoodsInfo.getItemNameByID(id) + "x" + num + "、";
                  }
               }
               Alert.smileAlart(_msg.substr(0,_msg.length - 1) + "。");
            }
            
            public static function compenPanelOpen() : void
            {
               _compeninfo = CompenStateControl.inst.init();
               if(_compeninfo.socketType > 0)
               {
                  GV.onlineSocket.addCmdListener(11019,back11019);
                  GF.sendSocket(11019,1,_compeninfo.dayType);
               }
               else
               {
                  Tool.finishSomething(_compeninfo.dayType,buChangLiBao);
               }
            }
            
            private static function back11019(e:*) : void
            {
               GV.onlineSocket.removeCmdListener(11019,back11019);
               var date:ByteArray = e.data as ByteArray;
               if(date == null)
               {
                  return;
               }
               var lg:uint = date.readUnsignedInt();
               var over:int = date.readByte();
               buChangLiBao(over);
            }
            
            private static function buChangLiBao(count:uint) : void
            {
               var _curDate:Date = null;
               var p:uint = 0;
               var myBirthday:uint = uint(LocalUserInfo.getBirthday());
               var minTime:Number = _compeninfo.glzTime / 1000;
               if(count == 0)
               {
                  _curDate = ServerUpTime.getInstance().chinaDate;
                  if(_curDate.time >= _compeninfo.glzTime && _curDate.time <= _compeninfo.endTime)
                  {
                     if(myBirthday < minTime)
                     {
                        p = setTimeout(function():void
                        {
                           clearTimeout(p);
                           p = 0;
                           if(LoginGiftManager.CheckFirstTask() == true)
                           {
                              ModuleManager.openPanel(ModuleType.COMPEN_STATE_BOARD_PANEL);
                           }
                        },3000);
                     }
                  }
               }
            }
            
            private static function openHBPPanel(e:*) : void
            {
               ModuleManager.openPanel("SL_FAMILY_Panel");
            }
            
            private static function openFGBPanel(e:*) : void
            {
               ModuleManager.openPanel("FirstGoldBoxPanel");
            }
            
            private static function openASPPanel(e:MouseEvent) : void
            {
               ModuleManager.openPanel("AccountSecurityPanel");
            }
            
            public static function changTimes(times:uint = 0) : void
            {
            }
            
            public static function dearmAttShowTimeUI() : void
            {
            }
            
            public static function changTodayArr(attendancetoday:Array) : void
            {
            }
            
            private static function getStatusHandler(evt:SocketEvent) : void
            {
               var time:uint = 0;
               var state:uint = 0;
               var recData:ByteArray = evt.data as ByteArray;
               var type:uint = recData.readUnsignedInt();
               if(type == 602)
               {
                  GV.onlineSocket.removeCmdListener(CommandID.COME_BK_STATUS,getStatusHandler);
                  time = recData.readUnsignedInt();
                  state = recData.readUnsignedInt();
                  if(int(ServerUpTime.getInstance().serverTime / 1000) - time < 3600 * 24 * 3 && state != 3)
                  {
                     ModuleManager.openPanel("ComeBackGiftPanel",{
                        "time":time,
                        "state":state
                     });
                  }
               }
            }
            
            private static function kaluolaLuckyList(evt:SocketEvent) : void
            {
               var ix:int = 0;
               var recData:ByteArray = evt.data as ByteArray;
               luckyCount = recData.readUnsignedInt();
               luckyList = [];
               if(luckyCount > 0)
               {
                  PopupMsgCtl.PopupMsg("今天可以獲得祝福禮物的幸運兒是",2000);
                  for(ix = 0; ix < luckyCount; ix++)
                  {
                     luckyList.push(recData.readUnsignedInt());
                  }
                  GV.onlineSocket.addEventListener(GetUserBasicInfoRes.GET_USER_BASIC_INFO,getUserInfoBack);
                  new GetUserBasicInfoReq().getUserBasicInfo(luckyList[luckyCount - 1]);
               }
            }
            
            private static function getUserInfoBack(evt:EventTaomee) : void
            {
               --luckyCount;
               PopupMsgCtl.PopupMsg(evt.EventObj.Nick + "(" + evt.EventObj.UserID + ")",3000);
               if(luckyCount == 0)
               {
                  GV.onlineSocket.removeEventListener(GetUserBasicInfoRes.GET_USER_BASIC_INFO,getUserInfoBack);
               }
               else
               {
                  new GetUserBasicInfoReq().getUserBasicInfo(luckyList[luckyCount - 1]);
               }
            }
            
            private static function kaluolaLucky(evt:SocketEvent) : void
            {
               var recData:ByteArray = evt.data as ByteArray;
               if(recData.readUnsignedInt() != 0)
               {
                  Alert.smileAlart("恭喜你成為了卡羅拉祝福的幸運兒,獲得了" + GoodsInfo.getItemNameByID(recData.readUnsignedInt()) + "*" + recData.readUnsignedInt());
               }
            }
            
            private static function blessBegin() : void
            {
               _blessTimer = new Timer(1000);
               _blessTimer.addEventListener(TimerEvent.TIMER,BlessOnline);
               _blessTimer.start();
               GV.onlineSocket.addCmdListener(CommandID.GET__BLESS,sceneBroadcast);
            }
            
            private static function BlessOnline(e:TimerEvent) : void
            {
               ++_blessCount;
               ++_blessNum;
               if(_blessCount == 60)
               {
                  _blessCount = 0;
                  getBlessing();
               }
            }
            
            private static function getBlessing() : void
            {
               var str:String = null;
               if(SystemTimeController.instance.checkSysTimeAchieve(57))
               {
                  str = "六一在線就能獲得大量愛心福袋，千萬不可錯過哦！";
                  if(SystemTimeController.instance.checkSysTimeAchieve(54))
                  {
                     str = "活動將持續1小時，每隔幾分鐘就會發送一次福袋";
                     GF.sendSocket(CommandID.GET__BLESS);
                  }
                  PopupMsgCtl.PopupMsg(str,10000);
               }
            }
            
            private static function sceneBroadcast(evt:SocketEvent) : void
            {
               var recData:ByteArray = evt.data as ByteArray;
               var id:uint = recData.readUnsignedInt();
               var count:uint = recData.readUnsignedInt();
               if(count == 0)
               {
                  return;
               }
               Alert.smileAlart("       恭喜你獲得" + count.toString() + "個" + GoodsInfo.getItemNameByID(id));
            }
            
            public static function getTransferItem(index:uint) : void
            {
               if(index == 3)
               {
                  if(Math.random() < 0.5)
                  {
                     Alert.angryAlart("很可惜沒有獲得到火之精靈！多點幾次試試吧！");
                     return;
                  }
               }
               if(index == 5)
               {
                  if(Math.random() < 0.5)
                  {
                     Alert.angryAlart("很可惜沒有獲得到雲之石！多點幾次試試吧！");
                     return;
                  }
               }
               if(index == 6)
               {
                  if(Math.random() < 0.5)
                  {
                     Alert.angryAlart("很可惜沒有獲得到流雲晶石！多玩幾次試試吧！");
                     return;
                  }
               }
               if(index == 8)
               {
                  if(Math.random() < 0.5)
                  {
                     Alert.angryAlart("很可惜沒有獲得到土漿果樹苗！多玩幾次試試吧！");
                     return;
                  }
               }
               Presented.getInstance().celebrate1225(KNIGHT_TRANSFER_SWAP_ID[index]);
            }
            
            public static function submitMushroom(teamId:uint) : void
            {
            }
            
            public static function addListenEvent() : void
            {
               GV.onlineSocket.addEventListener("MagciSpirite_gameEnd",overHandle);
            }
            
            private static function overHandle(e:EventTaomee) : void
            {
               GV.onlineSocket.removeEventListener("MagciSpirite_gameEnd",overHandle);
               if(e.EventObj.levelId == 1005 && e.EventObj.subLevelId == 1 || e.EventObj.levelId == 1006 && e.EventObj.subLevelId == 3)
               {
                  superlamuPartySocket.treasurebowl(229);
                  ActivityTmpDataManager.curTaskId = 0;
               }
            }
            
            public static function momoDiaryLoadHandler(evt:MouseEvent = null) : void
            {
               var tempMC:MCLoader = null;
               if(!MainManager.getGameLevel().getChildByName("momoDiaryMC"))
               {
                  momoDiaryMC = new MovieClip();
                  momoDiaryMC.name = "momoDiaryMC";
                  MainManager.getGameLevel().addChild(momoDiaryMC);
                  tempMC = new MCLoader("module/external/BooksUI/MomoDiary.swf",momoDiaryMC,1,"正在打開麼麼公主日記");
                  tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,momoDiaryLoadOver);
                  tempMC.doLoad();
               }
            }
            
            private static function momoDiaryLoadOver(evt:MCLoadEvent) : void
            {
               var mainMC:DisplayObjectContainer = evt.getParent();
               var childMC:* = evt.getLoader();
               mainMC.addChild(childMC);
               GV.onlineSocket.addEventListener("monthlyCloseEvent",closeMomoDiaryBook);
               var mcloader:MCLoader = evt.target as MCLoader;
               mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,momoDiaryLoadOver);
               mcloader.clear();
            }
            
            private static function closeMomoDiaryBook(evt:Event = null) : void
            {
               GV.onlineSocket.removeEventListener("monthlyCloseEvent",closeMomoDiaryBook);
               GC.stopAllMC(momoDiaryMC);
               GC.clearChildren(momoDiaryMC);
               momoDiaryMC.parent.removeChild(momoDiaryMC);
               momoDiaryMC = null;
            }
         }
      }
      
      