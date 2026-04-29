package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.dialogBox.DialogBox;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.loading.Loading;
   import com.core.newloader.BaseMCLoader;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.staticData.CommandID;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.PeopleCountLogic.PeopleCountLogic;
   import com.logic.socket.GetGoodsInfoByArr;
   import com.logic.socket.action.ActionReq;
   import com.logic.socket.doWork.DoWorkSocket;
   import com.logic.socket.enterGame.EnterGameReq;
   import com.logic.socket.haircut.HaircutSocket;
   import com.logic.socket.leaveGame.LeaveGameReq;
   import com.logic.socket.traffic.trafficReq;
   import com.logic.socket.traffic.trafficRes;
   import com.logic.task.TaskClothReviewCtrl;
   import com.module.activityModule.Presented;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.npc.NPC;
   import com.module.npc.npcInstance.MoleNPC;
   import com.module.sendBirthdayCard.ChargeGiveThing;
   import com.module.tommyWork.tommyWork;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.info.NPCDialogInfo;
   import com.mole.app.info.NPCDialogOptionInfo;
   import com.mole.app.manager.ActivityTmpDataManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.OnlineManager;
   import com.mole.app.manager.QueryItemCntManager;
   import com.mole.app.manager.StatisticsManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.task.TaskManager;
   import com.mole.app.task.type.TaskStateType;
   import com.mole.app.type.ActionType;
   import com.mole.app.utils.PlayMovie;
   import com.mole.app.utils.Tool;
   import com.mole.info.ItemInfo;
   import com.mole.net.events.SocketEvent;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLLoader;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   
   public class ClothView extends MapBase
   {
      
      private static const userUrl:String = "resource/xml/givingGoldUserId.xml";
      
      private static var clothBook_flag:uint = 18;
      
      public var prettyBox:MovieClip;
      
      public var bookMC:MovieClip;
      
      public var tempLoader:Loader;
      
      public var showClothMC:MovieClip;
      
      public var id:*;
      
      public var price:*;
      
      public var info:*;
      
      private var sale_mc:MovieClip;
      
      private var joinRequest:EnterGameReq;
      
      public var changecloth:MovieClip;
      
      private var clothPlace:SimpleButton;
      
      private var _queryConti:QueryItemCntManager;
      
      private var _useridArr:Array = [1206205,35583249,1206205,47033306,157567,100021,6255159,632628227,540999349,50537,50538,494282743,890118,18709070,174784838,288893920,596581350,612542347,65152,619235494,512526805,691164,69462768,556970283,543987298,447015068,618412752,47667945,30348855,50310,482867868,193451585,46398136,32050849,283703549,836184];
      
      private var _isGetWard:Boolean;
      
      private var _tommyWork:tommyWork;
      
      private var sayList:Array = [];
      
      private var tTimer:Timer;
      
      private var currnetStrNum:int = 1;
      
      private var boxM:DialogBox;
      
      private var strArr:Array = ["抱歉，請等一下，我一會兒就好!","不要急嘛，很快的!"];
      
      private var sitNum:int;
      
      private var seatTimer:Timer;
      
      private var buyHairID:int;
      
      public function ClothView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.inMap();
         SystemEventManager.addEventListener("getAward",this.onGetAward);
         GV.onlineSocket.addCmdListener(CommandID.cli_proto_get_bitbuf_info,this.onRewaredLastHandle);
         GF.sendSocket(CommandID.cli_proto_get_bitbuf_info,1,12);
         GV.onlineSocket.addCmdListener(CommandID.MAGICSPIRITE_GET_BY_NPC,this.onGetByNpc);
         var urlLoader:URLLoader = new URLLoader();
         BC.addOnceEvent(this,urlLoader,Event.COMPLETE,this.ItemPriceConfigComplete);
         urlLoader.load(VL.getURLRequest(userUrl));
      }
      
      private function ItemPriceConfigComplete(e:Event = null) : void
      {
         var xmlInfo:XML = null;
         var id:uint = 0;
         var xmlList:XMLList = null;
         var xml:XML = null;
         if(e != null)
         {
            xmlInfo = new XML(e.target.data);
            xmlList = xmlInfo.elements("Item");
            for each(xml in xmlList)
            {
               id = uint(xml.@user);
               if(this._useridArr.indexOf(id) == -1)
               {
                  this._useridArr.push(id);
               }
            }
         }
      }
      
      private function onRewaredLastHandle(e:*) : void
      {
         var bytearr:ByteArray = e.data as ByteArray;
         if(bytearr == null)
         {
            return;
         }
         var count:uint = bytearr.readUnsignedInt();
         var flag:uint = bytearr.readUnsignedByte();
         this._isGetWard = Boolean(flag);
      }
      
      private function onGetByNpc(e:*) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.MAGICSPIRITE_GET_BY_NPC,this.onGetByNpc);
         GF.sendSocket(CommandID.cli_proto_get_bitbuf_info,1,10);
      }
      
      private function onGetAward(e:SystemEvent) : void
      {
         GF.sendSocket(CommandID.FREE_GOLDEN_BEAN,6);
      }
      
      private function inMap() : void
      {
         if(Boolean(ActivityTmpDataManager.task382OverPanel_obj))
         {
            if(ActivityTmpDataManager.task382OverPanel_obj._goId == 2)
            {
               ModuleManager.openPanel("Task382OverPanel",{"showUIType":2});
               BC.addEvent(this,GV.onlineSocket,"task382overpanel3_openbook",function(e:Event):void
               {
                  showBookView();
               });
            }
         }
         this.tempLoader = new Loader();
         this._tommyWork = new tommyWork(controlLevel);
         controlLevel.door_1.mouseChildren = false;
         controlLevel.door_1.buttonMode = true;
         controlLevel.door_show.mouseEnabled = false;
         controlLevel.door_1.addEventListener(MouseEvent.MOUSE_OVER,this.doorOverHandler);
         controlLevel.door_1.addEventListener(MouseEvent.MOUSE_OUT,this.doorOutHandler);
         controlLevel.getBuildCard_mc.addEventListener(MouseEvent.CLICK,this.onOpenHelp1);
         controlLevel.newBook_btn.addEventListener(MouseEvent.CLICK,this.showBookViewNew);
         BC.addEvent(this,controlLevel.newBookBtn,MouseEvent.CLICK,this.showBookView);
         BC.addEvent(this,GV.onlineSocket,"TossTheRingsPanel_openClothBook",function(e:Event):void
         {
            showBookView();
         });
         controlLevel.tooth_btn.addEventListener(MouseEvent.MOUSE_OVER,this.toothOverHandler);
         controlLevel.tooth_btn.addEventListener(MouseEvent.MOUSE_OUT,this.toothOutHandler);
         controlLevel.tooth_btn.addEventListener(MouseEvent.CLICK,this.toothClickHandler);
         controlLevel.jingzi_mc.addEventListener(MouseEvent.MOUSE_OVER,this.showJZOVER);
         controlLevel.jingzi_mc.addEventListener(MouseEvent.MOUSE_OUT,this.showJZOUT);
         controlLevel.jingzi_mc.addEventListener(MouseEvent.CLICK,this.showJZClick);
         controlLevel.jingzi_mc.buttonMode = true;
         tip.tipTailDisPlayObject(controlLevel.jingzi_mc,"進入雲裳鏡界");
         tip.tipTailDisPlayObject(controlLevel.newBook_btn,"摩爾時尚");
         controlLevel.sale_btn.addEventListener(MouseEvent.CLICK,this.showSaleViewHandler);
         controlLevel.sale_btn.visible = false;
         GV.onlineSocket.addEventListener(trafficRes.TRAFFIC_OVER,this.halfHandler);
         trafficReq.trafficSend(5);
         controlLevel.getItem.addEventListener(MouseEvent.CLICK,this.getItemEvent);
         BC.addEvent(this,GV.onlineSocket,"POLICE_DUTY_EVENT",this.yiziDuty);
         this.joinRequest = new EnterGameReq();
         BC.addEvent(this,GV.onlineSocket,"read_" + 60016,this.seatChange);
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_-" + 10007,this.HavePeopleSit);
         HaircutSocket.getBarbershopSit();
         this.changecloth = depthLevel["changecloth"] as MovieClip;
         this.changecloth.gotoAndStop(33);
         this.clothPlace = topLevel["clothPlace"] as SimpleButton;
         this.clothPlace.addEventListener(MouseEvent.MOUSE_OVER,this.clothTips);
         this.clothPlace.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void
         {
            if(changecloth.currentFrame < 34)
            {
               changecloth.gotoAndPlay(34);
            }
         });
         this.clothPlace.addEventListener(MouseEvent.MOUSE_OUT,this.clothTips);
         BC.addEvent(this,buttonLevel.mail_btn,MouseEvent.CLICK,this.clothMailFun);
         TaskClothReviewCtrl.inst.initBtn();
         BC.addEvent(this,GV.onlineSocket,"gotoDressshop",this.goShop,false,0,true);
         BC.addEvent(this,GV.onlineSocket,"openMoleFaBook",this.openMoleFaBook,false,0,true);
         BC.addEvent(this,GV.onlineSocket,"NotOneLessEvent",this.notOneLessHandler);
         SystemEventManager.addEventListener("notOneLessStep2Over",this.notOneLessStep2Over);
      }
      
      private function onEnterSeat(e:*) : void
      {
         ModuleManager.openPanel("TossTheRingsPanel");
      }
      
      private function sendPaintHandle() : void
      {
         ModuleManager.openPanel("XiSuoTrustMainTwo");
      }
      
      private function notOneLessStep2Over(e:*) : void
      {
         var tFunc:Function = function(doneTimes:int):void
         {
            if(doneTimes < 4)
            {
               Alert.smileAlart("    在你的幫助下，孤單的小摩爾實現了心願，你獲得了30個愛心花瓣！");
               Tool.exchangeGoods(2133);
            }
            else
            {
               Alert.smileAlart("    在你的幫助下，孤單的小摩爾實現了心願!");
            }
         };
         Tool.finishSomething(31484,tFunc);
      }
      
      override public function init() : void
      {
         var npcOptionInfo:NPCDialogOptionInfo = null;
         var npcDialogInfo:NPCDialogInfo = null;
         super.init();
         var _str:String = "";
         npcOptionInfo = new NPCDialogOptionInfo("時裝製作流程",ActionType.FUNCTION,this.sendPaintHandle);
         this.sayList.push(npcOptionInfo);
         npcOptionInfo = new NPCDialogOptionInfo("製作時裝",ActionType.FUNCTION,this.makeCloth);
         this.sayList.push(npcOptionInfo);
         npcOptionInfo = new NPCDialogOptionInfo("如何獲得制衣材料",ActionType.FUNCTION,this.getCaiLiao);
         this.sayList.push(npcOptionInfo);
         npcOptionInfo = new NPCDialogOptionInfo("這裡是哪？",ActionType.MAP_SAY,14);
         this.sayList.push(npcOptionInfo);
         npcOptionInfo = new NPCDialogOptionInfo("沒什麼事",ActionType.NONE);
         this.sayList.push(npcOptionInfo);
         _str = "可惡，誰偷走了我的時裝，最近莊園越來越不太平了。";
         npcDialogInfo = new NPCDialogInfo(10027,"正常",_str,this.sayList);
         var npc5:MoleNPC = NPC.getNPCInstance(5);
         npc5.dialogInfo = npcDialogInfo;
      }
      
      private function makeCloth() : void
      {
         ModuleManager.openPanel("XiSuoTrustMakePanel");
      }
      
      private function getCaiLiao() : void
      {
         ModuleManager.openPanel("XiSuoTrustBook");
      }
      
      private function notOneLessHandler(e:EventTaomee) : void
      {
         var npcOptionInfo:NPCDialogOptionInfo = null;
         npcOptionInfo = new NPCDialogOptionInfo("一個都不能少",ActionType.MAP_SAY,21);
         this.sayList.push(npcOptionInfo);
      }
      
      private function onOpenHelp1(e:MouseEvent) : void
      {
         PlayMovie.play("resource/newTask/helpPanel/map_20_1.swf");
         OnlineManager.addCmdListener(GetGoodsInfoByArr.GetGoodsInfoByArrCmd,this.onGetGoodsInfo);
         GetGoodsInfoByArr.send(0,[12861,12905]);
      }
      
      private function onGetGoodsInfo(e:SocketEvent) : void
      {
         OnlineManager.removeCmdListener(GetGoodsInfoByArr.GetGoodsInfoByArrCmd,this.onGetGoodsInfo);
         var infoPro:GetGoodsInfoByArr = e.bodyInfo;
         var item12861:ItemInfo = infoPro.itemHash.getValue(12861);
         var item12905:ItemInfo = infoPro.itemHash.getValue(12905);
         if(!(item12861 && item12861.count) && !(item12905 && item12905.count))
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + 1485,this.getYFSure);
            DoWorkSocket.doWork_setHasBiudCard();
         }
      }
      
      private function getYFSure(E:EventTaomee) : void
      {
         Alert.smileAlart("　　一張摩爾建設卡已經放入你的百寶箱中啦！快去看看吧！");
      }
      
      private function goShop(e:*) : void
      {
         this.showBookView524();
      }
      
      private function openMoleFaBook(e:*) : void
      {
         this.showBookView527();
      }
      
      private function clothMailFun(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("module/external/clothMail.swf","正在打開......",MainManager.getAppLevel());
         loadGame = null;
      }
      
      private function onAierGoHome(evt:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"AierGoHome",this.onAierGoHome);
         depthLevel.aierMc.gotoAndStop(1);
      }
      
      private function clothClick() : void
      {
         this.tTimer = GC.setGTimeout(this.gotoDressshop,500);
      }
      
      private function gotoDressshop() : void
      {
         GC.clearGTimeout(this.tTimer);
         if(this.changecloth.currentFrame > 32 || this.changecloth.currentFrame == 1)
         {
            this.changecloth.gotoAndPlay(2);
         }
         this.tTimer = GC.setGTimeout(this.openDressshop,500);
      }
      
      private function openDressshop() : void
      {
         var tempMC:Sprite = null;
         var mcloader:MCLoader = null;
         GC.clearGTimeout(this.tTimer);
         if(MainManager.getAppLevel().getChildByName("dressshop") == null)
         {
            tempMC = new Sprite();
            tempMC.name = "dressshop";
            MainManager.getAppLevel().addChild(tempMC);
            mcloader = new MCLoader("module/external/dressshop.swf",tempMC,Loading.TITLE_AND_PERCENT,"正在打開試衣間...");
            mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,this.dressshopHandler);
            mcloader.doLoad();
         }
      }
      
      private function dressshopHandler(event:MCLoadEvent) : void
      {
         event.currentTarget.addEventListener(MCLoadEvent.ON_SUCCESS,this.dressshopHandler);
         var content:DisplayObject = event.getContent();
         var mc:Sprite = event.getParent() as Sprite;
         mc.addChild(content);
         BaseMCLoader(event.currentTarget).clear();
         GV.onlineSocket.addEventListener("close_dress",this.closeDress);
      }
      
      private function closeDress(e:Event) : void
      {
         var tempX:int;
         var tempY:int;
         var main:ClothView = null;
         var timer:Timer = null;
         GV.onlineSocket.removeEventListener("close_dress",this.closeDress);
         if(this.changecloth.currentFrame < 34)
         {
            this.changecloth.gotoAndPlay(34);
         }
         tempX = 714;
         tempY = 288;
         MoveTo.CanMove = true;
         MoveTo.CanMove2 = true;
         MoveTo.AutoFind(tempX,tempY,GV.MAN_PEOPLE);
         main = this;
         timer = GC.setGTimeout(function():void
         {
            GC.clearGTimeout(timer);
            if(changecloth.currentFrame > 32)
            {
               main.changecloth.gotoAndPlay(2);
            }
         },500);
      }
      
      private function clothTips(e:MouseEvent) : void
      {
         if(e.type == MouseEvent.MOUSE_OVER)
         {
            GF.showTip("試衣間");
         }
         else
         {
            GF.clearTip();
         }
      }
      
      private function hideSeatTip(e:MouseEvent) : void
      {
         GF.clearTip();
      }
      
      private function HavePeopleSit(e:EventTaomee) : void
      {
         var tempX:int = 57;
         var tempY:int = 356;
         var mc:MovieClip = depthLevel["seat" + this.sitNum] as MovieClip;
         MoveTo.AutoFind(tempX,tempY,GV.MAN_PEOPLE);
         this.currnetStrNum = this.currnetStrNum == 1 ? 0 : 1;
         var msgM:String = this.strArr[this.currnetStrNum];
         if(this.boxM == null)
         {
            this.boxM = DialogBox.showDialogBox(msgM,8000);
         }
         else
         {
            this.boxM.say(msgM);
         }
         if(this.sitNum == 1)
         {
            this.boxM.setPosXY(mc.x + 50,mc.y - 100);
         }
         else
         {
            this.boxM.setPosXY(mc.x,mc.y - 100);
         }
         this.topLevel.addChildAt(this.boxM,0);
      }
      
      private function seatChange(e:EventTaomee) : void
      {
         var i:int = 0;
         var obj:Object = null;
         var userInstance:PeopleManageView = null;
         var seatMC:MovieClip = null;
         var arr:Array = e.EventObj as Array;
         var tarr:Array = PeopleCountLogic.FloorLayerPList;
         for(var t:int = 0; t < 3; t++)
         {
            seatMC = this.depthLevel.getChildByName("seat" + (t + 1)) as MovieClip;
            obj = arr[t];
            if(obj.Uid != 0)
            {
               if(obj.state == 1)
               {
                  if(seatMC.currentFrame == seatMC.totalFrames)
                  {
                     seatMC.gotoAndPlay(1);
                  }
                  for(i = 0; i < tarr.length; i++)
                  {
                     userInstance = tarr[i].Instance as PeopleManageView;
                     if(userInstance.id == obj.Uid)
                     {
                        seatMC.colorObj = userInstance.colorObj;
                        userInstance.visible = false;
                        if(obj.Uid == LocalUserInfo.getUserID())
                        {
                           this.loadHairUI();
                        }
                        break;
                     }
                  }
               }
               else
               {
                  seatMC.gotoAndStop(seatMC.totalFrames);
                  for(i = 0; i < tarr.length; i++)
                  {
                     userInstance = tarr[i].Instance as PeopleManageView;
                     if(userInstance.id == obj.Uid)
                     {
                        userInstance.visible = true;
                        if(obj.Uid == LocalUserInfo.getUserID())
                        {
                           this.levelSit();
                        }
                        break;
                     }
                  }
               }
            }
         }
      }
      
      private function yiziDuty(e:EventTaomee) : void
      {
         if(e.EventObj.mc == this.clothPlace)
         {
            this.clothClick();
            return;
         }
         GV.isSitDown = true;
         this.sitNum = e.EventObj.mc.name.slice(-1);
         var d:uint = 3;
         PeopleManageView(GV.MAN_PEOPLE).sitDown(d);
         var actionReq:ActionReq = new ActionReq();
         actionReq.actions(3,d);
         this.joinRequest.enterGame(this.sitNum);
      }
      
      private function loadHairUI() : void
      {
         var tempMC:Sprite = null;
         var mcloader:MCLoader = null;
         if(MainManager.getTopLevel().getChildByName("haircutModule") == null)
         {
            tempMC = new Sprite();
            tempMC.name = "haircutModule";
            MainManager.getTopLevel().addChild(tempMC);
            mcloader = new MCLoader("module/external/haircutModule.swf",tempMC,Loading.TITLE_AND_PERCENT,"正在打開百變造型屋...");
            mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,this.haircutHandler);
            mcloader.doLoad();
         }
      }
      
      private function levelSit() : void
      {
         var tempX:int = 57;
         var tempY:int = 356;
         MoveTo.AutoFind(tempX,tempY,GV.MAN_PEOPLE);
      }
      
      private function enterGameHandler() : void
      {
      }
      
      private function haircutHandler(event:MCLoadEvent) : void
      {
         event.currentTarget.addEventListener(MCLoadEvent.ON_SUCCESS,this.haircutHandler);
         var content:DisplayObject = event.getContent();
         var mc:Sprite = event.getParent() as Sprite;
         mc.addChild(content);
         BaseMCLoader(event.currentTarget).clear();
         BC.addEvent(this,content,Event.CLOSE,this.hairCloseHandler);
      }
      
      private function hairCloseHandler(e:EventTaomee) : void
      {
         var obj:Object = e.EventObj;
         this.buyHairID = obj.id;
         BC.removeEvent(this,e.currentTarget,Event.CLOSE,this.hairCloseHandler);
         if(Boolean(obj.flag))
         {
            this.depthLevel["seat" + this.sitNum].gotoAndPlay(241);
            this.seatTimer = GC.setGTimeout(this.seatPlayOver,5000);
            BC.addEvent(this,GV.MAN_PEOPLE,PeopleManageView.ON_GO_START,this.seatPlayOver);
         }
         else
         {
            LeaveGameReq.leaveGame(0);
         }
      }
      
      private function seatPlayOver(e:Event = null) : void
      {
         BC.removeEvent(this,GV.MAN_PEOPLE,PeopleManageView.ON_GO_START,this.seatPlayOver);
         GC.clearGTimeout(this.seatTimer);
         LeaveGameReq.leaveGame(0);
         if(this.buyHairID == -1)
         {
            return;
         }
      }
      
      private function haveSitHandler(evt:EventTaomee) : void
      {
         var obj:Object = evt.EventObj;
         Alert.showAlert(MainManager.getAppLevel(),obj.msg,"",6,"D");
         this.sitNum = -1;
      }
      
      private function tutu_gamOvenEvent(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"tutu_game_one",this.tutu_gamOvenEvent);
         Presented.getInstance().FreeReceive(59);
      }
      
      private function heimao_gamOvenEvent(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"heimao_game_two",this.heimao_gamOvenEvent);
         Presented.getInstance().FreeReceive(60);
      }
      
      private function getItemEvent(evt:MouseEvent) : void
      {
         controlLevel.getItem.visible = false;
         var chargeGiveThing:ChargeGiveThing = new ChargeGiveThing();
         chargeGiveThing.itemID = 190212;
         chargeGiveThing.itemCount = 1;
         chargeGiveThing.msg = "        你得到了一些五彩布！";
         chargeGiveThing.url = "resource/allJob/icon/190212.swf";
         chargeGiveThing.panle = 0;
         chargeGiveThing.getThing();
      }
      
      private function loadBookHandler(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:* = evt.getLoader();
         mainMC.addChild(childMC);
         MCLoader(evt.target).clear();
      }
      
      private function removeMC(evt:Event = null) : void
      {
         GV.onlineSocket.removeEventListener("monthlyCloseEvent",this.removeMC);
         GC.stopAllMC(this.showClothMC);
         GC.clearChildren(this.showClothMC);
         this.showClothMC.parent.removeChild(this.showClothMC);
         this.showClothMC = null;
      }
      
      private function halfHandler(evt:EventTaomee) : void
      {
         if(evt.EventObj.type == 5)
         {
            if(evt.EventObj.Status != 0)
            {
               controlLevel.sale_btn.visible = true;
               depthLevel.saleShow_mc.gotoAndStop(2);
            }
            else
            {
               controlLevel.sale_btn.visible = false;
               depthLevel.saleShow_mc.gotoAndStop(1);
            }
         }
      }
      
      private function showSaleViewHandler(evt:MouseEvent) : void
      {
         var tempMC:Class = null;
         if(!GV.MC_AppLever.getChildByName("sale_mc"))
         {
            tempMC = GV.Lib_Map.getClass("sale_mc") as Class;
            this.sale_mc = new tempMC();
            GV.MC_AppLever.addChild(this.sale_mc);
            this.sale_mc.name = "sale_mc";
            this.sale_mc.x = (GV.MC_AppLever.stage.stageWidth - this.sale_mc.width) / 2;
            this.sale_mc.y = (GV.MC_AppLever.stage.stageHeight - this.sale_mc.height) / 2;
            this.sale_mc.closeBtn.addEventListener(MouseEvent.CLICK,this.removeSaleHandler);
            this.sale_mc.showBook_btn.addEventListener(MouseEvent.CLICK,this.showBookView);
         }
      }
      
      private function removeSaleHandler(evt:MouseEvent = null) : void
      {
         this.sale_mc.showBook_btn.removeEventListener(MouseEvent.CLICK,this.showBookView);
         this.sale_mc.closeBtn.removeEventListener(MouseEvent.CLICK,this.removeSaleHandler);
         GC.stopAllMC(this.sale_mc);
         GC.clearChildren(this.sale_mc);
         this.sale_mc.parent.removeChild(this.sale_mc);
         this.sale_mc = null;
      }
      
      private function emaiOverHandler(evt:MouseEvent) : void
      {
         evt.currentTarget.gotoAndPlay(2);
      }
      
      private function emaiOutHandler(evt:MouseEvent) : void
      {
         evt.currentTarget.gotoAndStop(1);
      }
      
      private function doorOverHandler(evt:MouseEvent) : void
      {
         controlLevel.door_show.gotoAndStop(2);
      }
      
      private function doorOutHandler(evt:MouseEvent) : void
      {
         controlLevel.door_show.gotoAndStop(1);
      }
      
      private function toothOverHandler(evt:MouseEvent) : void
      {
         MovieClip(evt.currentTarget.parent)["tooth_mc"].gotoAndPlay(2);
      }
      
      private function toothOutHandler(evt:MouseEvent) : void
      {
         MovieClip(evt.currentTarget.parent)["tooth_mc"].gotoAndStop(1);
      }
      
      private function toothClickHandler(evt:MouseEvent) : void
      {
         var mc:Sprite = null;
         var mcloader:MCLoader = null;
         if(!MainManager.getAppLevel().getChildByName("systemCollect"))
         {
            mc = new Sprite();
            mc.name = "systemCollect";
            MainManager.getAppLevel().addChild(mc);
            mcloader = new MCLoader("module/external/ClothCollectModule.swf",MainManager.getAppLevel(),Loading.TITLE_AND_PERCENT,"正在打開大頭鞋面板");
            mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,this.onload);
            mcloader.doLoad();
         }
      }
      
      private function onload(event:MCLoadEvent) : void
      {
         var mc:Sprite = MainManager.getAppLevel().getChildByName("systemCollect") as Sprite;
         var parent:MovieClip = event.getParent() as MovieClip;
         var content:DisplayObject = event.getLoader();
         mc.addChild(content);
         var mcloader:MCLoader = event.target as MCLoader;
         mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.onload);
         mcloader.clear();
      }
      
      private function showBoxView(evt:MouseEvent = null) : void
      {
         var tempMC:MCLoader = null;
         if(!MainManager.getGameLevel().getChildByName("prettyBox"))
         {
            this.prettyBox = new MovieClip();
            this.prettyBox.name = "prettyBox";
            MainManager.getGameLevel().addChild(this.prettyBox);
            tempMC = new MCLoader("module/external/PrettyBox.swf",this.prettyBox,Loading.TITLE_AND_PERCENT,"正在打開漂亮寶箱");
            tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadBoxOverHandler);
            tempMC.doLoad();
         }
      }
      
      private function loadBoxOverHandler(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:* = evt.getLoader();
         mainMC.addChild(childMC);
         mainMC.x = 0;
         mainMC.y = 0;
         var mcloader:MCLoader = evt.target as MCLoader;
         mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.loadBoxOverHandler);
         mcloader.clear();
      }
      
      private function showBookViewNew(e:MouseEvent) : void
      {
         ModuleManager.openPanel("PinBallPanel");
      }
      
      private function showBookView(evt:MouseEvent = null) : void
      {
         if(TaskManager.getTaskState(382) == TaskStateType.OPEN)
         {
            StatisticsManager.send(439);
         }
         if(this.sale_mc != null)
         {
            this.removeSaleHandler();
         }
         ModuleManager.openPanel("ClothBookShopPanel");
         if(TaskManager.getTaskState(382) == TaskStateType.OPEN)
         {
            StatisticsManager.send(440);
         }
         if(!MainManager.getGlobalObject().data.newsClothBook || MainManager.getGlobalObject().data.newsClothBook != clothBook_flag)
         {
            MainManager.getGlobalObject().data.newsClothBook = clothBook_flag;
            MainManager.getGlobalObject().flush();
         }
      }
      
      private function AddOpenOtherBook(event:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("remBook_openOther",this.AddOpenOtherBook);
         this.showBoxView();
      }
      
      private function showJZOVER(E:* = null) : void
      {
         if(controlLevel.jingzi_mc.currentFrame == 1)
         {
            controlLevel.gx_mc.play();
         }
      }
      
      private function showJZOUT(E:*) : void
      {
         try
         {
            if(E.type == "onGoStart")
            {
               GC.stopAllMC(controlLevel.jingzi_mc);
               controlLevel.jingzi_mc.gotoAndStop(1);
            }
            else if(controlLevel.jingzi_mc.currentFrame == 2)
            {
               GC.stopAllMC(controlLevel.jingzi_mc);
               controlLevel.jingzi_mc.gotoAndStop(1);
            }
         }
         catch(E:*)
         {
         }
      }
      
      private function showJZClick(E:*) : void
      {
         if(GV.MAN_PEOPLE.Petlevel > 100)
         {
            GV.Room_DefaultRoomID = 0;
            LocalUserInfo.setMapID(0);
            GF.switchMap(171,true);
         }
         else if(LocalUserInfo.isVIP())
         {
            Alert.smileAlart("    只有超級拉姆的神奇力量才能幫助你進入雲裳鏡界哦！快帶著超級拉姆來吧！");
         }
         else
         {
            Alert.SLAlart("    只有超級拉姆的神奇力量才能幫助你進入雲裳鏡界哦！超級拉姆大家庭期待你的加入哦！");
         }
      }
      
      private function showBookView524(evt:MouseEvent = null) : void
      {
         if(this.sale_mc != null)
         {
            this.removeSaleHandler();
         }
         ModuleManager.openPanel("ClothBookShopPanel",{"p":6});
         GV.onlineSocket.addEventListener("remBook_openOther",this.AddOpenOtherBook);
      }
      
      private function showBookView527(evt:MouseEvent = null) : void
      {
         if(this.sale_mc != null)
         {
            this.removeSaleHandler();
         }
         ModuleManager.openPanel("ClothBookShopPanel",{"p":3});
         GV.onlineSocket.addEventListener("remBook_openOther",this.AddOpenOtherBook);
      }
      
      override public function destroy() : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.cli_proto_get_bitbuf_info,this.onRewaredLastHandle);
         OnlineManager.removeCmdListener(GetGoodsInfoByArr.GetGoodsInfoByArrCmd,this.onGetGoodsInfo);
         SystemEventManager.removeEventListener("notOneLessStep2Over",this.notOneLessStep2Over);
         GC.clearGTimeout(this.seatTimer);
         GV.onlineSocket.removeEventListener("close_dress",this.closeDress);
         if(this.showClothMC != null)
         {
            this.removeMC();
         }
         BC.removeEvent(this);
         try
         {
            GV.MAN_PEOPLE.avatarClass.removeEventListener("onGoStart",this.showJZOUT);
         }
         catch(E:*)
         {
         }
         if(this.sale_mc != null)
         {
            this.removeSaleHandler();
         }
         GV.onlineSocket.removeEventListener(trafficRes.TRAFFIC_OVER,this.halfHandler);
         controlLevel.getItem.removeEventListener(MouseEvent.CLICK,this.getItemEvent);
         controlLevel.jingzi_mc.removeEventListener(MouseEvent.MOUSE_OVER,this.showJZOVER);
         controlLevel.jingzi_mc.removeEventListener(MouseEvent.MOUSE_OUT,this.showJZOUT);
         controlLevel.jingzi_mc.removeEventListener(MouseEvent.CLICK,this.showJZClick);
         controlLevel.door_1.removeEventListener(MouseEvent.MOUSE_OVER,this.doorOverHandler);
         controlLevel.door_1.removeEventListener(MouseEvent.MOUSE_OUT,this.doorOutHandler);
         controlLevel.newBook_btn.removeEventListener(MouseEvent.CLICK,this.showBookViewNew);
         controlLevel.tooth_mc.removeEventListener(MouseEvent.MOUSE_OVER,this.toothOverHandler);
         controlLevel.tooth_mc.removeEventListener(MouseEvent.MOUSE_OUT,this.toothOutHandler);
         controlLevel.getBuildCard_mc.removeEventListener(MouseEvent.MOUSE_OUT,this.onOpenHelp1);
         SystemEventManager.removeEventListener("sendPaint",this.sendPaintHandle);
         SystemEventManager.removeEventListener("beginGame",this.onEnterSeat);
         if(Boolean(this._tommyWork))
         {
            this._tommyWork.destroy();
         }
         super.destroy();
      }
   }
}

