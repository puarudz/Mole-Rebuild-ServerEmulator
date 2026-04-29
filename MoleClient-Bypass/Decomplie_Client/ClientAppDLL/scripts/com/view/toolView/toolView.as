package com.view.toolView
{
   import com.common.Alert.Alert;
   import com.common.Tween.TweenLite;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.core.loading.Loading;
   import com.core.manager.UIManager;
   import com.core.newloader.LoaderList;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.staticData.CommandID;
   import com.global.staticData.MapsConfig;
   import com.global.staticData.XMLInfo;
   import com.logic.JobLogic.PetJobLogic;
   import com.logic.actionMc.ActionMc;
   import com.logic.expressionLogic.expressionLogic;
   import com.logic.mapEvent.WordMapLogic_DXSL;
   import com.logic.mapEvent.WordMapLogic_DigTreasure;
   import com.logic.mapEvent.WordMapLogic_HSL;
   import com.logic.mapEvent.WordMapLogic_MLD;
   import com.logic.mapEvent.WordMapLogic_OldHSL;
   import com.logic.mapEvent.WordMapLogic_YS;
   import com.logic.socket.GetLimitStatus;
   import com.logic.socket.callSuperLamu.CallSuperLamu;
   import com.logic.socket.home.HomeCarSocket;
   import com.logic.task.SummerActivityCtr;
   import com.logic.toolLogic.toolLogic;
   import com.module.PlayMoleTime.PlayMoleTime;
   import com.module.friendList.friendView.listView;
   import com.module.messagesModule.messagesView.messagesView;
   import com.module.pet.petLogic;
   import com.module.present.PresentManager;
   import com.module.specialTool.specialLogic;
   import com.mole.app.manager.ActivityTmpDataManager;
   import com.mole.app.manager.BagViewManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.StatisticsManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.type.ModuleType;
   import com.mole.net.events.SocketEvent;
   import com.taomee.mole.library.utils.TimeFormat;
   import com.view.MapManageView.ImageLevelManager;
   import com.view.PeopleView.PeopleManageView;
   import com.view.activetyView.SuperPetPanel;
   import com.view.mapView.activity.Task83.Anniversary;
   import com.view.mapView.activity.Task83.SuperPrivilegeCtl;
   import com.view.toolView.tool.ToolPlugInMenu;
   import com.view.toolView.tool.ToolSystemMenu;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.getDefinitionByName;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   import org.taomee.net.SocketEvent;
   
   public class toolView extends Sprite
   {
      
      private static var instance:toolView;
      
      private static var toolBtnList:Array;
      
      public static var SHOWBAG_EVENT:String = "showBag_Event";
      
      public static var hasClassroomBool:Boolean = false;
      
      private var target_mc:MovieClip;
      
      private var _specialLogic:specialLogic;
      
      private var _plugInMenu:ToolPlugInMenu;
      
      private var _systemMenu:ToolSystemMenu;
      
      private var tipsDisappear:* = null;
      
      public var mapMC:MovieClip;
      
      public var friendListMC:MovieClip;
      
      public var friendMC:MovieClip;
      
      public var houseMC:MovieClip;
      
      public var infoMC:MovieClip;
      
      public var infoClass:MCLoader;
      
      public var expressionClass:expressionLogic;
      
      private var nowTimeTxt:TextField;
      
      public function toolView()
      {
         super();
         if(Boolean(GV.MyInfo_PetObj) && Boolean(GV.MyInfo_PetObj.SpriteID))
         {
            GV.PetJobLogics.chartNowPetClass(GV.MyInfo_PetObj.SpriteID);
            GV.PetJobLogics.addEventListener(PetJobLogic.CHARTONEALLINFO,getPetJob);
            if(ImageLevelManager.getImageQuality() != "")
            {
               ImageLevelManager.setImageLevel(ImageLevelManager.getImageQuality());
            }
         }
      }
      
      public static function getInstance() : toolView
      {
         if(instance == null)
         {
            instance = new toolView();
         }
         return instance;
      }
      
      public static function setToolBtns(expression:int = 1, language:int = 1, action:int = 1, special:int = 1, bag:int = 1, friend:int = 1, house:int = 1, classRoom:int = 1, sound:int = 1, map:int = 1, pet:int = 1, grid:int = 1, mall:int = 1, moling:int = 1) : void
      {
         toolBtnList[0].visible = expression;
         toolBtnList[1].visible = language;
         toolBtnList[2].visible = action;
         toolBtnList[3].visible = special;
         toolBtnList[4].visible = bag;
         toolBtnList[5].visible = friend;
         toolBtnList[6].visible = house;
         toolBtnList[7].visible = classRoom;
         toolBtnList[9].visible = map;
         toolBtnList[10].visible = pet;
         toolBtnList[12].visible = grid;
         toolBtnList[13].visible = mall;
         toolBtnList[14].visible = moling;
      }
      
      public static function getPetJob(e:EventTaomee) : void
      {
         GV.MyInfo_PetObj.Job = e.EventObj.obj.Arr;
      }
      
      private static function openEKOPanel(e:Event) : void
      {
         ModuleManager.openPanel("ElementKnightTransferPanel");
      }
      
      public function show() : void
      {
         TweenLite.to(this.target_mc,0.3,{"y":toolLogic.TOOL_Y});
      }
      
      public function hide() : void
      {
         TweenLite.to(this.target_mc,0.3,{"y":toolLogic.TOOL_Y + 200});
      }
      
      public function init(target:MovieClip) : void
      {
         this._specialLogic = new specialLogic(this);
         this.expressionClass = new expressionLogic();
         GV.MC_ToolView = target;
         this.target_mc = target;
         this.toolViewInit();
      }
      
      private function LahmHungry(evt:EventTaomee) : void
      {
         setTimeout(function():void
         {
            try
            {
               if(PeopleManageView(GV.MAN_PEOPLE).Petlevel > 1 && PeopleManageView(GV.MAN_PEOPLE).Petlevel != 101 && petLogic.PetMagicCan(103) || PeopleManageView(GV.MAN_PEOPLE).Petlevel == 101)
               {
                  PeopleManageView(GV.MAN_PEOPLE).lamu_say("小主人，快回牧場看看吧，我感應到動物們在挨餓了。");
               }
            }
            catch(err:Error)
            {
            }
         },2000);
      }
      
      private function onRead_251(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 251,this.onRead_251);
         var moleObj:PeopleManageView = GF.getPeopleByID(evt.EventObj.UserID) as PeopleManageView;
         var slobj:Object = evt.EventObj;
         if(slobj.UserID == LocalUserInfo.getUserID())
         {
            petLogic.updateGVPetInfo(slobj);
            PeopleManageView(GV.MAN_PEOPLE).addEffect("slMovie");
            if(moleObj.Petlevel > 1)
            {
               moleObj.backPet();
            }
         }
         this.dopetFollowOrBack(slobj,moleObj);
      }
      
      private function dopetFollowOrBack(obj:Object, mole:MovieClip) : void
      {
         if(Boolean(obj.Status))
         {
            if(obj.UserID == LocalUserInfo.getUserID())
            {
               petLogic.updateGVPetInfo(obj);
               GV.PetJobLogics.chartNowPetClass(obj.SpriteID);
               GV.PetJobLogics.addEventListener(PetJobLogic.CHARTONEALLINFO,getPetJob);
            }
            mole.PetID = obj.SpriteID;
            mole.PetColor = obj.Color;
            mole.Petlevel = obj.Level;
            mole.PetSkill = obj.Skill;
            mole.PetCloth = obj.Cloth;
            mole.Pet_cloth = obj.Cloth;
            mole.PetHonor = obj.Honor;
            mole.PetObj = obj;
            mole.addPet();
            GV.onlineSocket.addEventListener("read_" + 251,this.onRead_251);
         }
      }
      
      public function clickPlugBtn() : void
      {
         this.target_mc.plug_btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      }
      
      public function toolViewInit() : void
      {
         var toolBar_MC:Object = null;
         if(Boolean(ActivityTmpDataManager.task382OverPanel_obj))
         {
            if(ActivityTmpDataManager.task382OverPanel_obj._goId == 15)
            {
               BC.addEvent(this,GV.onlineSocket,"task382overpanel3_openVipPetUI",function(e:Event):void
               {
                  petBtnHandler();
               });
            }
         }
         GV.onlineSocket.addEventListener("read_" + 251,this.onRead_251);
         GV.onlineSocket.addEventListener("read_" + 1376,this.LahmHungry);
         new PlayMoleTime(this.target_mc.moleHead_mc);
         GV.onlineSocket.addEventListener(SHOWBAG_EVENT,this.onOpenBag);
         this.target_mc.oneINhouse2_btn.visible = false;
         this.target_mc.oneINhouse2_btn.addEventListener(MouseEvent.CLICK,this.showHouseAndStopFun);
         this.nowTimeTxt = this.target_mc.nowTime_txt;
         this.target_mc.house2_btn.addEventListener(MouseEvent.CLICK,this.showHouseAndStopFun);
         tip.tipTailDisPlayObject(this.target_mc.house2_btn,"我的家園");
         BC.addEvent(this,this.target_mc.cabin_btn,MouseEvent.CLICK,this.onOpenWineshopGame);
         tip.tipTailDisPlayObject(this.target_mc.cabin_btn,"我的天使");
         BC.addEvent(this,this.target_mc.moling_btn,MouseEvent.CLICK,this.onmoling);
         tip.tipTailDisPlayObject(this.target_mc.moling_btn,"摩靈傳說");
         this.target_mc.expression_btn.addEventListener(MouseEvent.CLICK,this.showExpression);
         tip.tipTailDisPlayObject(this.target_mc.expression_btn,"我的表情");
         this.target_mc.language_btn.addEventListener(MouseEvent.CLICK,this.showLanguage);
         tip.tipTailDisPlayObject(this.target_mc.language_btn,"快捷語言");
         this.target_mc.action_btn.addEventListener(MouseEvent.CLICK,this.showAction);
         tip.tipTailDisPlayObject(this.target_mc.action_btn,"我的動作");
         this.target_mc.special_btn.addEventListener(MouseEvent.CLICK,this.showSpecial);
         tip.tipTailDisPlayObject(this.target_mc.special_btn,"投擲道具");
         this.target_mc.bag_btn.addEventListener(MouseEvent.CLICK,this.onOpenBag);
         tip.tipTailDisPlayObject(this.target_mc.bag_btn,"百寶箱");
         this.target_mc.friend_btn.addEventListener(MouseEvent.CLICK,this.showFriend);
         tip.tipTailDisPlayObject(this.target_mc.friend_btn,"好友列表");
         this.target_mc.map_btn.addEventListener(MouseEvent.CLICK,this.showMap);
         this.target_mc.map_btn.addEventListener(MouseEvent.ROLL_OVER,this.showExtendFun);
         this.target_mc.map_btn.buttonMode = true;
         BC.addEvent(this,this.target_mc.mall_btn,MouseEvent.CLICK,this.mallBtnHandler);
         this.target_mc.lamugradepanel.x = -1000;
         this.target_mc.petBtn.buttonMode = true;
         this.target_mc.petBtn.addEventListener(MouseEvent.CLICK,this.petBtnHandler);
         this.target_mc.lamugradepanel.addEventListener(MouseEvent.CLICK,this.petBtnHandler);
         this.target_mc.lamugradepanel.btn1.addEventListener(MouseEvent.CLICK,this.onPetPanelBtnClick);
         this.target_mc.lamugradepanel.btn2.addEventListener(MouseEvent.CLICK,this.onPetPanelBtnClick);
         this.target_mc.petBtn.addEventListener(MouseEvent.ROLL_OVER,this.petBtnOverHandler);
         this.target_mc.petBtn.addEventListener(MouseEvent.ROLL_OUT,this.petBtnOutHandler);
         try
         {
            toolBar_MC = MainManager.getToolLevel().getChildByName("tool_mc");
            if(toolBar_MC != null)
            {
               if(GV.MAN_PEOPLE.address != "0")
               {
                  toolBar_MC.special_btn.visible = false;
                  toolBar_MC.action_btn.visible = false;
               }
               else
               {
                  toolBar_MC.special_btn.visible = true;
                  toolBar_MC.action_btn.visible = true;
               }
            }
         }
         catch(E:*)
         {
         }
         toolBtnList = [];
         toolBtnList[0] = this.target_mc.expression_btn;
         toolBtnList[1] = this.target_mc.language_btn;
         toolBtnList[2] = this.target_mc.action_btn;
         toolBtnList[3] = this.target_mc.special_btn;
         toolBtnList[4] = this.target_mc.bag_btn;
         toolBtnList[5] = this.target_mc.friend_btn;
         toolBtnList[6] = this.target_mc.house2_btn;
         toolBtnList[7] = this.target_mc.plug_btn;
         toolBtnList[9] = this.target_mc.map_btn;
         toolBtnList[10] = this.target_mc.petBtn;
         toolBtnList[11] = this.target_mc.oneINhouse2_btn;
         toolBtnList[12] = this.target_mc.cabin_btn;
         toolBtnList[13] = this.target_mc.mall_btn;
         toolBtnList[14] = this.target_mc.moling_btn;
         this._plugInMenu = new ToolPlugInMenu(this.target_mc["plug_btn"],this.target_mc["plugCon"]);
         this._systemMenu = new ToolSystemMenu(this.target_mc["extend_mc"]);
         setInterval(this.updateSysTime,1000);
         GV.onlineSocket.addEventListener(SocketEvent.DATA + CommandID.cli_proto_get_limit_info,this.onGetInfo);
         GetLimitStatus.send([10018]);
      }
      
      private function onGetInfo(e:com.mole.net.events.SocketEvent) : void
      {
         var flag:uint = 0;
         GV.onlineSocket.removeEventListener(SocketEvent.DATA + CommandID.cli_proto_get_limit_info,this.onGetInfo);
         var arr:Array = e.bodyInfo.getInfo as Array;
         flag = uint(arr[0]);
         if(flag >= 3)
         {
            this.target_mc["bubble_mc"].gotoAndStop(1);
            this.target_mc["bubble_mc"].visible = false;
         }
      }
      
      private function updateSysTime() : void
      {
         var date:Date = ServerUpTime.getInstance().valueDate;
         this.nowTimeTxt.text = TimeFormat.getTimeStr(date,TimeFormat.TIME_FORMAT_HHMMSS);
      }
      
      private function showExtendFun(evt:MouseEvent) : void
      {
         StatisticsManager.send(492);
         this._systemMenu.show();
      }
      
      private function mallBtnHandler(evt:MouseEvent) : void
      {
         StatisticsManager.send(490);
         Anniversary.getInstance().openMoleShop();
      }
      
      private function onOpenWineshopGame(evt:MouseEvent = null) : void
      {
         StatisticsManager.send(487);
         ModuleManager.openPanel("NewAngelBagPanel");
      }
      
      private function onmoling(evt:MouseEvent = null) : void
      {
         StatisticsManager.send(484);
         ModuleManager.openPanel("MagicSpiritMainPanel");
      }
      
      private function getKnightTransferState(evt:org.taomee.net.SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.GET_KNIGHT_TRANSFER_STATE,this.getKnightTransferState);
         var recData:ByteArray = evt.data as ByteArray;
         var typeIndex:uint = recData.readUnsignedInt();
         if(typeIndex > 0)
         {
            ModuleManager.openPanel("ElementKnightInfoPanel");
         }
         else
         {
            Alert.smileAlart("你還沒有就職成元素騎士哦，是否前往就職？",openEKOPanel);
         }
      }
      
      private function showHouseAndStopFun(e:MouseEvent = null) : void
      {
         StatisticsManager.send(488);
         MapManager.enterMap(0,1);
      }
      
      private function showExpression(evt:MouseEvent = null) : void
      {
         this.expressionClass.showExpressionBorder(this.target_mc.expression_mc);
      }
      
      private function showLanguage(evt:MouseEvent = null) : void
      {
         var tempClass:messagesView = null;
         if(!MainManager.getAppLevel().getChildByName("messagesMC"))
         {
            this.target_mc.cc = "";
            tempClass = new messagesView();
            GV.onlineSocket.dispatchEvent(new Event("show_language"));
         }
      }
      
      private function showAction(evt:MouseEvent = null) : void
      {
         StatisticsManager.send(482);
         ActionMc.inst.show();
      }
      
      private function showSpecial(evt:MouseEvent = null) : void
      {
         if(!GV.MAN_PEOPLE.isMoving && !GV.isChangeMap)
         {
            StatisticsManager.send(483);
            this._specialLogic.showSpecialPanel();
         }
      }
      
      private function onOpenBag(evt:* = null) : void
      {
         StatisticsManager.send(485);
         BagViewManager.openBag();
      }
      
      private function petBtnOverHandler(e:MouseEvent) : void
      {
         var textWord:String = null;
         var dueDate:Number = LocalUserInfo.getSLEndTime() * 1000;
         var nowDate:Number = ServerUpTime.getInstance().valueDate.time;
         var numDays:int = (dueDate - nowDate.valueOf()) / (24 * 3600 * 1000) + 1;
         var SLVipMonthArrNum:int = LocalUserInfo.getSLstar();
         if(SLVipMonthArrNum >= XMLInfo.SLVipMonthArr.length)
         {
            SLVipMonthArrNum = XMLInfo.SLVipMonthArr.length - 1;
         }
         var SLNextValue:int = XMLInfo.SLVipMonthArr[SLVipMonthArrNum][1] - LocalUserInfo.getSLValue();
         if(SLNextValue < 0)
         {
            SLNextValue = 0;
         }
         SLNextValue /= 5;
         if(LocalUserInfo.isVIP())
         {
            this.target_mc.lamugradepanel.lamugradeTip.visible = true;
            this.target_mc.lamugradepanel.lamugradeTip.gotoAndStop(LocalUserInfo.getSLstar());
            this.target_mc.lamugradepanel.btn1.visible = false;
            this.target_mc.lamugradepanel.btn2.visible = true;
            this.target_mc.lamugradepanel.txt1.visible = false;
            this.target_mc.lamugradepanel.txt2.visible = true;
            textWord = "                                                       擁有超能力：<FONT color =\'#FF0000\'><B>" + numDays + "</B></FONT>天\n" + "升級還需要：<FONT color =\'#FF0000\'><B>" + SLNextValue + "</B></FONT>天";
            this.target_mc.lamugradepanel.txt2.htmlText = "<b><u>召喚超級拉姆</u></b>";
         }
         else if(LocalUserInfo.onceIsVIP())
         {
            this.target_mc.lamugradepanel.lamugradeTip.visible = true;
            this.target_mc.lamugradepanel.lamugradeTip.gotoAndStop(LocalUserInfo.getSLstar());
            this.target_mc.lamugradepanel.btn1.visible = false;
            this.target_mc.lamugradepanel.btn2.visible = true;
            this.target_mc.lamugradepanel.txt1.visible = false;
            this.target_mc.lamugradepanel.txt2.visible = true;
            textWord = "你的超級拉姆能力消失了<FONT color =\'#FF0000\'><B>1天";
            this.target_mc.lamugradepanel.txt2.htmlText = "<b><u>我要超級拉姆</u></b>";
         }
         else
         {
            this.target_mc.lamugradepanel.lamugradeTip.visible = false;
            this.target_mc.lamugradepanel.btn1.visible = true;
            this.target_mc.lamugradepanel.btn2.visible = true;
            this.target_mc.lamugradepanel.txt1.visible = true;
            this.target_mc.lamugradepanel.txt2.visible = true;
            textWord = "超級拉姆擁有神奇能力，帶你玩轉莊園！";
            this.target_mc.lamugradepanel.txt1.htmlText = "<b><u>了解超級拉姆特權</u></b>";
            this.target_mc.lamugradepanel.txt2.htmlText = "<b><u>我要超級拉姆</u></b>";
         }
         TextField(this.target_mc.lamugradepanel.txt).htmlText = textWord;
         if(this.tipsDisappear != null)
         {
            clearTimeout(this.tipsDisappear);
         }
         if(this.target_mc.lamugradepanel.x < 0)
         {
            this.target_mc.lamugradepanel.x = 883;
            this.target_mc.lamugradepanel.y = 139;
            this.target_mc.lamugradepanel.scaleX = 0.2;
            this.target_mc.lamugradepanel.scaleY = 0.2;
            TweenLite.to(this.target_mc.lamugradepanel,0.3,{
               "scaleX":1,
               "scaleY":1
            });
         }
      }
      
      private function petBtnOutHandler(e:MouseEvent) : void
      {
         this.tipsDisappear = setTimeout(function():void
         {
            target_mc.lamugradepanel.x = -1000;
         },2000);
         this.target_mc.lamugradepanel.addEventListener(MouseEvent.ROLL_OVER,this.petTipsOverHandler);
      }
      
      private function onPetPanelBtnClick(e:MouseEvent) : void
      {
         var superPetLogin:* = undefined;
         var ss:String = e.currentTarget.name;
         var ind:int = int(ss.slice(3));
         if(ind == 1)
         {
            if(LocalUserInfo.isVIP())
            {
               trace("Vip此按鈕不可點擊、顯示！");
            }
            else
            {
               trace("打開超級拉姆特權面板！");
               SuperPrivilegeCtl.getInstance().onOpenSuperPrivilegeBook();
            }
         }
         else if(ind == 2)
         {
            if(LocalUserInfo.isVIP())
            {
               trace("召喚超級拉姆！");
               this.callSuperPet();
            }
            else
            {
               superPetLogin = getDefinitionByName("com.module.activityModule::superPetLogin") as Class;
               superPetLogin.gotoPay();
            }
         }
      }
      
      private function callSuperPet() : void
      {
         if(LocalUserInfo.isVIP())
         {
            if(GV.MAN_PEOPLE.Petlevel == 101)
            {
               GF.showAlert(GV.MC_AppLever,"    你的超級拉姆就在你身邊哦，不需要召喚它啦！","",100,"iknow",true,false,"E");
            }
            else if(LocalUserInfo.getMapID() == LocalUserInfo.getUserID() && LocalUserInfo.getMapType() == 0)
            {
               GF.showAlert(GV.MC_AppLever,"    你的拉姆就在你的小屋中，不需要召喚它啦！","",100,"iknow",true,false,"E");
            }
            else
            {
               CallSuperLamu.send_callSuperLamu();
            }
         }
         else
         {
            Alert.SLAlart("    只有擁有超能力的超級拉姆才能感應到主人的召喚哦！我們期待你加入。");
         }
      }
      
      private function petTipsOverHandler(e:MouseEvent) : void
      {
         if(this.tipsDisappear != null)
         {
            clearTimeout(this.tipsDisappear);
         }
         this.target_mc.lamugradepanel.addEventListener(MouseEvent.ROLL_OUT,this.petTipsOutHandler);
      }
      
      private function petTipsOutHandler(e:MouseEvent) : void
      {
         this.target_mc.lamugradepanel.x = -1000;
      }
      
      private function petBtnHandler(event:MouseEvent = null) : void
      {
         this.target_mc.lamugradepanel.x = -1000;
         SuperPetPanel.getInstance().initShardObject();
         SaveMoney.getInstance().initPanel();
         StatisticsManager.send(491);
      }
      
      public function showFriend(evt:MouseEvent = null) : void
      {
         var tempMC:Class = null;
         var man:Class = null;
         var fmc:DisplayObject = null;
         StatisticsManager.send(486);
         if(!MainManager.getAppLevel().getChildByName("friendMC") && !GV.isChangeMap)
         {
            tempMC = UIManager.getClass("friendListMC");
            man = UIManager.getClass("Man");
            this.friendMC = new tempMC();
            this.friendMC.name = "friendMC";
            this.friendMC.x = 623;
            this.friendMC.y = 164;
            this.friendMC.visible = PresentManager.showFriendPanelBool;
            MainManager.getAppLevel().addChild(this.friendMC);
            new listView(this.friendMC,man);
         }
         else
         {
            fmc = MainManager.getAppLevel().getChildByName("friendMC");
            if(Boolean(fmc))
            {
               fmc.visible = true;
            }
         }
      }
      
      private function showMap(evt:MouseEvent) : void
      {
         var tFunc:Function;
         GV.onlineSocket.dispatchEvent(new EventTaomee("clickMap"));
         tFunc = function():void
         {
            SummerActivityCtr.inst.isTransing = false;
            HomeCarSocket.DOWNCar();
            goMapFunc();
         };
         if(SummerActivityCtr.inst.isTransing)
         {
            Alert.smileAlart("    跳轉地圖運送的物資會消失哦！確定跳轉嗎？",tFunc,"sure,cancel");
         }
         else
         {
            this.goMapFunc();
         }
      }
      
      public function goMapFunc(tarFrame:uint = 0) : void
      {
         var tempMC:MCLoader = null;
         var mapID:int = LocalUserInfo.getMapID();
         var mapInfo:Object = MapsConfig.MapsInfo[mapID];
         if(tarFrame == 0)
         {
            if(Boolean(mapInfo) && Boolean(mapInfo.seabed))
            {
               ModuleManager.openPanel(ModuleType.SEABED_MAP_PANEL);
               return;
            }
            tarFrame = uint(this.target_mc.map_btn.currentFrame);
         }
         if(mapID >= 373 && mapID <= 380)
         {
            ModuleManager.openPanel("JoseeMapPanel",1);
            return;
         }
         if(mapID >= 381 && mapID <= 384)
         {
            ModuleManager.openPanel("JoseeMapPanel",2);
            return;
         }
         if(!MainManager.getGameLevel().getChildByName("mapMC") && !GV.isChangeMap)
         {
            this.mapMC = new MovieClip();
            this.mapMC.name = "mapMC";
            MainManager.getGameLevel().addChild(this.mapMC);
            if(mapID >= 364 && mapID <= 371)
            {
               tempMC = new MCLoader("resource/worldMap/worldMap_YS.swf",this.mapMC,Loading.TITLE_AND_PERCENT,"正在打開世界地圖");
               tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadMapOverHandlerYS);
               LoaderList.getInstance().addItem(tempMC,null,LoaderList.HIGHEST_AND_CLOSE_OTHERS);
               return;
            }
            if(tarFrame == 5)
            {
               ModuleManager.openPanel("WordMapMainPanel_MLSL","正在打開世界地圖");
            }
            else if(tarFrame == 1)
            {
               ModuleManager.openPanel("WordMapMainPanel","正在打開世界地圖");
            }
            else if(tarFrame == 3)
            {
               tempMC = new MCLoader("resource/worldMap/worldMap_MLD.swf",this.mapMC,Loading.TITLE_AND_PERCENT,"正在打開世界地圖");
               tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadMapOverHandler3);
               LoaderList.getInstance().addItem(tempMC,null,LoaderList.HIGHEST_AND_CLOSE_OTHERS);
            }
            else if(tarFrame == 4)
            {
               tempMC = new MCLoader("resource/worldMap/worldMap_digTreasure.swf",this.mapMC,Loading.TITLE_AND_PERCENT,"正在打開世界地圖");
               tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadMapOverHandler4);
               LoaderList.getInstance().addItem(tempMC,null,LoaderList.HIGHEST_AND_CLOSE_OTHERS);
            }
            else if(tarFrame == 2)
            {
               tempMC = new MCLoader("resource/worldMap/worldMap_HSL.swf",this.mapMC,Loading.TITLE_AND_PERCENT,"正在打開世界地圖");
               tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadMapOverHandler2);
               LoaderList.getInstance().addItem(tempMC,null,LoaderList.HIGHEST_AND_CLOSE_OTHERS);
            }
            else if(tarFrame == 16)
            {
               tempMC = new MCLoader("resource/worldMap/worldMap_DXSL.swf",this.mapMC,Loading.TITLE_AND_PERCENT,"正在打開世界地圖");
               tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadMapOverHandler16);
               LoaderList.getInstance().addItem(tempMC,null,LoaderList.HIGHEST_AND_CLOSE_OTHERS);
            }
            if(Boolean(tempMC))
            {
               tempMC.addEventListener(MCLoader.ON_USER_CLOSE_LOADER,this.closeLoadFun);
            }
         }
      }
      
      private function closeLoadFun(evt:Event) : void
      {
         if(Boolean(MainManager.getGameLevel().getChildByName("mapMC")))
         {
            MainManager.getGameLevel().removeChild(this.mapMC);
            this.mapMC = null;
         }
      }
      
      private function loadMapOverHandler2(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:Loader = evt.getLoader();
         mainMC.addChild(childMC);
         var map:WordMapLogic_HSL = new WordMapLogic_HSL(childMC);
      }
      
      private function loadMapOverHandler3(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:Loader = evt.getLoader();
         mainMC.addChild(childMC);
         var map:WordMapLogic_MLD = new WordMapLogic_MLD(childMC);
      }
      
      private function loadMapOverHandler4(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:Loader = evt.getLoader();
         mainMC.addChild(childMC);
         var map:WordMapLogic_DigTreasure = new WordMapLogic_DigTreasure(childMC);
      }
      
      private function loadMapOverHandler5(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:Loader = evt.getLoader();
         mainMC.addChild(childMC);
         var map:WordMapLogic_OldHSL = new WordMapLogic_OldHSL(childMC);
      }
      
      private function loadMapOverHandler16(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:Loader = evt.getLoader();
         mainMC.addChild(childMC);
         var map:WordMapLogic_DXSL = new WordMapLogic_DXSL(childMC);
      }
      
      private function loadMapOverHandlerYS(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:Loader = evt.getLoader();
         mainMC.addChild(childMC);
         var map:WordMapLogic_YS = new WordMapLogic_YS(childMC);
      }
      
      public function get targetMC() : MovieClip
      {
         return this.target_mc;
      }
   }
}

