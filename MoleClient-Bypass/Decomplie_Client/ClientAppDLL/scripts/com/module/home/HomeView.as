package com.module.home
{
   import com.common.Alert.Alert;
   import com.common.data.HashMap;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.info.MapInfo;
   import com.core.loading.Loading;
   import com.core.manager.AssetsManage;
   import com.core.manager.LevelManager;
   import com.core.music.TopicMusicManager;
   import com.core.newloader.BaseMCLoader;
   import com.core.newloader.LoaderList;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.links.Links;
   import com.global.staticData.CommandID;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.MapManageLogic.MapDepthManageLogic;
   import com.logic.MapManageLogic.MapManageLogic;
   import com.logic.socket.defend.defendSocket;
   import com.logic.socket.examinePack.examinePackStuff;
   import com.logic.socket.getSceneUserInfo.GetSceneUserInfoReq;
   import com.logic.socket.home.GetHomeInfoReq;
   import com.logic.socket.home.GetHomeInfoRes;
   import com.logic.socket.home.homeSocket;
   import com.logic.socket.pig.PigSocket;
   import com.logic.task.Task382;
   import com.logic.task.TaskDiceCurse;
   import com.module.coin.CoinBuyNewModle;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.newHouse.newHouseView;
   import com.module.npc.I_NPC;
   import com.module.npc.NPC;
   import com.module.npc.npcInstance.MoleNPC;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.info.NPCDialogInfo;
   import com.mole.app.info.NPCDialogOptionInfo;
   import com.mole.app.manager.ActivityTmpDataManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.task.type.TaskStateType;
   import com.mole.app.type.ActionType;
   import com.view.MapManageView.MapManageView;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.activity.Task83.SwitchMapToAngelPark;
   import com.view.mapView.activity.npcTask.defendNPCState;
   import com.view.userPanelView.userPanelView;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.media.SoundMixer;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   
   public class HomeView extends MovieClip
   {
      
      public static var instance:HomeView;
      
      public static var hostID:uint;
      
      public static var HotUI:*;
      
      public static var ListUI:*;
      
      public static var Man:*;
      
      public static var UserName:String;
      
      public static var HomeBGID:uint;
      
      public static var _EditMode:Boolean;
      
      public static var hotui:*;
      
      public static var listui:*;
      
      public static var InHome:Boolean;
      
      public static var newUserLightMC:MovieClip;
      
      public static var newUserLight:MovieClip;
      
      public static var hasAlert:Boolean = false;
      
      public static var book_ver:uint = 2;
      
      private var homeeditview:HomeEditView;
      
      public var itemBookViews:*;
      
      public var loadBookEvent:*;
      
      public var RootMC:MovieClip;
      
      public var homeUIMC:MovieClip;
      
      public var HomeObj:Object;
      
      public var HouseID:uint;
      
      private var mcloader:MCLoader;
      
      private var bgLoaderOver:Boolean = false;
      
      private var seedLoaderOver:Boolean = false;
      
      public var homelogic:HomeLogic;
      
      public var bgbmd:BitmapData;
      
      public var ChangeBGBool:Boolean;
      
      public var UIPosY:uint = 800;
      
      public var cropManage:ICropManage;
      
      private var Kind:int = 0;
      
      private var currentPage:uint = 1;
      
      private const NUM:uint = 10;
      
      private var depotGoodsArr:Array;
      
      public var Crop_Lib:AssetsManage = new AssetsManage(false);
      
      public var backAlert:*;
      
      public var tempGoods:*;
      
      public var tempGoodsObj:Object;
      
      public var temp_JJL:DisplayObject;
      
      public var newspageMC:MovieClip;
      
      private var npc:I_NPC;
      
      private var usernameMc:MovieClip;
      
      private var isFristInHome:Boolean = false;
      
      private var timerNum:int;
      
      private var timerDate:Date;
      
      private var foodNum:int;
      
      private var sayNpcTimer:Timer;
      
      private var defendMC:MovieClip;
      
      private var childMC:*;
      
      private var eatNum:uint = 1;
      
      private var CoinBuyModles:CoinBuyNewModle;
      
      private var isShowTuzi:Boolean = false;
      
      public function HomeView()
      {
         super();
      }
      
      public static function getInstance() : HomeView
      {
         if(instance == null)
         {
            instance = new HomeView();
         }
         return instance;
      }
      
      public static function get ismyhome() : Boolean
      {
         return newHouseView.isMyHouse;
      }
      
      public static function set ismyhome(value:Boolean) : void
      {
         newHouseView.isMyHouse = value;
      }
      
      public function setValue(tempObj:Loader, homeinfoObj:Object) : void
      {
         var btn_mc:Sprite = null;
         var btn:DisplayObject = null;
         var i:uint = 0;
         if(Boolean(ActivityTmpDataManager.task382OverPanel_obj))
         {
            if(ActivityTmpDataManager.task382OverPanel_obj._goId == 5)
            {
               if(ActivityTmpDataManager.task382OverPanel_obj._oneFlag == 2)
               {
                  ModuleManager.openPanel("Task382OverPanel",{"showUIType":5});
               }
            }
            else if(ActivityTmpDataManager.task382OverPanel_obj._goId == 6)
            {
               if(ActivityTmpDataManager.task382OverPanel_obj._oneFlag == 2)
               {
                  ModuleManager.openPanel("Task382OverPanel",{"showUIType":6});
                  BC.addEvent(this,GV.onlineSocket,"task382overpanel3_openHomeHot",function(e:Event):void
                  {
                     openMoleHome();
                  });
               }
            }
            else if(ActivityTmpDataManager.task382OverPanel_obj._goId == 7)
            {
               if(ActivityTmpDataManager.task382OverPanel_obj._oneFlag == 2)
               {
                  ModuleManager.openPanel("Task382OverPanel",{"showUIType":7});
               }
            }
            else if(ActivityTmpDataManager.task382OverPanel_obj._goId == 8)
            {
               if(ActivityTmpDataManager.task382OverPanel_obj._oneFlag == 1)
               {
                  ModuleManager.openPanel("Task382OverPanel",{"showUIType":8});
               }
            }
         }
         InHome = true;
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         this.homelogic = HomeLogic.getInstance();
         this.HomeObj = homeinfoObj;
         this.homelogic.setValue(this.HomeObj);
         this.RootMC = tempObj.content as MovieClip;
         if(Task382.state != TaskStateType.FINISH)
         {
            btn_mc = this.RootMC.btnMC;
            for(i = 0; i < btn_mc.numChildren; i++)
            {
               btn = btn_mc.getChildAt(i);
               if(btn.name != "save_btn")
               {
                  btn.visible = false;
               }
            }
         }
         else if(GF.getLocalGameHighScore("cardbook" + LocalUserInfo.getUserID()) != book_ver)
         {
            this.RootMC.btnMC.new_book.visible = true;
         }
         else
         {
            this.RootMC.btnMC.new_book.visible = false;
         }
         this.homeUIMC = this.RootMC.homeUIMC;
         this.homeUIMC.y = this.UIPosY;
         BC.addEvent(this,this.homeUIMC.close_btn,MouseEvent.CLICK,this.OpenClosedepot);
         this.RootMC.btnMC.save_btn.visible = false;
         ismyhome = this.HomeObj.UserID == LocalUserInfo.getUserID();
         hostID = this.HomeObj.UserID;
         UserName = this.HomeObj.Name;
         this.loadHouseground();
         this.homeeditview = HomeEditView.getInstance();
         this.homeeditview.setValue(this.HomeObj,this.RootMC);
         this.loadHomeground();
         this.initBtn();
         this.getLib();
         this.init();
         this.initHot();
         MainManager.getToolLevel().y = 0;
         TopicMusicManager.instance.stopSound();
         GV.onlineSocket.addCmdListener(CommandID.GET_LOVE_STAR,this.getLoveStar);
         GF.sendSocket(CommandID.GET_LOVE_STAR,hostID);
      }
      
      private function getLoveStar(e:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.GET_LOVE_STAR,this.getLoveStar);
         var recData:ByteArray = e.data as ByteArray;
         var flag:uint = recData.readUnsignedInt();
         var id:uint = recData.readUnsignedInt();
         if(flag == 0)
         {
            Alert.smileAlart("恭喜你獲得一顆祝福之心，每個好友家裡一天只能獲得一個哦!");
         }
         else if(flag == 2)
         {
            Alert.smileAlart("你每天最多只能獲得50個上限!");
         }
      }
      
      public function initHot() : void
      {
         HomeHot.init(hostID);
      }
      
      public function init() : void
      {
         if(ismyhome)
         {
            this.depotGoodsArr = [[],[],[],[],[],[],[],[]];
            BC.addEvent(this,GV.onlineSocket,"HomedepotAddGoods",this.moveHomeGoodsToDepot);
            BC.addEvent(this,this.homeeditview,"change_Home_BG",this.changeHomeBG);
            BC.addEvent(this,this.homeeditview,"HomeGoodsToDepot",this.moveHomeGoodsToDepot);
         }
         setTimeout(function():void
         {
            var npcOptionInfo:NPCDialogOptionInfo = null;
            var sayList:Array = new Array();
            npcOptionInfo = new NPCDialogOptionInfo("查看工作記錄",ActionType.SYSTEM_ACT,"a7_checkWork");
            sayList.push(npcOptionInfo);
            npcOptionInfo = new NPCDialogOptionInfo("查詢狀態",ActionType.SYSTEM_ACT,"a7_checkState");
            sayList.push(npcOptionInfo);
            npcOptionInfo = new NPCDialogOptionInfo("給我餵食",ActionType.SYSTEM_ACT,"a7_feed");
            sayList.push(npcOptionInfo);
            npcOptionInfo = new NPCDialogOptionInfo("把它趕走！",ActionType.SYSTEM_ACT,"a7_putOut");
            sayList.push(npcOptionInfo);
            npcOptionInfo = new NPCDialogOptionInfo("我有事，先走了",ActionType.NONE);
            sayList.push(npcOptionInfo);
            var npcDialogInfo:NPCDialogInfo = new NPCDialogInfo(10022,"正常","有了我，你就放心吧，絕對不會有一棵植物乾旱，也絕對不會有一隻動物逃跑的!",sayList);
            SystemEventManager.addEventListener("a7_checkWork",onCheckWork);
            SystemEventManager.addEventListener("a7_checkState",onCheckState);
            SystemEventManager.addEventListener("a7_feed",onFeed);
            SystemEventManager.addEventListener("a7_putOut",onPutOut);
            var a7:MoleNPC = NPC.getNPCInstance(1025);
            if(Boolean(a7) && ismyhome)
            {
               a7.dialogInfo = npcDialogInfo;
            }
         },2000);
      }
      
      private function onCheckWork(e:SystemEvent) : void
      {
         defendNPCState.getInstance().setSayId(1);
         new LoadGame("module/external/DefendAlt.swf","正在打開面板........",LevelManager.appLevel);
      }
      
      private function onCheckState(e:SystemEvent) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 1991,this.seeDefendFun1);
         defendSocket.seedefendTime(LocalUserInfo.getUserID(),1320001);
      }
      
      private function seeDefendFun1(evt:EventTaomee) : void
      {
         var msg:String = null;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1991,this.seeDefendFun1);
         this.timerDate = new Date(Number(evt.EventObj.Time * 1000));
         this.timerNum = evt.EventObj.Time;
         if(this.timerNum == 0)
         {
            msg = "姓名：R7（阿七）" + "\n" + "性別：無" + "\n" + "年齡：大衛沒告訴我" + "\n" + "特長：幫助摩爾照看家園的植物和牧場的動物。" + "\n" + "狀態：能量不足，無法工作！" + "\n" + "提示：能量不足時，可以用米幣購買“超能骨頭”，成為超級拉姆後，每週就可以免費領取1根哦。";
         }
         else
         {
            msg = "姓名：R7（阿七）" + "\n" + "性別：無" + "\n" + "年齡：大衛沒告訴我" + "\n" + "特長：幫助摩爾照看家園的植物和牧場的動物。" + "\n" + "狀態：剩餘能源可以維持到" + this.timerDate.getFullYear() + "年" + int(this.timerDate.getMonth() + 1) + "月" + this.timerDate.getDate() + "日" + "\n" + "提示：能量不足時，可以用米幣購買“超能骨頭”，成為超級拉姆後，每週就可以免費領取1根哦。";
         }
         var url:String = "resource/allJob/AlertPic/defend/defend01.swf";
         var aler:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"buy_energy,notgo",true,true,"SMCUI");
         BC.addEvent(this,aler,Alert.CLICK_ + "1",this.clickHandle);
      }
      
      private function clickHandle(evt:Event) : void
      {
         new CoinBuyNewModle().BuyModle(100556,1);
      }
      
      private function onFeed(e:SystemEvent) : void
      {
         defendNPCState.getInstance().setSayId(2);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1991,this.seeDefendInforFun);
         defendSocket.seedefendTime(LocalUserInfo.getUserID(),1320001);
      }
      
      private function seeDefendInforFun(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1991,this.seeDefendInforFun);
         this.timerDate = new Date(Number(evt.EventObj.Time * 1000));
         this.timerNum = evt.EventObj.Time;
         BC.addEvent(this,GV.onlineSocket,"read_" + 1915,this.seeItemEvent);
         examinePackStuff.examinePack_create([190639]);
      }
      
      private function seeItemEvent(evt:EventTaomee) : void
      {
         var url:String = null;
         var tempMC:MCLoader = null;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1915,this.seeItemEvent);
         this.foodNum = evt.EventObj.arr[0].count;
         if(!MainManager.getAppLevel().getChildByName("defendMC"))
         {
            this.defendMC = new MovieClip();
            this.defendMC.name = "defendMC";
            MainManager.getAppLevel().addChild(this.defendMC);
            url = "resource/allJob/AlertPic/defend/defend03.swf";
            tempMC = new MCLoader(url,this.defendMC,1,"正在打開面板......");
            tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadCallBoardHandler);
            tempMC.doLoad();
         }
      }
      
      private function loadCallBoardHandler(evt:MCLoadEvent) : void
      {
         var msg:String = null;
         var mainMC:DisplayObjectContainer = evt.getParent();
         this.childMC = evt.getLoader();
         mainMC.addChild(this.childMC);
         if(this.foodNum == 0)
         {
            MovieClip(this.childMC.content.root.num_mc).mouseEnabled = false;
            MovieClip(this.childMC.content.root.num_mc).mouseChildren = false;
         }
         this.childMC.content.root.num_mc.max = this.foodNum;
         if(this.timerNum == 0)
         {
            msg = "    親愛的主人，我已經沒有能量了，你現在擁有" + this.foodNum + "個超能骨頭，每餵我1根骨頭，我就可以連續工作7天，你想給我吃幾根呀？";
         }
         else
         {
            msg = "    親愛的主人，我的能力能維持到：" + this.timerDate.getFullYear() + "年" + int(this.timerDate.getMonth() + 1) + "月" + this.timerDate.getDate() + "日，你現在擁有" + this.foodNum + "個超能骨頭，每餵我1根骨頭，我就可以連續工作7天，你想給我吃幾根呀？";
         }
         if(this.foodNum == 0)
         {
            this.childMC.content.root.buy_btn.visible = true;
            this.childMC.content.root.yes_btn.visible = false;
         }
         else
         {
            this.childMC.content.root.buy_btn.visible = false;
            this.childMC.content.root.yes_btn.visible = true;
         }
         this.childMC.content.root.type_txt.text = msg;
         BC.addEvent(this,this.childMC.content.root.close_btn,MouseEvent.CLICK,this.removeMcHandler);
         BC.addEvent(this,this.childMC.content.root.no_btn,MouseEvent.CLICK,this.removeMcHandler);
         BC.addEvent(this,this.childMC.content.root.yes_btn,MouseEvent.CLICK,this.alClickHandle);
         BC.addEvent(this,this.childMC.content.root.buy_btn,MouseEvent.CLICK,this.buyClickHandle);
         MCLoader(evt.target).removeEventListener(MCLoadEvent.ON_SUCCESS,this.loadCallBoardHandler);
         MCLoader(evt.target).clear();
      }
      
      private function buyClickHandle(evt:MouseEvent) : void
      {
         this.removeMcHandler();
         this.CoinBuyModles = new CoinBuyNewModle();
         this.CoinBuyModles.BuyModle(100556,1);
      }
      
      private function removeMcHandler(evt:MouseEvent = null) : void
      {
         BC.removeEvent(this,this.childMC.content.root.close_btn,MouseEvent.CLICK,this.removeMcHandler);
         BC.removeEvent(this,this.childMC.content.root.no_btn,MouseEvent.CLICK,this.removeMcHandler);
         BC.removeEvent(this,this.childMC.content.root.yes_btn,MouseEvent.CLICK,this.alClickHandle);
         BC.removeEvent(this,this.childMC.content.root.buy_btn,MouseEvent.CLICK,this.buyClickHandle);
         GC.clearAll(this.defendMC);
         this.defendMC = null;
      }
      
      private function alClickHandle(evt:Event) : void
      {
         this.eatNum = this.childMC.content.root.num_mc.t_txt.text;
         if(this.foodNum == 0 || this.eatNum == 0)
         {
            if(this.foodNum == 0)
            {
               Alert.smileAlart("    主人！主人！你包包裡面沒有我吃的骨頭哦！");
            }
            else
            {
               Alert.smileAlart("    小主人，我聞到你包包裡的骨頭香味了，就餵我一根吧。");
            }
         }
         else
         {
            this.removeMcHandler();
            BC.addEvent(this,GV.onlineSocket,"read_" + 1990,this.eatFoodOKFun);
            defendSocket.eatfood(1320001,190639,this.eatNum);
         }
      }
      
      private function eatFoodOKFun(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1990,this.eatFoodOKFun);
         GC.clearGInterval(this.sayNpcTimer);
         var npc:I_NPC = NPC.getNPCInstance(1025);
         if(Boolean(npc))
         {
            npc["addToFloor"]();
            npc.autoMove = true;
         }
         defendNPCState.getInstance().setnpcTimer(evt.EventObj.Time);
         var loadGame:LoadGame = new LoadGame("module/external/DefendAlt.swf","正在打開面板.........",MainManager.getAppLevel());
         loadGame = null;
      }
      
      private function onPutOut(e:SystemEvent) : void
      {
         var url:String = "resource/allJob/AlertPic/defend/defend02.swf";
         var msg:String = "    趕走了我，除非去重新租用否則我是不會再回來的，你確定要趕我走嗎？";
         var a:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"sure,cancel",true,false,"EMP_BUY");
         BC.addEvent(this,a,Alert.CLICK_ + "1",this.clickFun);
      }
      
      private function clickFun(evt:Event) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 1989,this.backFun);
         defendSocket.backDefend(1320001);
      }
      
      private function backFun(evt:EventTaomee) : void
      {
         var npc:I_NPC = NPC.getNPCInstance(1025);
         NPC.getNPCInstance(1025,true).hideButton();
         npc.say("小主人我會想念你的！");
         npc.autoMove = false;
         npc.Speed *= 2;
         BC.addEvent(this,npc,PeopleManageView.ON_GO_OVER,this.npcOvenEvent);
         npc.MoveTo(137,300);
         defendNPCState.getInstance().setnpcTimer(0);
      }
      
      private function npcOvenEvent(evt:Event) : void
      {
         var npc:I_NPC = NPC.getNPCInstance(1025);
         BC.removeEvent(this,npc,PeopleManageView.ON_GO_OVER,this.npcOvenEvent);
         npc.clearClass();
      }
      
      private function open_HouseShopsPanel(e:MouseEvent) : void
      {
         if(this.EditMode == false)
         {
            ModuleManager.openPanel("HouseShopsPanel",null,"正在加載家園商店",null);
         }
      }
      
      public function initBtn() : void
      {
         BC.addEvent(this,this.RootMC.btnMC.molehome_btn,MouseEvent.CLICK,this.openMoleHome);
         BC.addEvent(this,this.RootMC.btnMC.gamecard_btn,MouseEvent.CLICK,this.openGameCard);
         BC.addEvent(this,this.RootMC.btnMC.gamecard_btn,MouseEvent.MOUSE_OVER,this.ShowGameCardTip);
         BC.addEvent(this,this.RootMC.btnMC.gamecard_btn,MouseEvent.MOUSE_OUT,this.HideGameCardTip);
         BC.addEvent(this,this.RootMC.btnMC.helper,MouseEvent.CLICK,this.helperHandler);
         if(ismyhome)
         {
            if(this.isFristInHome == false)
            {
               this.isFristInHome = true;
            }
            BC.addEvent(this,this.RootMC.btnMC.houseShopBtn,MouseEvent.CLICK,this.open_HouseShopsPanel);
            BC.addEvent(this,this.RootMC.btnMC.homedepot_btn,MouseEvent.CLICK,this.openHomeDepot);
            BC.addEvent(this,this.RootMC.btnMC.save_btn,MouseEvent.CLICK,this.dosaveHome);
         }
         else
         {
            this.RootMC.btnMC.houseShopBtn.visible = false;
            this.RootMC.btnMC.homedepot_btn.visible = false;
            this.RootMC.btnMC.save_btn.visible = false;
         }
      }
      
      private function helperHandler(evt:MouseEvent) : void
      {
         var tempMC:Sprite = null;
         var mcloader:MCLoader = null;
         if(MainManager.getAppLevel().getChildByName("SpecialHelper") == null)
         {
            tempMC = new Sprite();
            tempMC.name = "SpecialHelper";
            MainManager.getAppLevel().addChild(tempMC);
            mcloader = new MCLoader("module/external/CollectView.swf",tempMC,Loading.TITLE_AND_PERCENT,"正在打開百寶集...");
            mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,this.helperUIHandler);
            mcloader.doLoad();
         }
      }
      
      private function helperUIHandler(event:MCLoadEvent) : void
      {
         event.currentTarget.addEventListener(MCLoadEvent.ON_SUCCESS,this.helperUIHandler);
         var content:DisplayObject = event.getContent();
         var mc:Sprite = event.getParent() as Sprite;
         mc.addChild(content);
         BaseMCLoader(event.currentTarget).clear();
      }
      
      public function changeHomeBG(e:Event) : void
      {
         GC.stopAllMC(this.RootMC.doorName_mc);
         this.ChangeBGBool = true;
         this.cropManage.deleteAllSeed();
         this.AutoSaveHome();
         this.loadHomeground();
      }
      
      public function loadHouseground() : void
      {
         var tid:uint = 0;
         this.HouseID = this.HomeObj.HouseBackground;
         try
         {
            tid = uint(GoodsInfo.getInfoById(this.HouseID).id);
         }
         catch(E:Error)
         {
         }
         this.HouseID = Boolean(tid) ? this.HouseID : 160030;
         var tempLoader:Loader = new Loader();
         LoaderList.getInstance().addItem(tempLoader,VL.getURLRequest("resource/goods/BGinHome/" + this.HouseID + ".swf"),LoaderList.HIGH,true);
         this.RootMC.house_mc.addChild(tempLoader);
         BC.addEvent(this,tempLoader.contentLoaderInfo,Event.COMPLETE,this.HouseBGcompleteHandler);
      }
      
      public function HouseBGcompleteHandler(e:Event) : void
      {
         var goodsMC:Object = e.target.content;
         var tempObj:Object = this.HomeObj.itemArr[0];
         var door:Object = goodsMC.mc2.getChildAt(0);
         if(tempObj.PosY < 10 || tempObj.PosY > 300 || tempObj.PosX < 10 || tempObj.PosX > 900)
         {
            goodsMC.x = 450;
            goodsMC.y = 200;
         }
         else
         {
            goodsMC.x = tempObj.PosX;
            goodsMC.y = tempObj.PosY;
            goodsMC.mc1.gotoAndStop(tempObj.Direction);
            goodsMC.mc2.gotoAndStop(tempObj.Direction);
         }
         goodsMC.moving = false;
         if(ismyhome)
         {
            BC.addEvent(this,goodsMC.btn,MouseEvent.CLICK,this.moveHouseBG);
         }
         BC.addEvent(this,goodsMC.btn,MouseEvent.MOUSE_OVER,this.Door2);
         BC.addEvent(this,goodsMC.btn,MouseEvent.MOUSE_OUT,this.Door1);
      }
      
      public function Door1(e:MouseEvent) : void
      {
         if(!_EditMode)
         {
            try
            {
               e.currentTarget.parent.mc2.door_mc.door.gotoAndStop(1);
            }
            catch(e:Error)
            {
            }
         }
      }
      
      public function Door2(e:Event = null) : void
      {
         if(!_EditMode)
         {
            try
            {
               e.currentTarget.parent.mc2.door_mc.door.gotoAndStop(2);
            }
            catch(err:Error)
            {
            }
         }
      }
      
      public function gotoHouse() : void
      {
         if(ismyhome)
         {
            this.switchMap();
         }
         else
         {
            BC.addEvent(this,GV.onlineSocket,GetHomeInfoRes.USER_FLAG_SUCC,this.isLockTheDoor);
            GetHomeInfoReq.UserFlag(hostID);
         }
      }
      
      public function isLockTheDoor(e:EventTaomee) : void
      {
         var lockHome:uint = uint(e.EventObj.Flag);
         if(Boolean(lockHome & 2))
         {
            trace("-----------關了門");
            Alert.showAlert(MainManager.getTopLevel(),"小屋已經被上鎖，你無法進入哦！","",6,"D");
         }
         else
         {
            trace("-----------開門");
            this.switchMap();
         }
      }
      
      public function switchMap() : void
      {
         if(GV.Room_DefaultRoomID != GV.MyInfo_userID && !GV.isChangeMap)
         {
            GV.Room_DefaultRoomID = hostID;
            GF.switchMap(hostID);
         }
      }
      
      public function moveHouseBG(e:Event) : void
      {
         var actionGoods:* = undefined;
         var movingMC:MovieClip = null;
         if(_EditMode)
         {
            actionGoods = e.target.parent;
            movingMC = actionGoods.parent.parent as MovieClip;
            actionGoods.moving = !actionGoods.moving;
            if(Boolean(actionGoods.moving))
            {
               actionGoods.oldx = actionGoods.x;
               actionGoods.oldy = actionGoods.y;
               actionGoods.mc2.y -= 10;
               actionGoods.startDrag();
               HomeHitTest.moveHouseBG(actionGoods,movingMC);
               this.RootMC.addChild(actionGoods);
            }
            else
            {
               actionGoods.stopDrag();
               actionGoods.mc2.y += 10;
               this.doAction(actionGoods);
               HomeHitTest.stopMoveHouseBG();
               this.RootMC.tip_mc.visible = false;
               this.RootMC.tip_mc.x = 1000;
               this.RootMC.house_mc.addChild(actionGoods);
            }
         }
      }
      
      private function doAction(actionGoods:*) : void
      {
         if(HomeHitTest.backOldPos)
         {
            trace("碰邊復位");
            actionGoods.x = actionGoods.oldx;
            actionGoods.y = actionGoods.oldy;
            actionGoods.alpha = 1;
         }
         else
         {
            this.homeeditview.homeItemArr[0].PosX = actionGoods.x;
            this.homeeditview.homeItemArr[0].PosY = actionGoods.y;
            this.homeeditview.homeItemArr[0].Direction = actionGoods.mc2.currentFrame;
         }
      }
      
      public function moveHomeGoodsToDepot(e:EventTaomee) : void
      {
         var i:uint = 0;
         var tempObj:Object = e.EventObj.obj;
         var temp:Object = new Object();
         temp.ID = Number(tempObj.ID);
         temp.Count = 1;
         var o:Object = GoodsInfo.getInfoById(temp.ID);
         temp.Layer = o.Layer;
         try
         {
            temp.name = o.name;
            temp.PosX = tempObj.PosX;
            temp.PosY = tempObj.PosY;
            temp.Direction = Number(tempObj.Direction);
            temp.Visible = Number(tempObj.Visible);
            temp.Other = tempObj.Other;
         }
         catch(e:Error)
         {
         }
         temp.Type = o.Type;
         var id:Number = Number(temp.ID);
         var totalArrlen:uint = uint(this.depotGoodsArr[0].length);
         var objkind:Number = Number(temp.Type);
         var thisKindLen:uint = uint(this.depotGoodsArr[objkind].length);
         if(thisKindLen > 0)
         {
            for(i = 0; i < thisKindLen; i++)
            {
               if(this.depotGoodsArr[objkind][i].ID == id)
               {
                  ++this.depotGoodsArr[objkind][i].Count;
                  this.showCurrentGoods(temp);
                  break;
               }
               if(i == thisKindLen - 1)
               {
                  this.addGoodsToDepot(temp);
               }
            }
         }
         else
         {
            this.addGoodsToDepot(temp);
         }
      }
      
      private function addGoodsToDepot(temp:Object) : void
      {
         if(temp.ID != 160144)
         {
            this.depotGoodsArr[0].push(temp);
            this.depotGoodsArr[temp.Type].push(temp);
         }
         else
         {
            this.depotGoodsArr[0].unshift(temp);
            this.depotGoodsArr[temp.Type].unshift(temp);
         }
         this.showCurrentGoods(temp);
      }
      
      private function showCurrentGoods(temp:Object) : void
      {
         if(temp.Type == this.Kind || this.Kind == 0)
         {
            this.showGoods(this.Kind,this.currentPage);
         }
      }
      
      public function loadHomeground() : void
      {
         HomeBGID = this.homelogic.homeBGID;
         this.mcloader = new MCLoader(Links.getUrl("resource/home/item/swf/" + HomeBGID + ".swf"),this.RootMC,1,"正在加載家園背景...");
         BC.addEvent(this,this.mcloader,MCLoadEvent.ON_SUCCESS,this.loadBGSucc);
         BC.addEvent(this,this.mcloader,MCLoadEvent.ERROR,this.loadBGErr);
         LoaderList.getInstance().addItem(this.mcloader,null,LoaderList.HIGH);
      }
      
      private function loadBGErr(event:MCLoadEvent) : void
      {
         trace("加載出錯");
      }
      
      private function showHostInfo(e:MouseEvent) : void
      {
         userPanelView.showUserPanel(hostID);
      }
      
      private function showFarmInfo(e:MouseEvent) : void
      {
         if(!_EditMode)
         {
            GF.switchMap(hostID,false,2);
         }
      }
      
      private function loadBGSucc(event:MCLoadEvent) : void
      {
         var a:DisplayObjectContainer = event.getParent();
         var b:Loader = event.getLoader();
         var c:* = event.getContent();
         this.RootMC.type_mc.addChild(c.mc);
         var userNameMCIndex:int = MovieClip(c).getChildIndex(c.username);
         var tempUserNameMC:MovieClip = c.username;
         c.username = this.RootMC.username_mc;
         c.username.x = tempUserNameMC.x;
         c.username.y = tempUserNameMC.y;
         MovieClip(c).addChildAt(c.username,userNameMCIndex);
         MovieClip(c).removeChild(tempUserNameMC);
         c.username.txt.text = UserName;
         this.RootMC.control_mc.addChild(c.out_btn);
         c.username.buttonMode = true;
         c.username.txt.mouseEnabled = false;
         GC.clearAllChildren(this.RootMC.doorName_mc);
         this.RootMC.doorName_mc.addChild(c.username);
         BC.addEvent(this,GV.onlineSocket,"HOME_HIT",this.outHomeORinHouse);
         BC.addEvent(this,c.username.btnContain.farmBtn,MouseEvent.CLICK,this.showFarmInfo);
         BC.addEvent(this,c.username.btnContain.angelBtn,MouseEvent.CLICK,this.gotoAngelFun);
         BC.addEvent(this,c.username.btnContain.seaBtn,MouseEvent.CLICK,this.gotoSeaHouse);
         BC.addEvent(this,c.username.btnContain.pigHouseBtn,MouseEvent.CLICK,this.gotoPigHouse);
         BC.addEvent(this,c.username.btnContain.restaurantBtn,MouseEvent.CLICK,this.gotoRestaurant);
         BC.addEvent(this,c.username.btnContain,MouseEvent.ROLL_OVER,this.showBtnPanel);
         BC.addEvent(this,c.username.btnContain,MouseEvent.ROLL_OUT,this.hideBtnPanel);
         BC.addEvent(this,c.username.btnContain.mapBtn,MouseEvent.CLICK,this.openMap);
         tip.tipTailDisPlayObject(c.out_btn,"離開家園");
         tip.tipTailDisPlayObject(c.username.btnContain.farmBtn,"牧場");
         tip.tipTailDisPlayObject(c.username.btnContain.angelBtn,"天使園");
         tip.tipTailDisPlayObject(c.username.btnContain.seaBtn,"海妖館");
         tip.tipTailDisPlayObject(c.username.btnContain.pigHouseBtn,"肥肥館");
         tip.tipTailDisPlayObject(c.username.btnContain.restaurantBtn,"餐廳");
         if(Boolean(this.RootMC.bg_mc))
         {
            this.RootMC.bg_mc.addChild(c.bg);
         }
         this.initslMessBtn(c.username);
         var mcloader:MCLoader = event.target as MCLoader;
         mcloader.clear();
         this.bgLoaderOver = true;
         GC.clearAllChildren(this.RootMC.hittest_mc);
         this.RootMC.hittest_mc.addChild(c.item_mc);
         this.RootMC.hittest_mc.addChild(c.housebg_mc);
         HomeHitTest.getBMD(this.RootMC);
         if(this.ChangeBGBool)
         {
            if(Boolean(c))
            {
               while(Boolean(this.RootMC.seed_mc.numChildren))
               {
                  this.RootMC.seed_mc.removeChildAt(0);
               }
               while(Boolean(c.hitMC.numChildren))
               {
                  this.RootMC.seed_mc.addChild(c.hitMC.getChildAt(0));
               }
            }
            MapManageLogic.addBackgroud(c.bg);
         }
         else
         {
            this.checkLoadedOver(c);
         }
      }
      
      private function openMap(evt:MouseEvent) : void
      {
         ModuleManager.openPanel("HomeMapPanel");
      }
      
      private function showBtnPanel(evt:MouseEvent) : void
      {
         if(this.RootMC.username_mc.btnContain.currentFrame == 1)
         {
            this.RootMC.username_mc.btnContain.gotoAndPlay(2);
            this.RootMC.username_mc.map_mc.gotoAndPlay(2);
         }
      }
      
      private function hideBtnPanel(evt:MouseEvent) : void
      {
         this.RootMC.username_mc.btnContain.gotoAndStop(1);
         this.RootMC.username_mc.map_mc.gotoAndStop(1);
      }
      
      private function gotoSeaHouse(event:MouseEvent) : void
      {
         TaskDiceCurse.inst.openSystem();
      }
      
      private function gotoPigHouse(event:MouseEvent) : void
      {
         var obj:Object = null;
         if(hostID != LocalUserInfo.getUserID())
         {
            obj = {"friend":hostID};
            BC.addOnceEvent(this,GV.onlineSocket,"read_" + PigSocket.GetFriendsInfoCmd,this.GetFriendInfoHandler);
            PigSocket.GetFriendsInfo([obj]);
         }
         else
         {
            GF.switchToPigHouse(hostID);
         }
      }
      
      private function gotoRestaurant(evt:MouseEvent) : void
      {
         MapManageView.inst.gotoRestaurant();
      }
      
      private function GetFriendInfoHandler(e:EventTaomee) : void
      {
         var obj:HashMap = e.EventObj as HashMap;
         var tmp:int = obj.getValue(hostID);
         if(tmp == 0)
         {
            Alert.smileAlart("        它的肥肥館還沒有建好哦！");
         }
         else
         {
            GF.switchToPigHouse(hostID);
         }
      }
      
      private function gotoAngelFun(e:MouseEvent) : void
      {
         BC.removeEvent(this,e.currentTarget,MouseEvent.CLICK,this.gotoAngelFun);
         SwitchMapToAngelPark.instance.loadSwitchMV(hostID,this.RootMC.btnMC);
      }
      
      private function initslMessBtn(tempMc:MovieClip) : void
      {
         this.usernameMc = tempMc;
         BC.addEvent(this,GV.onlineSocket,"get_scene_info",this.onIsVip);
         new GetSceneUserInfoReq().getSeceeUserInfo(this.HomeObj.UserID);
      }
      
      private function onIsVip(evt:EventTaomee) : void
      {
         var syday:int = 0;
         BC.removeEvent(this,GV.onlineSocket,"get_scene_info",this.onIsVip);
         var vip:Boolean = Boolean(evt.EventObj.Vip >> 0 & 1);
         if(vip)
         {
            if(ismyhome)
            {
               syday = LocalUserInfo.vipDays;
               if(syday <= 7)
               {
                  this.RootMC.slMessBtn.gotoAndStop(1);
                  this.RootMC.slMessBtn.gotoAndStop(2);
               }
            }
            if(this.usernameMc.getChildByName("slMessBtn") == null)
            {
               this.RootMC.slMessBtn.x = 76;
               this.RootMC.slMessBtn.y = 65;
               BC.addEvent(this,this.RootMC.slMessBtn,MouseEvent.CLICK,this.onSLMessBtn);
               this.usernameMc.addChild(this.RootMC.slMessBtn);
            }
         }
         else if(ismyhome)
         {
            if(Boolean(LocalUserInfo.getVip() >> 5 & 1))
            {
               this.RootMC.slMessBtn.gotoAndStop(3);
               if(this.usernameMc.getChildByName("slMessBtn") == null)
               {
                  this.RootMC.slMessBtn.x = 76;
                  this.RootMC.slMessBtn.y = 65;
                  BC.addEvent(this,this.RootMC.slMessBtn,MouseEvent.CLICK,this.onSLMessBtn);
                  this.usernameMc.addChild(this.RootMC.slMessBtn);
               }
            }
         }
      }
      
      private function onSLMessBtn(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("module/external/SuperLamuMessageMain.swf","正在加載超級拉姆面板",MainManager.getGameLevel());
         loadGame = null;
      }
      
      private function outHomeORinHouse(e:EventTaomee) : void
      {
         var mapinfo:MapInfo = null;
         if(e.EventObj == 1)
         {
            mapinfo = MapInfo.getMapInfo(GV.MyInfo_PrevMap,LocalUserInfo.getMapType());
            if(GV.MyInfo_PrevMap >= 120 && GV.MyInfo_PrevMap <= 136)
            {
               GV.MyInfo_PrevMap = 61;
            }
            else if(mapinfo.digTreasureId > 0)
            {
               GV.MyInfo_PrevMap = 184;
            }
            GF.switchMapDirectly(GV.MyInfo_PrevMap);
         }
         else
         {
            this.gotoHouse();
         }
      }
      
      private function checkLoadedOver(c:* = null) : void
      {
         var cropManageClass:Class = null;
         if(Boolean(c))
         {
            while(Boolean(this.RootMC.seed_mc.numChildren))
            {
               this.RootMC.seed_mc.removeChildAt(0);
            }
            while(Boolean(c.hitMC.numChildren))
            {
               this.RootMC.seed_mc.addChild(c.hitMC.getChildAt(0));
            }
         }
         if(this.bgLoaderOver && this.seedLoaderOver)
         {
            cropManageClass = this.Crop_Lib.getClass("com.mole.home.CropManage");
            this.cropManage = new cropManageClass();
            BC.addEvent(this,this.cropManage,CropEvent.GROW_SUCCEED,this.updateHomeDepot);
            this.cropManage.editMode = _EditMode;
            this.cropManage.setRootMC(this.RootMC);
            this.cropManage.hostUseID = hostID;
            this.cropManage.showSeeds(this.HomeObj.plantArr);
            GV.onlineSocket.dispatchEvent(new EventTaomee("allHomeGoodsLoaded"));
            MapDepthManageLogic.compositorMapDepth();
            BC.addEvent(this,GV.onlineSocket,"read_" + 1991,this.seeDefendFun);
            defendSocket.seedefendTime(hostID,1320001);
         }
      }
      
      private function seeDefendFun(evt:EventTaomee) : void
      {
         var npcTimerNum:Number;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1991,this.seeDefendFun);
         npcTimerNum = Number(evt.EventObj.Time);
         defendNPCState.getInstance().setnpcTimer(npcTimerNum);
         GC.setGTimeout(function():void
         {
            MapDepthManageLogic.compositorMapDepth();
            MapDepthManageLogic.setAllPeopleDepth();
            if(evt.EventObj.ID == 1320001)
            {
               inteBear();
            }
            if(defendNPCState.getInstance().getnpcTimer() == 0 && evt.EventObj.ID == 1320001)
            {
               GC.setGTimeout(function():void
               {
                  var npc:I_NPC = NPC.getNPCInstance(1025);
                  if(Boolean(npc))
                  {
                     npc.closeAutoMove_And_Stop();
                     npc.say("能量不足，無法工作!");
                     npc.autoMove = false;
                     NPC.getNPCInstance(1025).showAction("Skills");
                  }
               },500);
            }
         },100);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1991,this.seeDefendHandler);
         defendSocket.seedefendTime(hostID,1320002);
      }
      
      private function seeDefendHandler(evt:EventTaomee) : void
      {
         var npcTimerNum:Number;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1991,this.seeDefendHandler);
         npcTimerNum = Number(evt.EventObj.Time);
         defendNPCState.getInstance().setCottageTimer(npcTimerNum);
         GC.setGTimeout(function():void
         {
            MapDepthManageLogic.compositorMapDepth();
            MapDepthManageLogic.setAllPeopleDepth();
            if(evt.EventObj.ID == 1320002)
            {
               inteBear(1124);
            }
            if(defendNPCState.getInstance().getCottageTimer() == 0 && evt.EventObj.ID == 1320002)
            {
               GC.setGTimeout(function():void
               {
                  var npc:I_NPC = NPC.getNPCInstance(1124);
                  if(Boolean(npc))
                  {
                     npc.closeAutoMove_And_Stop();
                     npc.say("餓死了餓死了，低能骨頭你在哪......");
                     npc.autoMove = false;
                     NPC.getNPCInstance(1124).showAction("Skills");
                  }
               },500);
            }
         },100);
      }
      
      private function inteBear(_int:int = 1025) : void
      {
         NPC.getNPCInstance(_int,true);
         if(hostID != LocalUserInfo.getUserID())
         {
            NPC.getNPCInstance(_int,true).hideButton();
         }
      }
      
      private function clearBear() : void
      {
         var npc:I_NPC = NPC.getNPCInstance(1025);
         if(Boolean(npc))
         {
            npc.clearClass();
         }
      }
      
      private function updateHomeDepot(e:EventTaomee) : void
      {
         var temp:* = undefined;
         if(e.EventObj.id == 1230136)
         {
            GF.sendSocket(CommandID.cli_proto_recoder_older_entrust_times,505,1);
         }
         for(var i:uint = 0; i < 10; i++)
         {
            temp = this.homeUIMC["I" + i];
            if(temp.ID == e.EventObj.ID)
            {
               this.moveGoodsToHouse(temp);
               return;
            }
         }
      }
      
      private function getLib() : void
      {
         BC.addEvent(this,this.Crop_Lib,AssetsManage.ON_COMPLETE,this.loadLibcomplete);
         this.Crop_Lib.IncludeLib("Crop_Lib","module/home/CropManage.swf","正在加載莊稼...");
      }
      
      private function loadLibcomplete(E:Event) : void
      {
         BC.removeEvent(this,this.Crop_Lib,AssetsManage.ON_COMPLETE,this.loadLibcomplete);
         this.seedLoaderOver = true;
         this.checkLoadedOver();
      }
      
      private function openMoleHome(e:MouseEvent = null) : void
      {
         HomeHot.showPanel();
      }
      
      private function AutoSaveHome() : void
      {
         this.saveHome();
      }
      
      private function dosaveHome(e:MouseEvent) : void
      {
         this.EditMode = false;
         HomeEditView.Editable = _EditMode;
         this.cropManage.editMode = _EditMode;
         this.RootMC.homeUIMC.y = this.UIPosY;
         this.RootMC.btnMC.save_btn.visible = false;
         MainManager.getToolLevel().y = 0;
         MoveTo.CanMove = true;
         this.homelogic.showPeople();
         this.saveHome();
         MapDepthManageLogic.compositorMapDepth();
      }
      
      private function openHomeDepot(e:MouseEvent) : void
      {
         if(!this.EditMode)
         {
            this.RootMC.homeUIMC.y = 440;
            this.EditMode = !_EditMode;
            HomeEditView.Editable = _EditMode;
            this.cropManage.editMode = _EditMode;
            this.RootMC.btnMC.save_btn.visible = _EditMode;
            GF.clearPeoples();
            MainManager.getToolLevel().y = 1000;
            MoveTo.CanMove = false;
            BC.addEvent(this,this.homelogic,HomeLogic.GET_DEPOT_GOODS,this.getDepotGoods);
            this.homelogic.HomeDepotReq();
         }
         else
         {
            this.OpenClosedepot();
         }
      }
      
      private function getDepotGoods(e:EventTaomee) : void
      {
         BC.removeEvent(this,this.homelogic,HomeLogic.GET_DEPOT_GOODS,this.getDepotGoods);
         this.depotGoodsArr = e.EventObj.arr;
         this.initBtnEvent();
         this.showGoods(0,1);
      }
      
      private function initBtnEvent() : void
      {
         for(var i:uint = 0; i < 8; i++)
         {
            if(i != 0)
            {
               this.homeUIMC["kind" + i].gotoAndStop(2);
            }
            BC.addEvent(this,this.homeUIMC["kind" + i].btn,MouseEvent.CLICK,this.showKindGoods);
         }
         BC.addEvent(this,this.homeUIMC.prev_btn,MouseEvent.CLICK,this.prevPage);
         BC.addEvent(this,this.homeUIMC.next_btn,MouseEvent.CLICK,this.nextPage);
      }
      
      private function showKindGoods(e:MouseEvent) : void
      {
         var tempkind:Number = Number(e.target.parent.name.slice(4,5));
         if(this.Kind != tempkind)
         {
            this.Kind = tempkind;
            this.changeBtn(this.Kind);
            this.showGoods(this.Kind,1);
         }
      }
      
      public function saveHome() : void
      {
         this.homelogic.savehome(this.getHomeItem(),this.homeeditview.getgoodsArr());
      }
      
      private function onBtnOver(e:MouseEvent) : void
      {
         e.target.parent.gotoAndStop(2);
         var goods:* = e.currentTarget.parent;
         GF.showTip(goods.Name,{
            "noDelay":true,
            "x":goods.x + 64,
            "y":goods.y + 430
         });
      }
      
      private function onBtnOut(E:MouseEvent) : void
      {
         E.target.parent.gotoAndStop(1);
      }
      
      private function prevPage(E:MouseEvent) : void
      {
         if(this.currentPage > 1)
         {
            this.showGoods(this.Kind,--this.currentPage);
         }
      }
      
      private function nextPage(E:MouseEvent) : void
      {
         if(this.depotGoodsArr[this.Kind].length > this.currentPage * this.NUM)
         {
            this.showGoods(this.Kind,++this.currentPage);
         }
      }
      
      private function showGoods(tempkind:uint, pagenum:uint) : void
      {
         var temp:* = undefined;
         var tempLoader:Loader = null;
         this.Kind = tempkind;
         this.currentPage = pagenum;
         try
         {
            this.clearItems();
         }
         catch(e:Error)
         {
         }
         for(var i:uint = (this.currentPage - 1) * this.NUM; i < this.currentPage * this.NUM; i++)
         {
            temp = this.homeUIMC["I" + (i - (this.currentPage - 1) * this.NUM)];
            try
            {
               BC.removeEvent(this,temp.btn,MouseEvent.CLICK,this.userPorp);
            }
            catch(e:Error)
            {
            }
            if(this.depotGoodsArr[this.Kind][i] != null)
            {
               temp.num = i;
               temp.ID = this.depotGoodsArr[this.Kind][i].ID;
               try
               {
                  temp.num_txt.text = this.depotGoodsArr[this.Kind][i].Count;
               }
               catch(e:Error)
               {
               }
               temp.obj = this.depotGoodsArr[this.Kind][i];
               temp.Type = this.depotGoodsArr[this.Kind][i].Type;
               temp.Name = this.depotGoodsArr[this.Kind][i].name;
               temp.Count = this.depotGoodsArr[this.Kind][i].Count;
               temp.Layer = this.depotGoodsArr[this.Kind][i].Layer;
               temp.Price = this.depotGoodsArr[this.Kind][i].price;
               temp.Class = this.depotGoodsArr[this.Kind][i].Class;
               temp.Grade = this.depotGoodsArr[this.Kind][i].Grade;
               temp.btn.visible = true;
               BC.addEvent(this,temp.btn,MouseEvent.MOUSE_OVER,this.onBtnOver);
               BC.addEvent(this,temp.btn,MouseEvent.MOUSE_OUT,this.onBtnOut);
               BC.addEvent(this,temp.btn,MouseEvent.CLICK,this.userPorp);
               tempLoader = new Loader();
               trace("load ----" + this.depotGoodsArr[this.Kind][i].ID);
               if(this.depotGoodsArr[this.Kind][i].ID > 1230000)
               {
                  tempLoader.load(VL.getURLRequest("resource/home/seed/icon/" + this.depotGoodsArr[this.Kind][i].ID + ".swf"));
               }
               else
               {
                  tempLoader.load(VL.getURLRequest("resource/home/item/icon/" + this.depotGoodsArr[this.Kind][i].ID + ".swf"));
               }
               temp.loadimg.addChild(tempLoader);
            }
            else
            {
               temp.btn.enabled = false;
            }
         }
      }
      
      private function userPorp(E:MouseEvent) : void
      {
         if(!hasAlert)
         {
            if(this.homeeditview.goodsNum <= 99 || E.target.parent.Layer == 8)
            {
               this.tempGoods = E.target.parent;
               this.tempGoodsObj = {
                  "ID":this.tempGoods.ID,
                  "PosX":0,
                  "PosY":0,
                  "Direction":1,
                  "Visible":0,
                  "Layer":this.tempGoods.Layer,
                  "Type":this.tempGoods.Type,
                  "Other":this.tempGoods.Other
               };
               if(this.tempGoodsObj.Layer != 8)
               {
                  if(this.getItemBool(this.tempGoods))
                  {
                     if(this.tempGoods.Type == 2)
                     {
                        if(this.tempGoods.obj.buyLevel == 0 || this.tempGoods.obj.buyLevel == null)
                        {
                           this.cropManage.startDragSeed(this.tempGoods.obj);
                        }
                        else
                        {
                           this.checkIsBuy();
                        }
                     }
                     else
                     {
                        this.homeeditview.loadNewGoods(this.tempGoodsObj);
                        this.moveGoodsToHouse(this.tempGoods);
                     }
                  }
               }
               else
               {
                  hasAlert = true;
                  this.backAlert = Alert.showAlert(MainManager.getAppLevel(),"","更換背景會把所有物品放回倉庫中，所有的植物會被連根拔起，是否確定？",Alert.SELECT_ALERT);
                  BC.addEvent(this,this.backAlert,"CLICK" + 1,this.backAllGoods);
                  BC.addEvent(this,this.backAlert,"CLICK" + 2,this.removeinit);
               }
            }
            else
            {
               Alert.showAlert(MainManager.getAppLevel(),"","你的家園東西太多了，已經超過最大上限無法擺放了！",Alert.IKNOW_ALERT);
            }
         }
      }
      
      private function checkIsBuy() : void
      {
         GV.onlineSocket.addEventListener("read_" + 1911,this.onRead_1911);
         homeSocket.queryPlantAndFarm(HomeView.hostID);
      }
      
      private function onRead_1911(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 1911,this.onRead_1911);
         this.cropManage.startDragSeed(this.tempGoods.obj);
      }
      
      private function getItemBool(temp:Object) : Boolean
      {
         var id:uint = uint(temp.ID);
         var objkind:Number = Number(temp.Type);
         var thisKindLen:uint = uint(this.depotGoodsArr[objkind].length);
         for(var i:uint = 0; i < thisKindLen; i++)
         {
            if(this.depotGoodsArr[objkind][i].ID == id)
            {
               if(this.depotGoodsArr[objkind][i].Count >= 1)
               {
                  return true;
               }
               return false;
            }
         }
         return false;
      }
      
      private function backAllGoods(e:Event = null) : void
      {
         GF.clearPeoples();
         hasAlert = false;
         this.moveGoodsToHouse(this.tempGoods);
         this.homeeditview.changeBG(this.tempGoodsObj);
      }
      
      private function removeinit(e:Event) : void
      {
         hasAlert = false;
         BC.removeEvent(this,this.backAlert,"CLICK" + 1,this.backAllGoods);
         BC.removeEvent(this,this.backAlert,"CLICK" + 2,this.removeinit);
      }
      
      private function moveGoodsToHouse(temp:Object) : void
      {
         var id:uint = uint(temp.ID);
         var totalArrlen:uint = uint(this.depotGoodsArr[0].length);
         var objkind:Number = Number(temp.Type);
         var thisKindLen:uint = uint(this.depotGoodsArr[objkind].length);
         for(var i:uint = 0; i < thisKindLen; i++)
         {
            if(this.depotGoodsArr[objkind][i].ID == id)
            {
               --this.depotGoodsArr[objkind][i].Count;
               temp.Count = this.depotGoodsArr[objkind][i].Count;
               if(this.depotGoodsArr[objkind][i].Count < 1)
               {
                  this.depotGoodsArr[objkind].splice(i,1);
                  this.removeOneInAll(id);
                  if(this.depotGoodsArr[this.Kind].length % this.NUM != 0)
                  {
                     this.showGoods(this.Kind,this.currentPage);
                  }
                  else
                  {
                     if(this.currentPage > 1)
                     {
                        --this.currentPage;
                     }
                     this.showGoods(this.Kind,this.currentPage);
                  }
               }
               else
               {
                  temp.num_txt.text = this.depotGoodsArr[objkind][i].Count;
               }
               break;
            }
         }
      }
      
      private function getHomeItem() : Array
      {
         var arr:Array = new Array();
         var totalArrlen:uint = uint(this.depotGoodsArr[0].length);
         for(var i:uint = 0; i < totalArrlen; i++)
         {
            if(this.depotGoodsArr[0][i].Type != 2)
            {
               arr.push(this.depotGoodsArr[0][i]);
            }
         }
         return arr;
      }
      
      private function removeOneInAll(id:uint) : void
      {
         var totalArrlen:uint = uint(this.depotGoodsArr[0].length);
         for(var i:uint = 0; i < totalArrlen; i++)
         {
            if(id == this.depotGoodsArr[0][i].ID)
            {
               this.depotGoodsArr[0].splice(i,1);
               break;
            }
         }
      }
      
      private function clearItems() : void
      {
         var temp:Object = null;
         for(var i:uint = 0; i < this.NUM; i++)
         {
            temp = this.homeUIMC["I" + i];
            if(temp.num != null)
            {
               temp.loadimg.removeChildAt(0);
               temp.num = null;
               temp.type = null;
               temp.btn.visible = false;
               temp.num_txt.text = "";
            }
         }
      }
      
      private function changeBtn(j:uint) : void
      {
         for(var i:uint = 0; i < 8; i++)
         {
            if(i == j)
            {
               this.homeUIMC["kind" + i].gotoAndStop(1);
            }
            else
            {
               this.homeUIMC["kind" + i].gotoAndStop(2);
            }
         }
      }
      
      private function removeEventHandler(E:Event) : void
      {
         MoveTo.CanMove = true;
         GV.MAN_PEOPLE.visible = true;
         this.temp_JJL = null;
         this.ChangeBGBool = false;
         this.cropManage.clearCrop();
         InHome = false;
         this.bgLoaderOver = false;
         this.seedLoaderOver = false;
         this.EditMode = false;
         BC.removeEvent(this);
         SoundMixer.stopAll();
         GC.stopAllMC(this.RootMC);
         if(Boolean(newUserLightMC))
         {
            MainManager.getGameLevel().removeChild(newUserLightMC);
            newUserLightMC = null;
            newUserLight = null;
         }
         SystemEventManager.removeEventListener("a7_checkWork",this.onCheckWork);
         SystemEventManager.removeEventListener("a7_checkState",this.onCheckState);
         SystemEventManager.removeEventListener("a7_feed",this.onFeed);
         SystemEventManager.removeEventListener("a7_putOut",this.onPutOut);
         GC.clearGInterval(this.sayNpcTimer);
      }
      
      private function OpenClosedepot(e:Event = null) : void
      {
         if(this.RootMC.homeUIMC.y < 500)
         {
            this.RootMC.homeUIMC.y = this.UIPosY;
         }
         else
         {
            this.RootMC.homeUIMC.y = 440;
         }
      }
      
      public function ShowGameCardTip(e:MouseEvent) : void
      {
         GF.showTip(UserName + "的卡片王手冊");
      }
      
      public function HideGameCardTip(e:MouseEvent) : void
      {
         GF.clearTip();
      }
      
      public function openGameCard(e:MouseEvent) : void
      {
         GF.updateLocalGameHighScore("cardbook" + LocalUserInfo.getUserID(),book_ver);
         BC.addEvent(this,GV.onlineSocket,"jjlcard_mc",this.removeJJLFun);
         if(ismyhome)
         {
            this.loadUI("module/external/CardUI/JJLCardBookView.swf?v=20120726");
         }
         else
         {
            this.loadUI("module/external/CardUI/JJLOtherUI.swf?v=20120726");
         }
      }
      
      private function removeJJLFun(eve:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"jjlcard_mc",this.removeJJLFun);
         MainManager.getAppLevel().removeChild(this.temp_JJL);
         this.temp_JJL = null;
      }
      
      private function loadUI(url:String) : void
      {
         this.mcloader = new MCLoader(url,MainManager.getAppLevel(),1,"正在打開吉吉樂卡片王手冊...");
         this.mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadSucc);
         this.mcloader.addEventListener(MCLoadEvent.ERROR,this.loadErr);
         this.mcloader.doLoad();
      }
      
      private function loadErr(event:MCLoadEvent) : void
      {
         trace("加載出錯");
      }
      
      private function loadSucc(event:MCLoadEvent) : void
      {
         var a:DisplayObjectContainer = event.getParent();
         var b:Loader = event.getLoader();
         var c:DisplayObject = event.getContent();
         this.temp_JJL = c;
         MainManager.getAppLevel().addChild(c);
         trace("loadSucc",c.name);
         var mcloader:MCLoader = event.target as MCLoader;
         mcloader.clear();
      }
      
      public function set EditMode(b:Boolean) : void
      {
         if(b)
         {
            if(!_EditMode)
            {
               this.clearBear();
            }
         }
         else if(_EditMode)
         {
            if(defendNPCState.getInstance().getnpcTimer() != 0)
            {
               this.inteBear();
            }
            if(defendNPCState.getInstance().getCottageTimer() != 0)
            {
               this.inteBear(1124);
            }
         }
         _EditMode = b;
      }
      
      public function get EditMode() : Boolean
      {
         return _EditMode;
      }
   }
}

